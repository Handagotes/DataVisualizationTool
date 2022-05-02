Class {
	#name : #DvtDataTableDictProcessor,
	#superclass : #DvtDataTableProcessor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #api }
DvtDataTableDictProcessor >> apply [
	dataTable isTransposed ifFalse: [ 
		dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
			key := node keys at: columnIndex ifAbsent: [ nil ].
			rowIndex = 1
				ifTrue: [ key ifNotNil: [ key asString ] ]
				ifFalse: [ rowIndex = 2 ifTrue: [ { key } ] ifFalse: [ nil ] ]
		] cellCountBlock: [ node keys size @ 2 ]
	] ifTrue: [ 
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
		] cellCountBlock: [ 2 @ (node size + 1) ]
	]
	
]

{ #category : #private }
DvtDataTableDictProcessor >> isCellKeyEditableAtColumn: column row: row [
	dataTable isTransposed
		ifFalse: [ ^ row = 1 and: [ ^ column <= (dataGrid columnCount + 1) ] ]
		ifTrue: [ ^ column = 1 and: [ row between: 2 and: dataGrid rowCount + 1 ]	]
]

{ #category : #private }
DvtDataTableDictProcessor >> isCellValueEditableAtColumn: column row: row [
	dataTable isTransposed
		ifFalse: [ ^ row = 2 and: [ column <= dataGrid columnCount ] ]
		ifTrue: [ ^ column = 2 and: [ row between: 2 and: dataGrid rowCount ] ]
]

{ #category : #api }
DvtDataTableDictProcessor >> putCellValue: newValue atColumn: column row: row [
	| keyEdit |
	keyEdit := dataTable isTransposed ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	keyEdit ifTrue: [ | oldValue |
		(node includesKey: newValue) ifTrue: [ 
			silent ifFalse: [ DvtErrorDialog open: ('Ключ "{1}" уже существует.' format: { newValue }) ].
			^ self
		].
		oldValue := dataGrid cellValueAtColumnIndex: column rowIndex: row.
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

{ #category : #api }
DvtDataTableDictProcessor >> removeCellValueAtColumn: column row: row [
	| keyEdit |
	keyEdit := dataTable isTransposed ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	keyEdit
		ifTrue: [ | key |
			key := dataGrid cellValueAt: column @ row.
			node removeKey: key ifAbsent: [  ]
		]
		ifFalse: [ | key |
			key := (dataGrid keysForCellCoord: column @ row) first.
			node at: key put: nil
		].
	dataGrid updateCellCount
]
