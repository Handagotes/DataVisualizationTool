Class {
	#name : #DvtDataTableListOfListsProcessor,
	#superclass : #DvtDataTableProcessor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtDataTableListOfListsProcessor >> apply [
	| columns rows |
	
	dataTable isTransposed ifFalse: [ 
		columns := node ifNotEmpty: [ node first size ] ifEmpty: [ 0 ].
		rows := node size.
		
		dataGrid data: node cellKeysBlock: [ :columnIndex :rowIndex |
			{ rowIndex. columnIndex }
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
DvtDataTableListOfListsProcessor >> putCellValue: newValue at: coord [
	
]

{ #category : #api }
DvtDataTableListOfListsProcessor >> removeCellValueAt: coord [
	
]
