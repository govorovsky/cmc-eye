#include "histogram.h"

#include <QDebug>
#include <algorithm>
#include <cmath>
#include <cstring>

const double AUTOLEVELS_ZERO = 0.02;

Histogram::Histogram(QDeclarativeItem *parent) :
    QDeclarativeItem(parent), m_doc(0), m_channel(0)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
}

Histogram::~Histogram() { }

int Histogram::parseChannel(const QString& channel) const
{
    if (channel == "value")
        return 0;
    if (channel == "red")
        return 1;
    if (channel == "green")
        return 2;
    if (channel == "blue")
        return 3;
    return m_channel;
}

uchar Histogram::getLow(const QString& channel) const
{
    const uint* freq = m_doc->getHistogram(parseChannel(channel));
    Q_ASSERT(freq != 0);

    uint max = *std::max_element(freq, freq + Document::NCOLORS);
    uint zero_level = (uint) max * AUTOLEVELS_ZERO;

    int low = 0;
    while (low < Document::NCOLORS && freq[low] <= zero_level)
        ++low;

    return (low != Document::NCOLORS) ? low : 0;
}

uchar Histogram::getHigh(const QString& channel) const
{
    const uint* freq = m_doc->getHistogram(parseChannel(channel));
    Q_ASSERT(freq != 0);

    uint max = *std::max_element(freq, freq + Document::NCOLORS);
    uint zero_level = (uint) max * AUTOLEVELS_ZERO;

    int high = Document::NCOLORS - 1;
    while (high >= 0 && freq[high] <= zero_level)
        --high;

    return (high >= 0) ? high : Document::NCOLORS - 1;
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
    connect(m_doc, SIGNAL(selectionChanged()), SLOT(repaint()));
    connect(m_doc, SIGNAL(repaint(QRect)), SLOT(repaint()));
}

QString Histogram::channel() const
{
    switch (m_channel) {
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
        m_channel = ch_id;
        emit channelChanged();
        update(boundingRect());
    } else {
        qDebug() << "Invalid channel" << channel;
    }
}

void Histogram::repaint() { update(boundingRect()); }

void Histogram::paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *)
{
    if (!m_doc)
        return;

    const int x = boundingRect().left();
    const int y = boundingRect().top();
    const int width = boundingRect().width();
    const int height = boundingRect().height();
    painter->fillRect(boundingRect(), QBrush(Qt::white, Qt::SolidPattern));

    const uint* freq = m_doc->getHistogram(m_channel);
    uint max_freq = *std::max_element(freq, freq + Document::NCOLORS);
    if (max_freq == 0)
        return;

    double w = (width + .0) / Document::NCOLORS;
    QPainterPath path;

    for (int i = 0; i < Document::NCOLORS; ++i) {
        path.addRect((int) x + (w * i), y + height,
                     (int) x + w, y + -height * (freq[i] + 0.0) / max_freq);
    }

    painter->fillPath(path, QBrush(Qt::SolidPattern));
}
