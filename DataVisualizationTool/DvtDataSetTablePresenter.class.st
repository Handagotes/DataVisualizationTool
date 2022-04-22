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
		'parentStack',
		'subNodeDict'
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
			] height: self toolbarHeight
	]
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayBlock [
	| columns rows |
	
	columns := 2.
	rows := node size + 1.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Индекс' ]
				ifFalse: [ 
					columnIndex = 2
						ifTrue: [ 'Значение' ]
						ifFalse: [ nil ]
				]
		] ifFalse: [ 
			columnIndex = 1
				ifTrue: [ rowIndex - 1 ]
				ifFalse: [ 
					columnIndex = 2
						ifTrue: [ self cellValueFor: (node at: rowIndex - 1 ifAbsent: [ nil ]) coord: columnIndex @ rowIndex ]
						ifFalse: [ nil ]
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayOfArraysBlock [
	| columns rows |
	
	columns := node ifNotEmpty: [ node first size ] ifEmpty: [ 0 ].
	rows := node size.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | | row |
		(row := node at: rowIndex ifAbsent: [ nil ])
			ifNil: [ nil ]
			ifNotNil: [ self cellValueFor: (row at: columnIndex ifAbsent: [ nil ]) coord: columnIndex @ rowIndex ]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayOfDictsBlock [
	| columns rows |
	
	columns := node ifNotEmpty: [ node first keys size ] ifEmpty: [ 0 ].
	rows := node size + 1.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			node
				ifEmpty: [ nil ]
				ifNotEmpty: [ node first keys at: columnIndex ]
		] ifFalse: [ | dict |
			(dict := node at: rowIndex - 1 ifAbsent: [ nil ])
				ifNil: [ nil ]
				ifNotNil: [ 
					self cellValueFor: (dict at: column ifAbsent: [ nil ]) coord: columnIndex @ rowIndex
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyDictBlock [
	| columns rows |
	
	columns := node keys size.
	rows := 2.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			node keys at: columnIndex
		] ifFalse: [ 
			self cellValueFor: (node at: column) coord: columnIndex @ rowIndex
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyDictOfArraysBlock [
	| columns rows |
	
	columns := node keys size.
	rows := node ifNotEmpty: [ (node maxValue: [ :e | e size ]) + 1 ] ifEmpty: [ 1 ].
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			node keys at: columnIndex
		] ifFalse: [ | array |
			array := node at: column.
			self cellValueFor: (array at: rowIndex - 1 ifAbsent: [ nil ]) coord: columnIndex @ rowIndex
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayBlock [
	| columns rows |
	
	columns := node size.
	rows := 2.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			columnIndex
		] ifFalse: [ 
			self cellValueFor: (node at: columnIndex ifAbsent: [ nil ]) coord: columnIndex @ rowIndex
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayOfArraysBlock [
	| columns rows |
	
	columns := node size.
	rows := node ifNotEmpty: [ node first size ] ifEmpty: [ 0 ].
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | | row |
		(row := node at: columnIndex ifAbsent: [ nil ])
			ifNil: [ nil ]
			ifNotNil: [ self cellValueFor: (row at: rowIndex ifAbsent: [ nil ]) coord: columnIndex @ rowIndex ]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayOfDictsBlock [
	| columns rows |
	
	columns := node size + 1.
	rows := node ifNotEmpty: [ node first keys size + 1 ] ifEmpty: [ 1 ].
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Ключ' ]
				ifFalse: [ columnIndex - 1 ]
		] ifFalse: [ 
			columnIndex = 1
				ifTrue: [ 
					node
						ifEmpty: [ nil ]
						ifNotEmpty: [ node first keys at: rowIndex - 1 ]
				]
				ifFalse: [ | dict |
					(dict := node at: columnIndex - 1 ifAbsent: [ nil ])
						ifNil: [ nil ]
						ifNotNil: [ | key |
							key := dataGrid cellValueAt: 1 @ rowIndex.
							self cellValueFor: (dict at: key) coord: columnIndex @ rowIndex
						]
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedDictBlock [
	| columns rows |
	
	columns := 2.
	rows := node size + 1.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Ключ' ]
				ifFalse: [ 
					columnIndex = 2
						ifTrue: [ 'Значение' ]
						ifFalse: [ nil ]
				]
		] ifFalse: [ 
			columnIndex = 1
				ifTrue: [ node keys at: rowIndex - 1 ]
				ifFalse: [ | key |
					key := dataGrid cellValueAt: 1 @ rowIndex.
					self cellValueFor: (node at: key) coord: columnIndex @ rowIndex
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedDictOfArraysBlock [
	| columns rows |
	
	columns := node ifNotEmpty: [ (node maxValue: [ :e | e size ]) + 1 ] ifEmpty: [ 1 ].
	rows := node size + 1.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Ключ' ]
				ifFalse: [ columnIndex - 1 ]
		] ifFalse: [ 
			columnIndex = 1
				ifTrue: [ node keys at: rowIndex - 1	]
				ifFalse: [ | key array |
					key := dataGrid cellValueAt: 1 @ rowIndex.
					array := node at: key.
					self cellValueFor: (array at: columnIndex - 1 ifAbsent: [ nil ]) coord: columnIndex @ rowIndex
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> cellValueFor: dataValue coord: coord [
	dataValue ifNil: [ ^ nil ].
	dataValue isDictionary ifTrue: [ 
		subNodeDict at: coord put: dataValue.
		^ '<объект>'
	].
	dataValue isArray ifTrue: [ 
		subNodeDict at: coord put: dataValue.
		^ '<массив>'
	].
	^ dataValue asString
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
	subNodeDict := Dictionary new
]

{ #category : #initialization }
DvtDataSetTablePresenter >> initializeDataGrid [
	(dataGrid := self instantiate: DataGridPresenter)
		cellTextColorBlock: [ :e |
			(#('<объект>' '<массив>') includes: e) ifTrue: [ 
				Color fromHexString: '0B4E60' 
			] ifFalse: [ 
				Color veryDarkGray
			]
		];
		whenCellDoubleClicked: [ :value :coord |
			(#('<объект>' '<массив>') includes: value) ifTrue: [ 
				(subNodeDict includesKey: coord) ifTrue: [ 
					parentStack push: node.
					self node: (subNodeDict at: coord)
				]
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
]

{ #category : #accessing }
DvtDataSetTablePresenter >> node [
	^ node
]

{ #category : #'private - accessing' }
DvtDataSetTablePresenter >> node: aNode [
	| transpose |
	
	node := aNode.
	subNodeDict removeAll.
	transpose := transposeCheckBox state.
	
	node isDictionary ifTrue: [ 
		(node allSatisfy: [ :e | e isArray ]) ifTrue: [ 
			transpose
				ifTrue: [ self applyTransposedDictOfArraysBlock ]
				ifFalse: [ self applyDictOfArraysBlock ]
		] ifFalse: [ 
			transpose
				ifTrue: [ self applyTransposedDictBlock ]
				ifFalse: [ self applyDictBlock ]
		].
		^ self
	].
	
	node isArray ifTrue: [ 
		(node allSatisfy: [ :e | e isDictionary and: [ e areKeysCompatibleWith: node first ] ]) ifTrue: [ 
			transpose
				ifTrue: [ self applyTransposedArrayOfDictsBlock ]
				ifFalse: [ self applyArrayOfDictsBlock ]
		] ifFalse: [ 
			(node allSatisfy: [ :e | e isArray ]) ifTrue: [ 
				transpose
					ifTrue: [ self applyTransposedArrayOfArraysBlock ]
					ifFalse: [ self applyArrayOfArraysBlock ]
			] ifFalse: [ 
				transpose
					ifTrue: [ self applyTransposedArrayBlock ]
					ifFalse: [ self applyArrayBlock ]
			]
		].
		^ self
	].
	
	self error: 'Node type must be either dictionary or array.'
]

{ #category : #private }
DvtDataSetTablePresenter >> onGoBackButtonAction [
	parentStack ifEmpty: [ ^ self ].
	self node: parentStack pop
]

{ #category : #private }
DvtDataSetTablePresenter >> onSelectColumnsButtonAction [
	| selectableInteraction start end range |
	selectableInteraction := dataGrid selectableInteraction.
	start := selectableInteraction selectionStart.
	end := selectableInteraction selectionEnd.
	(start isNil or: [ end isNil ]) ifTrue: [ ^ self ].
	range := (start x min: end x) @ (start x max: end x).
	selectableInteraction selectFrom: range x @ 1 to: range y @ dataGrid rowCount
]

{ #category : #private }
DvtDataSetTablePresenter >> onSelectRowsButtonAction [
	| selectableInteraction start end range |
	selectableInteraction := dataGrid selectableInteraction.
	start := selectableInteraction selectionStart.
	end := selectableInteraction selectionEnd.
	(start isNil or: [ end isNil ]) ifTrue: [ ^ self ].
	range := (start y min: end y) @ (start y max: end y).
	selectableInteraction selectFrom: 1 @ range x to: dataGrid columnCount @ range y
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
