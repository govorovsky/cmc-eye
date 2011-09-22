#include "histogram.h"

#include <QDebug>
#include <algorithm>
#include <cmath>
#include <cstring>

const double AUTOLEVELS_ZERO = 0.02;

Histogram::Histogram(QDeclarativeItem *parent) :
    QDeclarativeItem(parent), m_doc(0), m_ch(0)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
    memset(m_freq, 0, sizeof(m_freq));
}

Histogram::~Histogram() { }

uchar Histogram::getLow() const
{
    return m_low[m_ch];
}

uchar Histogram::getHigh() const
{
    return m_high[m_ch];
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

QString Histogram::channel() const
{
    switch (m_ch) {
    case 0: return "value";
    case 1: return "red";
    case 2: return "green";
    case 3: return "blue";
    default: return "undefined";
    }
}

void Histogram::setChannel(const QString& channel)
{
    int ch_id = -1;
    if (channel == "value")
        ch_id = 0;
    else if (channel == "red")
        ch_id = 1;
    else if (channel == "green")
        ch_id = 2;
    else if (channel == "blue")
        ch_id = 3;

    if (ch_id != -1) {
        m_ch = ch_id;
        emit channelChanged();
        update(boundingRect());
    } else {
        qDebug() << "Invalid channel" << channel;
    }
}

void Histogram::updateFrequencies()
{
    QRect selection = m_doc->selection();
    QImage img = m_doc->getImage();

    memset(m_freq, 0, sizeof(m_freq));
    for (int line = selection.top(); line <= selection.bottom(); ++line) {
        const QRgb* data = reinterpret_cast<const QRgb*>(img.constScanLine(line));
        data += selection.x();

        for (int i = 0; i < selection.width(); ++i, ++data) {
            ++m_freq[0][qGray(*data)];
            ++m_freq[1][qRed(*data)];
            ++m_freq[2][qGreen(*data)];
            ++m_freq[3][qBlue(*data)];
        }
    }

    for (uchar ch = 0; ch < NCHANNELS; ++ch) {
        m_max[ch] = *std::max_element(m_freq[ch], m_freq[ch] + NCOLORS);
        uchar low = 0, high = NCOLORS - 1;
        uint zero_level = (uint) m_max[ch] * AUTOLEVELS_ZERO;

        while (low < high && m_freq[ch][low] <= zero_level)
            ++low;
        while (low < high && m_freq[ch][high] <= zero_level)
            --high;

        m_low[ch] = low;
        m_high[ch] = high;
    }

    update(boundingRect());
}

void Histogram::paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *)
{
    if (!m_doc)
        return;

    const int x = boundingRect().left();
    const int y = boundingRect().top();
    const int width = boundingRect().width();
    const int height = boundingRect().height();
    painter->fillRect(boundingRect(), QBrush(Qt::white, Qt::SolidPattern));

    uint* freq = m_freq[m_ch];
    uint max_freq = m_max[m_ch];
    if (max_freq == 0)
        return;

    double w = (width + .0) / NCOLORS;
    for (int i = 0; i < NCOLORS; ++i) {
        painter->fillRect((int) x + std::ceil(w * i), y + height,
                          (int) x + std::ceil(w), y + -height * (freq[i] + 0.0) / max_freq,
                          Qt::SolidPattern);
    }
}
