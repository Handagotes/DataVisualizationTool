Class {
	#name : #DvtVisualizationViewPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'view',
		'viewAdapter',
		'menu'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtVisualizationViewPresenter class >> askForFileRefToSaveWithExtensions: extensions [
	| fileDialog topWindow |
	(fileDialog := FileDialogWindow new)
		validExtensions: extensions;
		answerSaveFile.
	topWindow := SystemWindow topWindow.
	topWindow modalLockTo: fileDialog.
	fileDialog openModal.
	topWindow modalUnlockFrom: fileDialog. 
	fileDialog cancelled ifTrue: [ ^ nil ].
	^ fileDialog answer
]

{ #category : #specs }
DvtVisualizationViewPresenter class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #menu height: self toolbarHeight;
			add: #viewAdapter
	];
	yourself
]

{ #category : #api }
DvtVisualizationViewPresenter class >> openForView: aView [
	^ self new
		view: aView;
		openWithSpec
]

{ #category : #api }
DvtVisualizationViewPresenter >> extent [
	^ 800 @ 800
]

{ #category : #initialization }
DvtVisualizationViewPresenter >> initializeMenu [
	(menu := MenuPresenter new) addGroup: [ :group |
		group addItem: [ :appMenuItem | | subMenu |
			(subMenu := MenuPresenter new) addGroup: [ :appGroup |
				appGroup
					addItem: [ :item |
						item
							name: 'в PNG';
							action: [ self onExportToPNGMenuItemAction ]
					];
					addItem: [ :item |
						item
							name: 'в JPEG';
							action: [ self onExportToJPEGMenuItemAction ]
					];
					addItem: [ :item |
						item
							name: 'в SVG';
							action: [ self onExportToSVGMenuItemAction ]
					];
					addItem: [ :item |
						item
							name: 'в HTML';
							action: [ self onExportToHTMLMenuItemAction ]
					]
			].
			appMenuItem
				name: 'Экспорт';
				subMenu: subMenu
		]
	].
]

{ #category : #initialization }
DvtVisualizationViewPresenter >> initializeWidgets [
	self initializeMenu.
	viewAdapter := self newNullPresenter
]

{ #category : #accessing }
DvtVisualizationViewPresenter >> menu [
	^ menu
]

{ #category : #private }
DvtVisualizationViewPresenter >> onExportToHTMLMenuItemAction [
	| fileRef |
	(fileRef := (self class askForFileRefToSaveWithExtensions: #('html'))) ifNil: [ ^ self ].
	RTHTML5Exporter new
		directory: fileRef path parent asFileReference;
		fileName: fileRef path segments last;
		export: view;
		createJS
]

{ #category : #private }
DvtVisualizationViewPresenter >> onExportToJPEGMenuItemAction [
	| fileRef |
	(fileRef := self class askForFileRefToSaveWithExtensions: #('jpeg')) ifNil: [ ^ self ].
	(RTCanvasExporter canvas: view canvas)
		fileName: fileRef fullName;
		format: #jpeg;
		whole;
		export
]

{ #category : #private }
DvtVisualizationViewPresenter >> onExportToPNGMenuItemAction [
	| fileRef |
	(fileRef := self class askForFileRefToSaveWithExtensions: #('png')) ifNil: [ ^ self ].
	RTPNGExporter new
		builder: view;
		fileName: fileRef fullName;
		exportToFile
]

{ #category : #private }
DvtVisualizationViewPresenter >> onExportToSVGMenuItemAction [
	| fileRef |
	(fileRef := (self class askForFileRefToSaveWithExtensions: #('svg'))) ifNil: [ ^ self ].
	RTSVGExporter exportViewAsSVG: view filename: fileRef fullName
]

{ #category : #api }
DvtVisualizationViewPresenter >> title [
	^ DvtApp appName
]

{ #category : #accessing }
DvtVisualizationViewPresenter >> view [
	^ view
]

{ #category : #accessing }
DvtVisualizationViewPresenter >> view: aView [
	view := aView.
	view canvas extent: self extent - (25 @ 25).
	viewAdapter := view canvas buildMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		asSpecAdapter.
	view canvas camera adjust
]

{ #category : #accessing }
DvtVisualizationViewPresenter >> viewAdapter [
	^ viewAdapter
]
