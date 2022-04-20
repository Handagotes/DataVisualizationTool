Class {
	#name : #DvtRequest,
	#superclass : #DvtEntity,
	#instVars : [
		'name',
		'text'
	],
	#category : #'DataVisualizationTool-Entity'
}

{ #category : #api }
DvtRequest class >> tableName [
	^ 'request'
]

{ #category : #accessing }
DvtRequest >> name [
	^ name
]

{ #category : #accessing }
DvtRequest >> name: anObject [
	name := anObject
]

{ #category : #accessing }
DvtRequest >> text [
	^ text
]

{ #category : #accessing }
DvtRequest >> text: anObject [
	text := anObject
]
