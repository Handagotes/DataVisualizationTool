Class {
	#name : #DvtRTDataTableEditor,
	#superclass : #DvtDialog,
	#instVars : [
		'settingsDataTable',
		'nameTextinput',
		'xKeyTextInput',
		'yKeyTextInput',
		'dotColorButton',
		'connectColorButton',
		'addButton',
		'removeButton',
		'okButton',
		'cancelButton',
		'settings'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtRTDataTableEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #settingsDataTable;
			newRow: [ :row |
				row
					add: #nameTextInput;
					add: #xKeyTextInput;
					add: #yKeyTextInput;
					add: #dotColorButton;
					add: #connectColorButton
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #addButton;
					add: #removeButton
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #okButton;
					add: #cancelButton
			] height: self buttonHeight
	]
]

{ #category : #'instance creation' }
DvtRTDataTableEditor class >> open [
	^ self openForSettings: Set new
]

{ #category : #'instance creation' }
DvtRTDataTableEditor class >> openForSettings: aSetOfDictionaries [
	^ self openDialogConfiguredAs: [ :dialog |
		dialog settings: aSetOfDictionaries
	]
]

{ #category : #accessing }
DvtRTDataTableEditor >> addButton [
	^ addButton
]

{ #category : #accessing }
DvtRTDataTableEditor >> cancelButton [
	^ cancelButton
]

{ #category : #accessing }
DvtRTDataTableEditor >> connectColorButton [
	^ connectColorButton
]

{ #category : #accessing }
DvtRTDataTableEditor >> dotColorButton [
	^ dotColorButton
]

{ #category : #api }
DvtRTDataTableEditor >> extent [
	^ 600 @ 300
]

{ #category : #initialization }
DvtRTDataTableEditor >> initializePresenter [
	settingsDataTable when: FTSelectionChanged do: [ self onSettingsDataTableSelectionChanged ].
	dotColorButton action: [ self onDotColorButtonAction ].
	connectColorButton action: [ self onConnectColorButtonAction ].
	addButton action: [ self onAddButtonAction ].
	removeButton action: [ self onRemoveButtonAction ].
	okButton action: [ self onOkButtonAction ].
	cancelButton action: [ self onCancelButtonAction ].
	self makeWindowUnresizeable
]

{ #category : #initialization }
DvtRTDataTableEditor >> initializeWidgets [
	settingsDataTable := self newDataTable.
	nameTextinput := self newTextInput.
	xKeyTextInput := self newTextInput.
	yKeyTextInput := self newTextInput.
	dotColorButton := self newButton.
	connectColorButton := self newButton.
	addButton := self newButton.
	removeButton := self newButton.
	okButton := self newButton.
	cancelButton := self newButton.
	
	nameTextinput autoAccept: true.
	xKeyTextInput autoAccept: true.
	yKeyTextInput autoAccept: true.
	dotColorButton label: 'Цвет точек'.
	connectColorButton label: 'Цвет соединений'.
	addButton label: 'Добавить данные графика'.
	removeButton label: 'Удалить данные графика'.
	okButton label: 'Ок'.
	cancelButton label: 'Отмена'.
	
	self focusOrder
		add: settingsDataTable;
		add: xKeyTextInput;
		add: yKeyTextInput;
		add: dotColorButton;
		add: connectColorButton;
		add: addButton;
		add: removeButton;
		add: okButton;
		add: cancelButton
]

{ #category : #accessing }
DvtRTDataTableEditor >> nameTextInput [
	^ nameTextinput
]

{ #category : #accessing }
DvtRTDataTableEditor >> okButton [
	^ okButton
]

{ #category : #private }
DvtRTDataTableEditor >> onAddButtonAction [
	
]

{ #category : #private }
DvtRTDataTableEditor >> onCancelButtonAction [
	self closeDialog
]

{ #category : #private }
DvtRTDataTableEditor >> onConnectColorButtonAction [
	
]

{ #category : #private }
DvtRTDataTableEditor >> onDotColorButtonAction [
	
]

{ #category : #private }
DvtRTDataTableEditor >> onOkButtonAction [
	
]

{ #category : #private }
DvtRTDataTableEditor >> onRemoveButtonAction [
	
]

{ #category : #private }
DvtRTDataTableEditor >> onSettingsDataTableSelectionChanged [
	
]

{ #category : #accessing }
DvtRTDataTableEditor >> removeButton [
	^ removeButton
]

{ #category : #accessing }
DvtRTDataTableEditor >> settings [
	^ settings
]

{ #category : #accessing }
DvtRTDataTableEditor >> settings: aSetOfDictionaries [
	| dataSource |
	settings := aSetOfDictionaries.
	dataSource := DvtRTDataListDataSource elements: aSetOfDictionaries.
	dataSource addColumnsTo: settingsDataTable widget.
	settingsDataTable widget dataSource: dataSource
]

{ #category : #accessing }
DvtRTDataTableEditor >> settingsDataTable [
	^ settingsDataTable
]

{ #category : #accessing }
DvtRTDataTableEditor >> xKeyTextInput [
	^ xKeyTextInput
]

{ #category : #accessing }
DvtRTDataTableEditor >> yKeyTextInput [
	^ yKeyTextInput
]
