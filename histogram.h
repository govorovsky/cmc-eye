#ifndef HISTOGRAM_H
#define HISTOGRAM_H

#include <QDeclarativeItem>
#include <QPainter>
#include "document.h"

class Histogram : public QDeclarativeItem
{
    Q_OBJECT
    Q_ENUMS(Channel)
    Q_PROPERTY(QObject* target READ document WRITE setDocument)
    Q_PROPERTY(Channel channel READ channel WRITE setChannel NOTIFY channelChanged)
public:
    enum Channel {
        Channel_VALUE,
        Channel_RED,
        Channel_GREEN,
        Channel_BLUE,
        Channel_ALL
    };

    QObject* document() const;
    void setDocument(QObject* document);

    Channel channel() const;
    void setChannel(Channel channel);

    explicit Histogram(QDeclarativeItem *parent = 0);
    virtual ~Histogram();
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget = 0);

signals:
    void channelChanged();

private:
    Document* m_doc;
    Channel m_ch;
    uint m_freq[Channel_ALL][256];

    Q_DISABLE_COPY(Histogram)
private slots:
    void updateFrequencies();
};

#endif // HISTOGRAM_H
