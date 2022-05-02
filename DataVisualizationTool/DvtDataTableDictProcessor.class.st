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

{ #category : #api }
DvtDataTableDictProcessor >> putCellValue: newValue at: coord [
	
]

{ #category : #api }
DvtDataTableDictProcessor >> removeCellValueAt: coord [
	
]
