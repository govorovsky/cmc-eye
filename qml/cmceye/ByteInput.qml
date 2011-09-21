import QtQuick 1.0

Rectangle {
    id: byteinput
    property int value: 0
    property alias validator: validator

    width: 30

    color: "transparent"
    border.width: 1
    border.color: "gray"

    TextInput {
        id: input

        anchors.fill: parent
        anchors.margins: 2
        horizontalAlignment: TextInput.AlignHCenter
        maximumLength: 3

        color: "white"
        text: value
        validator: IntValidator {id: validator; bottom: 0; top: 255}

        onTextChanged: {
            var newVal = parseInt(text)
            if (newVal != byteinput.value && acceptableInput)
                byteinput.value = newVal
        }
    }

    onValueChanged: {
        if (value >= validator.bottom && value <= validator.top)
            input.text = value
    }
}
