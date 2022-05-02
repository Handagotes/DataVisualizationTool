Class {
	#name : #DvtDataTableDictProcessor,
	#superclass : #DvtDataTableProcessor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtDataTableDictProcessor >> apply [
	| columns rows |
	
	dataTable isTransposed ifFalse: [ 
		columns := node keys size.
		rows := 2.
		
		dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
			key := node keys at: columnIndex ifAbsent: [ nil ].
			rowIndex = 1
				ifTrue: [ key ifNotNil: [ key asString ] ]
				ifFalse: [ rowIndex = 2 ifTrue: [ { key } ] ifFalse: [ nil ] ]
		] columnCount: columns rowCount: rows
	] ifTrue: [ 
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
	
]

{ #category : #private }
DvtDataTableDictProcessor >> isCellKeyEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount [
	dataTable isTransposed
		ifFalse: [ ^ row = 1 and: [ ^ column <= (columnCount + 1) ] ]
		ifTrue: [ ^ column = 1 and: [ row between: 2 and: rowCount + 1 ]	]
]

{ #category : #private }
DvtDataTableDictProcessor >> isCellValueEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount [
	dataTable isTransposed
		ifFalse: [ ^ row = 2 and: [ column <= columnCount ] ]
		ifTrue: [ ^ column = 2 and: [ row between: 2 and: rowCount ] ]
]

{ #category : #api }
DvtDataTableDictProcessor >> putCellValue: newValue at: coord [
	
]

{ #category : #api }
DvtDataTableDictProcessor >> removeCellValueAt: coord [
	
]
