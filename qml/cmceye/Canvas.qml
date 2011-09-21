import QtQuick 1.1 // required for 'preventStealing'

Flickable {
    id: canvas

    property alias source: image.source
    property variant selection: selection.active ?
                                    Qt.rect(selection.x, selection.y, selection.width, selection.height)
                                  : Qt.rect(-1, -1, -1, -1)

    anchors.fill: parent
    clip: true

    contentHeight: image.height
    contentWidth: image.width
    boundsBehavior: Flickable.StopAtBounds

    Image {
        id: image
        cache: false
    }

    Rectangle {
        id: selection

        property bool active: (Math.max(width, height) > 10)

        border.width: 2
        border.color: "white"
        color: "transparent"

        x: Math.min(selectionTrap.startX, selectionTrap.mouseX)
        y: Math.min(selectionTrap.startY, selectionTrap.mouseY)
        width: Math.abs(selectionTrap.startX - selectionTrap.mouseX)
        height: Math.abs(selectionTrap.startY - selectionTrap.mouseY)
    }

    MouseArea {
        id: selectionTrap
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        preventStealing: true

        property real startX: 0
        property real startY: 0

        onPressed: {
            startX = mouse.x
            startY = mouse.y
        }
    }

    Component {
        id: inverseRectangle
        Rectangle {
            color: "black"
            opacity: 0.7
            visible: selection.active
        }
    }

    Loader {
        sourceComponent: inverseRectangle
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: selection.top
        }
    }

    Loader {
        sourceComponent: inverseRectangle
        anchors {
            left: parent.left
            right: parent.right
            top: selection.bottom
            bottom: parent.bottom
        }
    }

    Loader {
        sourceComponent: inverseRectangle
        anchors {
            left: parent.left
            right: selection.left
            top: selection.top
            bottom: selection.bottom
        }
    }

    Loader {
        sourceComponent: inverseRectangle
        anchors {
            left: selection.right
            right: parent.right
            top: selection.top
            bottom: selection.bottom
        }
    }

}
