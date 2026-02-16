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

            implicitHeight: 30 // was 30

            ListView {
                id: workspace_list

                height: 30
                width: parent.width
                orientation: ListView.Horizontal
                spacing: 1
                interactive: false

                // Create template for workspaces
                model: ListModel {
                    id: workspace_model
                }

                // Add or removes workspaces to model
                property var rawWorkspaces: Workspaces.self_triming

                onRawWorkspacesChanged: {
                    if (!rawWorkspaces)
                        return;
                    var incoming = rawWorkspaces.slice(1);

                    // remove
                    for (var i = workspace_model.count - 1; i >= 0; i--) {
                        var currentName = workspace_model.get(i).workspaceName;
                        if (incoming.indexOf(currentName) === -1) {
                            workspace_model.remove(i);
                        }
                    }

                    // add
                    for (var j = 0; j < incoming.length; j++) {
                        var incomingName = incoming[j];
                        var found = false;

                        for (var k = 0; k < workspace_model.count; k++) {
                            if (workspace_model.get(k).workspaceName === incomingName) {
                                found = true;
                                break;
                            }
                        }

                        if (!found) {
                            // Triggers the animations
                            workspace_model.insert(j, {
                                "workspaceName": incomingName
                            });
                        }
                    }
                }

                // Animations :)
                add: Transition {
                    NumberAnimation {
                        property: "scale"
                        from: 0.0
                        to: 1.0
                        duration: 550
                        easing.type: Easing.OutBack
                    }
                }

                remove: Transition {
                    NumberAnimation {
                        property: "width"
                        to: 0.0
                        duration: 650
                        easing.type: Easing.InBack
                    }
                }

                displaced: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: 650
                        easing.type: Easing.OutQuad
                    }
                }

                // What it will create (May be turned into a button later)
                delegate: Rectangle {
                    id: workspace_rect

                    // Check if we are in current workspace to add highlighting
                    property string current_workspace_index: model.workspaceName
                    property bool isCurrent: current_workspace_index === Workspaces.self_triming[0]

                    transformOrigin: Item.Center
                    width: workspace_text.implicitWidth + 20
                    height: 30
                    radius: 15

                    color: isCurrent ? Theme.base0A : Theme.base0B

                    Behavior on width {
                        SpringAnimation {
                            spring: 13.0
                            damping: 1.0
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 1000
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
            // Center aligned
            Text {

                //text: "some very fancy looking text" + "T1: " + Workspaces.self_triming.slice(1, Workspaces.self_triming.length)
                //text: "test" + Workspaces.self_triming.slice(1)
                text: "test"
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
