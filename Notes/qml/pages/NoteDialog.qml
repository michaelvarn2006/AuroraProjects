import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog

    property string noteText: noteField.text

    canAccept: noteField.text.trim().length > 0

    Column {
        width: parent.width

        DialogHeader {
            title: qsTr("Новая заметка")
        }

        TextArea {
            id: noteField
            width: parent.width
            placeholderText: qsTr("Текст заметки")
        }
    }
}
