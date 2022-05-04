Class {
	#name : #ColorPickerButtonPresenter,
	#superclass : #ButtonPresenter,
	#instVars : [
		'colorIcon'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #initialization }
ColorPickerButtonPresenter >> initialize [
	super initialize.
	colorIcon := Color white asFormOfExtent: 16 @ 16.
	self icon: colorIcon.
	self action: [ | picker topWindow |
		picker := ColorSelectorDialogWindow new.
		topWindow := SystemWindow topWindow.
		picker selectedColor: self pickedColor.
		topWindow modalLockTo: picker.
		picker openModal.
		topWindow modalUnlockFrom: picker.
		picker cancelled ifFalse: [ self pickedColor: picker selectedColor ]
	]
]

{ #category : #accessing }
ColorPickerButtonPresenter >> pickedColor [
	^ colorIcon colorAt: 1 @ 1
]

{ #category : #accessing }
ColorPickerButtonPresenter >> pickedColor: aColor [
	colorIcon fillColor: aColor.
	self icon: colorIcon
]
