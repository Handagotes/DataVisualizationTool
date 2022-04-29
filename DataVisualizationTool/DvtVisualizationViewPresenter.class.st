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
	^ 640 @ 480
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
DvtVisualizationViewPresenter >> onExportToJPEGMenuItemAction [
	
]

{ #category : #private }
DvtVisualizationViewPresenter >> onExportToPNGMenuItemAction [
	
]

{ #category : #private }
DvtVisualizationViewPresenter >> onExportToSVGMenuItemAction [
	
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
	viewAdapter := view canvas buildMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		asSpecAdapter
]

{ #category : #accessing }
DvtVisualizationViewPresenter >> viewAdapter [
	^ viewAdapter
]
