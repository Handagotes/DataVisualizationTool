Class {
	#name : #DvtVisualizationEditor,
	#superclass : #ComposablePresenter,
	#instVars : [
		'visualization',
		'sampleFilePath',
		'sampleData',
		'config'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #accessing }
DvtVisualizationEditor >> config [
	^ config
]

{ #category : #accessing }
DvtVisualizationEditor >> config: aString [
	config := aString
]

{ #category : #api }
DvtVisualizationEditor >> generateScript [
	self subclassResponsibility
]

{ #category : #api }
DvtVisualizationEditor >> generateView [
	| view |
	[ 
		view := Smalltalk compiler evaluate: self generateScript
	] on: Error do: [ :e |
		DvtErrorDialog open: ('Произошла ошибка выполнения сценария. "{1}"' format: { e messageText }).
		^ self
	].
	self assert: [ view isKindOf: RTView ].
	^ view
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleData [
	^ sampleData
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleData: anObject [
	sampleData := anObject
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleFilePath [
	^ sampleFilePath
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleFilePath: anObject [
	sampleFilePath := anObject
]

{ #category : #accessing }
DvtVisualizationEditor >> visualization [
	^ visualization
]

{ #category : #accessing }
DvtVisualizationEditor >> visualization: anObject [
	visualization := anObject
]
