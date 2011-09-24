import QtQuick 1.0
import "functions.js" as Helper

Column {
    width: childrenRect.width
    height: childrenRect.height

    ToolButton {
        description: "Adjust contrast"
        background: "img/contrast.png"
        onClicked: toolbox.openWindow("Contrast")
    }

    ToolButton {
        description: "Gauss blur"
        background: "img/blur.svg"
        onClicked: document.gaussBlur(30.0)
    }

    ToolButton {
        description: "Auto white (Grayworld)"
        background: "img/blur.svg"
        onClicked: document.grayWorld()
    }

    ToolButton {
        description: "Wave effect"
        background: "img/blur.svg"
        onClicked: document.waveEffect()
    }

    ToolButton {
        description: "Scale & Rotate"
        background: "img/rotate.svg"
        onClicked: toolbox.openWindow("Rotation")
    }

    ToolButton {
        description: "Save changes"
        background: "img/document-save.svg"
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
        background: "img/document-open.svg"
        onClicked: Helper.loadFromFile()
    }
}
