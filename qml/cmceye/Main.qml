import QtQuick 1.0
import "functions.js" as Helper

Rectangle {
    id: main
    width: 600
    height: 600

    Canvas { id: canvas }
    ThumbChooser { id: thumbnails; opacity: 0 }
    Toolbox { id: toolbox }

    Component.onCompleted: {
        Helper.loadFromFile(main);
    }

    Connections {
        target: document
        onRepaint: { canvas.source = "image://document/" + Math.random() }
    }

    Binding {
        target: viewer
        property: "windowFilePath"
        value: document.source
    }

    Binding {
        target: viewer
        property: "windowModified"
        value: document.modified
    }
}
