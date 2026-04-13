import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: home_item
    anchors.fill: parent
    property string clamStatus: "No value passed"
    Rectangle {
        id: holding
        width: parent.width
        height: parent.height
        color: Theme.base05
        RegularText {
            id: homePageText
            text: "ClamAV:" + home_item.clamStatus
            color: Theme.base00
            x: 0
            //width: 70
            height: 50
            //horizontalAlignment: Text.AlignHCenter
            //verticalAlignment: Text.AlignVCenter
        }
        //CustomSlider {}
    }
    Process {
        id: statusChecker
        command: ["sh", "-c", "systemctl status clamav-daemon.service | rg Active"]
        running: true

        stdout: StdioCollector {
            id: ssh_output
            onStreamFinished: {
                home_item.clamStatus = text;
            }
        }
    }
}
