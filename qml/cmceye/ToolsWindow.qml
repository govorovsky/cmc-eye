import QtQuick 1.0
import "functions.js" as Helper

Column {
    width: childrenRect.width
    height: childrenRect.height

    ToolButton {
        description: "Adjust contrast"
        background: "panel/contrast.png"
        onClicked: toolbox.openWindow("Contrast")
    }

    ToolButton {
        description: "Wave"
        background: "panel/blur.svg"
        onClicked: document.waveEffect()
    }

    ToolButton {
        description: "Rotate"
        background: "panel/rotate.svg"
        onClicked: document.rotate(document.selection.x + document.selection.width / 2,
                                   document.selection.y + document.selection.height / 2,
                                   3.14 / 180.0 * 30.0)
    }

    ToolButton {
        description: "Save changes"
        background: "panel/document-save.svg"
        onClicked: {
            if (mouse.button == Qt.RightButton) {
                Helper.saveAsDocument()
            } else if (mouse.button == Qt.LeftButton) {
                Helper.saveDocument()
            }
        }
    }

    ToolButton {
        description: "Load image"
        background: "panel/document-open.svg"
        onClicked: Helper.loadFromFile()
    }
}
