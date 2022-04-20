Class {
	#name : #DvtYesNoDialog,
	#superclass : #DvtDialog,
	#instVars : [
		'questionImage',
		'questionLabel',
		'yesButton',
		'noButton'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtYesNoDialog class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				row
					add: #questionImage width: self questionIcon width;
					add: #questionLabel
			];
			newRow: [ :row |
				row
					add: #yesButton;
					add: #noButton
			]
	]
]

{ #category : #api }
DvtYesNoDialog class >> open: questionString [
	^ self openDialogConfiguredAs: [ :dialog :window |
		dialog questionLabel label: questionString.
		window extent: dialog extent
	]
]

{ #category : #private }
DvtYesNoDialog class >> questionIcon [
	^ self iconNamed: #question
]

{ #category : #api }
DvtYesNoDialog >> extent [
	^ super extent max: 50 + (self widthOfString: questionLabel label) @ 100
]

{ #category : #initialization }
DvtYesNoDialog >> initializePresenter [
	yesButton action: [ self closeDialog: true ].
	noButton action: [ self closeDialog: false ]
]

{ #category : #initialization }
DvtYesNoDialog >> initializeWidgets [
	questionImage := self newImage.
	questionLabel := self newLabel.
	yesButton := self newButton.
	noButton := self newButton.
	
	questionImage image: self class questionIcon.
	yesButton label: 'Да'.
	noButton label: 'Нет'.
	
	self focusOrder
		add: yesButton;
		add: noButton
]

{ #category : #accessing }
DvtYesNoDialog >> noButton [
	^ noButton
]

{ #category : #accessing }
DvtYesNoDialog >> questionImage [
	^ questionImage
]

{ #category : #accessing }
DvtYesNoDialog >> questionLabel [
	^ questionLabel
]

{ #category : #accessing }
DvtYesNoDialog >> yesButton [
	^ yesButton
]
