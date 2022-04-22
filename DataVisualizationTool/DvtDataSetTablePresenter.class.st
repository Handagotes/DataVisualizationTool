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
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayOfArraysBlock [
	| columns rows |
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyArrayOfDictsBlock [
	| columns rows |
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyDictBlock [
	| columns rows |
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyDictOfArraysBlock [
	| columns rows |
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayBlock [
	| columns rows |
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayOfArraysBlock [
	| columns rows |
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedArrayOfDictsBlock [
	| columns rows |
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedDictBlock [
	| columns rows |
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
	] columnCount: columns rowCount: rows
]

{ #category : #private }
DvtDataSetTablePresenter >> applyTransposedDictOfArraysBlock [
	| columns rows |
	
	columns := 0.
	rows := 0.
	
	dataGrid cellValueBlock: [ :column :columnIndex :rowIndex | |  |
		
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
	
	
	"transposeCheckBox state ifFalse: [ 
		data isDictionary ifTrue: [ 
			columns := data size.
			rows := (data allSatisfy: [ :e | e isArray ])
				ifTrue: [ data maxValue: [ :e | e size ] ]
				ifFalse: [ 2 ]
		] ifFalse: [ 
			(data allSatisfy: [ :e | e isDictionary and: [ data first areKeysCompatibleWith: e ] ]) ifTrue: [ 
				columns := data first keys size.
				rows := data size
			] ifFalse: [ 
				columns := 2.
				rows := data size + 1
			]
		]
	] ifTrue: [ 
		data isDictionary ifTrue: [ 
			rows := data keys size + 1.
			columns := (data allSatisfy: [ :e | e isArray ])
				ifTrue: [ (data maxValue: [ :e | e size ]) + 1 ]
				ifFalse: [ 2 ]
		] ifFalse: [ 
			(data allSatisfy: [ :e | e isDictionary and: [ data first areKeysCompatibleWith: e ] ]) ifTrue: [ 
				columns := data size + 1.
				rows := data first keys size + 1
			] ifFalse: [ 
				columns := data size.
				rows := 2
			]
		]
	]."
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
	
]

{ #category : #accessing }
DvtDataSetTablePresenter >> transposeCheckBox [
	^ transposeCheckBox
]
