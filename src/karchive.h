#ifndef KARCHIVE_H
#define KARCHIVE_H

#include <QObject>
#include <KArchive>
#include <KCompressionDevice>

class Karchive : public QObject
{
    Q_OBJECT
public:
    explicit Karchive(QObject *parent = 0);
    Q_INVOKABLE QString extract(const QString &program);

private:
    KCompressionDevice *m_karchive;
};

#endif 