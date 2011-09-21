#include "document.h"

#include <QtCore>
#include <QColor>

Document::Document()
{
}

QImage Document::getImage() const
{
    return m_image;
}

bool Document::load(const QString& filename)
{
    if (!m_image.load(filename))
        return false;

    setSelection(m_image.rect());
    emit changed(m_selection);
    return true;
}

bool Document::save(const QString& filename) const
{
    return m_image.save(filename);
}

QRect Document::selection() const
{
    return m_selection;
}

void Document::setSelection(QRect selection)
{
    m_selection = selection.isValid() ? selection : m_image.rect();
    emit selectionChanged();
}

/*
  Contrast editing functions
 */

struct Line {
    QRgb* data;
    int len;
    const Document::PixelMapper& func;

    Line(QRgb* _data, int _len, const Document::PixelMapper& _func)
        : data(_data), len(_len), func(_func) { }
    const Line& operator =(const Line& other) { return other; }
};

static void mapLine(Line line)
{
    for (int i = 0; i < line.len; ++i, ++line.data)
        (*line.data) = line.func(*line.data);
}

void Document::mapPixels(const PixelMapper& func)
{
    QList <Line> lines;
    for (int i = m_selection.top(); i <= m_selection.bottom(); ++i) {
        QRgb* data = reinterpret_cast <QRgb*> (m_image.scanLine(i));
        data += m_selection.left();
        lines.append(Line(data, m_selection.width(), func));
    }
    QtConcurrent::blockingMap(lines, mapLine);
}

struct ChannelCorrector {
    virtual uchar correct(uchar value) const = 0;
    uchar operator()(uchar value) const { return correct(value); }
};

class LinearCorrector: public ChannelCorrector {
    uchar m_low, m_high;
public:
    LinearCorrector(uchar low, uchar high): m_low (low), m_high(high) { }
    uchar correct(uchar value) const {
        if (value <= m_low)
            return 0;
        if (value >= m_high)
            return 255;
        return (uchar) ((value - m_low) * 255.0 / (m_high - m_low));
    }
};

struct RedCorrector: Document::PixelMapper {
    const ChannelCorrector& m_corrector;
    explicit RedCorrector(const ChannelCorrector& corrector): m_corrector(corrector) { }
    QRgb map(QRgb pixel) const {
        return qRgb(m_corrector(qRed(pixel)), qGreen(pixel), qBlue(pixel));
    }
};

struct GreenCorrector: Document::PixelMapper {
    const ChannelCorrector& m_corrector;
    explicit GreenCorrector(const ChannelCorrector& corrector): m_corrector(corrector) { }
    QRgb map(QRgb pixel) const {
        return qRgb(qRed(pixel), m_corrector(qGreen(pixel)), qBlue(pixel));
    }
};

struct BlueCorrector: Document::PixelMapper {
    const ChannelCorrector& m_corrector;
    explicit BlueCorrector(const ChannelCorrector& corrector): m_corrector(corrector) { }
    QRgb map(QRgb pixel) const {
        return qRgb(qRed(pixel), qGreen(pixel), m_corrector(qBlue(pixel)));
    }
};

struct ValueCorrector: Document::PixelMapper {
    const ChannelCorrector& m_corrector;
    explicit ValueCorrector(const ChannelCorrector& corrector): m_corrector(corrector) { }
    QRgb map(QRgb pixel) const {
        QColor color(pixel);
        int h, s, v;
        color.getHsv(&h, &s, &v);
        color.setHsv(h, s, m_corrector(v));
        return color.rgb();
    }
};

void Document::linearCorrection(uchar low, uchar high, QString channel)
{
    qDebug() << "LinearCorrection(" << low << "," << high << "," << channel << ")";

    if (channel == "red")
        mapPixels(RedCorrector(LinearCorrector(low, high)));
    else if (channel == "green")
        mapPixels(GreenCorrector(LinearCorrector(low, high)));
    else if (channel == "blue")
        mapPixels(BlueCorrector(LinearCorrector(low, high)));
    else if (channel == "value")
        mapPixels(ValueCorrector(LinearCorrector(low, high)));
    else {
        qCritical() << "Unknown channel name" << channel;
        return;
    }
    emit changed(m_selection);
}
