pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool busy: false
    property string lastError: ""
    property string lastTitle: ""

    signal noteCreated(string title)
    signal noteFailed(string error)

    Process {
        id: createProcess

        stdout: StdioCollector {
            id: stdoutCollector
        }

        stderr: StdioCollector {
            id: stderrCollector
        }

        onExited: function(exitCode, exitStatus) {
            root.busy = false

            if (exitCode === 0) {
                root.lastError = ""
                root.noteCreated(root.lastTitle)
            } else {
                const errorText = stderrCollector.text.trim()
                root.lastError = errorText.length > 0
                    ? errorText
                    : qsTr("Obsidian CLI failed (exit code %1)").arg(exitCode)
                root.noteFailed(root.lastError)
            }
        }
    }

    function createNote(content: string): bool {
        const text = (content || "").trim()
        if (root.busy || text.length === 0)
            return false

        const now = new Date()
        const pad = function(value) {
            return value < 10 ? `0${value}` : `${value}`
        }

        root.lastTitle = `Quick Note ${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}-${pad(now.getMinutes())}-${pad(now.getSeconds())}`
        root.lastError = ""
        root.busy = true

        // Obsidian CLI is invoked directly so note content is passed as one
        // argument and is not re-parsed by a shell.
        createProcess.command = [
            "obsidian",
            "create",
            `name=${root.lastTitle}`,
            `content=${text}`
        ]
        createProcess.running = true
        return true
    }
}
