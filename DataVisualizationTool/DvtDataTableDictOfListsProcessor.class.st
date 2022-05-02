Class {
	#name : #DvtDataTableDictOfListsProcessor,
	#superclass : #DvtDataTableProcessor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #api }
DvtDataTableDictOfListsProcessor >> apply [
	| columns rows |
	
	dataTable isTransposed ifFalse: [ 
		columns := node keys size.
		rows := node ifNotEmpty: [ (node maxValue: [ :e | e size ]) + 1 ] ifEmpty: [ 1 ].
		
		dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
			key := node keys at: columnIndex ifAbsent: [ nil ].
			rowIndex = 1
				ifTrue: [ key ifNotNil: [ key asString ] ]
				ifFalse: [ { key. rowIndex - 1 } ]
		] columnCount: columns rowCount: rows
	] ifTrue: [ 
		columns := node size.
		rows := node ifNotEmpty: [ node first size ] ifEmpty: [ 0 ].
		
		dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex |
			{ columnIndex. rowIndex }
		] columnCount: columns rowCount: rows
	]
]

{ #category : #private }
DvtDataTableDictOfListsProcessor >> isCellKeyEditableAtColumn: column row: row [
	dataTable isTransposed
		ifFalse: [ ^ row = 1 and: [ ^ column <= (dataGrid columnCount + 1) ] ]
		ifTrue: [ ^ column = 1 and: [ row between: 2 and: dataGrid rowCount + 1 ]	]
]

{ #category : #private }
DvtDataTableDictOfListsProcessor >> isCellValueEditableAtColumn: column row: row [
	dataTable isTransposed
		ifFalse: [ ^ row >= 2 and: [ column <= dataGrid columnCount ] ]
		ifTrue: [ ^ column >= 2 and: [ row between: 2 and: dataGrid rowCount ] ]
]

{ #category : #api }
DvtDataTableDictOfListsProcessor >> putCellValue: newValue atColumn: column row: row [
	| keyEdit |
	keyEdit := dataTable isTransposed ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	keyEdit ifTrue: [ | oldValue |
		(node includesKey: newValue) ifTrue: [ 
			silent ifFalse: [ DvtErrorDialog open: ('Ключ "{1}" уже существует.' format: { newValue }) ].
			^ self
		].
		oldValue := dataGrid cellValueAtColumnIndex: column rowIndex: row.
		oldValue ifNil: [ | size |
			size := node anyOne size.
			node at: newValue put: (node anyOne species ofSize: size)
		] ifNotNil: [ | v |
			v := node at: oldValue.
			node removeKey: oldValue.
			node at: newValue put: v
		]
	] ifFalse: [ 
		| keys index |
		keys := dataGrid keysForCellCoord: column @ row.
		index := keys second.
		index > node anyOne size ifTrue: [ 
			node do: [ :nodeColumn |
				nodeColumn at: index growPut: nil
			]
		].
		(node at: keys first) at: index put: newValue
	]
]

{ #category : #api }
DvtDataTableDictOfListsProcessor >> removeCellValueAtColumn: column row: row [
	| keyEdit keys key |
	keys := dataGrid keysForCellCoord: column @ row.
	key := keys first.
	(node includesKey: key) ifFalse: [ ^ self ].
	keyEdit := dataTable isTransposed ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	keyEdit ifTrue: [ 
		node removeKey: key
	] ifFalse: [ | index |
		index := keys second.
		index > node anyOne size ifTrue: [ ^ self ].
		(node at: key) at: index put: nil.
		[ index > 0 and: [ node allSatisfy: [ :nodeColumn | (nodeColumn at: index) isNil ] ] ] whileTrue: [ 
			node do: [ :nodeColumn | nodeColumn removeAt: index ].
			index := index - 1
		]
	]
]
