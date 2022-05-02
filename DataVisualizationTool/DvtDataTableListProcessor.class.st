Class {
	#name : #DvtDataTableListProcessor,
	#superclass : #DvtDataTableProcessor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtDataTableListProcessor >> apply [
	| columns rows |
	
	dataTable isTransposed ifFalse: [ 
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
	] ifTrue: [ 
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
]

{ #category : #private }
DvtDataTableListProcessor >> isCellKeyEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount [
	^ false
]

{ #category : #private }
DvtDataTableListProcessor >> isCellValueEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount [
	dataTable isTransposed
		ifFalse: [ ^ row ~= 1 and: [ column = 2 ] ]
		ifTrue: [ ^ row = 2 ]
]

{ #category : #api }
DvtDataTableListProcessor >> putCellValue: newValue at: coord [
	
]

{ #category : #api }
DvtDataTableListProcessor >> removeCellValueAt: coord [
	
]
