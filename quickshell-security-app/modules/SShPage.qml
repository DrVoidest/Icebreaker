pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: ssh_item
    anchors.fill: parent
    readonly property var int_configs: ["ClientAliveCountMax", "ClientAliveInterval", "LoginGraceTime", "MaxAuthTries", "MaxSessions", "MaxStartups", "Protocol", "Port"]
    readonly property var select_configs: ["Ciphers", "KexAlgorithms", "Macs"] // Stuff to add: "LogLevel", "AddressFamily"
    readonly property var addressFamilyList: ["any", "inet", "inet6"]
    readonly property var logLevelList: ["QUIET", "FATAL", "ERROR", "INFO", "VERBOSE"]
    readonly property var sliderConfigs: ["LogLevel", "AddressFamily"]
    readonly property var typing_configs: ["AllowUsers", "AllowGroups"]
    readonly property var endCapConfigs: ["HostKey"]

    readonly property var hidden_configs: ["AuthorizedPrincipalsFile", "Banner", "Subsystem", "AuthorizedKeysFile"]

    Rectangle {
        width: parent.width
        height: parent.height
        color: Theme.base05

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
                id: delegate_loader
                required property string modelData
                width: ListView.view.width

                readonly property string delegateKey: modelData.split(" ")[0]
                readonly property string delegateValue: modelData.split(" ").slice(1).join(" ")

                readonly property bool isIntBox: int_configs.some(key => modelData.startsWith(key))
                readonly property bool isSelectBox: select_configs.some(key => modelData.startsWith(key))
                readonly property bool isSliderBox: sliderConfigs.some(key => modelData.startsWith(key))

                readonly property bool isTypingBox: typing_configs.some(key => modelData.startsWith(key))
                readonly property bool isHiddenBox: hidden_configs.some(key => modelData.startsWith(key))
                readonly property bool isEndBox: endCapConfigs.some(key => modelData.startsWith(key))

                sourceComponent: isSelectBox ? selectComponet : isIntBox ? null : isTypingBox ? null : isHiddenBox ? null : isSliderBox ? sliderComponet : isEndBox ? endCapComponet : toggleComponet
                Component {
                    id: ssh_lists
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
                        color: Theme.base05
                    }
                }
                Component {
                    id: sliderComponet
                    Rectangle {
                        id: sliderBoundingBox
                        implicitWidth: sliderDelegate.implicitWidth + Theme.margins
                        implicitHeight: sliderDelegate.implicitHeight + Theme.margins
                        color: Theme.base05

                        CustomSlider {
                            id: sliderDelegate
                            sliderLabel: delegate_loader.delegateKey + ":" + delegate_loader.delegateValue
                            itemList: delegate_loader.delegateKey === "LogLevel" ? ssh_item.logLevelList : ssh_item.addressFamilyList
                        }
                    }
                }

                Component {
                    id: selectComponet
                    Rectangle {
                        id: select_rec
                        implicitWidth: selectSelector.implicitWidth + Theme.margins
                        implicitHeight: selectSelector.implicitHeight + Theme.margins
                        color: Theme.base05
                        Process {
                            id: ssh_proc
                            command: delegate_loader.delegateKey === "KexAlgorithms" ? ["ssh", "-Q", "kex"] : delegate_loader.delegateKey === "Macs" ? ["ssh", "-Q", "mac"] : delegate_loader.delegateKey === "Ciphers" ? ["ssh", "-Q", "cipher"] : "We should never get here"
                            running: true

                            stdout: StdioCollector {
                                id: ssh_output
                                onStreamFinished: {
                                    selectSelector.options = text.split("\n").filter(line => line.trim() !== "");
                                }
                            }
                        }
                        MultiSelector {
                            id: selectSelector
                            width: parent.width
                            text: delegate_loader.delegateKey + ":"
                            options: ["Will", "be overwriten"]

                            selected: delegate_loader.delegateValue ? delegate_loader.delegateValue.split(",") : []

                            onSelectionChanged: function (sel) {
                                console.log(delegate_loader.delegateKey + " selected: " + sel);
                                FileReader.multiSelector(delegate_loader.delegateKey, sel);
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                Component {
                    id: toggleComponet
                    Rectangle {
                        id: toggle_rec
                        implicitWidth: toggleSwitch.implicitWidth + Theme.margins
                        implicitHeight: toggleSwitch.implicitHeight + Theme.margins
                        color: Theme.base05

                        Toggle {
                            id: toggleSwitch
                            labelText: delegate_loader.delegateKey + ":"
                            isToggled: delegate_loader.delegateValue === "yes" ? true : false
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }
}
