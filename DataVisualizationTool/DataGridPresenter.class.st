Class {
	#name : #DataGridPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'dataGridAdapter',
		'dataGridView',
		'gridInteraction',
		'selectableInteraction',
		'draggableViewInteraction',
		'cellValueBlock',
		'columnCount',
		'rowCount',
		'labelsByPoint',
		'columnsIdxByName',
		'columnsNamesByIdx'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #specs }
DataGridPresenter class >> defaultSpec [
	^ SpecLayout composed
		add: #dataGridAdapter;
		yourself
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
DataGridPresenter >> cellValueAt: aPoint [
	| column |
	column := columnsNamesByIdx at: aPoint x ifAbsent: [ nil ].
	^ cellValueBlock value: column value: aPoint x value: aPoint y
]

{ #category : #api }
DataGridPresenter >> cellValueAtColumn: column rowIndex: rowIndex [
	| columnIndex |
	columnIndex := columnsIdxByName at: column ifAbsent: [ self raiseNoSuchColumnError: column ].
	^ self cellValueAtColumnIndex: columnIndex rowIndex: rowIndex
]

{ #category : #api }
DataGridPresenter >> cellValueAtColumnIndex: columnIndex rowIndex: rowIndex [
	^ self cellValueAt: columnIndex @ rowIndex
]

{ #category : #api }
DataGridPresenter >> cellValueBlock: a3ArgumentsBlock columnCount: columns rowCount: rows [
	"
	The block must return cell value and accept 3 arguments: column name, column index and column row.
	This block also must be ready to accept nil as column name when the row index is 1 or when column name is absent.
	"
	
	cellValueBlock := a3ArgumentsBlock.
	columnCount := columns.
	rowCount := rows.
	
	columnsIdxByName removeAll.
	columnsNamesByIdx removeAll.
	
	rowCount isZero ifFalse: [ 
		1 to: columnCount do: [ :i | | name |
			(name := cellValueBlock value: nil value: i value: 1)
				ifNotNil: [ 
					columnsIdxByName at: name put: i.
					columnsNamesByIdx at: i put: name
				]
		]
	].
	
	self
		updateCells;
		updateCameraLimits;
		resetCamera
]

{ #category : #accessing }
DataGridPresenter >> columnCount [
	^ columnCount
]

{ #category : #accessing }
DataGridPresenter >> columnCount: anObject [
	columnCount := anObject.
	self
		updateCells;
		updateCameraLimits
]

{ #category : #accessing }
DataGridPresenter >> columnCount: columns rowCount: rows [
	columnCount := columns.
	rowCount := rows.
	self updateCells
]

{ #category : #accessing }
DataGridPresenter >> columnNames [
	| names |
	names := OrderedCollection new.
	1 to: columnCount do: [ :i |
		names add: (columnsNamesByIdx at: i ifAbsent: [ nil ])
	].
	^ names
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

{ #category : #accessing }
DataGridPresenter >> createLabelAt: aPoint text: text [
	| label |
	(labelsByPoint includesKey: aPoint) ifTrue: [ ^ self ].
	label := RTLabel new
		color: Color veryDarkGray;
		element.
	labelsByPoint at: aPoint put: label.
	label
		model: text;
		@ (RTPopup text: [ text ]).
	selectableInteraction coverElementEvents: label.
	draggableViewInteraction coverElementEvents: label.
	dataGridView add: label
]

{ #category : #accessing }
DataGridPresenter >> dataGridAdapter [
	^ dataGridAdapter
]

{ #category : #initialization }
DataGridPresenter >> initialize [
	super initialize.
	cellValueBlock := nil.
	rowCount := 0.
	columnCount := 0.
	columnsIdxByName := Dictionary new.
	columnsNamesByIdx := Dictionary new.
	labelsByPoint := Dictionary new.
]

{ #category : #initialization }
DataGridPresenter >> initializeDataGridView [
	dataGridView := RTView new.
	gridInteraction := RTRectangularGridView new gridSize: 50 @ 25; mustDrawCenterMarker: false; yourself.
	selectableInteraction := RTGridViewCellSelectable forGridView: gridInteraction.
	draggableViewInteraction := RTDraggableViewWithLimit right.
	dataGridView
		@ gridInteraction;
		@ selectableInteraction;
		@ draggableViewInteraction;
		when: TRMouseDoubleRightClick do: [ :e | self resetCamera ];
		when: TRResizeCanvasEvent do: [ :e |
			self updateCameraLimits.
			draggableViewInteraction isCameraOutsideLimits ifTrue: [ 
				self resetCamera
			]
		]
]

{ #category : #initialization }
DataGridPresenter >> initializeWidgets [
	self initializeDataGridView.
	dataGridAdapter := dataGridView canvas buildMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		asSpecAdapter.
	self updateCameraLimits
]

{ #category : #private }
DataGridPresenter >> raiseNoSuchColumnError: column [
	self error: ('Column "{1}" does not exist.' format: { column })
]

{ #category : #private }
DataGridPresenter >> removeLabelAt: aPoint [
	| label |
	label := labelsByPoint at: aPoint ifAbsent: [ ^ self ].
	labelsByPoint removeKey: aPoint.
	label remove
]

{ #category : #initialization }
DataGridPresenter >> resetCamera [
	dataGridView canvas camera translateTo: draggableViewInteraction limitRect topLeft
]

{ #category : #accessing }
DataGridPresenter >> rowCount [
	^ rowCount
]

{ #category : #accessing }
DataGridPresenter >> rowCount: anObject [
	rowCount := anObject.
	self
		updateCells
		updateCameraLimits
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
DataGridPresenter >> selectedCellValues [
	| values |
	values := Dictionary new.
	self selectionDo: [ :value :coord |
		values add: coord -> value
	].
	^ values
]

{ #category : #enumerating }
DataGridPresenter >> selectionDo: aBlock [
	| start end |
	start := self selectionStart.
	end := self selectionEnd.
	start x to: end x do: [ :x |
		start y to: end y do: [ :y | | p v |
			p := x @ y.
			v := self cellValueAt: p.
			aBlock value: v value: p
		]
	]
]

{ #category : #accessing }
DataGridPresenter >> selectionEnd [
	^ selectableInteraction selectionEnd
]

{ #category : #accessing }
DataGridPresenter >> selectionStart [
	^ selectableInteraction selectionStart
]

{ #category : #api }
DataGridPresenter >> tsvData: aTsvString [
	| data columns rows |
	data := RTTabTable new
		input: aTsvString;
		values.
	
	columns := data ifNotEmpty: [ data first size ] ifEmpty: [ 0 ].
	rows := data size.
	
	self cellValueBlock: [ :column :columnIndex :rowIndex | | row |
		(row := data at: rowIndex ifAbsent: [ nil ])
			ifNil: [ nil ]
			ifNotNil: [ 
				row at: columnIndex ifAbsent: [ nil ]
			]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DataGridPresenter >> updateCameraLimits [
	| gs topLeft bottomRight |
	gs := gridInteraction gridSize.
	topLeft := (dataGridView canvas extent / 2) + gs - (1 @ 1).
	bottomRight := columnCount
		ifNotNil: [ (columnCount @ rowCount) * gs ]
		ifNil: [ gs * 10 ].
	draggableViewInteraction limitRect: (topLeft corner: bottomRight).
	draggableViewInteraction limitRect traceCr
]

{ #category : #updating }
DataGridPresenter >> updateCellAt: aPoint [
	| value label |
	
	(value := self cellValueAt: aPoint)
		ifNil: [
			^ self removeLabelAt: aPoint
		].
	
	value := value asString.
	self createLabelAt: aPoint text: value.
	label := labelsByPoint at: aPoint.
	value := label shape cropTextFor: label toWidth: self columnWidth.
	
	label
		model: value;
		translateTo: (gridInteraction pointForCellCoord: aPoint);
		update
]

{ #category : #updating }
DataGridPresenter >> updateCells [
	labelsByPoint
		do: [ :label |
			label remove
		];
		removeAll.
	
	1 to: columnCount do: [ :column |
		1 to: rowCount do: [ :row |
			self updateCellAt: column @ row
		]
	].
	
	dataGridView canvas signalUpdate
]

{ #category : #api }
DataGridPresenter >> whenCellDoubleClicked: aBlock [
	dataGridView when: TRMouseDoubleLeftClick do: [ :e | | coord cellValue |
		coord := gridInteraction cellCoordForPoint: e position.
		cellValue := self cellValueAt: coord.
		aBlock value: cellValue value: coord
	]
]
