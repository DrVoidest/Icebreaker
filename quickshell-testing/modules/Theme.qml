pragma Singleton
import Quickshell
import QtQuick

// Will later read from json to configure. I tried this and it went very badly I will come back to it later

Singleton {
    id: root
    // Fonts
    readonly property string font_family: "Maple Mono NF" // To make it look fancy turn on italic
    readonly property int fontSize: parseInt(Quickshell.env("FONT_SIZE")) || 13
    // Colors
    readonly property color base00: "#0c1118" // Used for base
    readonly property color base01: "#181c22"
    readonly property color base02: "#22262d"
    readonly property color base03: "#7b776e"
    readonly property color base04: "#949088"
    readonly property color base05: "#afaba2" // Used for text
    readonly property color base06: "#cac6bd"
    readonly property color base07: "#e7e2d9"
    readonly property color base08: "#f04339"
    readonly property color base09: "#df5923"
    readonly property color base0A: "#bb8801"
    readonly property color base0B: "#7f8b00"
    readonly property color base0C: "#00948b"
    readonly property color base0D: "#008dd1"
    readonly property color base0E: "#6a7fd2"
    readonly property color base0F: "#e3488e"
    // Margins
    readonly property int margins: 10
}
