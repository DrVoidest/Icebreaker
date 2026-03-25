import QtQuick
import QtQuick.Controls
import Quickshell

Item {
    id: ssh_item
    anchors.fill: parent
    Rectangle {
        width: parent.width
        height: parent.height
        color: Theme.base0F
        RegularText {
            text: "I loaded"
            color: Theme.base00
            width: parent.width
            height: parent.height

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
