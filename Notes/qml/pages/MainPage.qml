import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaListView {
        id: listView
        anchors.fill: parent

        // Модель проброшена из C++
        model: notesModel

        header: PageHeader {
            title: qsTr("Заметки (%1)").arg(notesModel.count)
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Новая заметка")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NoteDialog.qml"))
                    dialog.accepted.connect(function() {
                        notesModel.addNote(dialog.noteText)
                    })
                }
            }
        }

        ViewPlaceholder {
            enabled: listView.count === 0
            text: qsTr("Заметок нет")
            hintText: qsTr("Потяните вниз, чтобы добавить")
        }

        delegate: ListItem {
            id: listItem
            contentHeight: contentCol.height + Theme.paddingMedium * 2

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Удалить")
                    onClicked: listItem.remorseDelete(function() {
                        notesModel.removeNote(index)
                    })
                }
            }

            Column {
                id: contentCol
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }

                Label {
                    width: parent.width
                    text: model.text
                    color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    wrapMode: Text.Wrap
                    maximumLineCount: 4
                    truncationMode: TruncationMode.Fade
                }

                Label {
                    width: parent.width
                    text: Qt.formatDateTime(model.createdAt, "dd.MM.yyyy hh:mm")
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
        }
    }
}
