import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: clamAVItem
    anchors.fill: parent
    property string currentScanOutput: "No scan running"
    property bool isScaning: false
    Process {
        id: clamScanRunner
        command: ["sh"]

        stdout: StdioCollector {

            onStreamFinished: {
                clamAVItem.currentScanOutput = text;
                clamAVItem.isScaning = false;
            }
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: Theme.themeData.colors["base00"]
        Column {
            Rectangle {
                id: downloadsScanerBox
                width: 300 + Theme.margins
                height: width / 8
                radius: 10
                color: Theme.themeData.colors["base0A"]
                RegularText {
                    id: downloadsScanerText
                    text: "Scan Download's folder"
                    width: parent.width
                    height: parent.height

                    color: Theme.themeData.colors["base00"]
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea {
                    id: downloadsScanerMouseArea
                    anchors.fill: parent
                    enabled: !clamAVItem.isScaning
                    onClicked: {
                        console.log("Download folder scan starting");
                        clamAVItem.isScaning = true;
                        downloadsScanerBox.color = Theme.base0B;
                        clamAVItem.currentScanOutput = "Scan running";
                        clamScanRunner.command = ["sh", "-c", "clamscan ~/Downloads -o > ../clamdscan.log"];

                        clamScanRunner.running = true;
                        clamAVItem.isScaning = true;
                        clamScanRunner.command = ["sh", "-c", "./clamConverter.py ../clamdscan.log > clamscan.json"];
                        clamScanRunner.running = true;
                    }
                }
            }
            Rectangle {
                id: spacerTop
                width: 15 + Theme.margins
                height: width / 2
                radius: 10
                color: Theme.themeData.colors["base00"]
            }

            Row {
                id: scheduleRow
                property int hour: 13
                spacing: Theme.margins
                RegularText {
                    text: "Scan at: "
                    color: Theme.themeData.colors["base07"]
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    id: minusButton
                    width: 25 + Theme.margins
                    height: width
                    radius: 10
                    color: Theme.themeData.colors["base0A"]
                    RegularText {
                        id: minusButtonText
                        text: "-"
                        width: parent.width
                        height: parent.height
                        color: Theme.themeData.colors["base00"]
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            let newtime = scheduleRow.hour - 1;
                            if (newtime <= 0) {
                                newtime = 24;
                            }
                            scheduleRow.hour = newtime;
                        }
                    }
                }
                RegularText {
                    text: scheduleRow.hour > 12 ? scheduleRow.hour - 12 + " PM" : scheduleRow.hour + " AM"
                    color: Theme.themeData.colors["base07"]
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                id: spacerBottom
                width: 15 + Theme.margins
                height: width / 2
                radius: 10
                color: Theme.themeData.colors["base00"]
            }

            RegularText {
                text: "Current scan progress: " + clamAVItem.currentScanOutput
                color: Theme.themeData.colors["base07"]
            }
            x: Theme.margins
            RegularText {
                text: "ClamAV Scan Result"
                color: Theme.themeData.colors["base07"]
            }
            RegularText {
                text: "Known viruses: " + FileReader.scanData.summary["Known viruses"]
                color: Theme.themeData.colors["base07"]
            }

            RegularText {
                text: "Engine version: " + FileReader.scanData.summary["Engine version"]
                color: Theme.themeData.colors["base07"]
            }
            RegularText {
                text: "Scanned files: " + FileReader.scanData.summary["Scanned files"]
                color: Theme.themeData.colors["base07"]
            }
            RegularText {
                text: "Infected files: " + FileReader.scanData.summary["Infected files"]
                color: Theme.themeData.colors["base07"]
            }
            RegularText {
                text: "Time: " + FileReader.scanData.summary["Time"]
                color: Theme.themeData.colors["base07"]
            }
        }
    }
}
