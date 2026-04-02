import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: ssh_item
    anchors.fill: parent
    Rectangle {
        width: parent.width
        height: parent.height
        color: Theme.base05

        ListView {
            spacing: 5
            anchors.top: parent.top
            interactive: true
            Layout.fillHeight: true
            width: parent.width
            clip: true
            height: parent.height - (parent.height / 20)
            orientation: ListView.VerticalTopToBottom

            model: FileReader.test_file.slice(0, -1)
            delegate: Rectangle {
                id: list_bob
                implicitWidth: list_toggle1.implicitWidth + Theme.margins
                implicitHeight: list_toggle1.implicitHeight + Theme.margins
                color: Theme.base0C
                Toggle {
                    id: list_toggle1
                    labelText: modelData
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
    Process {
        id: value_changer
        running: false
    }
}
