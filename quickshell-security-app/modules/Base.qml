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

            readonly property var page_list: ["Home", "SSH"]
            property string currentPage: "Home"
            screen: modelData
            color: Theme.base00
            implicitHeight: appH / 2
            implicitWidth: appW
            ListView {
                id: pages_bar
                orientation: ListView.Horizontal
                Layout.fillHeight: true
                width: parent.implicitWidth
                spacing: 2
                model: ListModel {
                    id: page_model
                }
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
                // Will get moved into a model latter
                Rectangle {
                    id: home_page
                    implicitHeight: base.appH / 25
                    implicitWidth: 50
                    radius: 15
                    color: base.currentPage === "Home" ? Theme.base0A : Theme.base0B
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
                            base.currentPage = "Home";
                            console.log("User switched to Home page.");
                        }
                    }
                }
                Rectangle {
                    id: ssh_page_button
                    implicitHeight: base.appH / 25
                    implicitWidth: 50
                    radius: 15
                    color: base.currentPage === "SSH" ? Theme.base0A : Theme.base0B
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
                            base.currentPage = "SSH";
                            console.log("User switched to ssh page.");
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
                        text: "Quit"
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
