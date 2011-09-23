import QtQuick 1.0
import CustomComponents 1.0
import "functions.js" as Helper

Column {
    id: column
    width: 200
    height: childrenRect.height
    spacing: 5

    function autoLowHigh() {
        levelLow.value = histogram.getLow()
        levelHigh.value = histogram.getHigh()
    }

    Component.onCompleted: autoLowHigh();

    PushButton {
        label: "Autolevels"
        anchors {
            left: parent.left
            right: parent.right
        }
        onClicked: Helper.autoLevels(histogram);
    }

    Row {
        id: row
        spacing: 5

        Label { id: label; text: "Channel: "; }

        Repeater {
            id: repeater
            model: ["value", "red", "green", "blue"]
            Rectangle {
                parent: row

                anchors.bottom: label.baseline
                width: 10
                height: 10

                color: Helper.channelIconColor(modelData)

                Rectangle {
                    id: selection
                    anchors.centerIn: parent
                    width: parent.width + 3
                    height: parent.height + 3
                    visible: channelTrap.containsMouse
                    border.color: "white"
                    border.width: 1
                    color: "transparent"
                }

                MouseArea {
                    id: channelTrap
                    anchors.fill: selection
                    hoverEnabled: true
                    onClicked: {
                        histogram.channel = modelData
                        autoLowHigh();
                    }
                }
            }
        }
    }

    Histogram {
        id: histogram

        opacity: 1.0
        target: document
        width: parent.width
        height: 100
        channel: "value"
    }

    Label { text: "Input levels:" }

    Item {
        anchors {
            left: parent.left
            right: parent.right
        }
        height: 20

        Rectangle {
            anchors {
                bottom: parent.top
                bottomMargin: -2.5
            }
            width: 15
            height: parent.width
            transformOrigin: Item.BottomLeft
            rotation: 90

            gradient: Gradient {
                GradientStop { id: endColor; position: 1.0; color: "black" }
                GradientStop {
                    id: startColor; position: 0.0;
                    color: Helper.channelMaxColor(histogram.channel)
                }
            }
        }

        DraggableCursor {
            id: markerLow

            anchors.horizontalCenter: parent.left
            drag.minimumX: 0
            drag.maximumX: parent.width + markerHigh.position

            position: parent.width * (levelLow.value / 255.0)
            onPositionChanged: { levelLow.value = Math.round(255 * position / parent.width) }
        }

        DraggableCursor {
            id: markerHigh
            anchors.horizontalCenter: parent.right
            drag.maximumX: 0
            drag.minimumX: - (parent.width - markerLow.position)

            position: -parent.width * (1.0 - levelHigh.value / 255.0)
            onPositionChanged: { levelHigh.value = Math.round(255 * (1 + position / parent.width)) }
        }
    }

    Item {
        id: levelsEdit
        anchors {
            left: parent.left
            right: parent.right
        }
        height: childrenRect.height


        ByteInput {
            id: levelLow
            value: 0
            validator.top: levelHigh.value
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
        }

        PushButton {
            id: buttonAuto
            anchors.horizontalCenter: parent.horizontalCenter
            label: "Auto"
            onClicked: autoLowHigh()
        }

        ByteInput {
            id: levelHigh
            value: 255
            validator.bottom: levelLow.value
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        height: childrenRect.height

        PushButton {
            id: buttonCancel
            anchors {
                rightMargin: 5
                right: parent.horizontalCenter
                left: parent.left
            }
            label: "Cancel"
            onClicked: toolbox.openWindow("Tools")
        }

        PushButton {
            id: buttonApply
            anchors {
                left: parent.horizontalCenter
                leftMargin: 5
                right: parent.right
            }
            label: "Apply"
            onClicked: document.adjustContrast(levelLow.value, levelHigh.value, histogram.channel)
        }
    }
}
