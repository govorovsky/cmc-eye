lessThan(QT_VERSION, 4.7) {
    error("Qt 4.7 required")
}

TEMPLATE = subdirs

SUBDIRS = src

CONFIG += ordered

OTHER_FILES += \
    qml/Toolbox.qml \
    qml/ToolButton.qml \
    qml/TextBubble.qml \
    qml/ContrastWindow.qml \
    qml/PushButton.qml \
    qml/DraggableCursor.qml \
    qml/ByteInput.qml \
    qml/functions.js \
    qml/RotationWindow.qml \
    qml/Label.qml \
    qml/ToolsWindow.qml \
    readme.txt
