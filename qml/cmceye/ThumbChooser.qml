import QtQuick 1.0
import Qt.labs.folderlistmodel 1.0
import Qt 4.7

Rectangle {
    id: chooser
    property url currentUrl
    property bool active: false

    radius: 10
    height: 100
    gradient: Gradient {
        GradientStop { position: 0.0; color: "gray"; }
        GradientStop { position: 1.0; color: "black"; }
    }
    smooth: true

    anchors {
        left: parent.left
        leftMargin: 10
        right: parent.right
        rightMargin: 10
        bottom: parent.bottom
        bottomMargin: 0
    }

    ListView {
        id: list
        anchors.fill: parent
        anchors.margins: 5
        clip: true
        spacing: 10
        orientation: ListView.Horizontal

        model: folderModel
        delegate: fileDelegate
    }

    FolderListModel {
        id: folderModel
        folder: "."
        showDirs: false
        nameFilters: ["*.bmp", "*.jpg"]
    }

    Component {
        id: fileDelegate
        Thumb {
            source: fileName

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.ListView.view.currentIndex = index
                    chooser.currentUrl = parent.source
                }
            }
        }
    }

}
