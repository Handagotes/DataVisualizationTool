Class {
	#name : #DvtVisualization,
	#superclass : #DvtEntity,
	#instVars : [
		'name',
		'script',
		'sampleId'
	],
	#category : #'DataVisualizationTool-Entity'
}

{ #category : #api }
DvtVisualization class >> tableName [
	^ 'visualization'
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

{ #category : #accessing }
DvtVisualization >> script [
	^ script
]

{ #category : #accessing }
DvtVisualization >> script: anObject [
	script := anObject
]
