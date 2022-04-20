Class {
	#name : #DvtErrorDialog,
	#superclass : #DvtDialog,
	#instVars : [
		'errorImage',
		'errorLabel',
		'okButton'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtErrorDialog class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				row
					add: #errorImage width: self errorIcon width;
					add: #errorLabel
			];
			add: #okButton
	]
]

{ #category : #private }
DvtErrorDialog class >> errorIcon [
	^ self iconNamed: #error
]

{ #category : #api }
DvtErrorDialog class >> open: errorString [
	^ self openDialogConfiguredAs: [ :dialog :window |
		dialog errorLabel label: 'Ошибка: ' , errorString.
		window extent: dialog extent
	]
]

{ #category : #accessing }
DvtErrorDialog >> errorImage [
	^ errorImage
]

{ #category : #accessing }
DvtErrorDialog >> errorLabel [
	^ errorLabel
]

{ #category : #api }
DvtErrorDialog >> extent [
	^ super extent max: 30 + (self widthOfString: errorLabel label) @ 100
]

{ #category : #initialization }
DvtErrorDialog >> initializePresenter [
	okButton action: [ self closeDialog ]
]

{ #category : #initialization }
DvtErrorDialog >> initializeWidgets [
	errorImage := self newImage.
	errorLabel := self newLabel.
	okButton := self newButton.
	
	errorImage image: self class errorIcon.
	okButton label: 'Ок'.
	
	self focusOrder
		add: okButton
]

{ #category : #accessing }
DvtErrorDialog >> okButton [
	^ okButton
]
