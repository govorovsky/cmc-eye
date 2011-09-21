#include "histogram.h"

#include <QDebug>
#include <algorithm>
#include <cmath>
#include <cstring>

Histogram::Histogram(QDeclarativeItem *parent) :
    QDeclarativeItem(parent), m_doc(0), m_ch(Channel_VALUE)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
    memset(m_freq, 0, sizeof(m_freq));
}

Histogram::~Histogram()
{
}

QObject* Histogram::document() const
{
    return m_doc;
}

void Histogram::setDocument(QObject *document)
{
    if (m_doc) {
        disconnect(this, SLOT(updateFrequencies()));
    }
    m_doc = qobject_cast<Document*> (document);
    connect(m_doc, SIGNAL(selectionChanged()), SLOT(updateFrequencies()));
    connect(m_doc, SIGNAL(changed(QRect)), SLOT(updateFrequencies()));
    emit updateFrequencies();
}

Histogram::Channel Histogram::channel() const
{
    return m_ch;
}

void Histogram::setChannel(Channel channel)
{
    m_ch = channel;
    emit channelChanged();
    update(boundingRect());
}

void Histogram::updateFrequencies()
{
    QRect selection = m_doc->selection();
    QImage img = m_doc->getImage();

    memset(m_freq, 0, sizeof(m_freq));
    for (int line = 0; line < selection.height(); ++line) {
        const QRgb* data = reinterpret_cast<const QRgb*>(img.scanLine(selection.y() + line));
        data += selection.x();

        for (int i = 0; i < selection.width(); ++i, ++data) {
            ++m_freq[Channel_VALUE][qGray(*data)];
            ++m_freq[Channel_RED][qRed(*data)];
            ++m_freq[Channel_GREEN][qGreen(*data)];
            ++m_freq[Channel_BLUE][qBlue(*data)];
        }
    }

    update(boundingRect());
}

void Histogram::paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *)
{
    if (!m_doc)
        return;

    const int ncolors = 256;
    const int x = boundingRect().left();
    const int y = boundingRect().top();
    const int width = boundingRect().width();
    const int height = boundingRect().height();
    painter->fillRect(boundingRect(), QBrush(Qt::white, Qt::SolidPattern));

    uint* freq = m_freq[m_ch];
    uint max_freq = *std::max_element(freq, freq+ncolors);
    if (max_freq == 0)
        return;

    double w = (width + .0) / ncolors;
    for (int i = 0; i < ncolors; ++i) {
        painter->fillRect((int) x + std::ceil(w * i), y + height,
                          (int) x + std::ceil(w), y + -height * (freq[i] + 0.0) / max_freq,
                          Qt::SolidPattern);
    }
}
