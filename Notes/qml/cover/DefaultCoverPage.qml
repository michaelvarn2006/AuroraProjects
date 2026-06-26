import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: Theme.paddingLarge
            leftMargin: Theme.paddingMedium
            rightMargin: Theme.paddingMedium
        }
        spacing: Theme.paddingSmall

        Label {
            width: parent.width
            text: qsTr("Заметки")
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.highlightColor
        }

        Label {
            width: parent.width
            text: notesModel.count > 0 ? qsTr("%1 заметок").arg(notesModel.count) : qsTr("Нет заметок")
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryHighlightColor
        }
    }

    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
                appWindow.activate()
                var dialog = pageStack.push(Qt.resolvedUrl("../pages/NoteDialog.qml"))
                dialog.accepted.connect(function() {
                    notesModel.addNote(dialog.noteText)
                })
            }
        }
    }
}
