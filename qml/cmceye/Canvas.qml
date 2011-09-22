import QtQuick 1.1 // required for 'preventStealing'

Flickable {
    property alias source: image.source
    id: canvas

    anchors.fill: parent
    clip: true

    contentHeight: image.height
    contentWidth: image.width
    boundsBehavior: Flickable.StopAtBounds

    Image {
        id: image
        cache: false
    }

    Binding {
        target: document
        property: "selection"
        when: selection.visible
        value: Qt.rect(selection.x, selection.y,
                       selection.width, selection.height)
    }

    Rectangle {
        id: selection

        border.width: 2
        border.color: "white"
        color: "transparent"

        visible: Math.max(width, height) > 10
        x: Math.min(trap.startX, trap.mouseX)
        y: Math.min(trap.startY, trap.mouseY)
        width: Math.abs(trap.startX - trap.mouseX)
        height: Math.abs(trap.startY - trap.mouseY)
    }

    MouseArea {
        id: trap
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
            visible: selection.visible
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
