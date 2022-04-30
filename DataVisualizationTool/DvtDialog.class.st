Class {
	#name : #DvtDialog,
	#superclass : #ComposablePresenter,
	#instVars : [
		'result'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtDialog class >> openDialog [
	^ self openDialogConfiguredAs: [  ]
]

{ #category : #private }
DvtDialog class >> openDialogConfiguredAs: aBlock [
	| topMorph dialog window |
	topMorph := SystemWindow topWindow ifNil: [ World ].
	(dialog := self new)
		openWithSpec;
		result: nil.
	(window := dialog window)
		containingWindow removeBoxes.
	aBlock cull: dialog cull: window.
	window modalRelativeTo: topMorph.
	^ dialog result
]

{ #category : #private }
DvtDialog >> closeDialog [
	self closeDialog: nil
]

{ #category : #private }
DvtDialog >> closeDialog: aResultObject [
	self result: aResultObject.
	self window close
]

{ #category : #api }
DvtDialog >> extent [
	^ 175 + (self widthOfString: self title) @ 100
]

{ #category : #accessing }
DvtDialog >> result [
	^ result
]

{ #category : #accessing }
DvtDialog >> result: anObject [
	result := anObject
]

{ #category : #api }
DvtDialog >> title [
	^ DvtApp appName
]

{ #category : #measuring }
DvtDialog >> widthOfString: aString [
	^ self class defaultFont widthOfString: aString
]
