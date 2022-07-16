#include "karchive.h"

Karchive::Karchive(QObject *parent) :
    QObject(parent)
    //m_karchive(new KCompressionDevice(this))
{
}

QString Karchive::extract(const QString &program)
{
    KCompressionDevice ark("/home/tubbadu/Scaricati/file.cbr");
    ark.open(QIODevice::ReadOnly);
    /*m_process->start(program);
    m_process->waitForFinished(-1);
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);*/
    return ark.readAll();
}
