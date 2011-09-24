#ifndef HISTOGRAM_H
#define HISTOGRAM_H

#include <QDeclarativeItem>
#include <QPainter>
#include "document.h"

class Histogram : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QObject* target READ document WRITE setDocument)
    Q_PROPERTY(QString channel READ channel WRITE setChannel NOTIFY channelChanged)
public:
    QObject* document() const;
    void setDocument(QObject* document);

    QString channel() const;
    void setChannel(const QString& channel);

    Q_INVOKABLE uchar getLow(const QString& channel = QString()) const;
    Q_INVOKABLE uchar getHigh(const QString& channel = QString()) const;

    explicit Histogram(QDeclarativeItem *parent = 0);
    virtual ~Histogram();
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget = 0);

signals:
    void channelChanged();

private:
    Document* m_doc;
    uchar m_channel;

    int parseChannel(const QString& channel) const;

    Q_DISABLE_COPY(Histogram)
private slots:
    void repaint();
};

#endif // HISTOGRAM_H
