TARGET = ru.template.ImageProcessor

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/imageprocessor.cpp \
    src/main.cpp \
    src/processingworker.cpp \
    src/resultimageprovider.cpp

HEADERS += \
    src/imageprocessor.h \
    src/processingworker.h \
    src/resultimageprovider.h

DISTFILES += \
    rpm/ru.template.ImageProcessor.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.ImageProcessor.ts \
    translations/ru.template.ImageProcessor-ru.ts \
