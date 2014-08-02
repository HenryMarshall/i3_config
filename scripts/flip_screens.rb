require 'gir_ffi'

namespace = 'i3ipc'
GirFFI.setup namespace

i3 = I3ipc::Connection.new(nil)
i3.command 'focus right'