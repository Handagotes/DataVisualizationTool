Class {
	#name : #DvtVisualization,
	#superclass : #DvtEntity,
	#instVars : [
		'name',
		'configFilePath',
		'sampleId'
	],
	#category : #'DataVisualizationTool-Entity'
}

{ #category : #api }
DvtVisualization class >> tableName [
	^ 'visualization'
]

{ #category : #accessing }
DvtVisualization >> configFilePath [
	^ configFilePath
]

{ #category : #accessing }
DvtVisualization >> configFilePath: anObject [
	configFilePath := anObject
]

{ #category : #accessing }
DvtVisualization >> name [
	^ name
]

{ #category : #accessing }
DvtVisualization >> name: anObject [
	name := anObject
]

{ #category : #accessing }
DvtVisualization >> sampleId [
	^ sampleId
]

{ #category : #accessing }
DvtVisualization >> sampleId: anObject [
	sampleId := anObject
]
