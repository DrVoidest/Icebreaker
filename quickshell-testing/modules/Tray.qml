import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: root
    property int iconSize: Theme.font_size + 10 // seems a bit to small if I just do it as it is normaly

    implicitWidth: row.width
    implicitHeight: iconSize

    Row {
        id: row
        spacing: 4

        Repeater {
            model: SystemTray.items

            MouseArea {
                id: trayElement
                width: root.iconSize
                height: root.iconSize
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                required property SystemTrayItem modelData
                // Need this to make a menu for the apps context menu
                QsMenuAnchor {
                    id: menuAnchor
                    menu: trayElement.modelData.menu
                    anchor {
                        item: trayElement
                        edges: Edges.Bottom
                    }
                }

                onClicked: event => {
                    if (event.button === Qt.LeftButton) {
                        trayElement.modelData.activate();
                    } else if (event.button === Qt.RightButton) {
                        // This took way to long to figure out
                        if (trayElement.modelData.hasMenu) {
                            menuAnchor.open();
                        } else {
                            trayElement.modelData.secondaryActivate();
                        }
                    } else if (event.button === Qt.MiddleButton) {
                        trayElement.modelData.secondaryActivate();
                    }
                }

                Image {
                    id: icon
                    anchors.fill: parent
                    source: trayElement.modelData.icon
                    sourceSize: Qt.size(root.iconSize, root.iconSize)
                    smooth: true

                    // render as a texture (svg cases) seems to cause issues with rendering
                    //layer.enabled: true
                    //layer.smooth: true
                    //layer.textureSize: Qt.size(root.iconSize * 2, root.iconSize * 2)
                }
            }
        }
    }
}
