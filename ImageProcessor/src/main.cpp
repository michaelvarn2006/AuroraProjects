#include <auroraapp.h>
#include <QtQuick>
#include "resultimageprovider.h"
#include "imageprocessor.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(Aurora::Application::application(argc, argv));
    application->setOrganizationName(QStringLiteral("ru.template"));
    application->setApplicationName(QStringLiteral("imagelab"));

    QScopedPointer<QQuickView> view(Aurora::Application::createView());

    // 1. Создаем провайдер и отдаем движку QML
    ResultImageProvider *provider = new ResultImageProvider();
    view->engine()->addImageProvider(QStringLiteral("result"), provider);

    // 2. Создаем процессор (в главном потоке) и публикуем в QML
    ImageProcessor imageProcessor(provider);
    view->rootContext()->setContextProperty(QStringLiteral("imageProcessor"), &imageProcessor);

    view->setSource(Aurora::Application::pathTo(QStringLiteral("qml/ImageProcessor.qml")));
    view->show();

    return application->exec();
}
