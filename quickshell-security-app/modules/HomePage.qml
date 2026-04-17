import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: homeItem
    anchors.fill: parent
    property string clamStatus: "No value passed"
    property string sshStatus: "No value passed"

    Rectangle {
        id: holding
        width: parent.width
        height: parent.height
        color: Theme.themeData.colors["base00"]
        Row {
            x: Theme.margins
            Column {
                RegularText {
                    id: statusTop
                    text: "Status:"
                    color: Theme.themeData.colors["base07"]
                    //text: Theme.themeData.colors["base0C"]
                    //color: Theme.themeData.colors["base07"]

                    x: 0
                    height: 50
                }

                RegularText {
                    id: clamTitle
                    text: "ClamAV: "
                    color: Theme.themeData.colors["base07"]
                    x: 0
                    height: 50
                }
                RegularText {
                    id: sshTitle
                    text: "SShd:   "
                    color: Theme.themeData.colors["base07"]
                    x: 0
                    height: 50
                }
            }
            Column {
                RegularText {
                    id: statusTitleTop
                    text: "Place holder"
                    x: 0
                    height: 50
                    color: Theme.themeData.colors["base00"]
                }

                RegularText {
                    id: clamText
                    text: homeItem.clamStatus.split(" ")[6] === "active" ? "active" : "dead"
                    color: homeItem.clamStatus.split(" ")[6] === "active" ? Theme.base0B : Theme.base08
                    x: 0
                    height: 50
                }
                RegularText {
                    id: sshText
                    text: homeItem.sshStatus.split(" ")[6] === "active" ? "active" : "dead"

                    color: homeItem.sshStatus.split(" ")[6] === "active" ? Theme.base0B : Theme.base08

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
                homeItem.clamStatus = text;
            }
        }
    }
    Process {
        id: sshStatusChecker
        command: ["sh", "-c", "systemctl status sshd.service | rg Active"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                homeItem.sshStatus = text;
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
