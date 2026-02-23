import QtQuick

// Basic textbox modules for reuse
Item {
    property alias text: regular_text.text

    implicitWidth: regular_text.contentWidth
    implicitHeight: regular_text.contentHeight

    Text {
        id: regular_text
        font.family: Theme.font_family
        font.pointSize: Theme.font_size
        color: Theme.base05

        width: parent.width
        height: parent.height

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: "No text passed"
    }
}
