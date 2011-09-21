#ifndef DOCUMENT_H
#define DOCUMENT_H

#include <QObject>
#include <QImage>


class Document : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QRect selection READ selection WRITE setSelection NOTIFY selectionChanged)
public:
    explicit Document();

    QRect selection() const;
    void setSelection(QRect selection);

    Q_INVOKABLE bool load(const QString& filename);
    Q_INVOKABLE bool save(const QString& filename) const;

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
