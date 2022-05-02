Class {
	#name : #DvtDataTableDictOfListsProcessor,
	#superclass : #DvtDataTableProcessor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
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
	
]

{ #category : #api }
DvtDataTableDictOfListsProcessor >> removeCellValueAtColumn: column row: row [
	
]
