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
		'processor',
		'parentStack',
		'allowCellEdit',
		'cellEditedBlock'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #api }
DvtDataTablePresenter class >> cellTextColorForValue: value [
	value isString ifTrue: [ ^ DvtApp colorForStringValue ].
	value isNumber ifTrue: [ ^ DvtApp colorForNumberValue ].
	value isLiteral ifTrue: [ ^ DvtApp colorForLiteralValue ].
	(DvtDataTableProcessor isNode: value) ifTrue: [ ^ DvtApp colorForNodeValue ].
	^ Color veryDarkGray
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

{ #category : #accessing }
DvtDataTablePresenter >> allowCellEdit [
	^ allowCellEdit
]

{ #category : #accessing }
DvtDataTablePresenter >> allowCellEdit: aBoolean [
	allowCellEdit := aBoolean
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
	newValue := DvtDataTableProcessor detectValueStringTypeAndConvert: newValue.
	
	self
		editCellAt: coord value: value newValue: newValue silent: false;
		updateNode.
	
	cellEditedBlock ifNotNil: [ 
		cellEditedBlock cull: newValue cull: value
	]
]

{ #category : #api }
DvtDataTablePresenter >> editCellAt: coord value: value newValue: newValue silent: silent [
	(allowCellEdit and: [ self isCellEditable: coord ]) ifFalse: [ ^ self ].
	processor ifNil: [ ^ self ].
	newValue = value ifTrue: [ ^ self ].
	processor
		silent: silent;
		putCellValue: newValue at: coord.
	
	self updateNode
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
	allowCellEdit := false.
]

{ #category : #initialization }
DvtDataTablePresenter >> initializeDataGrid [
	(dataGrid := self instantiate: DataGridPresenter)
		cellDisplayBlock: [ :value |
			value ifNil: [ '' ] ifNotNil: [ 
				(DvtDataTableProcessor isNode: value)
					ifTrue: [ value isDictionary ifTrue: [ '<словарь>' ] ifFalse: [ '<список>' ] ]
					ifFalse: [ value asString ]
			]
		];
		cellTextColorBlock: [ :s :coord | | value |
			value := dataGrid cellValueAt: coord.
			self class cellTextColorForValue: value
		];
		whenCellDoubleClicked: [ :value :coord |
			(DvtDataTableProcessor isNode: value) ifTrue: [ 
				parentStack push: node.
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
	processor ifNil: [ ^ false ].
	^ processor isCellEditable: coord
]

{ #category : #testing }
DvtDataTablePresenter >> isCellKeyEditable: coord [
	processor ifNil: [ ^ false ].
	^ processor isCellKeyEditable: coord
]

{ #category : #testing }
DvtDataTablePresenter >> isCellValueEditable: coord [
	processor ifNil: [ ^ false ].
	^ processor isCellValueEditable: coord
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
	node := aNode.
	
	node ifNil: [ 
		dataGrid reset.
		^ self
	].
	
	node isDictionary ifTrue: [ 
		processor := (node size > 1 and: [ node allSatisfy: [ :e | e isArray and: [ e size = node anyOne size ] ] ])
			ifTrue: [ DvtDataTableDictOfListsProcessor forDataTable: self ]
			ifFalse: [ DvtDataTableDictProcessor forDataTable: self ].
		^ self
	].
	
	(node isKindOf: OrderedCollection) ifTrue: [ 
		processor := (node size > 1 and: [ node allSatisfy: [ :e | e isDictionary and: [ e areKeysCompatibleWith: node first ] ] ])
			ifTrue: [ DvtDataTableListOfDictsProcessor forDataTable: self ]
			ifFalse: [ 
				(node size > 1 and: [ node allSatisfy: [ :e | e isKindOf: OrderedCollection ] ])
					ifTrue: [ DvtDataTableListOfListsProcessor forDataTable: self ]
					ifFalse: [ DvtDataTableListProcessor forDataTable: self ]
			].
		^ self
	].
	
	self error: 'Node type must be either dictionary or ordered collection.'
]

{ #category : #private }
DvtDataTablePresenter >> onGoBackButtonAction [
	parentStack ifEmpty: [ ^ self ].
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
	self editCellAt: coord value: (dataGrid cellValueAt: coord) newValue: newValue silent: true
]

{ #category : #removing }
DvtDataTablePresenter >> removeCellValueAt: coord [
	processor ifNil: [ ^ self ].
	(processor isCellEditable: coord) ifFalse: [ ^ self ].
	processor removeCellValueAt: coord
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

{ #category : #api }
DvtDataTablePresenter >> tryConvertCellValue: value at: coord toType: type [
	processor ifNil: [ ^ false ].
	^ processor tryConvertCellValue: value at: coord toType: type
]

{ #category : #accessing }
DvtDataTablePresenter >> tryConvertCellValueAt: coord toType: type [
	processor ifNil: [ ^ false ].
	^ processor tryConvertCellValueAt: coord toType: type
]

{ #category : #updating }
DvtDataTablePresenter >> updateNode [
	self node: node
]

{ #category : #enumerating }
DvtDataTablePresenter >> whenCellEditedDo: aBlock [
	cellEditedBlock := aBlock
]
