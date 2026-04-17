import QtQuick
import Quickshell.Io
import QtQuick.Layouts

ListView {
    id: workspace_list

    width: 50 * 9
    orientation: ListView.Horizontal
    spacing: 1
    interactive: false
    Layout.fillHeight: true
    // Create template for workspaces
    model: ListModel {
        id: workspace_model
    }

    // Add or removes workspaces to model
    property var rawWorkspaces: workspace_runner.self_triming

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
        for (var j = 0; j < incoming.length; j++) { // j was 0
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

    delegate: Rectangle {
        id: workspace_rect

        // Check if we are in current workspace to add highlighting
        property string current_workspace_index: model.workspaceName
        property bool isCurrent: current_workspace_index === workspace_runner.self_triming[0]
        transformOrigin: Item.Center
        width: workspace_text.implicitWidth + 20
        height: 30
        //Layout.fillHeight: true
        radius: 15

        color: isCurrent ? Theme.themeData.colors["base0A"] : Theme.themeData.colors["base0B"]

        Behavior on width {
            SpringAnimation {
                spring: 13.0 // Determines the acceleration (stiffness)
                damping: 0.3  // Determines how quickly it settles (lower = more bounces)
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 1000
            }
        }
        Process {
            id: workspace_switcher
            running: false
        }

        Text {
            id: workspace_text
            font.family: Theme.fontFamily
            width: parent.width
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: Theme.fontSize
            color: Theme.themeData.colors["base00"]
            text: parent.isCurrent ? "|" + parent.current_workspace_index + "|" : parent.current_workspace_index
            Layout.leftMargin: Config.margins
        }
        MouseArea {
            id: workspace_mouse_area
            anchors.fill: parent
            onClicked: {
                workspace_switcher.exec(["sh", "-c", `mmsg -t ${parent.current_workspace_index}`]);
            }
        }
    }
    Item {
        id: workspace_runner
        property var self_triming
        // Black magic to lessen the amount of processes quickshell needs to run
        Process {
            id: self_triming_process
            command: ["sh", "-c", "mmsg -g -t | awk '$4 { print $3 }' | head -c 1 && printf '\n' && mmsg -g -t | awk '$5 >= 1 { print $3 }'"]
            running: true

            stdout: StdioCollector {
                onStreamFinished: workspace_runner.self_triming = this.text.trim().split("\n")
            }
        }

        Timer {
            interval: 500 // Was 1000
            running: true
            repeat: true
            onTriggered: self_triming_process.running = true
        }
        // Process {
        //     id: workspace_switcher
        //     running: false
        //}
    }
}
