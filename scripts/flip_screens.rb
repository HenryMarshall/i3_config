require 'gir_ffi'

class flipper
  def initialize
    GirFFI.setup 'i3ipc'
    i3 = I3ipc::Connection.new(nil)

    @tree = i3.get_tree
    @command = []
  end

  def move_workspace workspace
    current_output = workspace.output.match(/\d/)[0].to_i
    target_output = "xinerama-#{(current_output + 2) % 4}"
    "workspace #{workspace.name}; move workspace to #{target_output}"
  end
end
