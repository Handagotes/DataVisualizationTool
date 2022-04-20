Class {
	#name : #DvtTextInputDialog,
	#superclass : #DvtDialog,
	#instVars : [
		'label',
		'textInput',
		'okButton',
		'cancelButton'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtTextInputDialog class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #label height: 25;
			add: #textInput;
			newRow: [ :row |
				row
					add: #okButton;
					add: #cancelButton
			] height: self buttonHeight
	]
]

{ #category : #api }
DvtTextInputDialog class >> open: labelText [
	^ self open: labelText default: String empty
]

{ #category : #api }
DvtTextInputDialog class >> open: labelText default: defaultText [
	^ self openDialogConfiguredAs: [ :dialog |
		dialog setupLabelText: labelText defaultText: defaultText
	]
]

{ #category : #api }
DvtTextInputDialog class >> openNoCancel: labelText [
	^ self openNoCancel: labelText default: String empty
]

{ #category : #api }
DvtTextInputDialog class >> openNoCancel: labelText default: defaultText [
	^ self openDialogConfiguredAs: [ :dialog |
		dialog setupLabelText: labelText defaultText: defaultText.
		dialog cancelButton disable
	]
]

{ #category : #accessing }
DvtTextInputDialog >> cancelButton [
	^ cancelButton
]

{ #category : #api }
DvtTextInputDialog >> extent [
	^ super extent max: 50 + (self widthOfString: label label) @ 120
]

{ #category : #initialization }
DvtTextInputDialog >> initializePresenter [
	textInput
		whenTextChanged: [ 
			okButton enabled: textInput text isNotEmpty
		];
		bindKeyCombination: Character cr toAction: [ 
			okButton enabled ifTrue: [ 
				okButton performAction
			]
		].
	
	okButton action: [ 
		self closeDialog: textInput text
	].
	
	cancelButton action: [ 
		self closeDialog: nil
	]
]

{ #category : #initialization }
DvtTextInputDialog >> initializeWidgets [
	label := self newLabel.
	textInput := self newTextInput.
	okButton := self newButton.
	cancelButton := self newButton.
	
	textInput autoAccept: true.
	okButton label: 'Ок'.
	cancelButton label: 'Отмена'.
	
	self focusOrder
		add: textInput;
		add: okButton;
		add: cancelButton
]

{ #category : #accessing }
DvtTextInputDialog >> label [
	^ label
]

{ #category : #accessing }
DvtTextInputDialog >> okButton [
	^ okButton
]

{ #category : #private }
DvtTextInputDialog >> setupLabelText: labelText defaultText: defaultText [
	label label: labelText.
	textInput
		text: defaultText;
		selectAll.
]

{ #category : #accessing }
DvtTextInputDialog >> textInput [
	^ textInput
]
