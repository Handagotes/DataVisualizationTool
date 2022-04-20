Class {
	#name : #DvtEntity,
	#superclass : #Object,
	#instVars : [
		'id'
	],
	#category : #'DataVisualizationTool-Entity'
}

{ #category : #api }
DvtEntity class >> tableName [
	^ self subclassResponsibility
]

{ #category : #accessing }
DvtEntity >> id [
	^ id
]

{ #category : #accessing }
DvtEntity >> id: anObject [
	id := anObject
]
