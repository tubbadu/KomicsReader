#include "fileinfo.h"

FileInfo::FileInfo(QObject *parent) :
	QObject(parent),
	m_file(new QFileInfo())
{
}

qint64 FileInfo::getSize(const QString &filePath)
{
	m_file->setFile(filePath);
	return m_file->size();
}

bool FileInfo::exists(const QString &filePath)
{
	return QFile::exists(filePath);
}
