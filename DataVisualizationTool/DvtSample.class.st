Class {
	#name : #DvtSample,
	#superclass : #DvtEntity,
	#instVars : [
		'name',
		'sampleFilePath'
	],
	#category : #'DataVisualizationTool-Entity'
}

{ #category : #api }
DvtSample class >> tableName [
	^ 'sample'
]

{ #category : #accessing }
DvtSample >> name [
	^ name
]

{ #category : #accessing }
DvtSample >> name: anObject [
	name := anObject
]

{ #category : #accessing }
DvtSample >> sampleFilePath [
	^ sampleFilePath
]

{ #category : #accessing }
DvtSample >> sampleFilePath: anObject [
	sampleFilePath := anObject
]
