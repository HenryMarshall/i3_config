#!/usr/bin/python2.7
# Port of perl script: https://github.com/sciurus/i3tree

import i3

# save focused workspace
def find_active_workspace():
    workspaces = i3.get_workspaces()
    for workspace in workspaces:
        if workspace['focused'] == True:
            return workspace
    else:
        return False

def display_node(description, depth):
    margin = "\t" * depth
    print("{}{}".format(margin, description))
    return depth + 1

def walk_tree(node, depth):
    if node['type'] == 4:
        description = "{} [{}]".format(node['name'], node['orientation'])
        depth = display_node(description, depth)
    if node['type'] == 2:
        # probably a window
        if node['orientation'] == "none":
            # definately a window
            if not (node['name'] == "content" or node['name'] == "^i3bar"):
                description = "{}".format(node['name'])
                depth = display_node(description, depth)
        # a split container
        else:
            description = "Split: [{}]".format(node['orientation'])
            depth = display_node(description, depth)


    for node in node['nodes']:
        walk_tree(node, depth)

# find active workspace tree
workspace_tree = i3.filter(name=find_active_workspace()['name'])
walk_tree(workspace_tree[0], 0)