require 'gir_ffi'

class Flipper
  def initialize
    GirFFI.setup 'i3ipc'
    @i3 = I3ipc::Connection.new(nil)
    @workspaces = @i3.get_workspaces
  end

  def flip single_column=false
    focused_workspace = @workspaces.find { |workspace| workspace.focused }
    single_column ? (xinerama_number(workspace) % 2) : false
    queue = build_move_queue(@workspaces, single_column)
    # We focus where the originally focused workspace /will/ be (sync problems)
    queue << "focus #{target_output(focused_workspace)}"

    @i3.command queue.join('; ')
  end

  private

  def build_move_queue workspaces, single_column
    queue = []
    workspaces.each do |workspace|
      add_to_queue(workspace, queue) if flip_this?(workspace, single_column)
    end
    queue
  end

  def flip_this? workspace, single_column
    xinerama_number(workspace) % 2 == single_column or not single_column
  end

  def add_to_queue workspace, queue
    move_command = "workspace #{workspace.name};
                    move workspace to #{target_output(workspace)}"

    # If workspace was visible, put it on the top of the move queue so it
    # will be visible after the move. Otherwise put it on the bottom.
    if workspace.visible
      queue.push(move_command)
    else
      queue.unshift(move_command)
    end
  end

  def target_output workspace
    # This assumes a 2x2 display grid and you are moving workspaces vertically.
    # As we are using xinerama names are xinerama-0, xinerama-1 etc.
    "xinerama-#{(xinerama_number(workspace) + 2) % 4}"
  end

  def xinerama_number workspace
    workspace.output[-1].to_i
  end

end

f = Flipper.new
f.flip