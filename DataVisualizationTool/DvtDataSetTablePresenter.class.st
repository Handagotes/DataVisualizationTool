Class {
	#name : #DvtDataSetTablePresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'dataGrid',
		'goBackButton',
		'transposeCheckBox',
		'data'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtDataSetTablePresenter class >> cellValueFor: dataValue [
	dataValue ifNil: [ ^ nil ].
	dataValue isDictionary ifTrue: [ ^ '<объект>' ].
	dataValue isArray ifTrue: [ ^ '<массив>' ].
	^ dataValue asString
]

{ #category : #specs }
DvtDataSetTablePresenter class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #dataGrid;
			newRow: [ :row |
				row
					add: #goBackButton;
					add: #transposeCheckBox
			] height: self toolbarHeight
	]
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayBlock [
	| columns rows |
	
	columns := 2.
	rows := data size + 1.
	
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
						ifTrue: [ self class cellValueFor: (data at: rowIndex - 1 ifAbsent: [ nil ]) ]
						ifFalse: [ nil ]
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayOfArraysBlock [
	| columns rows |
	
	columns := data ifNotEmpty: [ data first size ] ifEmpty: [ 0 ].
	rows := data size.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | | row |
		(row := data at: rowIndex ifAbsent: [ nil ])
			ifNil: [ nil ]
			ifNotNil: [ self class cellValueFor: (row at: columnIndex ifAbsent: [ nil ]) ]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayOfDictsBlock [
	| columns rows |
	
	columns := data ifNotEmpty: [ data first keys size ] ifEmpty: [ 0 ].
	rows := data size + 1.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			data
				ifEmpty: [ nil ]
				ifNotEmpty: [ data first keys at: columnIndex ]
		] ifFalse: [ | dict |
			(dict := data at: rowIndex - 1 ifAbsent: [ nil ])
				ifNil: [ nil ]
				ifNotNil: [ 
					self class cellValueFor: (dict at: column ifAbsent: [ nil ])
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyDictBlock [
	| columns rows |
	
	columns := data keys size.
	rows := 2.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			data keys at: columnIndex
		] ifFalse: [ 
			self class cellValueFor: (data at: column)
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyDictOfArraysBlock [
	| columns rows |
	
	columns := data keys size.
	rows := data ifNotEmpty: [ (data maxValue: [ :e | e size ]) + 1 ] ifEmpty: [ 1 ].
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			data keys at: columnIndex
		] ifFalse: [ | array |
			array := data at: column.
			self class cellValueFor: (array at: rowIndex - 1 ifAbsent: [ nil ])
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayBlock [
	| columns rows |
	
	columns := data size.
	rows := 2.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			columnIndex
		] ifFalse: [ 
			self class cellValueFor: (data at: columnIndex ifAbsent: [ nil ])
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayOfArraysBlock [
	| columns rows |
	
	columns := data size.
	rows := data ifNotEmpty: [ data first size ] ifEmpty: [ 0 ].
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | | row |
		(row := data at: columnIndex ifAbsent: [ nil ])
			ifNil: [ nil ]
			ifNotNil: [ self class cellValueFor: (row at: rowIndex ifAbsent: [ nil ]) ]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayOfDictsBlock [
	| columns rows |
	
	columns := data size + 1.
	rows := data ifNotEmpty: [ data first keys size + 1 ] ifEmpty: [ 1 ].
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Ключ' ]
				ifFalse: [ columnIndex - 1 ]
		] ifFalse: [ 
			columnIndex = 1
				ifTrue: [ 
					data
						ifEmpty: [ nil ]
						ifNotEmpty: [ self class cellValueFor: (data first keys at: rowIndex - 1) ]
				]
				ifFalse: [ | dict |
					(dict := data at: columnIndex - 1 ifAbsent: [ nil ])
						ifNil: [ nil ]
						ifNotNil: [ | key |
							key := dataGrid cellValueAt: 1 @ rowIndex.
							self class cellValueFor: (dict at: key)
						]
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedDictBlock [
	| columns rows |
	
	columns := 2.
	rows := data size + 1.
	
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
				ifTrue: [ data keys at: rowIndex - 1 ]
				ifFalse: [ | key |
					key := dataGrid cellValueAt: 1 @ rowIndex.
					self class cellValueFor: (data at: key)
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedDictOfArraysBlock [
	| columns rows |
	
	columns := data ifNotEmpty: [ (data maxValue: [ :e | e size ]) + 1 ] ifEmpty: [ 1 ].
	rows := data size + 1.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		rowIndex = 1 ifTrue: [ 
			columnIndex = 1
				ifTrue: [ 'Ключ' ]
				ifFalse: [ columnIndex - 1 ]
		] ifFalse: [ 
			columnIndex = 1
				ifTrue: [ data keys at: rowIndex - 1	]
				ifFalse: [ | key array |
					key := dataGrid cellValueAt: 1 @ rowIndex.
					array := data at: key.
					self class cellValueFor: (array at: columnIndex - 1 ifAbsent: [ nil ])
				]
		]
	] columnCount: columns rowCount: rows
]

{ #category : #accessing }
DvtDataSetTablePresenter >> data [
	^ data
]

{ #category : #accessing }
DvtDataSetTablePresenter >> data: aCollectionOfCollections [
	| transpose |
	data := aCollectionOfCollections.
	transpose := transposeCheckBox state.
	
	data isDictionary ifTrue: [ 
		(data allSatisfy: [ :e | e isArray ]) ifTrue: [ 
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
	
	data isArray ifTrue: [ 
		(data allSatisfy: [ :e | e isDictionary and: [ e areKeysCompatibleWith: data first ] ]) ifTrue: [ 
			transpose
				ifTrue: [ self applyTransposedArrayOfDictsBlock ]
				ifFalse: [ self applyArrayOfDictsBlock ]
		] ifFalse: [ 
			(data allSatisfy: [ :e | e isArray ]) ifTrue: [ 
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
	
	self error: 'Data type must be either dictionary or array.'
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
DvtDataSetTablePresenter >> initializeDataGrid [
	dataGrid := self instantiate: DataGridPresenter
]

{ #category : #initialization }
DvtDataSetTablePresenter >> initializePresenter [
	goBackButton action: [ 
		self onGoBackButtonAction
	].
	transposeCheckBox whenChangedDo: [ 
		self onTransposeCheckBoxStateChanged
	].
	
]

{ #category : #initialization }
DvtDataSetTablePresenter >> initializeWidgets [
	self initializeDataGrid.
	goBackButton := self newButton.
	transposeCheckBox := self newCheckBox.
	
	goBackButton label: 'Назад'.
	transposeCheckBox label: 'Транспонировать'.
]

{ #category : #private }
DvtDataSetTablePresenter >> onGoBackButtonAction [
	
]

{ #category : #private }
DvtDataSetTablePresenter >> onTransposeCheckBoxStateChanged [
	self updateData
]

{ #category : #accessing }
DvtDataSetTablePresenter >> transposeCheckBox [
	^ transposeCheckBox
]

{ #category : #updating }
DvtDataSetTablePresenter >> updateData [
	self data: data
]
