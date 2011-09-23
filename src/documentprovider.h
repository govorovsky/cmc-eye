#ifndef DOCUMENTPROVIDER_H
#define DOCUMENTPROVIDER_H

#include <QDeclarativeImageProvider>
#include <QImage>

#include "document.h"

class DocumentProvider : public QDeclarativeImageProvider
{
    const Document* doc;
public:
    typedef QDeclarativeImageProvider super;

    explicit DocumentProvider(const Document* document);
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
    virtual ~DocumentProvider();
};

#endif // DOCUMENTPROVIDER_H
