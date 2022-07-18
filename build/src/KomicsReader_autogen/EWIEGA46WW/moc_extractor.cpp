/****************************************************************************
** Meta object code from reading C++ file 'extractor.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../../src/extractor.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'extractor.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Extractor_t {
    QByteArrayData data[15];
    char stringdata0[168];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Extractor_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Extractor_t qt_meta_stringdata_Extractor = {
    {
QT_MOC_LITERAL(0, 0, 9), // "Extractor"
QT_MOC_LITERAL(1, 10, 9), // "extracted"
QT_MOC_LITERAL(2, 20, 0), // ""
QT_MOC_LITERAL(3, 21, 10), // "extracted2"
QT_MOC_LITERAL(4, 32, 3), // "msg"
QT_MOC_LITERAL(5, 36, 12), // "getTmpFolder"
QT_MOC_LITERAL(6, 49, 14), // "resetTmpFolder"
QT_MOC_LITERAL(7, 64, 13), // "archiveExists"
QT_MOC_LITERAL(8, 78, 14), // "setArchiveFile"
QT_MOC_LITERAL(9, 93, 11), // "archiveFile"
QT_MOC_LITERAL(10, 105, 10), // "getRarList"
QT_MOC_LITERAL(11, 116, 10), // "getZipList"
QT_MOC_LITERAL(12, 127, 15), // "extractRarIndex"
QT_MOC_LITERAL(13, 143, 8), // "filename"
QT_MOC_LITERAL(14, 152, 15) // "extractZipIndex"

    },
    "Extractor\0extracted\0\0extracted2\0msg\0"
    "getTmpFolder\0resetTmpFolder\0archiveExists\0"
    "setArchiveFile\0archiveFile\0getRarList\0"
    "getZipList\0extractRarIndex\0filename\0"
    "extractZipIndex"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Extractor[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      11,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   69,    2, 0x06 /* Public */,
       3,    0,   72,    2, 0x06 /* Public */,
       4,    1,   73,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
       5,    0,   76,    2, 0x02 /* Public */,
       6,    0,   77,    2, 0x02 /* Public */,
       7,    0,   78,    2, 0x02 /* Public */,
       8,    1,   79,    2, 0x02 /* Public */,
      10,    0,   82,    2, 0x02 /* Public */,
      11,    0,   83,    2, 0x02 /* Public */,
      12,    1,   84,    2, 0x02 /* Public */,
      14,    1,   87,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString,    2,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    2,

 // methods: parameters
    QMetaType::QString,
    QMetaType::QString,
    QMetaType::Bool,
    QMetaType::Bool, QMetaType::QString,    9,
    QMetaType::QStringList,
    QMetaType::QStringList,
    QMetaType::Void, QMetaType::QString,   13,
    QMetaType::Void, QMetaType::QString,   13,

       0        // eod
};

void Extractor::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<Extractor *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->extracted((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 1: _t->extracted2(); break;
        case 2: _t->msg((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 3: { QString _r = _t->getTmpFolder();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 4: { QString _r = _t->resetTmpFolder();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 5: { bool _r = _t->archiveExists();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 6: { bool _r = _t->setArchiveFile((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 7: { QStringList _r = _t->getRarList();
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 8: { QStringList _r = _t->getZipList();
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        case 9: _t->extractRarIndex((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 10: _t->extractZipIndex((*reinterpret_cast< QString(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (Extractor::*)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Extractor::extracted)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (Extractor::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Extractor::extracted2)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (Extractor::*)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Extractor::msg)) {
                *result = 2;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject Extractor::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_Extractor.data,
    qt_meta_data_Extractor,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *Extractor::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Extractor::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Extractor.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Extractor::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 11)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 11)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 11;
    }
    return _id;
}

// SIGNAL 0
void Extractor::extracted(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void Extractor::extracted2()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void Extractor::msg(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
