TARGET = ru.template.notes

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \
    src/notesmodel.cpp

HEADERS += \
    src/notesmodel.h

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/pages/NoteDialog.qml \
    qml/cover/DefaultCoverPage.qml \
    rpm/ru.template.notes.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.notes.ts \
    translations/ru.template.notes-ru.ts \
