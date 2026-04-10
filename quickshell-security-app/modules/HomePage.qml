import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: home_item
    anchors.fill: parent
    Rectangle {
        id: holding
        width: parent.width
        height: parent.height
        color: Theme.base05
        RegularText {
            id: homePageText
            text: ""
            color: Theme.base05
            width: 50
            height: 50
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        CustomSlider {}
    }
}
