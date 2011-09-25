import QtQuick 1.0
import "kernel.js" as Kernel

Column {
    id: window
    anchors.left: parent ? parent.left : undefined
    anchors.leftMargin: 5
    spacing: 5

    property int kernelSize: ksize.input.acceptableInput ? parseInt(ksize.input.text) : kernelSize
    onKernelSizeChanged:
        Kernel.kernel = new Array(kernelSize * kernelSize)

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Helvetica"
        font.bold: true
        text: "Enter custom kernel"
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 3
            rightMargin: 3
        }
        height: childrenRect.height

        Label {
            id: labelSize
            anchors {
                left: parent.left
                verticalCenter: ksize.verticalCenter
            }
            text: "Size: "
        }

        Input {
            id: ksize
            anchors.right: parent.right
            height: labelSize.height + 4

            input {
                maximumLength: 5
                text: { 3 }
                validator: IntValidator {bottom: 2; top: 7 }
            }
        }
    }

    Repeater {
        id: rows
        model: kernelSize

        Row {
            id: row
            anchors.horizontalCenter: parent.horizontalCenter
            property int edit_y: index
            spacing: 5

            Repeater {
                model: kernelSize

                Input {
                    property int edit_y: row.edit_y
                    property int edit_x: index
                    height: 20

                    input {
                        text: { 0.0 }
                        validator: DoubleValidator { }
                        onTextChanged: {
                            if (input.acceptableInput) {
                                var i = edit_y * kernelSize + edit_x
                                Kernel.kernel[i] = parseFloat(input.text)
                            }
                        }
                    }
                }
            }
        }
    }

    WindowButtons {
        leftLabel: "Back"
        onLeftClicked: toolbox.openWindow("Filter")
        rightLabel: "Apply"
        onRightClicked: Kernel.serialize()
    }
}
