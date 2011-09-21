#include <QApplication>
#include <QtDeclarative>

#include "qmlapplicationviewer.h"
#include "document.h"
#include "documentprovider.h"
#include "histogram.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<Histogram>("CustomComponents", 1, 0, "Histogram");

    QmlApplicationViewer viewer;

    Document document;
    DocumentProvider* provider = new DocumentProvider(&document);
    viewer.rootContext()->setContextProperty("document", &document);
    viewer.engine()->addImageProvider("document", provider);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/cmceye/Main.qml"));
    viewer.showExpanded();

    return app.exec();
}
