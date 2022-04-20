Class {
	#name : #DvtRequest,
	#superclass : #DvtEntity,
	#instVars : [
		'name',
		'text'
	],
	#category : #'DataVisualizationTool-Entity'
}

{ #category : #accessing }
DvtRequest class >> default [
	^ self new
		name: '';
		text: 'http://';
		yourself
]

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
