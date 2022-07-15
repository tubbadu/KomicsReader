#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <KLocalizedContext>
#include <KLocalizedString>

#include "launcher.h"
#include "directory.h"
#include "fileinfo.h"
#include "karchive.h"


int main(int argc, char *argv[])
{
	QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	QApplication app(argc, argv);
	KLocalizedString::setApplicationDomain("helloworld");
	QCoreApplication::setOrganizationName(QStringLiteral("KDE"));
	QCoreApplication::setOrganizationDomain(QStringLiteral("kde.org"));
	QCoreApplication::setApplicationName(QStringLiteral("Hello World"));

	QQmlApplicationEngine engine;
	
	qmlRegisterType<Launcher>("Launcher", 1, 0, "Launcher");
	qmlRegisterType<Directory>("Directory", 1, 0, "Directory");
	qmlRegisterType<FileInfo>("FileInfo", 1, 0, "FileInfo");
	qmlRegisterType<Karchive>("Karchive", 1, 0, "Karchive");

	engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	if (engine.rootObjects().isEmpty()) {
		return -1;
	}

	return app.exec();
}
