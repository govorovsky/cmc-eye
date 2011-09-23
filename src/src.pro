TEMPLATE = app
TARGET = cmc-eye
DESTDIR = ../bin
QT += declarative

include(qmlapplicationviewer/qmlapplicationviewer.pri)

SOURCES += \
    main.cpp \
    document.cpp \
    documentprovider.cpp \
    histogram.cpp \
    util.cpp

HEADERS += \
    document.h \
    documentprovider.h \
    histogram.h \
    util.h
