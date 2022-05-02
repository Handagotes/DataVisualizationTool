Class {
	#name : #DvtDataTablePresenter,
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
		'allowCellEdit',
		'cellEditedBlock'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #api }
DvtDataTablePresenter class >> canValue: value beConvertedToType: type [
	type = #string ifTrue: [ ^ true ].
	type = #number ifTrue: [ ^ value isNumber or: [ value isString and: [ NumberParser isNumber: value ] ] ].
	type = #literal ifTrue: [ ^ #(true false nil #true #false #nil #null) includes: value ].
	^ false
]

{ #category : #api }
DvtDataTablePresenter class >> convertValue: value toType: type [
	value isString ifTrue: [ ^ self convertValueString: value toType: type ].
	type = #string ifTrue: [ ^ value asString ].
	type = #number ifTrue: [ ^ value asNumber ].
	type = #literal ifTrue: [ ^ Object readFromString: value ].
	^ nil
]

{ #category : #api }
DvtDataTablePresenter class >> convertValueString: aString toType: type [
	type = #string ifTrue: [ ^ aString ].
	type = #number ifTrue: [ ^ aString asNumber ].
	type = #literal ifTrue: [ ^ Object readFromString: aString ].
	^ nil
]

{ #category : #specs }
DvtDataTablePresenter class >> defaultSpec [
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
	];
	yourself
]

{ #category : #api }
DvtDataTablePresenter class >> detectValueStringTypeAndConvert: aString [
	^ self convertValueString: aString toType: (self resolveTypeForValueString: aString)
]

{ #category : #testing }
DvtDataTablePresenter class >> isNode: anObject [
	^ anObject isArray or: [ anObject isDictionary ]
]

{ #category : #api }
DvtDataTablePresenter class >> resolveTypeForValueString: aString [
	(NumberParser isNumber: aString) ifTrue: [ ^ #number ].
	(#(#true #false #nil #null) includes: aString) ifTrue: [ ^ #literal ].
	^ #string
]

{ #category : #accessing }
DvtDataTablePresenter >> allowCellEdit [
	^ allowCellEdit
]

{ #category : #accessing }
DvtDataTablePresenter >> allowCellEdit: aBoolean [
	allowCellEdit := aBoolean
]

{ #category : #private }
DvtDataTablePresenter >> applyArrayBlock [
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
DvtDataTablePresenter >> applyArrayOfArraysBlock [
	| columns rows |
	
	columns := node ifNotEmpty: [ node first size ] ifEmpty: [ 0 ].
	rows := node size.
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex |
		{ rowIndex. columnIndex }
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataTablePresenter >> applyArrayOfDictsBlock [
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
DvtDataTablePresenter >> applyDictBlock [
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
DvtDataTablePresenter >> applyDictOfArraysBlock [
	| columns rows |
	
	columns := node keys size.
	rows := node ifNotEmpty: [ (node maxValue: [ :e | e size ]) + 1 ] ifEmpty: [ 1 ].
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
		key := node keys at: columnIndex ifAbsent: [ nil ].
		rowIndex = 1
			ifTrue: [ key ifNotNil: [ key asString ] ]
			ifFalse: [ { key. rowIndex - 1 } ]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataTablePresenter >> applyTransposedArrayBlock [
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
DvtDataTablePresenter >> applyTransposedArrayOfArraysBlock [
	| columns rows |
	
	columns := node size.
	rows := node ifNotEmpty: [ node first size ] ifEmpty: [ 0 ].
	
	dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex |
		{ columnIndex. rowIndex }
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataTablePresenter >> applyTransposedArrayOfDictsBlock [
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
DvtDataTablePresenter >> applyTransposedDictBlock [
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
DvtDataTablePresenter >> applyTransposedDictOfArraysBlock [
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
				ifTrue: [ key ifNotNil: [ key asString ] ]
				ifFalse: [ { key. columnIndex - 1 } ]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #api }
DvtDataTablePresenter >> cellTextColorForValue: value [
	value isString ifTrue: [ ^ DvtApp colorForStringValue ].
	value isNumber ifTrue: [ ^ DvtApp colorForNumberValue ].
	value isLiteral ifTrue: [ ^ DvtApp colorForLiteralValue ].
	(self class isNode: value) ifTrue: [ ^ DvtApp colorForNodeValue ].
	^ Color veryDarkGray
]

{ #category : #api }
DvtDataTablePresenter >> convertCellValue: value at: coord toType: type [
	| newValue |
	(self class canValue: value beConvertedToType: type) ifFalse: [ ^ false ].
	newValue := self class convertValue: value toType: type.
	self putCellValue: newValue at: coord.
	^ true
]

{ #category : #api }
DvtDataTablePresenter >> convertCellValueAt: coord toType: type [
	self convertCellValue: (dataGrid cellValueAt: coord) at: coord toType: type
]

{ #category : #accessing }
DvtDataTablePresenter >> data [
	^ data
]

{ #category : #accessing }
DvtDataTablePresenter >> data: aCollectionOfCollections [
	data = aCollectionOfCollections ifTrue: [ ^ self ].
	data := aCollectionOfCollections.
	parentStack removeAll.
	self node: data
]

{ #category : #accessing }
DvtDataTablePresenter >> dataGrid [
	^ dataGrid
]

{ #category : #private }
DvtDataTablePresenter >> editCellAt: coord value: value [
	| newValue |
	(allowCellEdit and: [ self isCellEditable: coord ]) ifFalse: [ ^ self ].
	newValue := value ifNil: [ '' ] ifNotNil: [ value asString ].
	(newValue := DvtTextInputDialog open: 'Введите значение ячейки' default: newValue) ifNil: [ ^ self ].
	newValue := self class detectValueStringTypeAndConvert: newValue.
	
	self
		editCellAt: coord value: value newValue: newValue showDvtError: true;
		updateNode.
	
	cellEditedBlock ifNotNil: [ 
		cellEditedBlock cull: newValue cull: value
	]
]

{ #category : #api }
DvtDataTablePresenter >> editCellAt: coord value: value newValue: newValue showDvtError: shouldShowDvtError [
	| column row needResize  |
	(allowCellEdit and: [ self isCellEditable: coord ]) ifFalse: [ ^ self ].
	newValue = value ifTrue: [ ^ self ].
	column := coord x.
	row := coord y.
	needResize := column > dataGrid columnCount or: [ row > dataGrid rowCount ].
	
	nodeType = #array
		ifTrue: [ self putNewValue: newValue inArrayAtColumn: column row: row needResize: needResize ].
	
	nodeType = #arrayOfArrays
		ifTrue: [ self putNewValue: newValue inArrayOfArraysAtColumn: column row: row needResize: needResize ].
	
	nodeType = #arrayOfDicts
		ifTrue: [ self putNewValue: newValue inArrayOfDictsAtColumn: column row: row needResize: needResize oldValue: value showDvtError: shouldShowDvtError ].
	
	nodeType = #dict
		ifTrue: [ self putNewValue: newValue inDictAtColumn: column row: row oldValue: value showDvtError: shouldShowDvtError ].
	
	nodeType = #dictOfArrays
		ifTrue: [ self putNewValue: newValue inDictOfArraysAtColumn: column row: row needResize: needResize oldValue: value showDvtError: shouldShowDvtError ].
	
	needResize ifTrue: [ self updateNode ]
]

{ #category : #accessing }
DvtDataTablePresenter >> goBackButton [
	^ goBackButton
]

{ #category : #initialization }
DvtDataTablePresenter >> initialize [
	super initialize.
	data := nil.
	node := nil.
	parentStack := Stack new.
	nodeAccessKeysStack := Stack new.
	allowCellEdit := false.
]

{ #category : #initialization }
DvtDataTablePresenter >> initializeDataGrid [
	(dataGrid := self instantiate: DataGridPresenter)
		cellDisplayBlock: [ :value |
			value ifNil: [ '' ] ifNotNil: [ 
				(self class isNode: value)
					ifTrue: [ value isArray ifTrue: [ '<список>' ] ifFalse: [ '<словарь>' ] ]
					ifFalse: [ value asString ]
			]
		];
		cellTextColorBlock: [ :s :coord | | value |
			value := dataGrid cellValueAt: coord.
			self cellTextColorForValue: value
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
DvtDataTablePresenter >> initializePresenter [
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
DvtDataTablePresenter >> initializeWidgets [
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
DvtDataTablePresenter >> isCellEditable: coord [
	^ (self isCellKeyEditable: coord) or: [ self isCellValueEditable: coord ]
]

{ #category : #testing }
DvtDataTablePresenter >> isCellKeyEditable: coord [
	| column row columnCount rowCount |
	nodeType ifNil: [ ^ false ].
	column := coord x.
	row := coord y.
	columnCount := dataGrid columnCount.
	rowCount := dataGrid rowCount.
	(column <= 0 or: [ row <= 0 ]) ifTrue: [ ^ false ].
	(#(array arrayOfArrays) includes: nodeType) ifTrue: [ ^ false ].
	(#(dict dictOfArrays arrayOfDicts) includes: nodeType) ifTrue: [ 
		transposeCheckBox state
			ifFalse: [ ^ row = 1 and: [ ^ column <= (columnCount + 1) ] ]
			ifTrue: [ ^ column = 1 and: [ row between: 2 and: rowCount + 1 ]	]
	].
	^ false
]

{ #category : #testing }
DvtDataTablePresenter >> isCellValueEditable: coord [
	| transposed column row columnCount rowCount |
	nodeType ifNil: [ ^ false ].
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
		transposed
			ifFalse: [ ^ row = 2 and: [ column <= columnCount ] ]
			ifTrue: [ ^ column = 2 and: [ row between: 2 and: rowCount ] ]
	].
	(#(dictOfArrays arrayOfDicts) includes: nodeType) ifTrue: [
		transposed
			ifFalse: [ ^ row >= 2 and: [ column <= columnCount ] ]
			ifTrue: [ ^ column >= 2 and: [ row between: 2 and: rowCount ] ]
	].
	^ false
]

{ #category : #testing }
DvtDataTablePresenter >> isTransposed [
	^ transposeCheckBox state
]

{ #category : #accessing }
DvtDataTablePresenter >> node [
	^ node
]

{ #category : #'private - accessing' }
DvtDataTablePresenter >> node: aNode [
	| transpose |
	
	node := aNode.
	
	node ifNil: [ 
		dataGrid reset.
		nodeType := nil.
		^ self
	].
	
	transpose := transposeCheckBox state.
	
	node isDictionary ifTrue: [ 
		(node size > 1 and: [ node allSatisfy: [ :e | e isArray and: [ e size = node anyOne size ] ] ]) ifTrue: [ 
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
		(node size > 1 and: [ node allSatisfy: [ :e | e isDictionary and: [ e areKeysCompatibleWith: node first ] ] ]) ifTrue: [ 
			nodeType := #arrayOfDicts.
			transpose
				ifTrue: [ self applyTransposedArrayOfDictsBlock ]
				ifFalse: [ self applyArrayOfDictsBlock ]
		] ifFalse: [ 
			(node size > 1 and: [ node allSatisfy: [ :e | e isArray ] ]) ifTrue: [ 
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
DvtDataTablePresenter >> nodeType [
	^ nodeType
]

{ #category : #private }
DvtDataTablePresenter >> onGoBackButtonAction [
	parentStack ifEmpty: [ ^ self ].
	nodeAccessKeysStack pop.
	self node: parentStack pop
]

{ #category : #private }
DvtDataTablePresenter >> onSelectColumnsButtonAction [
	| selectableInteraction rect |
	selectableInteraction := dataGrid selectableInteraction.
	(selectableInteraction hasSelection) ifFalse: [ ^ self ].
	rect := selectableInteraction selectionRect.
	selectableInteraction selectFrom: rect left @ 1 to: rect right @ dataGrid rowCount
]

{ #category : #private }
DvtDataTablePresenter >> onSelectRowsButtonAction [
	| selectableInteraction rect|
	selectableInteraction := dataGrid selectableInteraction.
	(selectableInteraction hasSelection) ifFalse: [ ^ self ].
	rect := selectableInteraction selectionRect.
	selectableInteraction selectFrom: 1 @ rect top to: dataGrid columnCount @ rect bottom
]

{ #category : #private }
DvtDataTablePresenter >> onTransposeCheckBoxStateChanged [
	self updateNode
]

{ #category : #api }
DvtDataTablePresenter >> putCellValue: newValue at: coord [
	self editCellAt: coord value: (dataGrid cellValueAt: coord) newValue: newValue showDvtError: false
]

{ #category : #private }
DvtDataTablePresenter >> putNewValue: newValue inArrayAtColumn: column row: row needResize: needResize [
	transposeCheckBox state ifFalse: [ 
		needResize ifTrue: [ self resizeArrayNode: row - 1 ].
		node at: row - 1 put: newValue
	] ifTrue: [ 
		needResize ifTrue: [ self resizeArrayNode: column ].
		node at: column put: newValue
	]
]

{ #category : #private }
DvtDataTablePresenter >> putNewValue: newValue inArrayOfArraysAtColumn: column row: row needResize: needResize [
	| c r |
	c := column.
	r := row.
	transposeCheckBox state ifTrue: [ 
		c := row.
		r := column
	].
	needResize ifTrue: [ 
		self resizeArrayOfArraysNode: (c max: dataGrid columnCount) @ (r max: dataGrid rowCount)
	].
	(node at: r) at: c put: newValue
]

{ #category : #private }
DvtDataTablePresenter >> putNewValue: newValue inArrayOfDictsAtColumn: column row: row needResize: needResize oldValue: oldValue showDvtError: shouldShowDvtError [
	| keyEdit |
	keyEdit := transposeCheckBox state ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	keyEdit ifTrue: [ 
		(node first includesKey: newValue) ifTrue: [ 
			shouldShowDvtError ifTrue: [ 
				DvtErrorDialog open: ('Ключ "{1}" уже существует.' format: { newValue }).
			].
			^ self
		].
		oldValue ifNil: [ 
			node do: [ :dict |
				dict at: newValue put: nil
			]
		] ifNotNil: [ 
			node do: [ :dict | | v |
				v := dict at: oldValue.
				dict removeKey: oldValue.
				dict at: newValue put: v
			]
		]
	] ifFalse: [ 
		| keys |
		keys := dataGrid keysForCellCoord: column @ row.
		needResize ifTrue: [ | oldSize size |
			size := keys first.
			oldSize := node size.
			self resizeArrayNode: size.
			oldSize + 1 to: size do: [ :i | | dict |
				dict := Dictionary new.
				node first keysDo: [ :key |
					dict add: key -> nil
				].
				node at: i put: dict
			]
		].
		(node at: keys first) at: keys second put: newValue
	]
	
]

{ #category : #private }
DvtDataTablePresenter >> putNewValue: newValue inDictAtColumn: column row: row oldValue: oldValue showDvtError: shouldShowDvtError [
	| keyEdit |
	keyEdit := transposeCheckBox state ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	keyEdit ifTrue: [ 
		(node includesKey: newValue) ifTrue: [ 
			shouldShowDvtError ifTrue: [ 
				DvtErrorDialog open: ('Ключ "{1}" уже существует.' format: { newValue })
			].
			^ self
		].
		oldValue ifNil: [ 
			node at: newValue put: nil
		] ifNotNil: [ | v |
			v := node at: oldValue.
			node removeKey: oldValue.
			node at: newValue put: v
		]
	] ifFalse: [ | key |
		key := (dataGrid keysForCellCoord: column @ row) first.
		node at: key put: newValue
	]
]

{ #category : #private }
DvtDataTablePresenter >> putNewValue: newValue inDictOfArraysAtColumn: column row: row needResize: needResize oldValue: oldValue showDvtError: shouldShowDvtError [
	| keyEdit |
	keyEdit := transposeCheckBox state ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	keyEdit ifTrue: [ 
		(node includesKey: newValue) ifTrue: [ 
			shouldShowDvtError ifTrue: [ 
				DvtErrorDialog open: ('Ключ "{1}" уже существует.' format: { newValue })
			].
			^ self
		].
		oldValue ifNil: [ | size |
			size := transposeCheckBox state ifFalse: [ dataGrid rowCount - 1 ] ifTrue: [ dataGrid columnCount - 1 ].
			node at: newValue put: (Array new: size)
		] ifNotNil: [ | v |
			v := node at: oldValue.
			node removeKey: oldValue.
			node at: newValue put: v
		]
	] ifFalse: [ 
		| keys |
		keys := dataGrid keysForCellCoord: column @ row.
		needResize ifTrue: [ | size |
			size := keys second.
			node keysAndValuesDo: [ :k :v |
				node at: k put: (v resizeCopy: size)
			]
		].
		(node at: keys first) at: keys second put: newValue
	]
]

{ #category : #removing }
DvtDataTablePresenter >> removeCellValueAt: coord [
	
]

{ #category : #private }
DvtDataTablePresenter >> replaceResizedArrayNode: newNode [
	| parent keys |
	parentStack ifEmpty: [ 
		data := newNode.
		node := newNode.
		^ self
	].
	parent := parentStack top.
	keys := nodeAccessKeysStack top.
	1 to: keys size - 1 do: [ :i |
		parent := parent at: (keys at: i)
	].
	parent at: keys last put: newNode.
	node := newNode
]

{ #category : #private }
DvtDataTablePresenter >> resizeArrayNode: newSize [
	self replaceResizedArrayNode: (node resizeCopy: newSize)
]

{ #category : #private }
DvtDataTablePresenter >> resizeArrayOfArraysNode: newSize [
	self replaceResizedArrayNode: (node resizeCopyColumns: newSize x rows: newSize y)
]

{ #category : #accessing }
DvtDataTablePresenter >> selectColumnsButton [
	^ selectColumnsButton
]

{ #category : #accessing }
DvtDataTablePresenter >> selectRowsButton [
	^ selectRowsButton
]

{ #category : #accessing }
DvtDataTablePresenter >> transposeCheckBox [
	^ transposeCheckBox
]

{ #category : #updating }
DvtDataTablePresenter >> updateNode [
	self node: node
]

{ #category : #enumerating }
DvtDataTablePresenter >> whenCellEditedDo: aBlock [
	cellEditedBlock := aBlock
]
