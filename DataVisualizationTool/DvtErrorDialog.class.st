Class {
	#name : #DvtErrorDialog,
	#superclass : #DvtDialog,
	#instVars : [
		'errorImage',
		'errorLabel',
		'errorText',
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
			] height: self labelHeight;
			add: #errorText;
			add: #okButton height: self buttonHeight
	]
]

{ #category : #private }
DvtErrorDialog class >> errorIcon [
	^ self iconNamed: #error
]

{ #category : #api }
DvtErrorDialog class >> open: errorString [
	^ self openDialogConfiguredAs: [ :dialog :window |
		dialog errorText text: errorString.
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

{ #category : #accessing }
DvtErrorDialog >> errorText [
	^ errorText
]

{ #category : #api }
DvtErrorDialog >> extent [
	^ 400 @ 150
]

{ #category : #initialization }
DvtErrorDialog >> initializePresenter [
	okButton action: [ self closeDialog ]
]

{ #category : #initialization }
DvtErrorDialog >> initializeWidgets [
	errorImage := self newImage.
	errorLabel := self newLabel.
	errorText := self newTextInput.
	okButton := self newButton.
	
	errorImage image: self class errorIcon.
	errorLabel label: 'Ошибка'.
	errorText disable.
	okButton label: 'Ок'.
	
	self focusOrder
		add: okButton
]

{ #category : #accessing }
DvtErrorDialog >> okButton [
	^ okButton
]
