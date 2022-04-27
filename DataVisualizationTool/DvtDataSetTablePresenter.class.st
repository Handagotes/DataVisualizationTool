Class {
	#name : #DvtDataSetTablePresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'dataGrid',
		'goBackButton',
		'selectRowsButton',
		'selectColumnsButton',
		'transposeCheckBox',
		'data',
		'node',
		'nodeType',
		'parentStack',
		'nodeAccessKeysStack',
		'allowCellEdit'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtDataSetTablePresenter class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #dataGrid;
			newRow: [ :row |
				row
					add: #goBackButton;
					add: #selectColumnsButton;
					add: #selectRowsButton;
					add: #transposeCheckBox
			] height: self buttonHeight
	]
]

{ #category : #testing }
DvtDataSetTablePresenter class >> isNode: anObject [
	^ anObject isArray or: [ anObject isDictionary ]
]

{ #category : #accessing }
DvtDataSetTablePresenter >> allowCellEdit [
	^ allowCellEdit
]

{ #category : #accessing }
DvtDataSetTablePresenter >> allowCellEdit: aBoolean [
	allowCellEdit := aBoolean
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayBlock [
	| columns rows |
	
	columns := 2.
	rows := node size + 1.
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Индекс' ]
				ifFalse: [ columnIndex = 2 ifTrue: [ 'Значение' ] ifFalse: [ nil ] ]
		] ifFalse: [ 
			columnIndex = 1
				ifTrue: [ (rowIndex - 1) asString ]
				ifFalse: [ columnIndex = 2 ifTrue: [ { rowIndex - 1 } ] ifFalse: [ nil ] ]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayOfArraysBlock [
	| columns rows |
	
	columns := node ifNotEmpty: [ node first size ] ifEmpty: [ 0 ].
	rows := node size.
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex |
		{ rowIndex. columnIndex }
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayOfDictsBlock [
	| columns rows |
	
	columns := node ifNotEmpty: [ node first keys size ] ifEmpty: [ 0 ].
	rows := node size + 1.
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
		key := node first keys at: columnIndex ifAbsent: [ nil ].
		rowIndex = 1
			ifTrue: [ key ifNotNil: [ key asString ] ]
			ifFalse: [ { rowIndex - 1. key } ]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyDictBlock [
	| columns rows |
	
	columns := node keys size.
	rows := 2.
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
		key := node keys at: columnIndex ifAbsent: [ nil ].
		rowIndex = 1
			ifTrue: [ key ifNotNil: [ key asString ] ]
			ifFalse: [ rowIndex = 2 ifTrue: [ { key } ] ifFalse: [ nil ] ]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyDictOfArraysBlock [
	| columns rows |
	
	columns := node keys size.
	rows := node ifNotEmpty: [ (node maxValue: [ :e | e size ]) + 1 ] ifEmpty: [ 1 ].
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
		key := node keys at: columnIndex ifAbsent: [ nil ].
		rowIndex = 1
			ifTrue: [ key asString ]
			ifFalse: [ { key. rowIndex - 1 } ]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayBlock [
	| columns rows |
	
	columns := node size.
	rows := 2.
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex |
		rowIndex = 1 ifTrue: [ 
			columnIndex asString
		] ifFalse: [ 
			rowIndex = 2
				ifTrue: [ { columnIndex } ]
				ifFalse: [ nil ]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayOfArraysBlock [
	| columns rows |
	
	columns := node size.
	rows := node ifNotEmpty: [ node first size ] ifEmpty: [ 0 ].
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex |
		{ columnIndex. rowIndex }
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayOfDictsBlock [
	| columns rows |
	
	columns := node size + 1.
	rows := node ifNotEmpty: [ node first keys size + 1 ] ifEmpty: [ 1 ].
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Ключ' ]
				ifFalse: [ (columnIndex - 1) asString ]
		] ifFalse: [ 
			key := node first keys at: rowIndex - 1 ifAbsent: [ nil ].
			columnIndex = 1
				ifTrue: [ key ifNotNil: [ key asString ] ]
				ifFalse: [ { columnIndex - 1. key } ]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedDictBlock [
	| columns rows |
	
	columns := 2.
	rows := node size + 1.
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Ключ' ]
				ifFalse: [ columnIndex = 2 ifTrue: [ 'Значение' ] ifFalse: [ nil ] ]
		] ifFalse: [ 
			key := node keys at: rowIndex - 1 ifAbsent: [ nil ].
			columnIndex = 1
				ifTrue: [ key ifNotNil: [ key asString ] ]
				ifFalse: [ columnIndex = 2 ifTrue: [ { key } ] ifFalse: [ nil ] ]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedDictOfArraysBlock [
	| columns rows |
	
	columns := node ifNotEmpty: [ (node maxValue: [ :e | e size ]) + 1 ] ifEmpty: [ 1 ].
	rows := node size + 1.
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Ключ' ]
				ifFalse: [ (columnIndex - 1) asString ]
		] ifFalse: [ 
			key := node keys at: rowIndex - 1 ifAbsent: [ nil ].
			columnIndex = 1
				ifTrue: [ key asString ]
				ifFalse: [ { key. columnIndex - 1 } ]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #accessing }
DvtDataSetTablePresenter >> data [
	^ data
]

{ #category : #accessing }
DvtDataSetTablePresenter >> data: aCollectionOfCollections [
	data := aCollectionOfCollections.
	parentStack removeAll.
	self node: data
]

{ #category : #accessing }
DvtDataSetTablePresenter >> dataGrid [
	^ dataGrid
]

{ #category : #private }
DvtDataSetTablePresenter >> editCellAt: coord value: value [
	| newValue transposed column row columnCount rowCount resizeNode keyEdit  |
	(allowCellEdit and: [ self isCellEditable: coord ]) ifFalse: [ ^ self ].
	newValue := value ifNil: [ '' ] ifNotNil: [ value asString ].
	(newValue := DvtTextInputDialog open: 'Введите значение ячейки' default: newValue) ifNil: [ ^ self ].
	newValue = value ifTrue: [ ^ self ].
	transposed := transposeCheckBox state.
	column := coord x.
	row := coord y.
	columnCount := dataGrid columnCount.
	rowCount := dataGrid rowCount.
	resizeNode := [ :size | | newNode |
		newNode := node resizeCopy: size.
		self replaceCurrentNode: node with: newNode.
		self assert: [ node == newNode ]
	].
	nodeType = #array ifTrue: [ 
		transposed ifFalse: [ 
			row > rowCount ifTrue: [ resizeNode value: row - 1 ].
			node at: row - 1 put: newValue
		] ifTrue: [ 
			column > columnCount ifTrue: [ resizeNode value: column ].
			node at: column put: newValue
		]
	].
	nodeType = #arrayOfArrays ifTrue: [ 
		transposed ifTrue: [ | t |
			t := column.
			column := row.
			row := t.
			t := columnCount.
			columnCount := rowCount.
			rowCount := t
		].
		(column > columnCount or: [ row > rowCount ]) ifTrue: [ | newNode |
			newNode := node resizeCopyColumns: (column max: columnCount) rows: (row max: rowCount).
			self replaceCurrentNode: node with: newNode.
			self assert: [ node == newNode ]
		].
		(node at: row) at: column put: newValue
	].
	keyEdit := transposed ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	nodeType = #dict ifTrue: [ 
		keyEdit ifTrue: [ 
			(node includesKey: newValue) ifTrue: [ 
				^ DvtErrorDialog open: ('Ключ "{1}" уже существует.' format: { newValue })
			].
			value ifNil: [ 
				node at: newValue put: nil
			] ifNotNil: [ | v |
				v := node at: value.
				node removeKey: value.
				node at: newValue put: v
			]
		] ifFalse: [ | key |
			key := dataGrid cellValueAt: coord - (transposed ifFalse: [ 0 @ 1 ] ifTrue: [ 1 @ 0 ]).
			node at: key put: newValue
		]
	].
	nodeType = #arrayOfDicts ifTrue: [ 
		keyEdit ifTrue: [ 
			
		] ifFalse: [ 
			
		]
	].
	nodeType = #dictOfArrays ifTrue: [ 
		keyEdit ifTrue: [ 
			(node includesKey: newValue) ifTrue: [ 
				^ DvtErrorDialog open: ('Ключ "{1}" уже существует.' format: { newValue })
			].
			value ifNil: [ 
				node at: newValue put: (Array new: rowCount)
			] ifNotNil: [ | v |
				v := node at: value.
				node removeKey: value.
				node at: newValue put: v
			]
		] ifFalse: [ 
			
		]
	].
	self updateNode
]

{ #category : #accessing }
DvtDataSetTablePresenter >> goBackButton [
	^ goBackButton
]

{ #category : #initialization }
DvtDataSetTablePresenter >> initialize [
	super initialize.
	data := nil.
	node := nil.
	parentStack := Stack new.
	nodeAccessKeysStack := Stack new.
	allowCellEdit := true.
]

{ #category : #initialization }
DvtDataSetTablePresenter >> initializeDataGrid [
	(dataGrid := self instantiate: DataGridPresenter)
		cellDisplayBlock: [ :value |
			value ifNil: [ '' ] ifNotNil: [ 
				(self class isNode: value)
					ifTrue: [ value isArray ifTrue: [ '<массив>' ] ifFalse: [ '<объект>' ] ]
					ifFalse: [ value asString ]
			]
		];
		cellTextColorBlock: [ :s :coord | | value |
			value := dataGrid cellValueAt: coord.
			(self class isNode: value)
				ifTrue: [ Color fromHexString: '0B4E60' ]
				ifFalse: [ Color veryDarkGray ]
		];
		whenCellDoubleClicked: [ :value :coord |
			(self class isNode: value) ifTrue: [ 
				parentStack push: node.
				nodeAccessKeysStack push: (dataGrid keysForCellCoord: coord).
				self node: value
			] ifFalse: [ 
				self editCellAt: coord value: value
			]
		]
]

{ #category : #initialization }
DvtDataSetTablePresenter >> initializePresenter [
	goBackButton action: [ 
		self onGoBackButtonAction
	].
	selectColumnsButton action: [ 
		self onSelectColumnsButtonAction
	].
	selectRowsButton action: [ 
		self onSelectRowsButtonAction
	].
	transposeCheckBox whenChangedDo: [ 
		self onTransposeCheckBoxStateChanged
	].
	
]

{ #category : #initialization }
DvtDataSetTablePresenter >> initializeWidgets [
	self initializeDataGrid.
	goBackButton := self newButton.
	selectColumnsButton := self newButton.
	selectRowsButton := self newButton.
	transposeCheckBox := self newCheckBox.
	
	goBackButton label: 'Назад'.
	selectColumnsButton label: 'Выделить столбцы'.
	selectRowsButton label: 'Выделить строки'.
	transposeCheckBox label: 'Транспонировать'.
	
	self focusOrder
		add: goBackButton;
		add: selectColumnsButton;
		add: selectRowsButton;
		add: transposeCheckBox
]

{ #category : #testing }
DvtDataSetTablePresenter >> isCellEditable: coord [
	| value transposed column row columnCount rowCount |
	nodeType ifNil: [ ^ false ].
	value := dataGrid cellValueAt: coord.
	(self class isNode: value) ifTrue: [ ^ false ].
	column := coord x.
	row := coord y.
	columnCount := dataGrid columnCount.
	rowCount := dataGrid rowCount.
	(column <= 0 or: [ row <= 0 ]) ifTrue: [ ^ false ].
	nodeType = #arrayOfArrays ifTrue: [ ^ true	].
	transposed := transposeCheckBox state.
	nodeType = #array ifTrue: [ 
		transposed
			ifFalse: [ ^ row ~= 1 and: [ column = 2 ] ]
			ifTrue: [ ^ row = 2 ]
	].
	nodeType = #dict ifTrue: [ 
		transposed ifFalse: [ 
			row = 1 ifTrue: [ ^ column <= (columnCount + 1) ].
			^ row = 2 and: [ column <= columnCount ]
		] ifTrue: [ 
			row = 1 ifTrue: [ ^ false ].
			column = 1 ifTrue: [ ^ row <= (rowCount + 1) ].
			^ column = 2 and: [ row <= rowCount ]
		]
	].
	(#(dictOfArrays arrayOfDicts) includes: nodeType) ifTrue: [
		transposed ifFalse: [ 
			row = 1 ifTrue: [ ^ column <= (columnCount + 1) ].
			^ row <= (rowCount + 1) and: [ column <= columnCount ]
		] ifTrue: [ 
			row = 1 ifTrue: [ ^ false ].
			column = 1 ifTrue: [ ^ row <= (rowCount + 1) ].
			^ column <= (columnCount + 1) and: [ row <= rowCount ]
		]
	].
	^ false
]

{ #category : #accessing }
DvtDataSetTablePresenter >> node [
	^ node
]

{ #category : #'private - accessing' }
DvtDataSetTablePresenter >> node: aNode [
	| transpose |
	
	node := aNode.
	
	node ifNil: [ 
		dataGrid reset.
		nodeType := nil.
		^ self
	].
	
	transpose := transposeCheckBox state.
	
	node isDictionary ifTrue: [ 
		(node allSatisfy: [ :e | e isArray and: [ e size = node anyOne size ] ]) ifTrue: [ 
			nodeType := #dictOfArrays.
			transpose
				ifTrue: [ self applyTransposedDictOfArraysBlock ]
				ifFalse: [ self applyDictOfArraysBlock ]
		] ifFalse: [ 
			nodeType := #dict.
			transpose
				ifTrue: [ self applyTransposedDictBlock ]
				ifFalse: [ self applyDictBlock ]
		].
		^ self
	].
	
	node isArray ifTrue: [ 
		(node allSatisfy: [ :e | e isDictionary and: [ e areKeysCompatibleWith: node first ] ]) ifTrue: [ 
			nodeType := #arrayOfDicts.
			transpose
				ifTrue: [ self applyTransposedArrayOfDictsBlock ]
				ifFalse: [ self applyArrayOfDictsBlock ]
		] ifFalse: [ 
			(node allSatisfy: [ :e | e isArray ]) ifTrue: [ 
				nodeType := #arrayOfArrays.
				transpose
					ifTrue: [ self applyTransposedArrayOfArraysBlock ]
					ifFalse: [ self applyArrayOfArraysBlock ]
			] ifFalse: [ 
				nodeType := #array.
				transpose
					ifTrue: [ self applyTransposedArrayBlock ]
					ifFalse: [ self applyArrayBlock ]
			]
		].
		^ self
	].
	
	self error: 'Node type must be either dictionary or array.'
]

{ #category : #accessing }
DvtDataSetTablePresenter >> nodeType [
	^ nodeType
]

{ #category : #private }
DvtDataSetTablePresenter >> onGoBackButtonAction [
	parentStack ifEmpty: [ ^ self ].
	nodeAccessKeysStack pop.
	self node: parentStack pop
]

{ #category : #private }
DvtDataSetTablePresenter >> onSelectColumnsButtonAction [
	| selectableInteraction rect |
	selectableInteraction := dataGrid selectableInteraction.
	(selectableInteraction hasSelection) ifFalse: [ ^ self ].
	rect := selectableInteraction selectionRect.
	selectableInteraction selectFrom: rect left @ 1 to: rect right @ dataGrid rowCount
]

{ #category : #private }
DvtDataSetTablePresenter >> onSelectRowsButtonAction [
	| selectableInteraction rect|
	selectableInteraction := dataGrid selectableInteraction.
	(selectableInteraction hasSelection) ifFalse: [ ^ self ].
	rect := selectableInteraction selectionRect.
	selectableInteraction selectFrom: 1 @ rect top to: dataGrid columnCount @ rect bottom
]

{ #category : #private }
DvtDataSetTablePresenter >> onTransposeCheckBoxStateChanged [
	self updateNode
]

{ #category : #accessing }
DvtDataSetTablePresenter >> selectColumnsButton [
	^ selectColumnsButton
]

{ #category : #accessing }
DvtDataSetTablePresenter >> selectRowsButton [
	^ selectRowsButton
]

{ #category : #accessing }
DvtDataSetTablePresenter >> transposeCheckBox [
	^ transposeCheckBox
]

{ #category : #updating }
DvtDataSetTablePresenter >> updateNode [
	self node: node
]
