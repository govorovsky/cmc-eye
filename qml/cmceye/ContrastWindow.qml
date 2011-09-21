import QtQuick 1.0
import CustomComponents 1.0

Rectangle {
    id: window

    width: 150
    height: column.height + 10

    BorderImage {
        source: "panel/toolbox-bg.sci"
        width: parent.width + 14
        height: parent.height
        x: -7
    }
    color: "transparent"
    smooth: true

    Column {
        id: column

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: 5
        }
        spacing: 5

        Row {
            id: row
            spacing: 5

            property variant iconColor: ["gray", "red", "green", "blue"]
            property variant channel: [Histogram.Channel_VALUE,
                                       Histogram.Channel_RED,
                                       Histogram.Channel_GREEN,
                                       Histogram.Channel_BLUE]

            Text {
                id: label
                text: "Channel: "
                color: "white"
                style: Text.Raised
            }

            Repeater {
                id: repeater
                model: 4
                Rectangle {
                    parent: row

                    anchors.bottom: label.baseline
                    width: 10
                    height: 10

                    color: row.iconColor[index]

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
                        onClicked: histogram.channel = row.channel[index]
                    }
                }
            }
        }

        Histogram {
            id: histogram

            function maxColor() {
                switch (channel) {
                    case Histogram.Channel_VALUE: return "white";
                    case Histogram.Channel_RED: return "red";
                    case Histogram.Channel_GREEN: return "green";
                    case Histogram.Channel_BLUE: return "blue";
                }
            }

            opacity: 1.0
            target: document
            width: parent.width
            height: 100
            channel: Histogram.Channel_VALUE
        }

        Text {
            text: "Input levels:"
            color: "white"
            style: Text.Raised
        }

        Item {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: 20

            Rectangle {
                opacity: 1.0
                anchors.centerIn: parent
                width: 15
                height: parent.width
                rotation: 90
                gradient: Gradient {
                    GradientStop { id: endColor; position: 1.0; color: "black" }
                    GradientStop { id: startColor; position: 0.0; color: histogram.maxColor() }
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
                onClicked: toolbox.flipped = false
            }

            PushButton {
                id: buttonApply
                anchors {
                    left: parent.horizontalCenter
                    leftMargin: 5
                    right: parent.right
                }
                label: "Apply"
            }
        }
    }

}
