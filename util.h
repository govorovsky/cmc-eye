#ifndef UTIL_H
#define UTIL_H

#include <QObject>
#include <QWidget>

class Util : public QObject
{
    Q_OBJECT
public:
    explicit Util(QWidget* window, QObject *parent = 0);

    Q_INVOKABLE QString openFileDialog(const QString &caption, const QString& dir, const QString& filter);
    Q_INVOKABLE QString saveFileDialog(const QString &caption, const QString& dir, const QString& filter);
private:
    QWidget* m_window;
};

#endif // UTIL_H
