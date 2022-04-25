Class {
	#name : #DvtDropListDialog,
	#superclass : #DvtDialog,
	#instVars : [
		'label',
		'dropList',
		'itemDescriptionText',
		'okButton',
		'cancelButton',
		'itemDescriptionBlock'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtDropListDialog class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #label height: self labelHeight;
			add: #dropList height: self buttonHeight;
			add: #itemDescriptionText;
			newRow: [ :row |
				row
					add: #okButton;
					add: #cancelButton
			] height: self buttonHeight
	]
]

{ #category : #api }
DvtDropListDialog class >> open: labelText items: items [
	^ self open: labelText items: items displayBlock: nil descriptionBlock: nil allowCancel: true
]

{ #category : #api }
DvtDropListDialog class >> open: labelText items: items allowCancel: allowCancel [
	^ self open: labelText items: items displayBlock: nil descriptionBlock: nil allowCancel: allowCancel
]

{ #category : #api }
DvtDropListDialog class >> open: labelText items: items descriptionBlock: descriptionBlock [
	^ self open: labelText items: items displayBlock: nil descriptionBlock: descriptionBlock allowCancel: true
]

{ #category : #api }
DvtDropListDialog class >> open: labelText items: items descriptionBlock: descriptionBlock allowCancel: allowCancel [
	^ self open: labelText items: items displayBlock: nil descriptionBlock: descriptionBlock allowCancel: allowCancel
]

{ #category : #api }
DvtDropListDialog class >> open: labelText items: items displayBlock: displayBlock [
	^ self open: labelText items: items displayBlock: displayBlock descriptionBlock: nil allowCancel: true
]

{ #category : #api }
DvtDropListDialog class >> open: labelText items: items displayBlock: displayBlock allowCancel: allowCancel [
	^ self open: labelText items: items displayBlock: displayBlock descriptionBlock: nil allowCancel: allowCancel
]

{ #category : #api }
DvtDropListDialog class >> open: labelText items: items displayBlock: displayBlock descriptionBlock: descriptionBlock [
	^ self open: labelText items: items displayBlock: displayBlock descriptionBlock: descriptionBlock allowCancel: true
]

{ #category : #api }
DvtDropListDialog class >> open: labelText items: items displayBlock: displayBlock descriptionBlock: descriptionBlock allowCancel: allowCancel [
	^ self openDialogConfiguredAs: [ :dialog |
		dialog label
			label: labelText.
		dialog dropList
			displayBlock: (displayBlock ifNil: [ [ :e | e asString ] ]);
			items: items;
			setIndex: 0.
		dialog cancelButton enabled: allowCancel.
		dialog itemDescriptionBlock: descriptionBlock
	]
]

{ #category : #accessing }
DvtDropListDialog >> cancelButton [
	^ cancelButton
]

{ #category : #accessing }
DvtDropListDialog >> dropList [
	^ dropList
]

{ #category : #api }
DvtDropListDialog >> extent [
	^ super extent x @ (itemDescriptionBlock
		ifNil: [ 118 ]
		ifNotNil: [ 200 ])
]

{ #category : #initialization }
DvtDropListDialog >> initializePresenter [
	dropList whenSelectedItemChanged: [ self onDropListSelectedItemChanged ].
	okButton action: [ self closeDialog: dropList selectedItem ].
	cancelButton action: [ self closeDialog: nil ]
]

{ #category : #initialization }
DvtDropListDialog >> initializeWidgets [
	label := self newLabel.
	dropList := self newDropList.
	itemDescriptionText := self newText.
	okButton := self newButton.
	cancelButton := self newButton.
	itemDescriptionText disable.
	okButton label: 'Ок'.
	cancelButton label: 'Отмена'.
	
	self focusOrder
		add: dropList;
		add: okButton;
		add: cancelButton
]

{ #category : #accessing }
DvtDropListDialog >> itemDescriptionBlock [
	^ itemDescriptionBlock
]

{ #category : #accessing }
DvtDropListDialog >> itemDescriptionBlock: aBlock [
	itemDescriptionBlock := aBlock
]

{ #category : #accessing }
DvtDropListDialog >> itemDescriptionText [
	^ itemDescriptionText
]

{ #category : #accessing }
DvtDropListDialog >> label [
	^ label
]

{ #category : #accessing }
DvtDropListDialog >> okButton [
	^ okButton
]

{ #category : #private }
DvtDropListDialog >> onDropListSelectedItemChanged [
	| i |
	i := dropList selectedIndex.
	okButton enabled: i > 0.
	itemDescriptionText text: ((i > 0 and: [ itemDescriptionBlock isNotNil ])
		ifTrue: [ (itemDescriptionBlock value: dropList selectedItem) ]
		ifFalse: [ '' ])
]
