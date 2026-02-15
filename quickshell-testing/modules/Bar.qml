import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root
    property string time
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            color: Theme.base00
            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            Row {
                id: workspace_row
                spacing: 1
                // Creates a vector of our in use workspaces
                property var in_use_workspaces_vector: Workspaces.in_use_workspaces.trim().split("\n")
                property int current_workspace_int: Workspaces.current_workspace
                Repeater {
                    model: Workspaces.total_workspaces
                    anchors.leftMargin: 10

                    Rectangle {
                        // Helps with spacing
                        width: workspace_text.implicitWidth + 20
                        height: 30
                        radius: 15
                        property string current_workspace_index: workspace_row.in_use_workspaces_vector[index] || ""

                        property bool isCurrent: current_workspace_index == workspace_row.current_workspace_int
                        color: isCurrent ? Theme.base0A : Theme.base0B
                        // Animations :)
                        // Spring animation for the width change
                        Behavior on width {
                            SpringAnimation {
                                spring: 13.0   // Determines the acceleration (stiffness)
                                damping: 1.0  // Determines how quickly it settles (lower = more bounces)
                            }
                        }

                        // 2. Smooth fade for the color change
                        Behavior on color {
                            ColorAnimation {
                                duration: 400 // 200 milliseconds
                            }
                        }
                        Text {
                            id: workspace_text
                            font.family: Theme.font_family
                            font.pointSize: Theme.font_size
                            color: Theme.base00
                            text: parent.isCurrent ? "| " + parent.current_workspace_index + " |" : parent.current_workspace_index
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: Config.margins
                        }
                    }
                }
            }
            // Center aligned
            Text {
                text: "some very fancy looking text"
                font.family: Theme.font_family
                font.pointSize: Theme.font_size
                color: Theme.base05
                font.italic: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Right Aligned
            Text {
                text: Clock.time
                font.family: Theme.font_family
                font.pointSize: Theme.font_size
                color: Theme.base05
                anchors.right: parent.right
                anchors.rightMargin: Theme.margins
            }
        }
    }
}
