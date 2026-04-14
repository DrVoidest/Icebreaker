import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: home_item
    anchors.fill: parent
    property string clamStatus: "No value passed"
    property var test: clamStatus.split(" ")
    property string sshStatus: "No value passed"

    Rectangle {
        id: holding
        width: parent.width
        height: parent.height
        color: Theme.base00
        Row {
            Column {
                RegularText {
                    id: statusTop
                    text: "Status: "
                    color: Theme.base07
                    x: 0
                    height: 50
                }

                RegularText {
                    id: clamTitle
                    text: "ClamAV:"
                    color: Theme.base07
                    x: 0
                    height: 50
                }
                RegularText {
                    id: sshTitle
                    text: "SShd:  "
                    color: Theme.base07
                    x: 0
                    height: 50
                }
            }
            Column {
                RegularText {
                    id: statusTitleTop
                    text: test[6] === "active" ? "active" : "dead"
                    color: test[6] === "active" ? Theme.base0B : Theme.base08
                    x: 0
                    height: 50
                }

                RegularText {
                    id: clamText
                    text: home_item.clamStatus.split(" ")[6] === "active" ? "active" : "dead"
                    color: home_item.clamStatus.split(" ")[6] === "active" ? Theme.base0B : Theme.base08
                    x: 0
                    height: 50
                }
                RegularText {
                    id: sshText
                    text: home_item.sshStatus.split(" ")[6] === "active" ? "active" : "dead"

                    color: home_item.sshStatus.split(" ")[6] === "active" ? Theme.base0B : Theme.base08

                    x: 0
                    height: 50
                }
            }
        }
    }
    Process {
        id: clamStatusChecker
        command: ["sh", "-c", "systemctl status clamav-daemon.service | rg Active"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                home_item.clamStatus = text;
            }
        }
    }
    Process {
        id: sshStatusChecker
        command: ["sh", "-c", "systemctl status sshd.service | rg Active"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                home_item.sshStatus = text;
            }
        }
    }
    Timer {
        interval: 300000 // in ms
        running: true
        repeat: true
        onTriggered: {
            clamStatusChecker.running = true;
            sshStatusChecker.running = true;
        }
    }
}
