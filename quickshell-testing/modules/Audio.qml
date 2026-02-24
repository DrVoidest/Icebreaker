import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire

RowLayout {
    id: audio_row
    spacing: 3

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    function change_icon_sink(audio_sink) {
        if (audio_sink.muted) {
            return " ";
        } else {
            if (Math.ceil(audio_sink.volume * 100) >= 66) {
                return "󰕾 ";
            }
            if (Math.ceil(audio_sink.volume * 100) >= 33) {
                return "󰖀 ";
            }
            if (Math.ceil(audio_sink.volume * 100) < 33) {
                return "󰕿 ";
            }
        }
    }
    function change_icon_source(audio_source) {
        if (audio_source.muted) {
            return "󰍭";
        } else {
            return "󰍬";
        }
    }

    Item {
        id: sink_status_wrapper
        implicitWidth: sink_status.width
        height: sink_status.height
        RegularText {
            id: sink_status
            text: audio_row.change_icon_sink(Pipewire.defaultAudioSink.audio)
        }
        MouseArea {
            id: sink_status_mouse_area
            anchors.fill: parent
            onClicked: {
                sink_toggle.exec(["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"]);
            }
        }
        Process {
            id: sink_toggle
            running: false
        }
    }
    Item {
        id: sink_volume_wrapper
        implicitWidth: sink_volume.width

        height: sink_volume.height
        RegularText {
            id: sink_volume
            text: Math.floor(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
        }
        MouseArea {
            id: sink_volume_mouse_area
            anchors.fill: parent
            onClicked: {
                sink_toggle.exec(["pwvucontrol"]);
            }
        }
        Process {
            id: sink_exec
            running: false
        }
    }
    Item {
        id: source_wrapper
        implicitWidth: source.width
        height: source.height
        RegularText {
            id: source
            text: audio_row.change_icon_source(Pipewire.defaultAudioSource.audio)
        }
        MouseArea {
            id: source_mouse_area
            anchors.fill: parent
            onClicked: {
                source_toggle.exec(["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"]);
            }
        }
        Process {
            id: source_toggle
            running: false
        }
    }
}
