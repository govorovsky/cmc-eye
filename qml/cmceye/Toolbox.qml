import QtQuick 1.1
import "functions.js" as Helper

Flipable {
    id: toolbox

    anchors {
        left: parent.left
        leftMargin: 2
        verticalCenter: parent.verticalCenter
    }

    width: window.childrenRect.width + window.childrenRect.x
    height: window.height

    BorderImage {
        opacity: 0.7
        anchors {
            fill: parent
            leftMargin: -2
            rightMargin: -border.right + 4
            topMargin: -border.top + 2
            bottomMargin: -border.bottom + 2
        }

        border {
            top: 12
            bottom: 10
            right: 12
        }
        source: "panel/toolbox-bg.png"
        smooth: true
    }

    Behavior on width {
        NumberAnimation { duration: 300 }
    }

    Behavior on height {
        NumberAnimation { duration: 300 }
    }

    function openWindow(name) {
        window.source = name + "Window.qml"
    }

    function openHome() {
        openWindow("Tools")
    }

    Loader {
        id: window
        anchors.verticalCenter: parent.verticalCenter
        source: "ToolsWindow.qml"
    }
}
