import QtQuick 1.0
import CustomComponents 1.0
import "logic.js" as Logic

Rectangle {
    id: main
    width: 600
    height: 600

    Canvas { id: canvas }
    ThumbChooser { id: thumbnails }
    Toolbox { id: toolbox }

    Component.onCompleted: {
        document.changed.connect(function(rect) {canvas.source = "image://document/"});
        document.load("qml/cmceye/example.jpg");
    }

    Binding {
        target: document
        property: "selection"
        value: canvas.selection
    }
}
