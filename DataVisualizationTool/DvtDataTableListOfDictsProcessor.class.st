Class {
	#name : #DvtDataTableListOfDictsProcessor,
	#superclass : #DvtDataTableProcessor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtDataTableListOfDictsProcessor >> apply [
	| columns rows |
	
	dataTable isTransposed ifFalse: [ 
		columns := node ifNotEmpty: [ node first keys size ] ifEmpty: [ 0 ].
		rows := node size + 1.
		
		dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex | | key |
			key := node first keys at: columnIndex ifAbsent: [ nil ].
			rowIndex = 1
				ifTrue: [ key ifNotNil: [ key asString ] ]
				ifFalse: [ { rowIndex - 1. key } ]
		] columnCount: columns rowCount: rows
	] ifTrue: [ 
		columns := node size + 1.
		rows := node ifNotEmpty: [ node first keys size + 1 ] ifEmpty: [ 1 ].
		
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
		] columnCount: columns rowCount: rows
	]
]

{ #category : #api }
DvtDataTableListOfDictsProcessor >> putCellValue: newValue at: coord [
	
]

{ #category : #api }
DvtDataTableListOfDictsProcessor >> removeCellValueAt: coord [
	
]
