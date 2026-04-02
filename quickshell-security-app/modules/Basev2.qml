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

            readonly property var page_list: ["Home", "SSh", "Quit"]
            property string currentPage: page_list[0]
            screen: modelData
            color: Theme.base00
            implicitHeight: appH / 2
            implicitWidth: appW
            ListView {
                id: pages_bar
                orientation: ListView.Horizontal
                Layout.fillHeight: true
                width: parent.implicitWidth
                height: parent.height
                spacing: 2
                model: pages_list
                //                model: ListModel {
                //                   id: page_model
                //               }
                delegate: Rectangle {
                    id: page_button
                    implicitHeight: base.appH / 25
                    implicitWidth: 50
                    radius: 15
                    color: Theme.base0B
                }
            }
            RowLayout {
                id: pages_list
                Layout.fillHeight: true
                width: parent.implicitWidth
                spacing: Theme.margins / 2
                Process {
                    id: page_switcher
                    running: false
                }
                Rectangle {
                    id: home_page
                    implicitHeight: base.appH / 25
                    implicitWidth: 50
                    radius: 15
                    color: base.currentPage === page_list[0] ? Theme.base0A : Theme.base0B
                    RegularText {
                        id: homeText
                        text: base.page_list[0]
                        color: Theme.base00
                        width: parent.width
                        height: parent.height

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        id: home_mouse_area
                        anchors.fill: homeText
                        onClicked: {
                            page_area.loadPage("HomePage.qml");
                            base.currentPage = page_list[0];
                            console.log("User switched to " + page_list[0] + " page.");
                        }
                    }
                }
                Rectangle {
                    id: ssh_page_button
                    implicitHeight: base.appH / 25
                    implicitWidth: 50
                    radius: 15
                    color: base.currentPage === page_list[1] ? Theme.base0A : Theme.base0B
                    RegularText {
                        text: base.page_list[1]
                        color: Theme.base00
                        width: parent.width
                        height: parent.height

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        id: ssh_mouse_area
                        anchors.fill: parent
                        onClicked: {
                            page_area.loadPage("SShPage.qml");
                            base.currentPage = page_list[1];
                            console.log("User switched to " + page_list[1] + " page.");
                        }
                    }
                }

                Rectangle {
                    id: quit
                    implicitHeight: base.appH / 25
                    implicitWidth: 50
                    radius: 15
                    color: Theme.base08 // F
                    RegularText {
                        text: page_list[2]
                        color: Theme.base00
                        width: parent.width
                        height: parent.height

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        id: quit_mouse_area
                        anchors.fill: parent
                        onClicked: {
                            console.log("User exited app.");
                            page_switcher.exec(["sh", "-c", `qs kill --pid ${Quickshell.processId}`]);
                        }
                    }
                }
            }
            Rectangle {
                id: page_area
                color: Theme.base0A
                y: quit.height + Theme.margins
                implicitWidth: appW
                implicitHeight: appH - (quit.height + 0)
                // Hack to make Home page load by default
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
                //page_loader.item.anchors.fill = page_area;
                }
                LazyLoader {
                    id: page_loader
                }
            }
        }
    }
}
