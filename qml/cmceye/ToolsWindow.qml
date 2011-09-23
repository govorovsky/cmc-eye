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
        description: "Wave effect"
        background: "panel/blur.svg"
        onClicked: document.waveEffect()
    }

    ToolButton {
        description: "Scale & Rotate"
        background: "panel/rotate.svg"
        onClicked: toolbox.openWindow("Rotation")
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
