import QtQuick 1.0

Input {
    id: byteinput
    property int value: 0
    property alias validator: validator

    width: 30

    input {
        maximumLength: 3
        text: value
        validator: IntValidator {id: validator; bottom: 0; top: 255}
        onTextChanged: {
            var newVal = parseInt(input.text)
            if (newVal != byteinput.value && input.acceptableInput)
                byteinput.value = newVal
        }
    }

    onValueChanged: {
        if (value >= validator.bottom && value <= validator.top)
            input.text = value
    }
}
