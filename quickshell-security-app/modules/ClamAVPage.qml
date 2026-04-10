import QtQuick
import QtQuick.Controls
import Quickshell

Item {
    id: home_item
    anchors.fill: parent
    Rectangle {
        width: parent.width
        height: parent.height
        color: Theme.base0B
        RegularText {
            text: "ClamAVWIP"
            color: Theme.base00
            width: parent.width
            height: parent.height

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
