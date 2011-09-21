import QtQuick 1.0


Image {
    id: thumb
    property bool active: false
    asynchronous: true
    opacity: 0.5

    fillMode: Image.PreserveAspectFit
    height: parent.height
    sourceSize.height: height

    MouseArea {
        id: mouseBox
        anchors.fill: parent
        hoverEnabled: true
    }

    states: State {
        name: "hovered"
        when: mouseBox.containsMouse
        PropertyChanges {
            target: thumb
            opacity: 1.0
        }
    }

    transitions: Transition {
        NumberAnimation {
            property: "opacity"
            duration: 300
        }
    }

}

