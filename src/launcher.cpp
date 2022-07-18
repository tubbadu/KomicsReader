#include "launcher.h"

Launcher::Launcher(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
}

QString Launcher::launch(const QString &program)
{
    m_process->start(program);
    m_process->waitForFinished(-1);
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    return output;
}

QString Launcher::getZipList(const QString &filename)
{
    QString cmd = "filename=" + filename + ";"
"filelist=()"
"for subfile in $(unzip -l $filename | grep jpg)"
"do"
"	if [[ \"$subfile\" == *.jpg ]]"
"	then"
"		filelist+=(\"$subfile\")"
"	fi"
"done"
"echo ${filelist[@]}";

    return launch(cmd);
}

QString Launcher::getRarList(const QString &filename)
{
    QString cmd = "filename=" + filename + ";"
"filelist=()"
"for subfile in $(unrar l $filename | grep jpg)"
"do"
"	if [[ \"$subfile\" == *.jpg ]]"
"	then"
"		filelist+=(\"$subfile\")"
"	fi"
"done"
"IFS=$'\n' filelist=($(sort <<<\"${filelist[*]}\")); unset IFS"
"echo ${filelist[@]}";

    return launch(cmd);
}

QString Launcher::getProva()
{
    QString cmd = "ciao a tutti quanti";

    return cmd;
}