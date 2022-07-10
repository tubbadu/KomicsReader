#ifndef DIRECTORY_H
#define DIRECTORY_H

#include <QObject>
#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QJsonArray>
#include <QJsonValue> 
#include <QJsonObject>
#include <QFileInfo>

class Directory : public QObject
{
    Q_OBJECT
public:
    explicit Directory(QObject *parent = 0);
    Q_INVOKABLE void emptyDir(const QString &rootDir);
    Q_INVOKABLE void makeDir(const QString &rootDir);
    Q_INVOKABLE QStringList getFiles(const QString &rootDir);
    Q_INVOKABLE QStringList getFiles(const QString &rootDir, const QStringList &filters);
    Q_INVOKABLE QStringList getFilesRecursively(const QString &rootDir, const QStringList &filters);
    Q_INVOKABLE QStringList getFilesRecursively(const QString &rootDir);
    Q_INVOKABLE QJsonArray getAllFilesAndDirs(const QString &rootDir);
    Q_INVOKABLE bool exists(const QString &filePath);


private:
    QDir *m_dir;
};

#endif