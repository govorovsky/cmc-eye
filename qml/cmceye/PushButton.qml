import QtQuick 1.1

Item {
    id: button

    property alias label: label.text
    property real verticalMargin: 2
    property real horizontalMargin: 5
    signal clicked()

    implicitWidth: label.width + horizontalMargin * 2
    implicitHeight: label.height + verticalMargin * 2

    Rectangle {
        id: rect
        anchors.fill: parent

        color: "gray"
        radius: 5
        opacity: 1.0

        Rectangle {
            id: shadow
            color: "black"
            anchors.fill: parent
            anchors.rightMargin: 1
            anchors.bottomMargin: 1
            radius: parent.radius
            z: -1
        }

        MouseArea {
            id: trap
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: button.clicked()
        }

        transform: Translate { id: translation; x: 0; y: 0 }

        states: State {
            name: "pressed"
            when: trap.pressed
            PropertyChanges {
                target: translation
                x: 3; y: 3
            }
        }

        Label {
            id: label
            anchors {
                horizontalCenter: rect.horizontalCenter
                verticalCenter: rect.verticalCenter
            }
        }
    }

}
