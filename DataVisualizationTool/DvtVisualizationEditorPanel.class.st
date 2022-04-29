Class {
	#name : #DvtVisualizationEditorPanel,
	#superclass : #ComposablePresenter,
	#instVars : [
		'editor',
		'sampleFilePath'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtVisualizationEditorPanel class >> defaultSpec [
	^ SpecLayout composed
		add: #editor;
		yourself
]

{ #category : #accessing }
DvtVisualizationEditorPanel >> editor [
	^ editor
]

{ #category : #initialization }
DvtVisualizationEditorPanel >> initializeWidgets [
	editor := self newNullPresenter
]
