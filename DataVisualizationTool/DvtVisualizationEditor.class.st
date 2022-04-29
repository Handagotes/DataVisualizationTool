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
DvtVisualizationEditor >> config: aCollectionOfCollections [
	config := aCollectionOfCollections
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

{ #category : #api }
DvtVisualizationEditor >> updateConfigFile [
	| json |
	json := NeoJSONWriter toString: config.
	(DvtApp visualizationFileRefFor: visualization)
		writeStreamDo: [ :ws | ws nextPutAll: json	]
]

{ #category : #accessing }
DvtVisualizationEditor >> visualization [
	^ visualization
]

{ #category : #accessing }
DvtVisualizationEditor >> visualization: anObject [
	visualization := anObject
]
