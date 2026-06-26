TARGET = ru.template.temperatureconverter
CONFIG += auroraapp
CONFIG += auroraapp_i18n
PKGCONFIG += auroraapp
SOURCES += \
    src/main.cpp
TRANSLATIONS += \
    translations/ru.template.temperatureconverter.ts \
    translations/ru.template.temperatureconverter-ru.ts
DISTFILES += rpm/ru.template.ConverterApp.spec
AURORAAPP_ICONS = 86x86 108x108 128x128 172x172
