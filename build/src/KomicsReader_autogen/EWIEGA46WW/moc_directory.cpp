/****************************************************************************
** Meta object code from reading C++ file 'directory.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../../src/directory.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'directory.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Directory_t {
    QByteArrayData data[11];
    char stringdata0[108];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Directory_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Directory_t qt_meta_stringdata_Directory = {
    {
QT_MOC_LITERAL(0, 0, 9), // "Directory"
QT_MOC_LITERAL(1, 10, 8), // "emptyDir"
QT_MOC_LITERAL(2, 19, 0), // ""
QT_MOC_LITERAL(3, 20, 7), // "rootDir"
QT_MOC_LITERAL(4, 28, 7), // "makeDir"
QT_MOC_LITERAL(5, 36, 8), // "getFiles"
QT_MOC_LITERAL(6, 45, 7), // "filters"
QT_MOC_LITERAL(7, 53, 19), // "getFilesRecursively"
QT_MOC_LITERAL(8, 73, 18), // "getAllFilesAndDirs"
QT_MOC_LITERAL(9, 92, 6), // "exists"
QT_MOC_LITERAL(10, 99, 8) // "filePath"

    },
    "Directory\0emptyDir\0\0rootDir\0makeDir\0"
    "getFiles\0filters\0getFilesRecursively\0"
    "getAllFilesAndDirs\0exists\0filePath"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Directory[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   54,    2, 0x02 /* Public */,
       4,    1,   57,    2, 0x02 /* Public */,
       5,    1,   60,    2, 0x02 /* Public */,
       5,    2,   63,    2, 0x02 /* Public */,
       7,    2,   68,    2, 0x02 /* Public */,
       7,    1,   73,    2, 0x02 /* Public */,
       8,    1,   76,    2, 0x02 /* Public */,
       9,    1,   79,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::QStringList, QMetaType::QString,    3,
    QMetaType::QStringList, QMetaType::QString, QMetaType::QStringList,    3,    6,
    QMetaType::QStringList, QMetaType::QString, QMetaType::QStringList,    3,    6,
    QMetaType::QStringList, QMetaType::QString,    3,
    QMetaType::QJsonArray, QMetaType::QString,    3,
    QMetaType::Bool, QMetaType::QString,   10,

       0        // eod
};

void Directory::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<Directory *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->emptyDir((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 1: _t->makeDir((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 2: { QStringList _r = _t->getFiles((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 3: { QStringList _r = _t->getFiles((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QStringList(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 4: { QStringList _r = _t->getFilesRecursively((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QStringList(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 5: { QStringList _r = _t->getFilesRecursively((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 6: { QJsonArray _r = _t->getAllFilesAndDirs((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QJsonArray*>(_a[0]) = std::move(_r); }  break;
        case 7: { bool _r = _t->exists((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject Directory::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_Directory.data,
    qt_meta_data_Directory,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *Directory::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Directory::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Directory.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Directory::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 8;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
