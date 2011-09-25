import QtQuick 1.0
import "functions.js" as Helper

Image {
    id: main
    width: 600
    height: 600

    source: "img/bg.png"
    fillMode: Image.Tile

    Canvas { id: canvas }
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
