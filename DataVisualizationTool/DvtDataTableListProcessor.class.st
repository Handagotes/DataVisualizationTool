Class {
	#name : #DvtDataTableListProcessor,
	#superclass : #DvtDataTableProcessor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #api }
DvtDataTableListProcessor >> apply [
	dataTable isTransposed ifFalse: [ 
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
		] cellCountBlock: [ 2 @ (node size + 1) ]
	] ifTrue: [ 
		dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex |
			rowIndex = 1 ifTrue: [ 
				columnIndex asString
			] ifFalse: [ 
				rowIndex = 2
					ifTrue: [ { columnIndex } ]
					ifFalse: [ nil ]
			]
		] cellCountBlock: [ node size @ 2 ]
	]
]

{ #category : #private }
DvtDataTableListProcessor >> isCellKeyEditableAtColumn: column row: row [
	^ false
]

{ #category : #private }
DvtDataTableListProcessor >> isCellValueEditableAtColumn: column row: row [
	dataTable isTransposed
		ifFalse: [ ^ row = 2 ]
		ifTrue: [ ^ row ~= 1 and: [ column = 2 ] ]
]

{ #category : #api }
DvtDataTableListProcessor >> putCellValue: newValue atColumn: column row: row [
	dataTable isTransposed
		ifFalse: [ node at: row - 1 growPut: newValue ]
		ifTrue: [ node at: column growPut: newValue ]
]

{ #category : #api }
DvtDataTableListProcessor >> removeCellValueAtColumn: column row: row [
	dataTable isTransposed ifFalse: [ 
		node size < (row - 1) ifTrue: [ ^ self ].
		node removeAt: row - 1
	] ifTrue: [ 
		node size < column ifTrue: [ ^ self ].
		node removeAt: column
	].
	dataGrid updateCellCount
]
