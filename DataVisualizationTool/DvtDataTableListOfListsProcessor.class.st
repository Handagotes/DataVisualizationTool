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

{ #category : #private }
DvtDataTableListOfListsProcessor >> isCellKeyEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount [
	^ false
]

{ #category : #private }
DvtDataTableListOfListsProcessor >> isCellValueEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount [
	^ true
]

{ #category : #api }
DvtDataTableListOfListsProcessor >> putCellValue: newValue at: coord [
	
]

{ #category : #api }
DvtDataTableListOfListsProcessor >> removeCellValueAt: coord [
	
]
