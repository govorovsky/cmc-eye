#include "document.h"

#include <QDebug>
#include <algorithm>
#include <cmath>

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
