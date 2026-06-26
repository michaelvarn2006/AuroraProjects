#include <auroraapp.h>
#include <QtQuick>
#include "notesmodel.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(Aurora::Application::application(argc, argv));
    application->setOrganizationName(QStringLiteral("ru.template"));
    application->setApplicationName(QStringLiteral("notes"));

    NotesModel notesModel;

    QScopedPointer<QQuickView> view(Aurora::Application::createView());

    // Публикуем объект в QML
    view->rootContext()->setContextProperty(QStringLiteral("notesModel"), &notesModel);

    // В зависимости от имени твоего проекта, путь к основному QML файлу может отличаться
    view->setSource(Aurora::Application::pathTo(QStringLiteral("qml/notes.qml")));
    view->show();

    return application->exec();
}
