import QtQuick 1.0

Item {
    id: bubble

    property alias text: descriptionText.text
    property color color: "black"

    Rectangle {
        id: arrow

        property real squareSide: parent.height / 4

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: squareSide * Math.SQRT2 / 2
        color: "transparent"
        clip: true

        Rectangle {
            anchors {
                horizontalCenter: parent.right
                verticalCenter: parent.verticalCenter
            }
            width: bubble.height / 4
            height: width

            color: bubble.color
            rotation: 45
            smooth: true
        }
    }

    Rectangle {
        id: descriptionBox

        anchors {
            left: arrow.right
            top: parent.top
            bottom: parent.bottom
        }
        width: descriptionText.width + descriptionText.anchors.leftMargin * 2

        color: bubble.color
        smooth: true
        radius: 10
    }

    Text {
        id: descriptionText

        anchors {
            left: descriptionBox.left
            leftMargin: 10
            verticalCenter: descriptionBox.verticalCenter
        }

        font.family: "Helvetica"
        font.bold: true
        color: "white"
        style: Text.Raised
        styleColor: "gray"
        smooth: true
    }
}
