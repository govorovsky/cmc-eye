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

static int parseChannel(const QString& channel)
{
    if (channel == "value")
        return 0;
    if (channel == "red")
        return 1;
    if (channel == "green")
        return 2;
    if (channel == "blue")
        return 3;
    return -1;
}

uchar Histogram::getLow(const QString& channel) const
{
    int ch = parseChannel(channel);
    return m_low[(ch == -1) ? m_ch : ch];
}

uchar Histogram::getHigh(const QString& channel) const
{
    int ch = parseChannel(channel);
    return m_high[(ch == -1) ? m_ch : ch];
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
    connect(m_doc, SIGNAL(repaint(QRect)), SLOT(updateFrequencies()));
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
    int ch_id;

    if (-1 != (ch_id = parseChannel(channel))) {
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
