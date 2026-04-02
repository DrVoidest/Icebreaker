pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: base
            required property var modelData
            readonly property var appH: modelData.height / 2
            readonly property var appW: modelData.width / 2
            readonly property int appD25: base.appH / 25
            readonly property var page_list: ["Home", "SSh", "ClamAV", "Quit"]
            property string currentPage: page_list[0]

            screen: modelData
            color: Theme.base00
            implicitHeight: appH / 2
            implicitWidth: appW
            ListView {
                id: pages_bar
                spacing: 2
                anchors.top: parent.top
                interactive: true
                Layout.fillHeight: true
                width: parent.width
                clip: true
                height: base.appD25 + 10
                orientation: ListView.Horizontal
                model: base.page_list

                Process {
                    id: page_switcher
                    running: false
                }
                delegate: Rectangle {
                    id: page_button
                    required property string modelData
                    implicitHeight: base.appD25
                    implicitWidth: base.appW / 18
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 15
                    color: modelData === "Quit" ? Theme.base08 : base.currentPage === modelData ? Theme.base0A : Theme.base0B

                    RegularText {
                        id: page_text
                        text: page_button.modelData
                        color: Theme.base00
                        width: parent.width
                        height: parent.height

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        id: page_mouse_area
                        anchors.fill: parent
                        onClicked: {
                            if (page_button.modelData === "Quit") {
                                console.log("User exited app.");
                                Qt.quit();
                            } else {
                                page_area.loadPage(page_button.modelData + "Page.qml");
                                base.currentPage = page_button.modelData;
                                console.log("User switched to " + page_button.modelData + " page.");
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: page_area
                color: Theme.base0A
                y: base.appD25 + 10
                implicitWidth: appW
                implicitHeight: appH - 32
                Timer {
                    interval: 0
                    running: true
                    repeat: false
                    onTriggered: page_area.loadPage("HomePage.qml")
                }
                function loadPage(url) {
                    if (page_loader.active && page_loader.source === url)
                        return;

                    page_loader.active = false;
                    page_loader.source = url;
                    page_loader.active = true;
                    page_loader.item.parent = page_area;
                }
                LazyLoader {
                    id: page_loader
                }
            }
        }
    }
}
