pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property var self_triming
    // Black magic to lessen the amount of processes quickshell needs to run
    Process {
        id: self_triming_process
        command: ["sh", "-c", "mmsg -g -t | awk '$4 { print $3 }' | head -c 1 && printf '\n' && mmsg -g -t | awk '$5 >= 1 { print $3 }'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.self_triming = this.text.trim().split("\n")
        }
    }

    Timer {
        interval: 500 // Was 1000
        running: true
        repeat: true
        onTriggered: self_triming_process.running = true
    }
}
