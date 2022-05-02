Class {
	#name : #DvtDataTableProcessor,
	#superclass : #Object,
	#instVars : [
		'dataTable',
		'dataGrid',
		'node'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #testing }
DvtDataTableProcessor class >> canValue: value beConvertedToType: type [
	type = #string ifTrue: [ ^ true ].
	type = #number ifTrue: [ ^ value isNumber or: [ value isString and: [ NumberParser isNumber: value ] ] ].
	type = #literal ifTrue: [ ^ #(true false nil #true #false #nil #null) includes: value ].
	^ false
]

{ #category : #api }
DvtDataTableProcessor class >> convertValue: value toType: type [
	value isString ifTrue: [ ^ self convertValueString: value toType: type ].
	type = #string ifTrue: [ ^ value asString ].
	type = #number ifTrue: [ ^ value asNumber ].
	type = #literal ifTrue: [ ^ Object readFromString: value ].
	^ nil
]

{ #category : #api }
DvtDataTableProcessor class >> convertValueString: aString toType: type [
	type = #string ifTrue: [ ^ aString ].
	type = #number ifTrue: [ ^ aString asNumber ].
	type = #literal ifTrue: [ ^ Object readFromString: aString ].
	^ nil
]

{ #category : #api }
DvtDataTableProcessor class >> detectValueStringTypeAndConvert: aString [
	^ self convertValueString: aString toType: (self resolveTypeForValueString: aString)
]

{ #category : #'instance creation' }
DvtDataTableProcessor class >> forDataTable: aDvtDataTablePresenter [
	^ self new
		dataTable: aDvtDataTablePresenter
		yourself
]

{ #category : #testing }
DvtDataTableProcessor class >> isNode: anObject [
	^ anObject isDictionary or: [ anObject isKindOf: OrderedCollection ]
]

{ #category : #api }
DvtDataTableProcessor class >> resolveTypeForValueString: aString [
	(NumberParser isNumber: aString) ifTrue: [ ^ #number ].
	(#(#true #false #nil #null) includes: aString) ifTrue: [ ^ #literal ].
	^ #string
]

{ #category : #private }
DvtDataTableProcessor >> apply [
	self subclassResponsibility
]

{ #category : #accessing }
DvtDataTableProcessor >> dataTable [
	^ dataTable
]

{ #category : #accessing }
DvtDataTableProcessor >> dataTable: aDvtDataTablePresenter [
	dataTable := aDvtDataTablePresenter.
	dataGrid := dataTable dataGrid.
	node := dataTable node.
	self apply
]

{ #category : #testing }
DvtDataTableProcessor >> isCellEditable: coord [
	^ (self isCellValueEditable: coord) or: [ self isCellKeyEditable: coord ]
]

{ #category : #testing }
DvtDataTableProcessor >> isCellKeyEditable: coord [
	| column row columnCount rowCount |
	column := coord x.
	row := coord y.
	(column <= 0 or: [ row <= 0 ]) ifTrue: [ ^ false ].
	columnCount := dataGrid columnCount.
	rowCount := dataGrid rowCount.
	^ self isCellKeyEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount
]

{ #category : #private }
DvtDataTableProcessor >> isCellKeyEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount [
	self subclassResponsibility
]

{ #category : #testing }
DvtDataTableProcessor >> isCellValueEditable: coord [
	| column row columnCount rowCount |
	column := coord x.
	row := coord y.
	(column <= 0 or: [ row <= 0 ]) ifTrue: [ ^ false ].
	columnCount := dataGrid columnCount.
	rowCount := dataGrid rowCount.
	^ self isCellValueEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount
]

{ #category : #private }
DvtDataTableProcessor >> isCellValueEditableAtColumn: column row: row columnCount: columnCount rowCount: rowCount [
	self subclassResponsibility
]

{ #category : #api }
DvtDataTableProcessor >> putCellValue: newValue at: coord [
	self subclassResponsibility
]

{ #category : #api }
DvtDataTableProcessor >> removeCellValueAt: coord [
	self subclassResponsibility
]

{ #category : #api }
DvtDataTableProcessor >> tryConvertCellValue: value at: coord toType: type [
	| newValue |
	(self class canValue: value beConvertedToType: type) ifFalse: [ ^ false ].
	newValue := self class convertValue: value toType: type.
	self putCellValue: newValue at: coord.
	^ true
]

{ #category : #api }
DvtDataTableProcessor >> tryConvertCellValueAt: coord toType: type [
	^ self tryConvertCellValue: (dataGrid cellValueAt: coord) at: coord toType: type
]
