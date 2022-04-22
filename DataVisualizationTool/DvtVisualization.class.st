Class {
	#name : #DvtVisualization,
	#superclass : #DvtEntity,
	#instVars : [
		'name',
		'script',
		'sample_id'
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
DvtVisualization >> sample_id [
	^ sample_id
]

{ #category : #accessing }
DvtVisualization >> sample_id: anObject [
	sample_id := anObject
]

{ #category : #accessing }
DvtVisualization >> script [
	^ script
]

{ #category : #accessing }
DvtVisualization >> script: anObject [
	script := anObject
]
