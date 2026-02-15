pragma Singleton
import Quickshell
import QtQuick

// Will later read from json to configure

Singleton {
    id: root
    property int margins: 10
    property string time: "tEst"
}
