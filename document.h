#ifndef DOCUMENT_H
#define DOCUMENT_H

#include <QObject>
#include <QImage>

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

    explicit Document(QObject *parent = 0);

    QRect selection() const { return m_selection; }
    void setSelection(QRect selection);

    QString source() const { return m_source; }
    void setSource(const QString& source);

    bool modified() const { return m_modified; }

    Q_INVOKABLE bool save(const QString& filename);
    Q_INVOKABLE void adjustContrast(uchar low, uchar high, QString channel);
    Q_INVOKABLE void transform(qreal x, qreal y, qreal angle, qreal scale = 1.0);
    Q_INVOKABLE void waveEffect();

    void concurrentMap(const PixelMapper& func);
    void translatePixels(const PixelTranslator& func);
    QImage getImage() const { return m_image; }
signals:
    void repaint(QRect region);
    void selectionChanged();
    void sourceChanged();
    void modifiedChanged();
private:
    Q_DISABLE_COPY(Document)
    void setModified(bool modified);

    QImage m_image;
    QString m_source;
    bool m_modified;
    QRect m_selection;
};

#endif // DOCUMENT_H
