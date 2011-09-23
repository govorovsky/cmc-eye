import QtQuick 1.1

Column {
    width: childrenRect.width
    anchors.left: parent ? parent.left : undefined
    anchors.leftMargin: 5
    spacing: 5

    Row {
        spacing: 5

        Label {
            id: labelAngle
            anchors.verticalCenter: parent.verticalCenter
            text: "Angle: "
        }

        Input {
            id: angle

            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: labelAngle.height + 4

            input {
                maximumLength: 5
                text: "30"
                validator: DoubleValidator { }
            }
        }

    }

    Row {
        spacing: 5

        Label {
            id: labelOrigin
            anchors.verticalCenter: parent.verticalCenter
            text: "Origin offset: ( "
        }

        Input {
            id: originX
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: labelOrigin.height + 4

            input.validator: DoubleValidator { }

            function setDefault() {
                input.text = document.selection.x + document.selection.width / 2
            }
            Component.onCompleted: setDefault()
            Connections { target: document; onSelectionChanged: originX.setDefault() }
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: " , "
        }

        Input {
            id: originY
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: labelOrigin.height + 4
            input.validator: DoubleValidator { }

            function setDefault() {
                input.text = document.selection.y + document.selection.height / 2
            }
            Component.onCompleted: setDefault()
            Connections { target: document; onSelectionChanged: originY.setDefault() }
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: ")"
        }
    }

    WindowButtons {
        onLeftClicked: toolbox.openHome()
        rightLabel: "Rotate"
        onRightClicked:
            document.rotate(originX.input.text, originY.input.text,
                            Math.PI / 180.0 * angle.input.text)
    }

    Rectangle {
        parent: main
        width: 7
        height: width
        radius: width / 2
        border.width: 1
        border.color: "white"
        color: trap.containsMouse ? "steelblue" : "black"
        x: originX.input.text - width / 2
        y: originY.input.text - height / 2

        MouseArea {
            id: trap
            hoverEnabled: true
            anchors.fill: parent
            anchors.margins: -5
            drag.target: parent
            onReleased: {
                originX.input.text = parent.x + parent.width / 2
                originY.input.text = parent.y + parent.height / 2
            }
        }
    }
}
