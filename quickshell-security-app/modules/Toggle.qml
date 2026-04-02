import QtQuick

// Reusable button for boolean toggels
Item {
    id: root
    property alias isToggled: toggle_row.isToggled
    property alias labelText: toggle_row.line_values
    property var bool_value: labelText.split(" ")
    implicitHeight: toggle_row.implicitHeight
    implicitWidth: toggle_row.implicitWidth
    Row {
        id: toggle_row
        spacing: 12
        property bool isToggled: root.bool_value[1] === "yes" ? true : false
        property var line_values: "No values passed"
        RegularText {
            id: text_box
            text: root.bool_value[0]
            color: Theme.base00
            visible: root.labelText !== "" // Hide completely if no text is set
            anchors.verticalCenter: parent.verticalCenter // Vertically align with the toggle
        }
        Rectangle {
            id: boolean_base
            implicitHeight: 30
            implicitWidth: 80
            radius: height / 2
            color: toggle_row.isToggled ? Theme.base0B : Theme.base03
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color {
                ColorAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
            MouseArea {
                id: toggle_mouse_area
                anchors.fill: parent
                onClicked: {
                    toggle_row.isToggled = !toggle_row.isToggled;
                    FileReader.toggle(root.bool_value);
                }
            }
            Rectangle {
                id: boolean_slider
                implicitHeight: parent.height
                implicitWidth: height
                radius: width / 2
                color: Theme.base0A
                x: toggle_row.isToggled ? (boolean_base.width - width) : 0

                Behavior on x {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
                RegularText {
                    text: toggle_row.isToggled ? "1" : "0"
                    //text: text_box.text
                    implicitHeight: parent.implicitHeight
                    implicitWidth: parent.implicitHeight
                    color: Theme.base00
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
