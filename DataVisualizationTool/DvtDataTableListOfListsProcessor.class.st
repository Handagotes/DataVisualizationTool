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
DvtDataTableListOfListsProcessor >> isCellKeyEditableAtColumn: column row: row [
	^ false
]

{ #category : #private }
DvtDataTableListOfListsProcessor >> isCellValueEditableAtColumn: column row: row [
	^ true
]

{ #category : #api }
DvtDataTableListOfListsProcessor >> putCellValue: newValue atColumn: c row: r [
	| column row columnCount rowCount |
	column := c.
	row := r.
	columnCount := dataGrid columnCount.
	rowCount := dataGrid rowCount.
	
	dataTable isTransposed ifTrue: [ 
		column := r.
		row := c
	].
	
	column > columnCount ifTrue: [ 
		columnCount := column
		node do: [ :nodeRow |
			nodeRow at: columnCount growPut: nil
		]
	].
	
	row > rowCount ifTrue: [ 
		node at: row growPut: nil.
		rowCount + 1 to: row do: [ :i |
			node at: i put: (node species ofSize: columnCount)
		].
		rowCount := row.
	].
	
	(node at: row) at: column put: newValue
]

{ #category : #api }
DvtDataTableListOfListsProcessor >> removeCellValueAtColumn: c row: r [
	| column row columnCount rowCount |
	column := c.
	row := r.
	columnCount := dataGrid columnCount.
	rowCount := dataGrid rowCount.
	
	dataTable isTransposed ifTrue: [ 
		column := r.
		row := c
	].
	
	(node size < row or: [ node first size < column ]) ifTrue: [ ^ self ].
	(node at: row) at: column put: nil.
	
	"trim rows"
	[ rowCount > 0 and: [ (node at: rowCount) allSatisfy: [ :e | e isNil ] ] ] whileTrue: [ 
		node removeAt: rowCount.
		rowCount := rowCount - 1
	].
	
	"trim columns"
	[ columnCount > 0 and: [ node allSatisfy: [ :nodeRow | (nodeRow at: columnCount) isNil ] ] ] whileTrue: [ 
		node do: [ :nodeRow | nodeRow removeAt: columnCount ].
		columnCount := columnCount - 1
	]
]
