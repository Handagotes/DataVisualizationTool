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

{ #category : #api }
DvtDataTableProcessor class >> forDataTable: dataTable [
	^ self new
		dataTable: dataTable
		yourself
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

{ #category : #api }
DvtDataTableProcessor >> putCellValue: newValue at: coord [
	self subclassResponsibility
]

{ #category : #api }
DvtDataTableProcessor >> removeCellValueAt: coord [
	self subclassResponsibility
]
