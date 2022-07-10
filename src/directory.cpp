#include "directory.h"

Directory::Directory(QObject *parent) :
	QObject(parent),
	m_dir(new QDir())
{
}

void Directory::emptyDir(const QString &rootDir)
{
	QDir dir(rootDir);

	dir.setFilter( QDir::NoDotAndDotDot | QDir::Files );
	foreach( QString dirItem, dir.entryList() )
		dir.remove( dirItem );

	dir.setFilter( QDir::NoDotAndDotDot | QDir::Dirs );
	foreach( QString dirItem, dir.entryList() )
	{
		QDir subDir( dir.absoluteFilePath( dirItem ) );
		subDir.removeRecursively();
	}
}

void Directory::makeDir(const QString &rootDir)
{
	QDir dir(rootDir);
	dir.mkdir(rootDir);
}

QStringList Directory::getFiles(const QString &rootDir, const QStringList &filters) // get just the files in rootDir
{
	m_dir->setCurrent(rootDir);
	m_dir->setFilter(QDir::Files);
	QStringList output = m_dir->entryList(filters);
	return output;
}
QStringList Directory::getFiles(const QString &rootDir) // get just the files in rootDir
{
	m_dir->setCurrent(rootDir);
	m_dir->setFilter(QDir::Files);
	QStringList output = m_dir->entryList();
	return output;
}

QStringList Directory::getFilesRecursively(const QString &rootDir, const QStringList &filters)
{
	QStringList output = {};
	QDirIterator it(rootDir, filters, QDir::Files, QDirIterator::Subdirectories); //QDir::Files | QDir::NoSymLinks | QDir::NoDotAndDotDot
	while (it.hasNext())
	{
		output.append(it.next());
	}
	return output;
}

QStringList Directory::getFilesRecursively(const QString &rootDir)
{
	QStringList output = {};
	QDirIterator it(rootDir, QDir::Files, QDirIterator::Subdirectories); //QDir::Files | QDir::NoSymLinks | QDir::NoDotAndDotDot
	while (it.hasNext())
	{
		output.append(it.next());
	}
	return output;
}

bool Directory::exists(const QString &filePath)
{
	return QFile::exists(filePath);
}

QJsonArray scanDir(QDir dir) // copyed from internet, partially modified
{
	QJsonArray output;
	QJsonObject obj;

	dir.setFilter(QDir::Files | QDir::NoDotAndDotDot | QDir::NoSymLinks);

	qDebug() << "Scanning: " << dir.path();

	QStringList fileList = dir.entryList();

	obj.insert("url", dir.path());
	obj.insert("isFile", false);
	output.append(obj);

	
	for (int i=0; i<fileList.count(); i++)
	{
		//qDebug() << "Found file: " << fileList[i];
		obj.insert("url", dir.path() + "/" + fileList[i]);
		obj.insert("isFile", true);
		output.append(obj);
	}

	dir.setFilter(QDir::AllDirs | QDir::NoDotAndDotDot | QDir::NoSymLinks);
	QStringList dirList = dir.entryList();
	for (int i=0; i<dirList.size(); ++i)
	{
		QString newPath = QString("%1/%2").arg(dir.absolutePath()).arg(dirList.at(i));
		QJsonArray add = scanDir(QDir(newPath));
		for (const auto& value : add)
        	output << value;
	}
	return output;
}

QJsonArray Directory::getAllFilesAndDirs(const QString &rootDir)
{
	return scanDir(QDir(rootDir));
}

/*
QJsonArray Directory::getAllFilesAndDirs(const QString &rootDir)
{
	QJsonArray output;
	QJsonObject obj;

	QDirIterator it(rootDir, QDir::Files | QDir::AllDirs | QDir::NoDotAndDotDot, QDirIterator::Subdirectories); //QDir::Files | QDir::NoSymLinks | QDir::NoDotAndDotDot
	while (it.hasNext())
	{
		QString el(it.next());
		QFileInfo f(el);
		obj.insert("url", el);
		//obj.insert("name", "page num blebleble"); // perhaps not useful
		obj.insert("isFile", f.exists() && f.isFile());
		output.append(obj);
	}
	return output;
}
*/