Class {
	#name : #DvtDataSet,
	#superclass : #DvtEntity,
	#instVars : [
		'fetchDate',
		'fetchTime',
		'dataFilePath',
		'requestId'
	],
	#category : #'DataVisualizationTool-Entity'
}

{ #category : #api }
DvtDataSet class >> tableName [
	^ 'dataset'
]

{ #category : #accessing }
DvtDataSet >> dataFilePath [
	^ dataFilePath
]

{ #category : #accessing }
DvtDataSet >> dataFilePath: anObject [
	dataFilePath := anObject
]

{ #category : #accessing }
DvtDataSet >> fetchDate [
	^ fetchDate
]

{ #category : #accessing }
DvtDataSet >> fetchDate: anObject [
	fetchDate := anObject
]

{ #category : #accessing }
DvtDataSet >> fetchTime [
	^ fetchTime
]

{ #category : #accessing }
DvtDataSet >> fetchTime: anObject [
	fetchTime := anObject
]

{ #category : #accessing }
DvtDataSet >> requestId [
	^ requestId
]

{ #category : #accessing }
DvtDataSet >> requestId: anObject [
	requestId := anObject
]
