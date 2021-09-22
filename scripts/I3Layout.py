#!/usr/bin/env python3

from i3ipc import Connection

i3 = Connection()
win = i3.get_tree().find_focused()

if win.rect.height > win.rect.width:
    i3.command('split v')
else:
    i3.command('split h')

