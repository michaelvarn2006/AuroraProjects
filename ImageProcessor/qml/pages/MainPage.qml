import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

Page {
    id: page
    property string selectedPath: ""
    property string selectedUrl: "" // URL нужен для QML компонента Image

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentCol.height + Theme.paddingLarge

        Column {
            id: contentCol
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: "Обработка изображений" }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Выбрать изображение"
                enabled: !imageProcessor.busy
                onClicked: pageStack.push(imagePickerComponent)
            }

            // Исходное изображение
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - Theme.horizontalPageMargin * 2
                height: width
                fillMode: Image.PreserveAspectFit
                source: page.selectedUrl
                visible: source !== ""
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Обработать"
                enabled: page.selectedPath !== "" && !imageProcessor.busy
                onClicked: {
                    imageProcessor.process(page.selectedPath)
                }
            }

            // Индикатор загрузки
            BusyIndicator {
                anchors.horizontalCenter: parent.horizontalCenter
                size: BusyIndicatorSize.Large
                running: imageProcessor.busy
                visible: imageProcessor.busy
            }

            // Статистика (видна только если есть результат и мы не обрабатываем сейчас)
            Column {
                width: parent.width
                visible: imageProcessor.resultSource !== "" && !imageProcessor.busy
                spacing: Theme.paddingSmall

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Яркость: " + imageProcessor.meanBrightness.toFixed(1)
                    color: Theme.highlightColor
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Время: " + imageProcessor.elapsedMs + " мс"
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                }
            }

            // Обработанное изображение
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - Theme.horizontalPageMargin * 2
                height: width
                fillMode: Image.PreserveAspectFit
                cache: false // Обязательно отключаем кэш!
                source: imageProcessor.resultSource
                visible: source !== "" && !imageProcessor.busy
            }
        }
    }

    Component {
        id: imagePickerComponent
        ImagePickerPage {
            onSelectedContentPropertiesChanged: {
                page.selectedPath = selectedContentProperties.filePath
                page.selectedUrl = selectedContentProperties.url
            }
        }
    }
}
