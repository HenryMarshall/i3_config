require 'gir_ffi'

class Flipper
  def initialize
    GirFFI.setup 'i3ipc'
    @i3 = I3ipc::Connection.new(nil)
    @workspaces = @i3.get_workspaces
    @tree = @i3.get_tree
    @command = []
  end

  def flip both=true
    focused_workspace = nil
    @workspaces.each do |workspace|
      # If workspace was visible, put it on the top of the command stack so it
      # will be visible after the move. Otherwise put it on the bottom.
      if workspace.visible
        @command.push move_workspace_command(workspace)
        focused_workspace = workspace if workspace.focused
      else
        @command.unshift move_workspace_command(workspace)
      end
    end

    # Focus the output that the previously focused client /will/ be on when the
    # movements end.
    focused_output = focused_workspace.output.match(/\d/)[0].to_i
    @command.push "focus xinerama-#{(focused_output + 2) % 4}"

    # Send the entire command to i3 at once
    @i3.command @command.join('; ')
  end

  private

  def move_workspace_command workspace
    current_output = workspace.output.match(/\d/)[0].to_i
    target_output = "xinerama-#{(current_output + 2) % 4}"
    "workspace #{workspace.name}; move workspace to #{target_output}"
  end
end

f = Flipper.new
f.flip true