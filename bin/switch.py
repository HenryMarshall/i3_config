#!/usr/bin/python2.7
import time
import i3
outputs = i3.get_outputs()

# TODO: replace sleep kludge with some form of waiting

# save focused workspace
def find_active_workspace():
    workspaces = i3.get_workspaces()
    for workspace in workspaces:
        if workspace['focused'] == True:
            return workspace['name']
    else:
        return False
active_workspace = find_active_workspace()

# move everything
for output in range(0, len(outputs)):
    i3.workspace(outputs[output]['current_workspace'])
    i3.command('move', 'workspace to output up')
    time.sleep(0.1)

# restore focus to previously focused
time.sleep(0.1)
if active_workspace:
    i3.command("workspace", active_workspace)