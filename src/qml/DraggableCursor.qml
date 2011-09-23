import QtQuick 1.0

Item {
    id: marker

    property alias drag: trap.drag
    property alias position: image.x

    anchors {
        top: parent.top
        bottom: parent.bottom
    }

    width: image.width
    height: image.height

    Image {
        id: image
        anchors.verticalCenter: parent.verticalCenter
        x: 0
        source: (trap.containsMouse || trap.drag.active) ?
                    "marker-selected.svg"
                  : "marker.svg"

        MouseArea {
            id: trap
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton

            drag {
                target: parent
                axis: Drag.XAxis
            }
        }
    }
}
