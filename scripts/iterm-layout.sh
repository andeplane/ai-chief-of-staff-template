#!/bin/bash
# Opens iTerm2 with the AI chief-of-staff 3-pane layout:
#   Left:         Claude Code
#   Right top:    kanban-md TUI
#   Right bottom: Next TODOs sorted by due date (auto-refreshing)
#
# Usage: ./iterm-layout.sh [--dangerously-skip-permissions]
#   Pass --dangerously-skip-permissions to forward it to Claude Code.

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_FLAGS="$*"

osascript <<APPLESCRIPT
tell application "iTerm2"
    activate
    set newWindow to (create window with default profile)

    tell newWindow
        tell current session
            -- Left pane: Claude Code
            write text "cd $PROJECT_DIR && claude $CLAUDE_FLAGS"

            -- Split right for kanban area
            set rightTop to (split vertically with default profile)
        end tell

        tell rightTop
            write text "cd $PROJECT_DIR && kanban-md tui"

            -- Split right-top downward for the TODO list
            set rightBottom to (split horizontally with default profile)
        end tell

        tell rightBottom
            write text "cd $PROJECT_DIR && while true; do clear; echo 'Next TODOs (by due date):'; echo ''; kanban-md list --sort due --compact --status backlog,todo,in-progress,review; sleep 30; done"
        end tell
    end tell
end tell
APPLESCRIPT
