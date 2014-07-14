#!/usr/bin/python2.7

import i3
outputs = i3.get_outputs()

# for each output
for output in range(0, len(outputs)):
    # select workspace
    i3.workspace(outputs[output]['current_workspace'])
    # and move
    i3.command('move', 'workspace to output down')
