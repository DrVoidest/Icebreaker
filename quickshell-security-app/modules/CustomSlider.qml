import QtQuick
import QtQuick.Controls

Item {
    id: customSlider
    property var itemList: ["QUIET", "FATAL", "ERROR", "INFO", "VERBOSE"]
    property int itemListLen: itemList.length - 1 // Accounts for qt counting for zero in the slider control
    property int longestWordLen: Math.max(...itemList.map(s => s.length)) + 1 //+1 for spacing
    property var paddedItemList: itemList.map(s => s.padEnd(longestWordLen))
    property string sliderLabel: "cool"
    property string sliderLabelStart: sliderLabel.split(":")[0]
    property string sliderLabelEnd: sliderLabel.split(":")[1]
    property int currentIndex: paddedItemList.findIndex(s => s.trim() === sliderLabelEnd.trim())
    implicitHeight: sliderRow.implicitHeight
    implicitWidth: sliderRow.implicitWidth
    Row {
        id: sliderRow
        anchors.verticalCenter: parent.verticalCenter
        x: Theme.margins
        RegularText {
            id: labelText
            text: customSlider.sliderLabelStart + ": "
            color: Theme.base07
            anchors.verticalCenter: parent.verticalCenter
        }

        RegularText {
            id: sliderText
            text: customSlider.paddedItemList[sliderControl.value]
            color: Theme.base07
            anchors.verticalCenter: parent.verticalCenter
        }

        Slider {
            id: sliderControl
            from: 0
            stepSize: 1
            snapMode: Slider.SnapOnRelease
            value: customSlider.currentIndex
            to: customSlider.itemListLen
            x: sliderText.x + sliderText.implicitWidth + Theme.margins
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                x: sliderControl.leftPadding
                y: sliderControl.topPadding + sliderControl.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: sliderControl.availableWidth
                height: implicitHeight
                radius: 2
                color: Theme.base03

                Rectangle {
                    width: sliderControl.visualPosition * parent.width
                    height: parent.height
                    color: Theme.base0B
                    radius: 2
                }
            }
            handle: Rectangle {
                x: sliderControl.leftPadding + sliderControl.visualPosition * (sliderControl.availableWidth - width)
                y: sliderControl.topPadding + sliderControl.availableHeight / 2 - height / 2
                implicitWidth: 26
                implicitHeight: 26
                radius: 13
                color: Theme.base0A
            }
            onMoved: {
                const index = Math.round(position * customSlider.itemListLen);
                sliderText.text = customSlider.paddedItemList[index];
                FileReader.slider(customSlider.sliderLabel.split(":")[0], customSlider.paddedItemList[index]);
            }
        }
    }
}
