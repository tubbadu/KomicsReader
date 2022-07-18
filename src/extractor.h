/*
 * SPDX-FileCopyrightText: 2019 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef EXTRACTOR_H
#define EXTRACTOR_H

#include <QObject>

class QTemporaryDir;
class KArchive;
class KArchiveDirectory;

class Extractor : public QObject
{
    Q_OBJECT
public:
    explicit Extractor(QObject *parent = nullptr);
    ~Extractor();

    Q_INVOKABLE QString getTmpFolder();
    Q_INVOKABLE QString resetTmpFolder();
    Q_INVOKABLE bool archiveExists();
    Q_INVOKABLE bool setArchiveFile(QString archiveFile);
    Q_INVOKABLE QStringList getRarList();
    Q_INVOKABLE QStringList getZipList();
    Q_INVOKABLE void extractRarIndex(QString filename);
    Q_INVOKABLE void extractZipIndex(QString filename);

    /*Q_INVOKABLE void extractArchive();
    Q_INVOKABLE void extractRarArchive();
    Q_INVOKABLE QString extractionFolder();
    Q_INVOKABLE QString unrarNotFoundMessage();
    Q_INVOKABLE QString archiveFile();
    Q_INVOKABLE QString resetTmpDir();
    Q_INVOKABLE QString getError();
    Q_INVOKABLE QString getlog();
    Q_INVOKABLE QStringList getFileList();
    Q_INVOKABLE void setArchiveFile(const QString &archiveFile);
    Q_INVOKABLE void extractSingleZip(const QString &singleFile);*/


Q_SIGNALS:
    /*void started();
    void finished();
    void finishedMemory(KArchive *, const QStringList &);
    void error(const QString &);
    void progress(int, QString);
    void unrarNotFound();*/
    void extracted(QString);
    void extracted2();
    void msg(QString);

private:
    //void getImagesInArchive(const QString &prefix, const KArchiveDirectory *dir);
    QString unzip = "/usr/bin/unzip";
    QString unrar = "/usr/bin/unrar";
    QString m_archiveFile;
    QTemporaryDir *m_tmpFolder {};
    QStringList m_entries;
};

#endif // EXTRACTOR_H
