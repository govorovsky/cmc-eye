import QtQuick 1.0

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
                id: contrast
                description: "Adjust contrast"
                background: "panel/contrast.png"
                onClicked: flipTo("ContrastWindow")
            }

            ToolButton {
                id: blur
                description: "Blur"
                background: "panel/blur.svg"
                onClicked: {
                    document.inverse(document.revision)
                }
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
                id: open
                description: "Save changes"
                background: "panel/document-open.svg"
                onClicked: {
                    document.save("out.jpg", 2);
                }
            }

            ToolButton {
                id: save
                description: "Load image or directory"
                background: "panel/document-save.svg"
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
