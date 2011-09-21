import QtQuick 1.0
import CustomComponents 1.0

Rectangle {
    id: main
    width: 600
    height: 600

    Canvas { id: canvas }
    ThumbChooser { id: thumbnails; opacity: 0 }
    Toolbox { id: toolbox }

    Component.onCompleted: {
        document.changed.connect(function(rect) {
                                     canvas.source = "image://document/" + Math.random()
                                     console.log(canvas.source);
                                 });
        document.load("qml/cmceye/example.jpg");
    }

    Binding {
        target: document
        property: "selection"
        value: canvas.selection
    }
}
