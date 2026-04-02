pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    Variants {
        model: Quickshell.screens
        FloatingWindow {
            id: base
            required property var modelData
            readonly property var appH: height
            readonly property var appW: width
            readonly property int appHD25: base.appH / 25
            readonly property var page_list: ["Home", "SSh", "ClamAV", "Quit"]
            property string currentPage: page_list[0]

            //screen: modelData
            color: Theme.base00
            implicitHeight: 800
            implicitWidth: 500
            title: "Icebreaker"
            ListView {
                id: pages_bar
                spacing: 0
                anchors.top: parent.top
                interactive: false
                width: base.appW
                clip: true
                height: base.appHD25 + 10
                orientation: ListView.Horizontal
                model: base.page_list
                anchors.horizontalCenter: parent.horizontalCenter

                Process {
                    id: page_switcher
                    running: false
                }
                delegate: Rectangle {
                    id: page_button
                    required property string modelData
                    width: pages_bar.width / base.page_list.length
                    implicitHeight: base.appHD25
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
                y: base.appHD25 + 10
                implicitWidth: base.width
                implicitHeight: base.height
                Layout.fillHeight: true
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
