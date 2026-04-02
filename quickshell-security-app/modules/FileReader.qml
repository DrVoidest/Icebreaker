pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    readonly property var test_file: reader.text().split("\n")
    FileView {
        id: reader
        path: Qt.resolvedUrl("../sshd_config")
        watchChanges: true
        onFileChanged: this.reload()
        blockLoading: true
    }
    function toggle(lineValue) {
        let lines = root.test_file.slice();
        let targetIndex = lines.findIndex(line => line.startsWith(lineValue[0]));
        if (targetIndex !== -1) {
            let workingLine = lines[targetIndex];
            if (lineValue[1] === "yes") {
                lines[targetIndex] = lineValue[0] + " no";
            } else {
                lines[targetIndex] = lineValue[0] + " yes";
            }
            reader.setText(lines.join("\n"));
        } else {
            console.warn("Quickshell FileView: No line found starting with '" + lineValue + "'");
        }
    }
}
