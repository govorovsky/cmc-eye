import QtQuick 1.0

Rectangle {
    property alias input: input

    width: 30

    color: "transparent"
    border.width: 1
    border.color: "gray"

    TextInput {
        id: input
        anchors.fill: parent
        anchors.margins: 2
        horizontalAlignment: TextInput.AlignHCenter
        color: "white"
    }
}
