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
	^ self openForSettings: OrderedCollection new
]

{ #category : #'instance creation' }
DvtRTDataTableEditor class >> openForSettings: anOrderedCollectionOfDictionaries [
	^ self openDialogConfiguredAs: [ :dialog |
		dialog settings: anOrderedCollectionOfDictionaries
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
	self selectedSettingIndex > 0 ifTrue: [ ^ self ].
	nameTextinput text ifEmpty: [ ^ self ].
	settings add: {
		#name -> nameTextinput text.
		#xKey -> xKeyTextInput text.
		#yKey -> yKeyTextInput text.
		#dotColor -> dotColorButton pickedColor.
		#connectColor -> connectColorButton pickedColor.
	} asDictionary.
	self
		resetInputs;
		updateSettingsDataTable
]

{ #category : #private }
DvtRTDataTableEditor >> onCloseButtonAction [
	self
		saveLastSelectedSetting;
		closeDialog: settings
]

{ #category : #private }
DvtRTDataTableEditor >> onNameTextInputTextChanged [
	| name |
	name := nameTextinput text.
	addButton enabled: (name isNotEmpty and: [ settings allSatisfy: [ :s | (s at: #name) ~= name ] ])
]

{ #category : #private }
DvtRTDataTableEditor >> onRemoveButtonAction [
	| setting |
	(setting := self selectedSetting) ifNil: [ ^ self ].
	settings remove: setting.
	self
		resetInputs;
		updateSettingsDataTable.
	settingsDataTable widget selectRowIndex: 0
]

{ #category : #private }
DvtRTDataTableEditor >> onSettingsDataTableSelectionChanged [
	| setting |
	setting := self selectedSetting.
	self saveLastSelectedSetting.
	lastSelectedSetting := setting.
	
	setting ifNil: [ 
		self resetInputs.
		removeButton disable.
		addButton enable.
		^ self
	].
	
	nameTextinput text: (setting at: #name).
	xKeyTextInput text: (setting at: #xKey).
	yKeyTextInput text: (setting at: #yKey).
	dotColorButton
		pickedColor: (setting at: #dotColor);
		enable.
	connectColorButton
		pickedColor: (setting at: #connectColor);
		enable.
	removeButton enable.
	addButton disable
]

{ #category : #accessing }
DvtRTDataTableEditor >> removeButton [
	^ removeButton
]

{ #category : #private }
DvtRTDataTableEditor >> resetInputs [
	nameTextinput text: String empty.
	xKeyTextInput text: String empty.
	yKeyTextInput text: String empty.
	dotColorButton pickedColor: Color red.
	connectColorButton pickedColor: Color red
]

{ #category : #private }
DvtRTDataTableEditor >> saveLastSelectedSetting [
	| name |
	lastSelectedSetting ifNil: [ ^ self ].
	(name := nameTextinput text) ifNotEmpty: [ 
		lastSelectedSetting at: #name put: name
	].
	lastSelectedSetting at: #xKey put: xKeyTextInput text.
	lastSelectedSetting at: #yKey put: yKeyTextInput text.
	lastSelectedSetting at: #dotColor put: dotColorButton pickedColor.
	lastSelectedSetting at: #connectColor put: connectColorButton pickedColor
]

{ #category : #private }
DvtRTDataTableEditor >> selectedSetting [
	| i |
	(i := self selectedSettingIndex) isZero ifTrue: [ ^ nil ].
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
DvtRTDataTableEditor >> settings: anOrderedCollectionOfDictionaries [
	| dataSource |
	settings := anOrderedCollectionOfDictionaries.
	dataSource := DvtRTDataListDataSource elements: settings.
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
