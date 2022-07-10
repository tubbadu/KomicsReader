// Includes relevant modules used by the QML
import QtQuick 2.15
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

import Launcher 1.0
import Directory 1.0


//import QtQuick.Window 2.15
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.3
import Qt.labs.folderlistmodel 2.5
import QtQml.Models 2.2


// Base element, provides basic features needed for all kirigami applications

Kirigami.ApplicationWindow {
	id: window
	title: i18nc("@title:window", "Hello World")
	property bool rotate: false

	function toggleFullscreen(){
		if(window.visibility === 5){
			window.visibility = "Windowed"
		} else {
			window.visibility = "FullScreen" // hhere
		}
	}
	Item{ id: backend
		Launcher {
			id: launcher

			function extract(file){
				let cmd = "ark \"" + file + "\" -o /tmp/KomicsReader -ab"
				launch(cmd)
			}

			function pdfConvert(file){
				// TODO
			}
		}
		Directory{
			id: dir
		}
		FileDialog {
			id: fileDialog
			title: "Please choose a file"
			folder: shortcuts.home
			selectFolder: false
			nameFilters: [ "Comics files (*.cbr *.cbz)", "Pdf files (*.pdf)" ] // TODO fix
			onAccepted: {
				let path = (fileDialog.fileUrl + "").replace(/^file\:\/\/./g, "/") // the . is just because the text editor is stupid and \//g was considered as a comment
				root.openFile(path)
			}
			onRejected: {
				console.log("Canceled")
			}
		}
	}
	Item{ id: toolbar
		// TODO perhaps header?  Kirigami.ToolBarApplicationHeader
		width: (window.rotate? parent.height : parent.width)
		y: (window.rotate? parent.height : 0)
		transform: Rotation{
			angle: (window.rotate ? -90 : 0)
		}

		Kirigami.ActionToolBar { // top left toolbar
			anchors.top: parent.top
			actions: [
				Kirigami.Action { 
					text: "10x" 
					icon.name: "go-previous" 
					onTriggered: root.previous(10)
				}, 
				Kirigami.Action { 
					text: "10x" 
					icon.name: "go-next" 
					onTriggered: root.next(10)
				}
			]
		}

		Kirigami.ActionToolBar { // top right toolbar
			anchors.right: parent.right
			actions: [
				Kirigami.Action {  //TODO
					text: "open"
					visible: !rotate
					icon.name: "document-open-folder" 
					onTriggered: fileDialog.open()
				},
				Kirigami.Action { 
					text: "fullscreen"
					visible: !rotate
					icon.name: "view-fullscreen" 
					onTriggered: window.toggleFullscreen()
				}, 
				Kirigami.Action { 
					text: "Rotate" 
					visible: (window.visibility === 5)
					icon.name: "screen-rotate-auto-on" 
					onTriggered: window.rotate = !window.rotate
				}
			]
		}
	}
	pageStack.initialPage: Kirigami.Page { id: root
		padding: 0
		y: (rotate? window.height : 0)
		transform: Rotation{
			angle: (window.rotate ? -90 : 0)
		}
		property string rootDir: "/tmp/KomicsReader/"
		property var fileJson: []
		property var fileList: []
		property int index: 0

		function next(q=1){
			index += q
			if(index > fileList.length - 1){
				index = fileList.length - 1
			}
			if(!fileList[i]["isFile"]){
				index++
			}
		}

		function previous(q=1){
			index -= q
			if(index < 0){
				index = 0
			}
			if(!fileList[i]["isFile"]){
				index--
			}
		}

		function goTo(page){
			if(page >= 0 && page < fileList.length){
				index = page
			}
		}

		function openFile(arg=Qt.application.arguments[1]){
			// TODO do this only after the gui has been displayed (and display a loading message)
			if(arg !== undefined){
				if(dir.exists(arg) && arg.match(/\.(cbz|cbr|pdf)$/g) !== null){
					// create dir if not present
					dir.makeDir(root.rootDir)
					// empty dir from precedent files
					dir.emptyDir(root.rootDir)
					// extract file"
					if( arg.match(/\.(pdf)$/g) !== null){
						// convert pdf to jpg TODO!
					} else {
						launcher.extract(arg)
					}
					// read files
					root.fileJson = dir.getAllFilesAndDirs(root.rootDir)
					root.fileJson.shift() // remove /tmp/KomicsReader from file list
					root.fileJson.shift() // remove /tmp/KomicsReader/firstfolder from file list
					root.fileList = []
					lModel.model.clear()
					for(let i=0; i<root.fileJson.length; i++){
						if(root.fileJson[i]["isFile"]){
							lView.append("    Page " + (root.fileList.length + 1), root.fileList.length)
							root.fileList.push(root.fileJson[i]["url"])
						} else {
							lView.append(" " + root.fileJson[i]["url"].replace(/^.*[\\\/]/, ""), root.fileList.length) //.replace(/^.*[\\\/]/, "")
						}
					}
					// display first file
					root.index = 0
					// do other things under here
				}		
			} else {
				console.log("is undefined")
			}
		}

		//////// GUI //////////
		Item { id: gui
			width: (window.rotate? window.height : parent.width)
			height: (window.rotate? parent.width : parent.height)
			
			Image{ id: img
				anchors.fill: parent
				fillMode: Image.PreserveAspectFit
				property string url: root.fileList[root.index]
				source: (url === "" ? null : "file://" + url.replace(/\#/g, "%23")) // is null good?

				MultiPointTouchArea { id: touch
					property int xThreshold: 100
					property int yThreshold: 200
					property int x0: 0
					property int x1: 0
					property int y0: 0
					property int y1: 0

					anchors.fill: parent
					touchPoints: [
						TouchPoint { id: point1 }
					]

					Timer{ id: tripleClickTimer

						property bool tap1: false
						property bool tap2: false

						function addTap(){
							start()
							if(!tap1){
								tap1 = true
							} else if(!tap2){
								tap2 = true
							} else {
								// this is the tripleclick!
								tap1 = false
								tap2 = false
								stop()
								// toggle fullscreen
								//window.toggleFullscreen() // disabled because the topbar is better
							}
						}

						running: false
						repeat: false
						interval: 350
						onTriggered:{
							tap1 = false
							tap2 = false
						}
					}

					onPressed: {
						tripleClickTimer.addTap()

						x0 = point1.x
						x1 = point1.x

						y0 = point1.y
						y1 = point1.y
					}
					onReleased:{
						x1 = point1.x
						y1 = point1.y
						if (x0 - x1 > xThreshold) {
							root.next()
						} else if (x1 - x0 > xThreshold) {
							root.previous()
						} else if (y0 - y1 > xThreshold) {
							console.log("up")
						} else if (y1 - y0 > xThreshold) {
							console.log("down")
						}
					}
				}

				Component.onCompleted: root.openFile()
			}

			Item { id: leftItem
				anchors.left: parent.left
				height: parent.height
				width: 150
				MultiPointTouchArea{ id: touchLeftbar
					width: 20
					height: parent.height
					y: 0
					touchPoints: [
						TouchPoint { id: p2 }
					]

					onReleased: {
						if(leftbar.x < 0){
							leftbar.x = - leftbar.width // close
							// TODO add animation
						} else {
							leftbar.x = 0
						}
						touchLeftbar.x = leftbar.x + leftbar.width - touchLeftbar.width/2
					}
					onUpdated: {
						if(p2.x - leftbar.width + touchLeftbar.x < 0){
							leftbar.x = p2.x - leftbar.width + touchLeftbar.x
						} else {
							leftbar.x = 0
						}
					}
				}
				Rectangle{ id: leftbar
					color: "white"
					width: 100 //parent.width
					height: parent.height //toolbar.height + 10
					x: -width
					z: 100
					Component.onCompleted: {
						color.a = 0.1
						// open topbar
						leftbar.x = 0
						touchLeftbar.x = leftbar.x + leftbar.width - touchLeftbar.width/2
					}

					DelegateModel { id: lModel
						model: ListModel {}
						delegate: Rectangle{
							height: pageName.height
							width: lView.width
							color: "transparent"
							Text{
								id: pageName
								width: parent.width
								text: name //(isFile ? "    page " + (pos + 1) : "url")
								wrapMode: Text.Wrap
								font.pixelSize: 15
								color: "white"
								style: Text.Outline
								styleColor: "black"

								MouseArea{
									anchors.fill: parent

									onClicked: {
										root.goTo(pos)
									}
								}
							}
						}
					}
					ListView{ id: lView
						model: lModel
						anchors.bottom: parent.bottom
						height: parent.height - 10
						width: parent.width - 10

						function append(name, pos){ // just a shorter way to do it
							lModel.model.append({"name": name, "pos": pos})
						}
					}
				}
			}
		}
	}
}