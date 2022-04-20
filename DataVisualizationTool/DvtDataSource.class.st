Class {
	#name : #DvtDataSource,
	#superclass : #FTSimpleDataSource,
	#category : #'DataVisualizationTool-Util'
}

{ #category : #adding }
DvtDataSource >> addColumnsTo: aTable [
	self subclassResponsibility
]

{ #category : #accessing }
DvtDataSource >> cellColumn: column row: rowIndex [
	self subclassResponsibility
]
