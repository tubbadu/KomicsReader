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

	function toggleFullscreen(){
		if(window.visibility === 5){
			window.visibility = "Windowed"
			leftbar.x = 0
			touchLeftbar.x = leftbar.x + leftbar.width - touchLeftbar.width/2
		} else {
			window.visibility = "FullScreen"
			leftbar.x = - leftbar.width
			touchLeftbar.x = leftbar.x + leftbar.width - touchLeftbar.width/2
		}
	}

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

	Text{
		id: text
		color: "white"
		anchors.centerIn: parent
		text: root.fileList[root.index] + "<<"
	}
	Directory{
		id: dir
		Component.onCompleted:{
			
		}
	}

	// TODO perhaps header?  Kirigami.ToolBarApplicationHeader
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
			Kirigami.Action { 
				text: "fullscreen" 
				icon.name: "view-fullscreen" 
				onTriggered: window.toggleFullscreen()
			}, 
			Kirigami.Action { 
				text: "Rotate" 
				icon.name: "screen-rotate-auto-on" 
				onTriggered: showPassiveNotification("BEEP!") 
			}
		]
	}

	// Initial page to be loaded on app load
	pageStack.initialPage: Kirigami.Page {
		id: root
		padding: 0

		Layout.maximumWidth: 200
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
			// TODO do this only after the page has been displayed
			//let arg = Qt.application.arguments[1]
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
						//text.text ="extracting " + arg
						launcher.extract(arg)
					}
					// read files
					root.fileJson = dir.getAllFilesAndDirs(root.rootDir)
					root.fileJson.shift() // remove /tmp/KomicsReader from file list
					root.fileJson.shift() // remove /tmp/KomicsReader/firstfolder from file list
					root.fileList = []
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
					// do other things
					
				}		
			} else {
				text.text = "is undefined"
			}
		}

		Image{
			id: img
			anchors.fill: parent
			fillMode: Image.PreserveAspectFit
			property string url: root.fileList[root.index]
			source: (url === "" ? null : "file://" + url.replace(/\#/g, "%23")) // is null good?

			MultiPointTouchArea {
				id: touch
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

				Timer{
					id: tripleClickTimer

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
							//window.toggleFullscreen()
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
						log.log("up")
					} else if (y1 - y0 > xThreshold) {
						log.log("down")
					}
				}
			}
		}

		Item {
			id: leftItem
			anchors.left: parent.left
			height: parent.height
			width: 150
			MultiPointTouchArea{
				id: touchLeftbar
				width: 20
				height: parent.height
				y: 0
				//anchors.top: gui.top
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
			Rectangle{
				id: leftbar
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

				DelegateModel {
					id: lModel
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
				ListView{
					id: lView
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

	Component.onCompleted: root.openFile()
}

