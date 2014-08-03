#!/bin/sh -e

# Take screenshot
scrot /tmp/screen_locked.png
# Blur it
convert /tmp/screen_locked.png -blur 0x10 /tmp/screen_locked.png
# Lock the screen
i3lock -i /tmp/screen_locked.png
