Class {
	#name : #DvtPickValueTypeDialog,
	#superclass : #DvtDialog,
	#instVars : [
		'label',
		'stringButton',
		'numberButton',
		'literalButton',
		'cancelButton'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtPickValueTypeDialog class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #label height: self labelHeight;
			newRow: [ :row |
				row
					add: #stringButton;
					add: #numberButton;
					add: #literalButton
			];
			add: #cancelButton height: self buttonHeight
	];
	yourself
]

{ #category : #'instance creation' }
DvtPickValueTypeDialog class >> open [
	^ self openDialog
]

{ #category : #accessing }
DvtPickValueTypeDialog >> cancelButton [
	^ cancelButton
]

{ #category : #api }
DvtPickValueTypeDialog >> extent [
	^ super extent x @ 125
]

{ #category : #initialization }
DvtPickValueTypeDialog >> initializePresenter [
	stringButton action: [ self closeDialog: #string ].
	numberButton action: [ self closeDialog: #number ].
	literalButton action: [ self closeDialog: #literal ].
	cancelButton action: [ self closeDialog: nil ]
]

{ #category : #initialization }
DvtPickValueTypeDialog >> initializeWidgets [
	label := self newLabel.
	stringButton := self newButton.
	numberButton := self newButton.
	literalButton := self newButton.
	cancelButton := self newButton.
	
	label label: 'Выберите тип значения ячеек:'.
	stringButton
		label: ' Строка';
		icon: (DvtApp colorForStringValue asFormOfExtent: 22 @ 22).
	numberButton
		label: ' Число';
		icon: (DvtApp colorForNumberValue asFormOfExtent: 22 @ 22).
	literalButton
		label: ' Литерал';
		icon: (DvtApp colorForLiteralValue asFormOfExtent: 22 @ 22).
	
	cancelButton label: 'Отмена'.
	
	self focusOrder
		add: stringButton;
		add: numberButton;
		add: literalButton;
		add: cancelButton
]

{ #category : #accessing }
DvtPickValueTypeDialog >> label [
	^ label
]

{ #category : #accessing }
DvtPickValueTypeDialog >> literalButton [
	^ literalButton
]

{ #category : #accessing }
DvtPickValueTypeDialog >> numberButton [
	^ numberButton
]

{ #category : #accessing }
DvtPickValueTypeDialog >> stringButton [
	^ stringButton
]
