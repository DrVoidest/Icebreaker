import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    property string time
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData

            screen: modelData
            color: Theme.base00
            implicitHeight: 30 // Should be the same size as the rectangles
            implicitWidth: 30
            anchors {
                top: true
                left: true
                right: true
            }
            RowLayout {
                id: row_layout
                spacing: 10
                anchors.fill: parent
                Workspaces {} // Grabs workspace module
                Item {
                    // Acts as a spacer
                    Layout.fillWidth: true
                }
                Tray {}
                Audio {}
                RegularText {
                    id: clock
                    text: `${Battery.formated_power} ${Clock.time} `
                }
            }
        }
    }
}
