pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: sshItem
    anchors.fill: parent
    readonly property var intConfigs: ["ClientAliveCountMax", "ClientAliveInterval", "LoginGraceTime", "MaxAuthTries", "MaxSessions", "MaxStartups", "Protocol", "Port"]
    readonly property var selectConfigs: ["Ciphers", "KexAlgorithms", "Macs"] // Stuff to add: "LogLevel", "AddressFamily"
    readonly property var addressFamilyList: ["any", "inet", "inet6"]
    readonly property var logLevelList: ["QUIET", "FATAL", "ERROR", "INFO", "VERBOSE"]
    readonly property var sliderConfigs: ["LogLevel", "AddressFamily"]
    readonly property var typingConfigs: ["AllowUsers", "AllowGroups"]
    readonly property var endCapConfigs: ["HostKey"]

    readonly property var hiddenConfigs: ["AuthorizedPrincipalsFile", "Banner", "Subsystem", "AuthorizedKeysFile"]

    Rectangle {
        width: parent.width
        height: parent.height
        color: Theme.base00
        ListView {
            spacing: 0
            anchors.top: parent.top
            interactive: true
            Layout.fillHeight: true
            width: parent.width
            clip: true
            height: parent.height - (parent.height / 20)
            orientation: ListView.VerticalTopToBottom

            model: FileReader.sshConfigFile.slice(0, -1)
            delegate: Loader {
                id: delegateLoader
                required property string modelData
                width: ListView.view.width

                readonly property string delegateKey: modelData.split(" ")[0]
                readonly property string delegateValue: modelData.split(" ").slice(1).join(" ")

                readonly property bool isIntBox: intConfigs.some(key => modelData.startsWith(key))
                readonly property bool isSelectBox: selectConfigs.some(key => modelData.startsWith(key))
                readonly property bool isSliderBox: sliderConfigs.some(key => modelData.startsWith(key))

                readonly property bool isTypingBox: typingConfigs.some(key => modelData.startsWith(key))
                readonly property bool isHiddenBox: hiddenConfigs.some(key => modelData.startsWith(key))
                readonly property bool isEndBox: endCapConfigs.some(key => modelData.startsWith(key))

                sourceComponent: isSelectBox ? selectComponet : isIntBox ? null : isTypingBox ? null : isHiddenBox ? null : isSliderBox ? sliderComponet : isEndBox ? endCapComponet : toggleComponet
                Component {
                    id: sshLists
                    Item {
                        width: 0
                        height: 0
                        implicitWidth: 0
                        implicitHeight: 0
                    }
                }
                Component {
                    id: endCapComponet
                    Rectangle {
                        id: endCapBoundingBox
                        implicitWidth: 50 + Theme.margins
                        implicitHeight: 50 + Theme.margins
                        color: Theme.base00
                    }
                }
                Component {
                    id: sliderComponet
                    Rectangle {
                        id: sliderBoundingBox
                        implicitWidth: sliderDelegate.implicitWidth + Theme.margins
                        implicitHeight: sliderDelegate.implicitHeight + Theme.margins
                        color: Theme.base00

                        CustomSlider {
                            id: sliderDelegate
                            sliderLabel: delegateLoader.delegateKey + ":" + delegateLoader.delegateValue
                            itemList: delegateLoader.delegateKey === "LogLevel" ? sshItem.logLevelList : sshItem.addressFamilyList
                        }
                    }
                }

                Component {
                    id: selectComponet
                    Rectangle {
                        id: selectRectangle
                        implicitWidth: selectSelector.implicitWidth + Theme.margins
                        implicitHeight: selectSelector.implicitHeight + Theme.margins
                        color: Theme.base00
                        Process {
                            id: sshProc
                            command: delegateLoader.delegateKey === "KexAlgorithms" ? ["ssh", "-Q", "kex"] : delegateLoader.delegateKey === "Macs" ? ["ssh", "-Q", "mac"] : delegateLoader.delegateKey === "Ciphers" ? ["ssh", "-Q", "cipher"] : "We should never get here"
                            running: true

                            stdout: StdioCollector {
                                id: sshOutput
                                onStreamFinished: {
                                    selectSelector.options = text.split("\n").filter(line => line.trim() !== "");
                                }
                            }
                        }
                        MultiSelector {
                            id: selectSelector
                            width: parent.width
                            text: delegateLoader.delegateKey + ":"
                            options: ["Will", "be overwriten"]

                            selected: delegateLoader.delegateValue ? delegateLoader.delegateValue.split(",") : []

                            onSelectionChanged: function (sel) {
                                console.log(delegateLoader.delegateKey + " selected: " + sel);
                                FileReader.multiSelector(delegateLoader.delegateKey, sel);
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                Component {
                    id: toggleComponet
                    Rectangle {
                        id: toggleRectangle
                        implicitWidth: toggleSwitch.implicitWidth + Theme.margins
                        implicitHeight: toggleSwitch.implicitHeight + Theme.margins
                        color: Theme.base00

                        Toggle {
                            id: toggleSwitch
                            labelText: delegateLoader.delegateKey + ":"
                            isToggled: delegateLoader.delegateValue === "yes" ? true : false
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }
}
