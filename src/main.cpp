#include <QApplication>
#include <QtDeclarative>
#include <QDir>

#include "qmlapplicationviewer.h"
#include "document.h"
#include "documentprovider.h"
#include "histogram.h"
#include "util.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<Histogram>("CustomComponents", 1, 0, "Histogram");

    QmlApplicationViewer    viewer;
    Document                document;
    Util                    util(&viewer);

    viewer.rootContext()->setContextProperty("document", &document);
    viewer.rootContext()->setContextProperty("viewer", &viewer);
    viewer.rootContext()->setContextProperty("util", &util);
    viewer.engine()->addImageProvider("document", new DocumentProvider(&document));

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.showExpanded();

    // HACK
    QDir binary(argv[0]);
    binary.makeAbsolute();
    binary.cdUp(); // skip binary name
    viewer.setMainQmlFile(binary.path() + "/../qml/Main.qml");

    return app.exec();
}
