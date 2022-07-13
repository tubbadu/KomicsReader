#ifndef FILEINFO_H
#define FILEINFO_H

#include <QObject>
#include <QFile>
#include <QFileInfo>

class FileInfo : public QObject
{
    Q_OBJECT
public:
    explicit FileInfo(QObject *parent = 0);
    Q_INVOKABLE qint64 getSize(const QString &filePath);
    Q_INVOKABLE bool exists(const QString &filePath);
    /*Q_INVOKABLE void makeDir(const QString &rootDir);
    Q_INVOKABLE QStringList getFiles(const QString &rootDir);
    Q_INVOKABLE QStringList getFiles(const QString &rootDir, const QStringList &filters);
    Q_INVOKABLE QStringList getFilesRecursively(const QString &rootDir, const QStringList &filters);
    Q_INVOKABLE QStringList getFilesRecursively(const QString &rootDir);
    Q_INVOKABLE QJsonArray getAllFilesAndDirs(const QString &rootDir);*/
    


private:
    QFileInfo *m_file;
};

#endif