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

{ #category : #api }
DvtDataTableDictOfListsProcessor >> putCellValue: newValue at: coord [
	
]

{ #category : #api }
DvtDataTableDictOfListsProcessor >> removeCellValueAt: coord [
	
]
