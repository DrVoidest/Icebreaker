pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property int total_workspaces
    property int current_workspace
    property string in_use_workspaces

    // Total Workspaces
    Process {
        id: total_workspaces_process
        command: ["sh", "-c", "mmsg -g -t | awk '$5 >= 1 { print $3 }' | wc -w"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.total_workspaces = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: total_workspaces_process.running = true
    }
    // In Use Workspaces
    Process {
        id: in_use_workspaces_process
        command: ["sh", "-c", "mmsg -g -t | awk '$5 >= 1 { print $3 }'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.in_use_workspaces = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: in_use_workspaces_process.running = true
    }
    // Current Workspaces
    Process {
        id: current_workspace_process
        command: ["sh", "-c", "mmsg -g -t | awk '$4 { print $3 }' | head -c 1"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.current_workspace = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: current_workspace_process.running = true
    }
}
