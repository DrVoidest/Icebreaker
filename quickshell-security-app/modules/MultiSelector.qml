// MultiSelector.qml
import QtQuick
import QtQuick.Layouts

Item {
    id: multi_selector

    // ✅ Input list and output selection
    property var options: []
    property var selected: []
    property string text: "Loading"
    // ✅ Signal emits the full selected list whenever it changes
    signal selectionChanged(var selected)

    implicitWidth: flow.implicitWidth
    implicitHeight: flow.implicitHeight

    RegularText {
        id: selectorName
        text: multi_selector.text + " "
        color: Theme.base00
        anchors.verticalCenter: parent.verticalCenter
    }

    // ✅ Flow wraps items onto new lines automatically
    Flow {
        id: flow
        x: 0 + selectorName.width
        width: parent.width
        spacing: 5

        Repeater {
            model: multi_selector.options

            delegate: Rectangle {
                id: option_chip
                required property string modelData
                required property int index

                readonly property bool isSelected: multi_selector.selected.includes(modelData)

                implicitWidth: chip_text.implicitWidth + 20
                implicitHeight: chip_text.implicitHeight + 10
                radius: 10

                // ✅ Different color when selected
                color: isSelected ? Theme.base0A : Theme.base03

                RegularText {
                    id: chip_text
                    text: option_chip.modelData
                    color: Theme.base00
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // ✅ Toggle — add if missing, remove if present
                        let current = [...multi_selector.selected];
                        const i = current.indexOf(option_chip.modelData);
                        if (i === -1)
                            current.push(option_chip.modelData);
                        else
                            current.splice(i, 1);

                        multi_selector.selected = current;
                        multi_selector.selectionChanged(current);
                    }
                }
            }
        }
    }
}
