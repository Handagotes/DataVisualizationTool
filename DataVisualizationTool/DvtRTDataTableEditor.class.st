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
		'closeButton',
		'settings',
		'lastSelectedSetting'
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
			add: #closeButton height: self buttonHeight
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
DvtRTDataTableEditor >> closeButton [
	^ closeButton
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
	nameTextinput whenTextChanged: [ self onNameTextInputTextChanged ].
	addButton action: [ self onAddButtonAction ].
	removeButton action: [ self onRemoveButtonAction ].
	closeButton action: [ self onCloseButtonAction ].
	self makeWindowUnresizeable
]

{ #category : #initialization }
DvtRTDataTableEditor >> initializeWidgets [
	settingsDataTable := self newDataTable.
	nameTextinput := self newTextInput.
	xKeyTextInput := self newTextInput.
	yKeyTextInput := self newTextInput.
	dotColorButton := self newColorPickerButton.
	connectColorButton := self newColorPickerButton.
	addButton := self newButton.
	removeButton := self newButton.
	closeButton := self newButton.
	
	settingsDataTable widget beSingleSelection.
	nameTextinput autoAccept: true.
	xKeyTextInput autoAccept: true.
	yKeyTextInput autoAccept: true.
	dotColorButton
		label: 'Цвет точек';
		pickedColor: Color red.
	connectColorButton
		label: 'Цвет соединений';
		pickedColor: Color red.
	addButton label:
		'Добавить данные графика';
		disable.
	removeButton
		label: 'Удалить данные графика';
		disable.
	closeButton label: 'Закрыть'.
	
	self focusOrder
		add: settingsDataTable;
		add: xKeyTextInput;
		add: yKeyTextInput;
		add: dotColorButton;
		add: connectColorButton;
		add: addButton;
		add: removeButton;
		add: closeButton
]

{ #category : #accessing }
DvtRTDataTableEditor >> nameTextInput [
	^ nameTextinput
]

{ #category : #private }
DvtRTDataTableEditor >> onAddButtonAction [
	.
	self updateSettingsDataTable
]

{ #category : #private }
DvtRTDataTableEditor >> onCloseButtonAction [
	self closeDialog
]

{ #category : #private }
DvtRTDataTableEditor >> onNameTextInputTextChanged [
	| name |
	name := nameTextinput text.
	addButton enabled: (name isNotEmpty and: [ settings allSatisfy: [ :s | (s at: #name) ~= name ] ])
]

{ #category : #private }
DvtRTDataTableEditor >> onRemoveButtonAction [
	
]

{ #category : #private }
DvtRTDataTableEditor >> onSettingsDataTableSelectionChanged [
	| setting |
	setting := self selectedSetting.
	self saveLastSelectedSetting.
	lastSelectedSetting := setting.
	
	setting ifNil: [ 
		nameTextinput text: String empty.
		xKeyTextInput text: String empty.
		yKeyTextInput text: String empty.
		dotColorButton disable.
		connectColorButton disable.
		removeButton disable.
		addButton enable.
		^ self
	].
	
	nameTextinput text: (setting at: #name).
	xKeyTextInput text: (setting at: #xKey).
	yKeyTextInput text: (setting at: #yKey).
	dotColorButton enable.
	connectColorButton enable.
	removeButton enable.
	addButton disable
]

{ #category : #accessing }
DvtRTDataTableEditor >> removeButton [
	^ removeButton
]

{ #category : #private }
DvtRTDataTableEditor >> saveLastSelectedSetting [
	
]

{ #category : #private }
DvtRTDataTableEditor >> selectedSetting [
	| i |
	(i := self selectedSettingIndex) ifNil: [ ^ self ].
	^ settingsDataTable widget dataSource elementAt: i
]

{ #category : #private }
DvtRTDataTableEditor >> selectedSettingIndex [
	^ settingsDataTable widget selectedRowIndex
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

{ #category : #private }
DvtRTDataTableEditor >> updateSettingsDataTable [
	settingsDataTable widget refresh
]

{ #category : #accessing }
DvtRTDataTableEditor >> xKeyTextInput [
	^ xKeyTextInput
]

{ #category : #accessing }
DvtRTDataTableEditor >> yKeyTextInput [
	^ yKeyTextInput
]
