Class {
	#name : #DvtSample,
	#superclass : #DvtEntity,
	#instVars : [
		'name',
		'sample_file_path'
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
DvtSample >> sample_file_path [
	^ sample_file_path
]

{ #category : #accessing }
DvtSample >> sample_file_path: anObject [
	sample_file_path := anObject
]
