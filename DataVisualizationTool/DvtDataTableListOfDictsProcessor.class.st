Class {
	#name : #DvtDataTableListOfDictsProcessor,
	#superclass : #DvtDataTableProcessor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #api }
DvtDataTableListOfDictsProcessor >> apply [
	dataTable isTransposed ifFalse: [ 
		dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
			key := node first keys at: columnIndex ifAbsent: [ nil ].
			rowIndex = 1
				ifTrue: [ key ifNotNil: [ key asString ] ]
				ifFalse: [ { rowIndex - 1. key } ]
		] cellCountBlock: [ | columns rows |
			columns := node ifNotEmpty: [ node first keys size ] ifEmpty: [ 0 ].
			rows := node size + 1.
			columns @ rows
		]
	] ifTrue: [ 
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
		] cellCountBlock: [ | columns rows |
			columns := node size + 1.
			rows := node ifNotEmpty: [ node first keys size + 1 ] ifEmpty: [ 1 ].
			columns @ rows
		]
	]
]

{ #category : #private }
DvtDataTableListOfDictsProcessor >> isCellKeyEditableAtColumn: column row: row [
	dataTable isTransposed
		ifFalse: [ ^ row = 1 and: [ ^ column <= (dataGrid columnCount + 1) ] ]
		ifTrue: [ ^ column = 1 and: [ row between: 2 and: dataGrid rowCount + 1 ]	]
]

{ #category : #private }
DvtDataTableListOfDictsProcessor >> isCellValueEditableAtColumn: column row: row [
	dataTable isTransposed
		ifFalse: [ ^ row >= 2 and: [ column <= dataGrid columnCount ] ]
		ifTrue: [ ^ column >= 2 and: [ row between: 2 and: dataGrid rowCount ] ]
]

{ #category : #api }
DvtDataTableListOfDictsProcessor >> putCellValue: newValue atColumn: column row: row [
	| keyEdit |
	keyEdit := dataTable isTransposed ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	keyEdit ifTrue: [ | oldValue |
		(node first includesKey: newValue) ifTrue: [ 
			silent ifFalse: [ DvtErrorDialog open: ('Ключ "{1}" уже существует.' format: { newValue }) ].
			^ self
		].
		oldValue := dataGrid cellValueAtColumnIndex: column rowIndex: row.
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
	] ifFalse: [ | keys index |
		keys := dataGrid keysForCellCoord: column @ row.
		index := keys first.
		index > node size ifTrue: [ 
			node size + 1 to: index do: [ :i | | dict |
				dict := Dictionary new.
				node first keysDo: [ :key |
					dict add: key -> nil
				].
				node at: i growPut: dict
			]
		].
		(node at: index) at: keys second put: newValue
	]
]

{ #category : #api }
DvtDataTableListOfDictsProcessor >> removeCellValueAtColumn: column row: row [
	| keyEdit |
	keyEdit := dataTable isTransposed ifFalse: [ row = 1 ] ifTrue: [ column = 1 ].
	keyEdit ifTrue: [ | key |
		key := dataGrid cellValueAt: column @ row.
		(node first includesKey: key) ifFalse: [ ^ self ].
		node do: [ :dict |
			dict removeKey: key
		]
	] ifFalse: [ | keys key index |
		keys := dataGrid keysForCellCoord: column @ row.
		index := keys first.
		key := keys second.
		index > node size ifTrue: [ ^ self ].
		(node at: index) at: key put: nil.
		"trim rows, leave at least two"
		[ node size > 2 and: [ index > 0 and: [ (node at: index) allSatisfy: [ :e | e isNil ] ] ] ] whileTrue: [ 
			node removeAt: index.
			index := index - 1
		]
	].
	dataGrid updateCellCount
]
