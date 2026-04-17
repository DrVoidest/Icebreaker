// MultiSelector.qml
import QtQuick
import QtQuick.Layouts

Item {
    id: multiSelector
    // ✅ Input list and output selection
    property var options: []
    property var selected: []
    property string text: "Loading"
    // ✅ Signal emits the full selected list whenever it changes
    signal selectionChanged(var selected)

    implicitWidth: parent.width
    implicitHeight: flow.height

    RegularText {
        id: selectorName
        text: multiSelector.text + " "
        x: Theme.margins
        color: Theme.themeData.colors["base07"]
        anchors.verticalCenter: parent.verticalCenter
    }

    // ✅ Flow wraps items onto new lines automatically
    Flow {
        id: flow
        x: 0 + selectorName.width
        width: parent.width - x
        spacing: 5

        Repeater {
            model: multiSelector.options

            delegate: Rectangle {
                id: optionChip
                required property string modelData
                required property int index

                readonly property bool isSelected: multiSelector.selected.includes(modelData)

                implicitWidth: 0
                implicitHeight: 0
                radius: 10

                color: isSelected ? Theme.themeData.colors["base0A"] : Theme.themeData.colors["base03"]
                Component.onCompleted: {
                    implicitWidth = chipText.implicitWidth + 20;
                    implicitHeight = chipText.implicitHeight + 10;
                }
                RegularText {
                    id: chipText

                    text: optionChip.modelData
                    color: Theme.themeData.colors["base00"]
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // ✅ Toggle — add if missing, remove if present
                        let current = [...multiSelector.selected];
                        const i = current.indexOf(optionChip.modelData);
                        if (i === -1)
                            current.push(optionChip.modelData);
                        else
                            current.splice(i, 1);

                        multiSelector.selected = current;
                        multiSelector.selectionChanged(current);
                    }
                }
            }
        }
    }
}
