#ifndef DOCUMENT_H
#define DOCUMENT_H

#include <QObject>
#include <QImage>
#include <QVector>

class Document : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QRect selection READ selection WRITE setSelection NOTIFY selectionChanged)
    Q_PROPERTY(QString source READ source() WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(bool modified READ modified() NOTIFY modifiedChanged())
public:
    struct PixelMapper {
        virtual QRgb map(QRgb pixel, QPoint point) const = 0;
        inline QRgb operator()(QRgb pixel, QPoint point) const { return map(pixel, point); }
    };

    struct PixelTranslator {
        /*  Returns coordinates on original image
         *  from the resulting image coordinates
         */
        virtual QPointF translate(QPoint point) const = 0;
        inline QPointF operator()(QPoint point) const { return translate(point); }
    };

    enum {
        NCHANNELS = 4,
        NCOLORS = 256
    };

    explicit Document(QObject *parent = 0);

    QRect selection() const { return m_selection; }
    void setSelection(QRect selection);

    QString source() const { return m_source; }
    void setSource(const QString& source);

    bool modified() const { return m_modified; }

    Q_INVOKABLE bool save(const QString& filename);
    Q_INVOKABLE void adjustContrast(uchar low, uchar high, QString channel);
    Q_INVOKABLE void transform(qreal x, qreal y, qreal angle, qreal scale = 1.0);
    Q_INVOKABLE void gaussBlur(qreal sigma = 0.5);
    Q_INVOKABLE void unsharp(qreal sharpness = 0.5, qreal sigma = 0.5);
    Q_INVOKABLE void medianFilter(uint radius = 3);
    Q_INVOKABLE void waveEffect();
    Q_INVOKABLE void grayWorld();

    void concurrentMap(const PixelMapper& func);
    void translatePixels(const PixelTranslator& func);
    void separableFilter(const QVector<qreal> &filter);

    const uint* getHistogram(int channel);
    QImage getImage() const { return m_image; }
signals:
    void repaint(QRect region);
    void selectionChanged();
    void sourceChanged();
    void modifiedChanged();
private:
    Q_DISABLE_COPY(Document)
    void setModified(bool modified);
    void updateHistogram();

    QImage m_image;
    QString m_source;
    bool m_modified;
    QRect m_selection;

    bool m_histogram_valid;
    uint m_freq[NCHANNELS][NCOLORS];
private slots:
    void invalidate_histogram();
};

#endif // DOCUMENT_H
