Class {
	#name : #DvtVisualizationEditor,
	#superclass : #ComposablePresenter,
	#instVars : [
		'sampleFilePath'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtVisualizationEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		
	];
	yourself
]

{ #category : #initialization }
DvtVisualizationEditor >> initializeWidgets [
	
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleFilePath [
	^ sampleFilePath
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleFilePath: anObject [
	sampleFilePath := anObject
]
