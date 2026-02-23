pragma Singleton

import Quickshell

import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root
    property string formated_power: root.change_icon(Math.round(UPower.displayDevice.percentage * 100)) // round the number because of floating point issues
    Connections {
        target: UPower.displayDevice
        function onPercentageChanged() {
        }
    }
    function change_icon(percentage) {
        if (UPower.onBattery) {
            if (percentage >= 70) {
                return `󰁹 ${percentage}%`;
            }
            if (percentage >= 60) {
                return `󰁿 ${percentage}%`;
            }
            if (percentage >= 50) {
                return `󰁾 ${percentage}%`;
            }
            if (percentage >= 40) {
                return `󰁽 ${percentage}%`;
            }
            if (percentage >= 25) {
                return `󰁼 ${percentage}%`;
            }
            if (percentage < 25) {
                return `󰂃 ${percentage}%`;
            }
        } else {
            return `󰂄 ${percentage}%`;
        }
    }
}
