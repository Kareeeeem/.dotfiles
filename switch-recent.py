#!/usr/bin/env python3
import i3ipc

WINDOW_STACK = []


def on_command(conn, event):
    if WINDOW_STACK and 'switch-recent' in event.binding.command:
        if len(WINDOW_STACK) == 1:
            window_id = WINDOW_STACK[0]
        else:
            window_id = WINDOW_STACK.pop()
        conn.command('[con_id="%s"] focus' % window_id)


def on_focus(conn, event):
    WINDOW_STACK.insert(0, event.container.id)
    del WINDOW_STACK[2:]


conn = i3ipc.Connection()
conn.on('binding::run', on_command)
conn.on('window::focus', on_focus)
conn.main()
