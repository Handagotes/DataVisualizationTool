Class {
	#name : #DvtRequest,
	#superclass : #DvtEntity,
	#instVars : [
		'name',
		'dataType',
		'text'
	],
	#category : #'DataVisualizationTool-Entity'
}

{ #category : #accessing }
DvtRequest class >> default [
	^ self new
		name: '';
		text: 'http://';
		dataType: #auto;
		yourself
]

{ #category : #api }
DvtRequest class >> tableName [
	^ 'request'
]

{ #category : #accessing }
DvtRequest >> dataType [
	^ dataType
]

{ #category : #accessing }
DvtRequest >> dataType: anObject [
	dataType := anObject
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
