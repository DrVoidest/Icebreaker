import QtQuick

// Reusable button for boolean toggels
Item {
    id: root
    property alias isToggled: toggleRow.isToggled
    property alias labelText: toggleRow.lineValues
    property var boolValue: labelText.split(" ")
    implicitHeight: toggleRow.implicitHeight
    implicitWidth: toggleRow.implicitWidth
    Row {
        id: toggleRow
        spacing: 12
        x: Theme.margins
        property bool isToggled: root.boolValue[1] === "yes" ? true : false
        property var lineValues: "No values passed"
        RegularText {
            id: textBox
            text: root.boolValue[0]
            color: Theme.base07
            visible: root.labelText !== "" // Hide completely if no text is set
            anchors.verticalCenter: parent.verticalCenter // Vertically align with the toggle
        }
        Rectangle {
            id: booleanBase
            implicitHeight: 30
            implicitWidth: 80
            radius: height / 2
            color: toggleRow.isToggled ? Theme.base0B : Theme.base03
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color {
                ColorAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
            MouseArea {
                id: toggleMouseArea
                anchors.fill: parent
                onClicked: {
                    toggleRow.isToggled = !toggleRow.isToggled;
                    FileReader.toggle(root.labelText + root.isToggled);
                    console.log(root.labelText + root.isToggled);
                }
            }
            Rectangle {
                id: booleanSlider
                implicitHeight: parent.height
                implicitWidth: height
                radius: width / 2
                color: Theme.base0A
                x: toggleRow.isToggled ? (booleanBase.width - width) : 0

                Behavior on x {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
                RegularText {
                    text: toggleRow.isToggled ? "1" : "0"
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
