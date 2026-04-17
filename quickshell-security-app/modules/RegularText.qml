import QtQuick

// Basic textbox modules for reuse
Item {
    property alias text: regularText.text
    property alias color: regularText.color
    property alias horizontalAlignment: regularText.horizontalAlignment
    property alias verticalAlignment: regularText.verticalAlignment

    implicitWidth: regularText.contentWidth
    implicitHeight: regularText.contentHeight

    Text {
        id: regularText //test
        font.family: Theme.font_family
        font.pointSize: Theme.fontSize
        color: Theme.base05

        width: parent.width
        height: parent.height

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: "No text passed"
    }
}
