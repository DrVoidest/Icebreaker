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
        let splitLineValue = lineValue.toString().split(":");
        let lineStart = splitLineValue[0];
        let lineEnd = splitLineValue[1] === true ? "yes" : "no";

        let lines = root.test_file.slice();
        let targetIndex = lines.findIndex(line => line.startsWith(lineStart));
        if (targetIndex !== -1) {
            let workingLine = lines[targetIndex];
            if (splitLineValue[1] === "false") {
                lines[targetIndex] = lineStart + " no";
            } else {
                lines[targetIndex] = lineStart + " yes";
            }
            reader.setText(lines.join("\n"));
        } else {
            console.warn("Quickshell FileView: No line found starting with '" + lineStart + "'");
        }
    }
    function multiSelector(lineValue, newVales) {
        let lines = root.test_file.slice();
        let targetIndex = lines.findIndex(line => line.startsWith(lineValue[0]));
        if (targetIndex !== -1) {
            let workingLine = lines[targetIndex];
            lines[targetIndex] = lineValue + " " + newVales;
            reader.setText(lines.join("\n"));
        } else {
            console.warn("Quickshell FileView: No line found starting with '" + lineValue + "'");
        }
    }
    function slider(lineValue, newValue) {
        let lines = root.test_file.slice();
        let targetIndex = lines.findIndex(line => line.trim().startsWith(lineValue));
        if (targetIndex !== -1) {
            let workingLine = lines[targetIndex];
            // Preserve any leading whitespace from the original line
            let leadingWhitespace = workingLine.match(/^\s*/)[0];
            lines[targetIndex] = leadingWhitespace + lineValue + " " + newValue;
            reader.setText(lines.join("\n"));
        } else {
            console.warn("Quickshell FileView: No line found starting with '" + lineValue + "'");
        }
    }
}
