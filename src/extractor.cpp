/*
 * SPDX-FileCopyrightText: 2007 Tobias Koenig <tokoe@kde.org>
 * SPDX-FileCopyrightText: 2019 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "extractor.h"
#include <KArchive>
#include <QCollator>
#include <QDir>
#include <QFileInfo>
#include <QFile>
#include <QMimeDatabase>
#include <QProcess>
#include <QTemporaryDir>
#include <QQuickAsyncImageProvider> 

#include <KLocalizedString>
#include <KTar>
#include <KZip>
#include <QRegularExpression>
#ifdef WITH_K7ZIP
#include <K7Zip>
#endif

Extractor::Extractor(QObject *parent)
	: QObject{parent}
{
	m_tmpFolder = new QTemporaryDir("/tmp/KomicsReader");
}

Extractor::~Extractor()
{
	delete m_tmpFolder;
}

QString Extractor::getTmpFolder(){
	return m_tmpFolder->path();
}

QString Extractor::resetTmpFolder(){
	delete m_tmpFolder;
	m_tmpFolder = new QTemporaryDir("/tmp/KomicsReader");
	return m_tmpFolder->path();
}

bool Extractor::archiveExists(){
	// TODO add iszip or israr
	return QFileInfo::exists(m_archiveFile);// && QFileInfo::isFile(m_archiveFile);
}

bool Extractor::setArchiveFile(QString archiveFile){
	m_archiveFile = archiveFile;
	return archiveExists();
}

QStringList Extractor::getRarList(){
	if(archiveExists()){
		QStringList args;
		args << "l" << m_archiveFile;

		auto process = new QProcess();
		process->setProgram(unrar);
		process->setArguments(args);
		process->start();
		process->waitForFinished(-1);

		QByteArray bytes = process->readAllStandardOutput();
		QStringList ret = {};
		QStringList output = QString::fromLocal8Bit(bytes).split(QRegExp("\n|\r\n|\r"),QString::SkipEmptyParts);
		for(auto s: output){
			if(s.endsWith(".jpg") || s.endsWith(".jpeg") || s.endsWith(".png") || s.endsWith(".jpe"))
				//ret.append(s.split(" ")[s.split(" ").size()-1]); // TODO tidy up
				ret.append(s.replace(QRegExp("^ *.{7} +[0-9]* +[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2} {2}"), ""));
		}
		// must now be sorted in alphabetical order
		ret.sort();
		// end sort
		return ret;
	} else {
		return {};
	}
}

QStringList Extractor::getZipList(){
	if(archiveExists()){
		QStringList args;
		args << "-l" << m_archiveFile;
		
		auto process = new QProcess();
		process->setProgram(unzip);
		process->setArguments(args);
		process->start();
		process->waitForFinished(-1);

		QByteArray bytes = process->readAllStandardOutput();
		QStringList ret = {};
		QStringList output = QString::fromLocal8Bit(bytes).split(QRegExp("\n|\r\n|\r"),QString::SkipEmptyParts);
		for(auto s: output){
			if(s.endsWith(".jpg") || s.endsWith(".jpeg") || s.endsWith(".png") || s.endsWith(".jpe"))
				ret.append(s.replace(QRegExp("^ *[0-9]+ {2}[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2} {3}"), ""));
		}
		// already sorted
		return ret;
	} else {
		return {};
	}
}

	void Extractor::extractRarIndex(QString filename){
		//QString argfilename = QString(filename).replace("[", "\\[").replace("]", "\\]").replace(" ", "\\ "); // not needed? dunno why
		if(archiveExists()){
		QStringList args;
		args << "x" << m_archiveFile << m_tmpFolder->path() << filename;

		auto process = new QProcess();
		process->setProgram(unrar);
		process->setArguments(args);
		process->start();
		connect(process, static_cast<void(QProcess::*)(int, QProcess::ExitStatus)>(&QProcess::finished),
			[=]  (int exitCode, QProcess::ExitStatus exitStatus) 
			{
				Q_EMIT extracted(filename);
			}
		);
	}
}

void Extractor::extractZipIndex(QString filename){
	Q_EMIT msg(filename);
	QString argfilename = QString(filename).replace("[", "\\[").replace("]", "\\]").replace(" ", "\\ ");
	if(archiveExists()){
		QStringList args;
		args << m_archiveFile << argfilename << "-d" << m_tmpFolder->path();

		auto process = new QProcess();
		process->setProgram(unzip);
		process->setArguments(args);
		process->start();
		connect(process, static_cast<void(QProcess::*)(int, QProcess::ExitStatus)>(&QProcess::finished),
			[=]  (int exitCode, QProcess::ExitStatus exitStatus) 
			{
				Q_EMIT extracted(filename);
				Q_EMIT msg(QString::fromLocal8Bit(process->readAllStandardOutput()));
			}
		);
	}
}


















/*
void Extractor::extractArchive()
{
	KArchive *archive {nullptr};
	QMimeDatabase db;
	const QMimeType mimetype = db.mimeTypeForFile(m_archiveFile, QMimeDatabase::MatchContent);
	if (mimetype.inherits(QStringLiteral("application/x-cbz"))
			|| mimetype.inherits(QStringLiteral("application/zip"))
			|| mimetype.inherits(QStringLiteral("application/vnd.comicbook+zip"))) {
		archive = new KZip(m_archiveFile);
		log += "kzip\n";
#ifdef WITH_K7ZIP
	} else if (mimetype.inherits(QStringLiteral("application/x-7z-compressed"))
			   || mimetype.inherits(QStringLiteral("application/x-cb7"))) {
		archive = new K7Zip(m_archiveFile);
		log += "k7zip\n";
#endif
	} else if (mimetype.inherits(QStringLiteral("application/x-tar"))
			   || mimetype.inherits(QStringLiteral("application/x-cbt"))) {
		archive = new KTar(m_archiveFile);
		log += "tar\n";
	} else if (mimetype.inherits(QStringLiteral("application/x-rar"))
			   || mimetype.inherits(QStringLiteral("application/x-cbr"))
			   || mimetype.inherits(QStringLiteral("application/vnd.rar"))
			   || mimetype.inherits(QStringLiteral("application/vnd.comicbook-rar"))) {
		extractRarArchive();
		log += "rar\n";
		return;
	} else {
		m_error = "err 2";
		Q_EMIT error(i18n("Could not open archive: %1", m_archiveFile));
		return;
	}
	log += "and now\n";
	if (!archive->open(QIODevice::ReadOnly)) {
		log += "can not open archive\n";
		delete archive;
		archive = nullptr;
		m_error = "err 3";
		Q_EMIT error(i18n("Could not open archive: %1", m_archiveFile));
		return;
	}

	const KArchiveDirectory *directory = archive->directory();
	if (!directory) {
		log += "!not a directory\n";
		delete archive;
		archive = nullptr;
		m_error = "err 4";
		Q_EMIT error(i18n("Could not open archive: %1", m_archiveFile));
		return;
	}

	getImagesInArchive(QString(), archive->directory());
	QCollator collator;
	collator.setNumericMode(true);
	std::sort(m_entries.begin(), m_entries.end(), collator);

	for(auto entry : m_entries){
		log += entry + ", ";

	}
	Q_EMIT finishedMemory(archive, m_entries);
	m_entries.clear();
}

void Extractor::getImagesInArchive(const QString &prefix, const KArchiveDirectory *dir)
{
	const QStringList entryList = dir->entries();
	for (const QString &file : entryList) {
		const KArchiveEntry *e = dir->entry(file);
		if (e->isDirectory()) {
			log += "is directory\n";
			getImagesInArchive(prefix + file + QStringLiteral("/"), static_cast<const KArchiveDirectory *>(e));
		} else if (e->isFile()) {
			//log += prefix + file + " is not directory";
			m_entries.append(prefix + file);
		}
	}
}

void Extractor::extractRarArchive()
{
	 auto unrar = QString("/usr/bin/unrar");
	if (unrar.startsWith("file://")) {
 #ifdef Q_OS_WIN32
		unrar.remove(0, QString("file:///").size());
 #else
		unrar.remove(0, QString("file://").size());
 #endif
	}
	QFileInfo fi(unrar);
	if (unrar.isEmpty() || !fi.exists()) {
		Q_EMIT unrarNotFound();
	}

	QStringList args;
	args << "e" << m_archiveFile << m_tmpFolder->path() << "-o+";
	auto process = new QProcess();
	process->setProgram(unrar);
	process->setArguments(args);
	process->start();

	connect(process, (void (QProcess::*)(int,QProcess::ExitStatus))&QProcess::finished,
			this, &Extractor::finished);

	connect(process, &QProcess::readyReadStandardOutput, this, [=]() {
		QRegularExpression re("[0-9]+[%]");
		QRegularExpressionMatch match = re.match(process->readAllStandardOutput());
		if (match.hasMatch()) {
			QString matched = match.captured(0);
			Q_EMIT progress(matched.remove("%").toInt(), matched);
		}
	});

	connect(process, &QProcess::errorOccurred,
			this, [=](QProcess::ProcessError err) {
		QString errorMessage;
		switch (err) {
		case QProcess::FailedToStart:
			errorMessage = "FailedToStart";
			break;
		case QProcess::Crashed:
			errorMessage = "Crashed";
			break;
		case QProcess::Timedout:
			errorMessage = "Timedout";
			break;
		case QProcess::WriteError:
			errorMessage = "WriteError";
			break;
		case QProcess::ReadError:
			errorMessage = "ReadError";
			break;
		default:
			errorMessage = "UnknownError";
		}
		m_error = "err 1";
		Q_EMIT error(i18n("Error: Could not open the archive. %1", errorMessage));
	});

	return;
}

void Extractor::extractSingleZip(const QString &singleFile){
	auto unzip = QString("/usr/bin/unzip")
	QStringList args;
	args << m_archiveFile << singleFile << "-d" << m_tmpFolder->path();
	auto process = new QProcess();
	process->setProgram(unzip);
	process->setArguments(args);
	process->start();
	Q_EMIT progress(singleFile);
	return;
}


QString Extractor::archiveFile()
{
	return m_archiveFile;
}
QString Extractor::getError()
{
	return m_error;
}
QString Extractor::getlog()
{
	return log;
}
QStringList Extractor::getFileList()
{
	return m_entries;
}

void Extractor::setArchiveFile(const QString &archiveFile)
{
	m_archiveFile = archiveFile;
}

QString Extractor::resetTmpDir()
{
	delete m_tmpFolder;
	m_tmpFolder = new QTemporaryDir();
	return m_tmpFolder->path();
}

QString Extractor::extractionFolder()
{
	return m_tmpFolder->path();
}

QString Extractor::unrarNotFoundMessage()
{
#ifdef Q_OS_WIN32
	return QStringLiteral("UnRAR executable was not found.\n"
						  "It can be installed through WinRAR or independent. "
						  "When installed with WinRAR just restarting the application "
						  "should be enough to find the executable.\n"
						  "If installed independently you have to manually "
						  "set the path to the UnRAR executable in the settings.");
#else
	return QStringLiteral("UnRAR executable was not found.\n"
						  "Install the unrar package and restart the application, "
						  "unrar should be picked up automatically.\n"
						  "If unrar is still not found you can set "
						  "the path to the unrar executable manually in the settings.");
#endif
}
*/