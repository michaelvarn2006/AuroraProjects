import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    function calculateConversion(inputText, index) {
        var value = parseFloat(inputText.replace(",","."));
        if (isNaN(value)) {
            return "—";
        }

        var result = 0;
        if (index === 0) {
            // °C → °F
            result = value * 9 / 5 + 32;
            return result.toFixed(2) + " °F";
        } else if (index === 1) {
            // °F → °C
            result = (value - 32) * 5 / 9;
            return result.toFixed(2) + " °C";
        } else if (index === 2) {
            // °C → K
            result = value + 273.15;
            return result.toFixed(2) + " K";
        }
        return "—";
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        // Выдвижное меню для сброса состояния
        PullDownMenu {
            MenuItem {
                text: qsTr("Очистить")
                onClicked: inputField.text = ""
            }
        }

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Конвертер величин")
            }

            // Поле ввода числового значения
            TextField {
                id: inputField
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                placeholderText: qsTr("Введите значение")
                label: qsTr("Исходная величина")
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                // Кнопка Готово на клавиатуре закрывает её
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            // Выбор направления конвертации
            ComboBox {
                id: directionChoice
                width: parent.width
                label: qsTr("Направление:")
                currentIndex: 0

                menu: ContextMenu {
                    MenuItem { text: qsTr("°C → °F") }
                    MenuItem { text: qsTr("°F → °C") }
                    MenuItem { text: qsTr("°C → K") }
                }
            }

            // Секция отображения результата
            SectionHeader {
                text: qsTr("Результат")
            }

            Label {
                id: resultLabel
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeHuge
                color: Theme.highlightColor
                font.bold: true

                // Автоматический пересчёт реактивной привязкой (Data Binding)
                text: page.calculateConversion(inputField.text, directionChoice.currentIndex)
            }
        }

        VerticalScrollDecorator {}
    }
}
