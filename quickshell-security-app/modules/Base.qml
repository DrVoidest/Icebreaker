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
            readonly property var pageList: ["Home", "SSh", "ClamAV", "Quit"]
            property string currentPage: pageList[0]

            color: Theme.themeData.colors["base00"]
            implicitHeight: 800
            implicitWidth: 500
            title: "Icebreaker"
            ListView {
                id: pageBar
                spacing: 0
                anchors.top: parent.top
                interactive: false
                width: base.appW
                clip: true
                height: base.appHD25 + 10
                orientation: ListView.Horizontal
                model: base.pageList
                anchors.horizontalCenter: parent.horizontalCenter

                Process {
                    id: pageSwitcher
                    running: false
                }
                delegate: Rectangle {
                    id: pageButton
                    required property string modelData
                    width: pageBar.width / base.pageList.length
                    implicitHeight: base.appHD25
                    anchors.verticalCenter: parent.verticalCenter

                    radius: 15
                    color: modelData === "Quit" ? Theme.themeData.colors["base08"] : base.currentPage === modelData ? Theme.themeData.colors["base0A"] : Theme.themeData.colors["base0B"]

                    RegularText {
                        id: pageText
                        text: pageButton.modelData
                        color: Theme.themeData.colors["base00"]
                        width: parent.width
                        height: parent.height

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        id: pageMouseArea
                        anchors.fill: parent
                        onClicked: {
                            if (pageButton.modelData === "Quit") {
                                console.log("User exited app.");
                                Qt.quit();
                            } else {
                                pageArea.loadPage(pageButton.modelData + "Page.qml");
                                base.currentPage = pageButton.modelData;
                                console.log("User switched to " + pageButton.modelData + " page.");
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: pageArea
                color: Theme.themeData.colors["base0A"]
                y: base.appHD25 + 10
                implicitWidth: base.width
                implicitHeight: base.height
                Layout.fillHeight: true
                Timer {
                    interval: 0
                    running: true
                    repeat: false
                    onTriggered: pageArea.loadPage("HomePage.qml")
                }
                function loadPage(url) {
                    if (pageLoader.active && pageLoader.source === url)
                        return;

                    pageLoader.active = false;
                    pageLoader.source = url;
                    pageLoader.active = true;
                    pageLoader.item.parent = pageArea;
                }
                LazyLoader {
                    id: pageLoader
                }
            }
        }
    }
}
