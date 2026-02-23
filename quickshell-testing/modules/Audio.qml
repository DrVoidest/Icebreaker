pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Pipewire

Singleton {
    id: root
    readonly property PwNodeAudio default_audio_sink: Pipewire.defaultAudioSink.audio
    readonly property string formated_audio: `${change_icon_sink(Pipewire.defaultAudioSink.audio)}${Math.ceil(default_audio_sink.volume * 100)}%${change_icon_source(Pipewire.defaultAudioSource.audio)}`

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
    function change_icon_sink(audio_sink) {
        if (audio_sink.muted) {
            return "  ";
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
            return " 󰍭";
        } else {
            return " 󰍬";
        }
    }
}
