import QtQuick 1.0

Item {
    property alias leftLabel: buttonLeft.label
    property alias rightLabel: buttonRight.label

    signal leftClicked()
    signal rightClicked()

    anchors.left: parent.left
    anchors.right: parent.right
    height: childrenRect.height

    PushButton {
        id: buttonLeft
        anchors {
            rightMargin: 5
            right: parent.horizontalCenter
            left: parent.left
        }
        label: "Cancel"
        onClicked: leftClicked()
    }

    PushButton {
        id: buttonRight
        anchors {
            left: parent.horizontalCenter
            leftMargin: 5
            right: parent.right
        }
        label: "Apply"
        onClicked: rightClicked()
    }
}
