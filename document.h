#ifndef DOCUMENT_H
#define DOCUMENT_H

#include <QObject>
#include <QImage>


class Document : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QRect selection READ selection WRITE setSelection NOTIFY selectionChanged)
public:
    struct PixelMapper {
        virtual QRgb map(QRgb pixel) const = 0;
        inline QRgb operator()(QRgb pixel) const { return map(pixel); }
    };

    explicit Document();

    QRect selection() const;
    void setSelection(QRect selection);

    Q_INVOKABLE bool load(const QString& filename);
    Q_INVOKABLE bool save(const QString& filename) const;
    Q_INVOKABLE void linearCorrection(uchar low, uchar high, QString channel);

    void mapPixels(const PixelMapper& func);
    QImage getImage() const;
signals:
    void changed(QRect region);
    void selectionChanged();
private:
    Q_DISABLE_COPY(Document)
    QRect m_selection;
    QImage m_image;
};

#endif // DOCUMENT_H
