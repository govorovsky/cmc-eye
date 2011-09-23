#include <QDebug>
#include "documentprovider.h"

DocumentProvider::DocumentProvider(const Document* document)
    : QDeclarativeImageProvider(Image), doc(document)
{
}

QImage DocumentProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(id);

    QImage result = doc->getImage();
    result = result.copy(QRect(QPoint(0,0), result.size()));
    if (size) *size = result.size();
    if (requestedSize.isValid())
        return result.scaled(requestedSize);
    else
        return result;
}

DocumentProvider::~DocumentProvider()
{
}
