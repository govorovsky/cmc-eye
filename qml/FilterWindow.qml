import QtQuick 1.1

Column {
    width: 150
    anchors.left: parent ? parent.left : undefined
    anchors.leftMargin: 5
    spacing: 5

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Helvetica"
        font.bold: true
        text: "Filter"
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
            id: labelSigma
            anchors {
                left: parent.left
                verticalCenter: sigma.verticalCenter
            }
            text: "Sigma: "
        }

        Input {
            id: sigma
            anchors.right: parent.right
            width: 40
            height: labelSigma.height + 4

            input {
                maximumLength: 5
                text: "1"
                validator: DoubleValidator {
                    bottom: 0.5;
                    top: Math.min(document.selection.width, document.selection.height) / 6 - 1
                }
            }
        }

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
            id: labelSharpness
            anchors {
                left: parent.left
                verticalCenter: sharpness.verticalCenter
            }
            text: "Sharpness: "
        }

        Input {
            id: sharpness
            anchors.right: parent.right
            width: 40
            height: labelSigma.height + 4

            input {
                maximumLength: 5
                text: { 0.8 }
                validator: DoubleValidator { bottom: 0.0; top: 1.0; }
            }
        }

    }

    WindowButtons {
        leftLabel: "Blur"
        onLeftClicked: if (sigma.input.acceptableInput)
                           document.gaussBlur(sigma.input.text)
        rightLabel: "Unsharp"
        onRightClicked: if (sharpness.input.acceptableInput && sigma.input.acceptableInput)
                            document.unsharp(sharpness.input.text, sigma.input.text)
    }

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Helvetica"
        font.bold: true
        text: "Median filter"
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
            id: labelRadius
            anchors {
                left: parent.left
                verticalCenter: m_radius.verticalCenter
            }
            text: "Radius: "
        }

        Input {
            id: m_radius
            anchors {
                left: labelRadius.right
                leftMargin: 5
            }
            width: 20
            height: labelRadius.height + 4

            input {
                maximumLength: 3
                text: { 1 }
                validator: IntValidator {
                    bottom: 1
                    top: Math.min(Math.min(document.selection.width, document.selection.height) / 2, 10)
                }
            }
        }

        PushButton {
            label: "Apply"
            anchors {
                left: m_radius.right
                leftMargin: 5
                right: parent.right
            }
            onClicked: if (m_radius.input.acceptableInput)
                           document.medianFilter(m_radius.input.text)
        }
    }

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Helvetica"
        font.bold: true
        text: "Custom filter"
    }

    WindowButtons {
        leftLabel: "Back"
        onLeftClicked: toolbox.openHome()
        rightLabel: "Edit..."
        onRightClicked: toolbox.openWindow("CustomKernel")
    }

}
