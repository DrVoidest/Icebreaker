pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    readonly property string test_file: reader.text()
    readonly property string plz: "test2"
    FileView {
        id: reader
        path: Qt.resolvedUrl("../sshd_config")
        watchChanges: true
        onFileChanged: this.reload()
        blockLoading: true
    }
}
