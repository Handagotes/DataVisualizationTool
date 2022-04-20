Class {
	#name : #DvtHeaderField,
	#superclass : #DvtEntity,
	#instVars : [
		'header',
		'field',
		'order',
		'requestId'
	],
	#category : #'DataVisualizationTool-Entity'
}

{ #category : #api }
DvtHeaderField class >> tableName [
	^ 'header_field'
]

{ #category : #accessing }
DvtHeaderField >> field [
	^ field
]

{ #category : #accessing }
DvtHeaderField >> field: anObject [
	field := anObject
]

{ #category : #accessing }
DvtHeaderField >> header [
	^ header
]

{ #category : #accessing }
DvtHeaderField >> header: anObject [
	header := anObject
]

{ #category : #accessing }
DvtHeaderField >> order [
	^ order
]

{ #category : #accessing }
DvtHeaderField >> order: anObject [
	order := anObject
]

{ #category : #accessing }
DvtHeaderField >> requestId [
	^ requestId
]

{ #category : #accessing }
DvtHeaderField >> requestId: anObject [
	requestId := anObject
]
