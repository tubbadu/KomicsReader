// Includes relevant modules used by the QML
import QtQuick 2.15
//import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami


//import QtQuick.Window 2.15
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.3
//import Qt.labs.folderlistmodel 2.5
import QtQml.Models 2.2
import Qt.labs.settings 1.0


import Launcher 1.0
import Directory 1.0
import FileInfo 1.0

// Base element, provides basic features needed for all kirigami applications

Kirigami.ApplicationWindow {
	id: window
	title: "KomicsReader"
	//property bool rotate: false
	property int rotate: 0

	function toggleFullscreen(){
		if(window.visibility === 5){
			window.visibility = "Windowed"
			leftbar.x = 0 // open
		} else {
			window.visibility = "FullScreen" // hhere
			leftbar.x = - leftbar.width // close
		}
		// adjust touchleftbar
		touchLeftbar.x = leftbar.x + leftbar.width - touchLeftbar.width/2
	}
	Item{ id: backend
		Launcher {
			id: launcher

			function extract(file){
				let cmd = "ark \"" + file + "\" -o /tmp/KomicsReader -ab"
				launch(cmd)
			}

			function pdfConvert(file){
				let cmd = "pdftoppm -jpeg -r 300 \"" + file + "\" -o /tmp/KomicsReader/img"
				launch(cmd)
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
			nameFilters: [ "cbr, cbz, pdf (*.cbr *.cbz *.pdf)"]
			onAccepted: {
				let path = (fileDialog.fileUrl + "").replace(/\%23/g, "#").replace(/^file\:\/\/./g, "/") // the . is just because the text editor is stupid and \//g was considered as a comment
				root.openFile(path)
			}
			onRejected: {
				console.log("Canceled")
			}
		}
		Settings{
			id: settings

			function saveFileIndex(path, index){
				let fileSize = fileinfo.getSize(path)
				let fileName = path.replace(/^.*[\\\/]/, "")
				let key = fileName + "_" + fileSize
				setValue(key, index)
			}
		}
		FileInfo{
			id: fileinfo
		}
	}
	Item{ id: toolbar
		z: 500
		// TODO perhaps header?  Kirigami.ToolBarApplicationHeader
		width: (window.rotate !== 0 ? parent.height : parent.width)
		//y: (window.rotate !== 0? parent.height : 0)
		y: (window.rotate === -1 ? parent.height : (window.rotate === +1 ? 0 : 0))
		x: (window.rotate === -1 ? 0 : (window.rotate === +1 ? window.width : 0))
		transform: Rotation{
			angle: (window.rotate === -1 ? -90 : (window.rotate === +1 ? 90 : 0))
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
					//visible: !rotate
					icon.name: "document-open-folder" 
					onTriggered: fileDialog.open()
				},
				Kirigami.Action { 
					text: "Rotate" 
					visible: (window.visibility === 5) && (window.rotate !== -1) // the actiontoolbar's background (id depends on kirigami.page) beheaves weirdly when toggling fullscreen while staying rotate, so I'll hide those button in order to avoid messing things up 
					icon.name: "osd-rotate-ccw" 
					onTriggered: {
						window.rotate += -1
						if (window.rotate < -1) {
							window.rotate = -1
						}
					}
				},
				Kirigami.Action { 
					text: "Rotate" 
					visible: (window.visibility === 5) && (window.rotate !== +1) // the actiontoolbar's background (id depends on kirigami.page) beheaves weirdly when toggling fullscreen while staying rotate, so I'll hide those button in order to avoid messing things up 
					icon.name: "osd-rotate-cw" 
					onTriggered: {
						window.rotate += +1
						if (window.rotate > +1) {
							window.rotate = +1
						}
					}
				},
				Kirigami.Action { 
					text: "fullscreen"
					visible: rotate === 0 // see comment in action "Rotate"
					icon.name: "view-fullscreen" 
					onTriggered: window.toggleFullscreen()
				}
			]
		}
	}
	pageStack.initialPage: Kirigami.Page {id: pagee
		padding: 0
		//y: (rotate === -1? window.height : 0)
		y: (window.rotate === -1 ? window.height : (window.rotate === +1 ? 0 : 0))
		x: (window.rotate === -1 ? 0 : (window.rotate === +1 ? window.width : 0))
		transform: Rotation{
			angle: (window.rotate === -1 ? -90 : (window.rotate === +1 ? 90 : 0))
		}
		Item{
			id: page
			anchors.fill: parent
		}
	}
	Item{ id: root
		height: page.height
		width: page.width
		anchors.bottom: parent.bottom
		
		property string rootDir: "/tmp/KomicsReader/"
		property string currentFile: "" // perhaps change the functions extract etc so that no value is needed to be passed anymore, just read this value TODO (perhaps)
		property var fileJson: []
		property var fileList: []
		property int index: 0

		onIndexChanged:{
			pageCounter.startTimeout()
		}

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
			//showPassiveNotification(arg)
			// TODO do this only after the gui has been displayed (and display a loading message)
			if(arg !== undefined){
				currentFile = arg
				if(dir.exists(arg) && arg.match(/\.(cbz|cbr|pdf)$/g) !== null){
					// create dir if not present
					dir.makeDir(root.rootDir)
					// empty dir from precedent files
					dir.emptyDir(root.rootDir)
					// extract file"
					if( arg.match(/\.(pdf)$/g) !== null){
						// convert pdf to jpg TODO!
						launcher.pdfConvert(arg)
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
					// unset the image source
					root.index = -1
					// display the first image after a small amount of time (so it resets)
					resetImageTimer.start()
					// do other things under here
				}		
			} else {
				console.log("is undefined")
			}
			loading.running = false
		}

		//////// GUI //////////
		Item { id: gui
			width: (window.rotate !== 0? window.height : parent.width)
			height: (window.rotate !== 0? page.width : parent.height)
			y: (window.rotate === -1 ? parent.height : (window.rotate === +1 ? page.height - window.height : 0))
			x: (window.rotate === -1 ? 0 : (window.rotate === +1 ? height : 0))
			transform: Rotation{
				angle: (window.rotate === -1 ? -90 : (window.rotate === +1 ? 90 : 0))
			}
			
			Image{ id: img
				anchors.bottom: parent.bottom
				height: (window.rotate !== 0? parent.height - (window.height - page.height) : parent.height)
				anchors.left: parent.left
				anchors.right: parent.right

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
								window.toggleFullscreen()
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
						} 
						if (y0 - y1 > xThreshold) {
							console.log("up")
						} else if (y1 - y0 > xThreshold) {
							console.log("down")
						}
					}

					onUpdated: {
						xx.height = point1.y
						xx.width = point1.x
					}
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
							} else {
								leftbar.x = 0 // open fully
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
						color: (window.active? Kirigami.Theme.alternateBackgroundColor : "transparent")
						width: 150 
						height: parent.height 
						x: -width
						z: 100
						Component.onCompleted: {
							//color.a = 0.1
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
									text: name
									wrapMode: Text.Wrap
									font.pixelSize: 15
									color: Kirigami.Theme.textColor 
									style: Text.Outline
									styleColor: Kirigami.Theme.backgroundColor

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
				BusyIndicator {
					id: loading
					running: true
					visible: true
					anchors.centerIn: parent
					height: 100
					width: height
					Timer { id: startProcessTimer
						running: true
						repeat: false
						interval: 100
						onTriggered:{
							root.openFile()
						}
					}			
				}
				Text { id: pageCounter
					text: (root.index + 1) + "/" + root.fileList.length
					anchors.top: parent.top
					anchors.right: parent.right
					font.pixelSize: 30
					style: Text.Outline
					styleColor: Kirigami.Theme.backgroundColor 
					visible: false
					color: Kirigami.Theme.textColor 
					function startTimeout(){
						visible = true
						pageCounterTimeout.restart()
					}

					Timer{
						id: pageCounterTimeout
						running: false
						repeat: false
						interval: 800
						onTriggered:{
							pageCounter.visible = false
						}
					}


				}

				Timer { id: resetImageTimer
					running: false
					repeat: false
					interval: 100
					onTriggered:{
						let fileSize = fileinfo.getSize(root.currentFile)
						let fileName = root.currentFile.replace(/^.*[\\\/]/, "")
						let key = fileName + "_" + fileSize

						root.index = settings.value(key, 0)
					}
				}
			}
		}
	}

	onClosing: {
		close.accepted = false
		settings.saveFileIndex(root.currentFile, root.index)
		Qt.quit()
	}
}