Class {
	#name : #DataGridPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'dataGridAdapter',
		'dataGridView',
		'gridInteraction',
		'selectableInteraction',
		'draggableViewInteraction',
		'data',
		'cellKeysBlock',
		'cellCountBlock',
		'columnCount',
		'rowCount',
		'cellDisplayBlock',
		'labelsByCoord',
		'cellTextColorBlock'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #specs }
DataGridPresenter class >> defaultSpec [
	^ SpecLayout composed
		add: #dataGridAdapter;
		yourself
]

{ #category : #accessing }
DataGridPresenter >> cellDisplayBlock [
	^ cellDisplayBlock
]

{ #category : #accessing }
DataGridPresenter >> cellDisplayBlock: aBlock [
	cellDisplayBlock := aBlock.
	self updateCells
]

{ #category : #configuration }
DataGridPresenter >> cellSize [
	^ gridInteraction gridSize
]

{ #category : #setup }
DataGridPresenter >> cellSize: size [
	gridInteraction gridSize: size.
	self updateCells
]

{ #category : #accessing }
DataGridPresenter >> cellTextColorBlock [
	^ cellTextColorBlock
]

{ #category : #accessing }
DataGridPresenter >> cellTextColorBlock: aBlock [
	cellTextColorBlock := aBlock.
	dataGridView canvas signalUpdate
]

{ #category : #accessing }
DataGridPresenter >> cellValueAt: coord [
	^ self cellValueAtColumnIndex: coord x rowIndex: coord y
]

{ #category : #api }
DataGridPresenter >> cellValueAtColumnIndex: columnIndex rowIndex: rowIndex [
	| keys value |
	keys := self keysForCellColumnIndex: columnIndex rowIndex: rowIndex.
	keys ifNil: [ ^ nil ].
	keys isString ifTrue: [ ^ keys ].
	self assert: [ keys isArray ] description: 'Cell keys block must return either an array of keys or nil or string.'.
	keys ifEmpty: [ ^ nil ].
	value := data.
	keys do: [ :key |
		value := value at: key ifAbsent: [ ^ nil ]
	].
	^ value
]

{ #category : #private }
DataGridPresenter >> colorElement: anElement coord: coord [
	^ cellTextColorBlock cull: anElement cull: coord
]

{ #category : #accessing }
DataGridPresenter >> columnCount [
	^ columnCount
]

{ #category : #accessing }
DataGridPresenter >> columnWidth [
	^ gridInteraction gridSize x
]

{ #category : #accessing }
DataGridPresenter >> columnWidth: columnWidth [
	gridInteraction gridSize: columnWidth @ gridInteraction gridSize y.
	self updateCameraLimits
]

{ #category : #api }
DataGridPresenter >> copySelectedCellsToClipboard [
	selectableInteraction hasSelection ifFalse: [ ^ self ].
	data ifNil: [ ^ self ].
	Clipboard clipboardText: (String streamContents: [ :ws | | rect rowEnd columnEnd |
		rect := selectableInteraction selectionRect.
		rowEnd := rect right.
		columnEnd := rect bottom.
		selectableInteraction selectionDo: [ :coord | | cell |
			(cell := (self stringCellValueAt: coord)) ifNotNil: [ 
				ws nextPutAll: cell asString.
				(coord x = rowEnd) ifFalse: [ ws tab ]
			].
			(coord x = rowEnd and: [ coord y < columnEnd ]) ifTrue: [ ws crlf ]
		]
	])
]

{ #category : #accessing }
DataGridPresenter >> createLabelAt: coord text: text [
	| label |
	(labelsByCoord includesKey: coord) ifTrue: [ ^ self ].
	label := RTLabel new element.
	labelsByCoord at: coord put: label.
	label
		model: text;
		when: TRMouseDragging do: [ self updateVisibleCells ];
		@ (RTPopup text: [ text ]).
	label shape
		color: [ :e | self colorElement: e coord: coord ].
	selectableInteraction coverElementEvents: label.
	draggableViewInteraction coverElementEvents: label
]

{ #category : #api }
DataGridPresenter >> data: aCollectionOfCollections cellKeysBlock: aCellKeysBlock cellCountBlock:  aCellCountBlock [
	"
	The data must be a collection of collections which accept message at:ifAbsent:.
	The cell key block must accept column and row indices of cell and return array of keys to access it's value in data or nil if there is no value.
	Additionaly, this block can return string instead of keys array which will be used as content for cell.
	"
	
	data := aCollectionOfCollections.
	cellKeysBlock := aCellKeysBlock.
	cellCountBlock := aCellCountBlock.
	
	self
		updateCells;
		updateCameraLimits;
		resetCamera
]

{ #category : #accessing }
DataGridPresenter >> dataGridAdapter [
	^ dataGridAdapter
]

{ #category : #testing }
DataGridPresenter >> hasSelection [
	^ selectableInteraction hasSelection
]

{ #category : #initialization }
DataGridPresenter >> initialize [
	data := nil.
	cellKeysBlock := nil.
	rowCount := 0.
	columnCount := 0.
	labelsByCoord := Dictionary new.
	cellTextColorBlock := [ Color veryDarkGray ].
	super initialize.
]

{ #category : #initialization }
DataGridPresenter >> initializeDataGridView [
	| initialResize |
	initialResize := true.
	dataGridView := RTView new.
	gridInteraction := RTRectangularGridView new
		gridSize: 75 @ 25;
		mustDrawCenterMarker: false;
		color: Color lightGray;
		yourself.
	selectableInteraction := RTGridViewCellSelectable forGridView: gridInteraction.
	draggableViewInteraction := RTDraggableViewWithLimit right.
	dataGridView
		@ gridInteraction;
		@ selectableInteraction;
		@ draggableViewInteraction;
		@ RTZoomableView;
		when: TRMouseDoubleRightClick do: [ self resetCamera ];
		when: TRMouseDragging do: [ self updateVisibleCells ];
		when: TRMouseWheelEvent do: [ self updateVisibleCells ];
		when: TRMouseEnter do: [ dataGridView canvas morph takeKeyboardFocus ]; "There is a bug when morph spec adapter never takes keyboard focus."
		when: TRKeyDown do: [ :e |
			(e keyCombination asString = 'Ctrl + c') ifTrue: [ 
				self copySelectedCellsToClipboard
			]
		];
		when: TRResizeCanvasEvent do: [ 
			self updateCameraLimits.
			
			(initialResize or: [ draggableViewInteraction isCameraOutsideLimits ]) ifTrue: [ 
				self resetCamera.
				initialResize := false
			].
			
			self updateVisibleCells.
		]
]

{ #category : #initialization }
DataGridPresenter >> initializeWidgets [
	self initializeDataGridView.
	dataGridAdapter := dataGridView canvas buildMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		asSpecAdapter
]

{ #category : #api }
DataGridPresenter >> keysForCellColumnIndex: columnIndex rowIndex: rowIndex [
	cellKeysBlock ifNil: [ ^ nil ].
	^ cellKeysBlock value: columnIndex value: rowIndex
]

{ #category : #api }
DataGridPresenter >> keysForCellCoord: coord [
	^ self keysForCellColumnIndex: coord x rowIndex: coord y
]

{ #category : #private }
DataGridPresenter >> removeLabelAt: aPoint [
	| label |
	label := labelsByCoord at: aPoint ifAbsent: [ ^ self ].
	labelsByCoord removeKey: aPoint.
	dataGridView removeElement: label.
	label view: nil
]

{ #category : #api }
DataGridPresenter >> reset [
	self data: nil cellKeysBlock: nil cellCountBlock: nil
]

{ #category : #api }
DataGridPresenter >> resetCamera [
	dataGridView canvas camera scale: 1.
	draggableViewInteraction moveCameraToLimitTopLeft.
	self updateVisibleCells
]

{ #category : #accessing }
DataGridPresenter >> rowCount [
	^ rowCount
]

{ #category : #accessing }
DataGridPresenter >> rowHeight [
	^ gridInteraction gridSize y
]

{ #category : #accessing }
DataGridPresenter >> rowHeight: rowHeight [
	gridInteraction gridSize: gridInteraction gridSize x @ rowHeight.
	self updateCameraLimits
]

{ #category : #accessing }
DataGridPresenter >> selectableInteraction [
	^ selectableInteraction
]

{ #category : #accessing }
DataGridPresenter >> selectedCellValues [
	| values |
	values := Dictionary new.
	self selectedCellsDo: [ :value :coord |
		values add: coord -> value
	].
	^ values
]

{ #category : #enumerating }
DataGridPresenter >> selectedCellsDo: aBlock [
	selectableInteraction hasSelection ifFalse: [ ^ self ].
	selectableInteraction selectionDo: [ :coord | | cell |
		cell := self cellValueAt: coord.
		aBlock value: cell value: coord 
	]
]

{ #category : #enumerating }
DataGridPresenter >> selectedCellsReverseDo: aBlock [
	selectableInteraction hasSelection ifFalse: [ ^ self ].
	selectableInteraction selectionReverseDo: [ :coord | | cell |
		cell := self cellValueAt: coord.
		aBlock value: cell value: coord 
	]
]

{ #category : #accessing }
DataGridPresenter >> selectionEnd [
	^ selectableInteraction selectionEnd
]

{ #category : #accessing }
DataGridPresenter >> selectionRect [
	^ selectableInteraction selectionRect
]

{ #category : #accessing }
DataGridPresenter >> selectionStart [
	^ selectableInteraction selectionStart
]

{ #category : #accessing }
DataGridPresenter >> stringCellValueAt: coord [
	| value |
	value := self cellValueAt: coord.
	^ (cellDisplayBlock
		ifNotNil: [ cellDisplayBlock value: value ]
		ifNil: [ value ifNil: [ String empty ] ]) asString
]

{ #category : #api }
DataGridPresenter >> updateCameraLimits [
	| gs topLeft bottomRight |
	gs := gridInteraction gridSize.
	topLeft := gs - (1 @ 1).
	bottomRight := ((columnCount @ rowCount) + (5 @ 5)) * gs.
	draggableViewInteraction limitRect: (topLeft corner: bottomRight)
]

{ #category : #updating }
DataGridPresenter >> updateCellAt: aPoint [
	| stringValue label |
	
	(stringValue := self stringCellValueAt: aPoint)
		ifEmpty: [ ^ self removeLabelAt: aPoint ].
	
	self createLabelAt: aPoint text: stringValue.
	label := labelsByCoord at: aPoint.
	stringValue := label shape cropTextFor: label toWidth: self columnWidth.
	
	label
		model: stringValue;
		translateTo: (gridInteraction pointForCellCoord: aPoint);
		update
]

{ #category : #updating }
DataGridPresenter >> updateCellCount [
	| cellCount |
	cellCountBlock ifNil: [ ^ self ].
	cellCount := cellCountBlock value.
	columnCount := cellCount x.
	rowCount := cellCount y
]

{ #category : #updating }
DataGridPresenter >> updateCells [
	self updateCellCount.
	
	[ :job | | cell cellCount |
		labelsByCoord
			do: [ :label |
				dataGridView removeElement: label.
				label view: nil
			];
			removeAll.
		
		cell := 1.
		cellCount := columnCount * rowCount.
		
		1 to: columnCount do: [ :column |
			1 to: rowCount do: [ :row |
				job
					progress: (cell / cellCount) asFloat;
					title: ('Обрабатывается ячейка {1} из {2}' format: { cell . cellCount }).
				self updateCellAt: column @ row.
				cell := cell + 1
			]
		].
		
		dataGridView canvas signalUpdate
	] asJob run
]

{ #category : #api }
DataGridPresenter >> updateVisibleCells [
	"This method should be called whenever camera changes position or scale and after canvas resizing"
	| rect |
	rect := self visibleCellsRect.
	
	dataGridView elements do: [ :e |
		(e shape class = RTLabel) ifTrue: [ | cellPos |
			cellPos := gridInteraction cellCoordForPoint: e position.
			(rect containsPoint: cellPos) ifFalse: [ 
				dataGridView removeElement: e.
				e view: nil
			]
		]
	].
	
	rect left to: rect right by: 1 do: [ :column |
		rect top to: rect bottom by: 1 do: [ :row | | label |
			(label := labelsByCoord at: column @ row ifAbsent: [ nil ]) ifNotNil: [ 
				label view ifNil: [ 
					dataGridView add: label.
					label view: dataGridView
				]
			]
		]
	].
	
	dataGridView canvas signalUpdate
]

{ #category : #private }
DataGridPresenter >> visibleCellsRect [
	| gs viewRect |
	gs := gridInteraction gridSize.
	viewRect := dataGridView canvas camera viewCanvasRect.
	^ ((viewRect topLeft // gs) - (1 @ 1)) corner: (viewRect bottomRight // gs)
]

{ #category : #api }
DataGridPresenter >> whenCellDoubleClicked: aBlock [
	dataGridView when: TRMouseDoubleLeftClick do: [ :e | | coord cellValue |
		coord := gridInteraction cellCoordForPoint: e position.
		cellValue := self cellValueAt: coord.
		aBlock value: cellValue value: coord
	]
]
