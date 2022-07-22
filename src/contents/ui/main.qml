import QtQuick 2.15
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.19 as Kirigami
import QtQuick.Controls 2.15 as Controls
import QtQuick.Dialogs 1.3
import QtQml.Models 2.2
import Qt.labs.settings 1.0
import QtQuick.Window 2.2


import Launcher 1.0
import Directory 1.0
import FileInfo 1.0
import Extractor 1.0

// Base element, provides basic features needed for all kirigami applications

Kirigami.ApplicationWindow {
	id: window
	title: i18n("KomicsReader")
	height: Screen.height - 100
	width: Screen.width - 100
	//property bool rotate: false
	property int rotate: 0

	Controls.ScrollView{
		anchors.right: parent.right
		visible: log.visible
		width: 700
		height: 700
		z: 10000000
		Controls.TextArea{
			visible: false ////// LOGLOGLOGLOGLOGLOGLOGLOGLOGLOGLOGLOGLOGLOGLOG
			id: log
			text: "log:\n"
			color: "red"
			//anchors.centerIn: parent
			anchors.fill: parent
			function log(x){
				text += "\n" + x
			}
		}
	}

	Text{
		visible: log.visible
		text: root.index
		z: 10000000000000000
		color: "green"
	}
	

	function toggleFullscreen(){
		if(window.visibility === 5){
			window.visibility = "Windowed"
			leftbar.x = 0 // open
		} else {
			window.visibility = "FullScreen"
			leftbar.x = - leftbar.width // close
		}
		// adjust touchleftbar
		touchLeftbar.x = leftbar.x + leftbar.width - touchLeftbar.width/2
	}
	Item{ id: backend
		Kirigami.Dialog {
			id: help // TODO finish!
			visible: false
			title: window.title + " - " + i18n("Help")
			preferredWidth: Kirigami.Units.gridUnit * 30
	    	standardButtons: Kirigami.Dialog.Ok | Kirigami.Dialog.Cancel

			onAccepted: console.log("OK button pressed")
			onRejected: console.log("Rejected")
		
			ColumnLayout {
				spacing: 0
				Text{
					width: Kirigami.Units.gridUnit * 20
					text: "# " + window.title + "\n" + i18n("### A Comics Reader designed for touchscreens!") + "\n\n" + i18n("Swipe with you finger to the left or to the right to navigate through the pages") + "\n" + i18n("Enter fullscreen mode with the button in the toolbar")+ "\n" + i18n("Rotate the screen clockwise or counterclockwise with the button if your tablet does not support automatic rotate (or if you just want to read in your bed and the autorotate is your greatest enemy)")
					color: Kirigami.Theme.textColor
					textFormat: Text.MarkdownText
					wrapMode: Text.Wrap
				}
			}
		}
		/*Launcher {
			id: launcher

			function extract(file){
				return 
				let cmd = "ark \"" + file + "\" -o /tmp/KomicsReader -ab"
				launch(cmd)
			}

			function pdfConvert(file){
				return
				let cmd = "pdftoppm -jpeg -r 300 \"" + file + "\" -o /tmp/KomicsReader/img"
				launch(cmd)
			}
		}*/
		
		Extractor{
			id: extractor
			// TODO 
			// start extracting not from 0 but from pagenumber - 5
			property int extractedIndex: 0
			property int firstExtractedIndex: 0
			property bool firstExtraction: true
			property var ff
			property string archiveType: ""
			property string tmpFolder: ""

			function extractIndex(){
				if(archiveType === "RAR")
					extractRarIndex(ff[extractedIndex])
				else if (archiveType === "ZIP")
					extractZipIndex(ff[extractedIndex])
				else
					log.log("error")
			}

			function extract(archive){
				tmpFolder=getTmpFolder()
				if(setArchiveFile(archive)){

					if(archive.endsWith(".cbr")){
						archiveType = "RAR"
						ff = getRarList()
					} else if (archive.endsWith(".cbz")) {
						archiveType = "ZIP"
						ff = getZipList()
					}else {
						log.log("invalid archive: " + archive)
						return
					}


					let fileSize = fileinfo.getSize(root.currentFile)
					let fileName = root.currentFile.replace(/^.*[\\\/]/, "")

					let key = fileName + "_" + fileSize
					firstExtractedIndex = settings.value(key, 0) - 5
					log.log("firstExtractedIndex=" + firstExtractedIndex)
					if(firstExtractedIndex < 0) {
						firstExtractedIndex = 0
					}
					for(let i=0; i<firstExtractedIndex; i++){
						root.fileList.push("-1")
					}
					extractedIndex = firstExtractedIndex

					if(archive.endsWith(".cbr")){
						extractRarIndex(ff[extractedIndex])
					} else if (archive.endsWith(".cbz")) {
						extractZipIndex(ff[extractedIndex])
					}
				} else {
					log.log("error: file does not exist")
				}
				
			}

			onMsg: (msg) => {
				//log.log("c++ msg: " + msg)
			}

			onExtracted: (file) => {
				if(root.fileList.length > extractedIndex){
					root.fileList[extractedIndex] = tmpFolder + "/" + file
				} else {
					root.fileList.splice(extractedIndex, 0, tmpFolder + "/" + file)
				}
				lView.insert(" page " + extractedIndex, extractedIndex, (extractedIndex > lView.count ? lView.count : extractedIndex))
				//log.log("lview append: " + extractedIndex + " at position " + (extractedIndex > lView.count ? lView.count : extractedIndex))
				extractedIndex++
				
				if(firstExtraction && extractedIndex < ff.length){
					//log.log("extracting index! " + extractedIndex)
					extractIndex()
				} else if(!firstExtraction && extractedIndex < firstExtractedIndex){
					//log.log("extracting index II! " + extractedIndex)
					extractIndex()
				} else {
					if(firstExtraction){
						firstExtraction = false
						log.log("now restarting from 0 until settings.value(key, 0) - 5!")
						extractedIndex = 0
						extractIndex()
					} else {
						log.log("finished!\n")
						/*let fileSize = fileinfo.getSize(root.currentFile)
						let fileName = root.currentFile.replace(/^.*[\\\/]/, "")
						let key = fileName + "_" + fileSize
						let setIndex = settings.value(key, 0)
						root.index = setIndex*/
					}
				}
				if(root.reloaded){
					let fileSize = fileinfo.getSize(root.currentFile)
					let fileName = root.currentFile.replace(/^.*[\\\/]/, "")
					let key = fileName + "_" + fileSize
					log.log(settings.value(key, "niente di nienmte"))
					let setIndex = settings.value(key, 0)
					root.index = -1
					log.log("check: " + setIndex + ", " + root.fileList.length + ", " + firstExtractedIndex)
					if(setIndex == root.fileList.length - 1){
						log.log("set index!\n")
						root.reloaded = false
						root.index = setIndex
					}
					
					
					
					

					//root.index = settings.value(key, 0)

					/*resetImageTimer.setUrl = root.fileList[settings.value(key, 0)]
					resetImageTimer.start()*/
				}
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
		property string pdfFile: ""
		property int index: -1
		property bool isPdf: false
		property bool reloaded: false

		onIndexChanged:{
			pageCounter.startTimeout()
		}

		function next(q=1){
			if(isPdf){
				img.currentFrame += q
				if(img.currentFrame > img.frameCount - 1){
					img.currentFrame = img.frameCount - 1
				}
			} else {
				index += q
				if(index > fileList.length - 1){
					index = fileList.length - 1
				}
				/*if(!fileList[i]["isFile"]){
					index++
				}*/
			}
			
		}

		function previous(q=1){
			if(isPdf){
				img.currentFrame -= q
				if(img.currentFrame < 0){
					img.currentFrame = 0
				}
			}else {
				index -= q
				if(index < 0){
					index = 0
				}
				/*if(!fileList[i]["isFile"]){
					index--
				}*/
			}
			
		}

		function goTo(page){
			if(isPdf){
				if(page >= 0 && page < img.frameCount){
					img.currentFrame = page
				}
			} else {
				if(page >= 0 && page < fileList.length){
					index = page
				}
			}
		}
			

		function openFile(arg=Qt.application.arguments[1]){
			root.index = -1
			img.currentFrame = 0
			root.isPdf = false
			lModel.model.clear()
			fileList = []
			reloaded = true
			
			if(arg.endsWith(".pdf")){
				root.isPdf = true
				pdfFile = "file://" + arg
			} else {
				extractor.extract(arg)
			}
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
				property string fileUrl: (root.fileList.length > 0 ? root.fileList[root.index] : null)
				source: (root.isPdf ? root.pdfFile : "file://" + root.fileList[root.index].replace(/\#/g, "%23")) //(fileUrl === null ? null : "file://" + fileUrl)//.replace(/\#/g, "%23")) // is null good?
				//currentFrame: (root.isPdf ? root.index : 0) // for PDF
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

							function insert(name, pos, ix){ // just a shorter way to do it
								lModel.model.insert(ix, {"name": name, "pos": pos})
							}
						}
					}
				}
				Controls.BusyIndicator {
					id: loading
					running: !true
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
					property string setUrl
					interval: 100
					onTriggered:{
						root.index = setUrl 
						return
						let fileSize = fileinfo.getSize(root.currentFile)
						let fileName = root.currentFile.replace(/^.*[\\\/]/, "")
						let key = fileName + "_" + fileSize

						if(settings.value(key, 0) < root.fileList.length){
							root.index = settings.value(key, 0)
						} else {
							resetImageTimer.restart()
						}
					}
				}

				Rectangle{ // white background (for PDF view)
					z: -1
					visible: root.isPdf
					anchors.centerIn: parent
					height: img.paintedHeight
					width: img.paintedWidth
					color: "white"
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