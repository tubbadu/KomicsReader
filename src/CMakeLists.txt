add_executable(KomicsReader main.cpp resources.qrc launcher.cpp directory.cpp)
target_link_libraries(KomicsReader Qt5::Quick Qt5::Qml Qt5::Gui Qt5::QuickControls2 Qt5::Widgets KF5::Kirigami2 KF5::I18n) 
