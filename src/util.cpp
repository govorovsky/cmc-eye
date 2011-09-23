#include "util.h"

#include <QFileDialog>

Util::Util(QWidget* window, QObject *parent) :
    QObject(parent), m_window(window)
{
}

QString Util::openFileDialog(const QString &caption, const QString &dir, const QString &filter)
{
    return QFileDialog::getOpenFileName(m_window, caption, dir, filter);
}

QString Util::saveFileDialog(const QString &caption, const QString &dir, const QString &filter)
{
    return QFileDialog::getSaveFileName(m_window, caption, dir, filter);
}
