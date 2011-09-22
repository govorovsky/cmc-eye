import QtQuick 1.0
import "functions.js" as Helper

Flipable {
    id: toolbox

    anchors {
        left: parent.left
        leftMargin: 0
        top: parent.top
        topMargin: 10
        bottom: thumbnails.top
        bottomMargin: 10
    }
    opacity: 0.6

    front: Item {
        width: 40
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        BorderImage {
            source: "panel/toolbox-bg.sci";
            width: parent.width + 14;
            height: parent.height;
            x: -7
        }

        Column {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 3
            }

            ToolButton {
                description: "Adjust contrast"
                background: "panel/contrast.png"
                onClicked: flipTo("ContrastWindow")
            }

            ToolButton {
                description: "Blur"
                background: "panel/blur.svg"
            }
        }

        Column {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 3
            }

            ToolButton {
                description: "Save changes"
                background: "panel/document-open.svg"
                onClicked: {
                    console.debug("tool clicked " + mouse.button)
                    if (mouse.button == Qt.RightButton) {
                        Helper.saveAsDocument()
                    } else if (mouse.button == Qt.LeftButton) {
                        Helper.saveDocument()
                    }
                }
            }

            ToolButton {
                description: "Load image"
                background: "panel/document-save.svg"
                onClicked: Helper.loadFromFile()
            }
        }
    }

    back: Loader {
        id: windowLoader
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.left// HACK? take in account that we are flipped
        }
    }

    /*
      Back part of the toolbox
     */

    property bool flipped: false

    function flipTo(src) {
        windowLoader.source = src + ".qml"
        flipped = true
    }

    transform: Rotation {
        id: rotation
        origin.x: 0
        origin.y: parent.height / 2
        axis {x: 0; y: 1; z: 0}
        angle: 0
    }

    states: State {
        name: "flipped"
        when: flipped
        PropertyChanges {
            target: rotation
            angle: 180
        }
    }

    transitions: Transition {
        NumberAnimation { target: rotation; property: "angle"; duration: 300 }
    }
}
