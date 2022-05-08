Class {
	#name : #DvtRTDataSettingsEditor,
	#superclass : #DvtVisualizationSettingsEditorDialog,
	#instVars : [
		'settingsDataTable',
		'nameTextinput',
		'xKeyTextInput',
		'yKeyTextInput',
		'shapeColorButton',
		'connectColorButton',
		'shapeTypeDropList',
		'addButton',
		'removeButton',
		'closeButton',
		'settings',
		'lastSelectedSetting'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtRTDataSettingsEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #settingsDataTable;
			newRow: [ :row |
				row
					add: #nameTextInput;
					add: #xKeyTextInput;
					add: #yKeyTextInput;
					add: #shapeColorButton;
					add: #connectColorButton;
					add: #shapeTypeDropList
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
DvtRTDataSettingsEditor class >> open [
	^ self openForSettings: OrderedCollection new
]

{ #category : #'instance creation' }
DvtRTDataSettingsEditor class >> openForSettings: anOrderedCollectionOfDvtRTDataSetting [
	^ self openDialogConfiguredAs: [ :dialog |
		dialog settings: anOrderedCollectionOfDvtRTDataSetting
	]
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> addButton [
	^ addButton
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> closeButton [
	^ closeButton
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> connectColorButton [
	^ connectColorButton
]

{ #category : #api }
DvtRTDataSettingsEditor >> extent [
	^ 780 @ 300
]

{ #category : #initialization }
DvtRTDataSettingsEditor >> initializePresenter [
	settingsDataTable when: FTSelectionChanged do: [ self onSettingsDataTableSelectionChanged ].
	nameTextinput whenTextChanged: [ self onNameTextInputTextChanged ].
	addButton action: [ self onAddButtonAction ].
	removeButton action: [ self onRemoveButtonAction ].
	closeButton action: [ self onCloseButtonAction ].
	self makeWindowUnresizeable
]

{ #category : #initialization }
DvtRTDataSettingsEditor >> initializeWidgets [
	settingsDataTable := self newDataTable.
	nameTextinput := self newTextInput.
	xKeyTextInput := self newTextInput.
	yKeyTextInput := self newTextInput.
	shapeColorButton := self newColorPickerButton.
	connectColorButton := self newColorPickerButton.
	shapeTypeDropList := self newDropList.
	addButton := self newButton.
	removeButton := self newButton.
	closeButton := self newButton.
	
	settingsDataTable widget beSingleSelection.
	nameTextinput autoAccept: true.
	xKeyTextInput autoAccept: true.
	yKeyTextInput autoAccept: true.
	shapeColorButton
		label: 'Цвет вершин';
		pickedColor: Color red.
	connectColorButton
		label: 'Цвет соединений';
		pickedColor: Color red.
	shapeTypeDropList
		items: DvtRTDataSetting availableShapeTypes;
		displayBlock: DvtRTDataSetting shapeTypeDisplayBlock.
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
		add: shapeColorButton;
		add: connectColorButton;
		add: addButton;
		add: removeButton;
		add: closeButton
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> nameTextInput [
	^ nameTextinput
]

{ #category : #private }
DvtRTDataSettingsEditor >> onAddButtonAction [
	self selectedSettingIndex > 0 ifTrue: [ ^ self ].
	nameTextinput text ifEmpty: [ ^ self ].
	settings add: (DvtRTDataSetting new
		name: nameTextinput text;
		xKey: xKeyTextInput text;
		yKey: yKeyTextInput text;
		shapeColor: shapeColorButton pickedColor;
		connectColor: connectColorButton pickedColor;
		shapeType: shapeTypeDropList selectedItem;
		yourself).
	self
		resetInputs;
		updateSettingsDataTable
]

{ #category : #private }
DvtRTDataSettingsEditor >> onCloseButtonAction [
	self
		saveLastSelectedSetting;
		closeDialog: settings
]

{ #category : #private }
DvtRTDataSettingsEditor >> onNameTextInputTextChanged [
	| name |
	name := nameTextinput text.
	addButton enabled: (name isNotEmpty and: [ settings allSatisfy: [ :s | s name ~= name ] ])
]

{ #category : #private }
DvtRTDataSettingsEditor >> onRemoveButtonAction [
	| setting |
	(setting := self selectedSetting) ifNil: [ ^ self ].
	settings remove: setting.
	self
		resetInputs;
		updateSettingsDataTable.
	settingsDataTable widget selectRowIndex: 0
]

{ #category : #private }
DvtRTDataSettingsEditor >> onSettingsDataTableSelectionChanged [
	| setting |
	setting := self selectedSetting.
	self saveLastSelectedSetting.
	lastSelectedSetting := setting.
	
	setting ifNil: [ 
		self resetInputs.
		addButton enable.
		removeButton disable.
		^ self
	].
	
	nameTextinput text: setting name.
	xKeyTextInput text: setting xKey.
	yKeyTextInput text: setting yKey.
	shapeColorButton
		pickedColor: setting shapeColor;
		enable.
	connectColorButton
		pickedColor: setting connectColor;
		enable.
	shapeTypeDropList setSelectedItem: setting shapeType.
	addButton disable.
	removeButton enable
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> removeButton [
	^ removeButton
]

{ #category : #private }
DvtRTDataSettingsEditor >> resetInputs [
	nameTextinput text: String empty.
	xKeyTextInput text: String empty.
	yKeyTextInput text: String empty.
	shapeColorButton pickedColor: Color red.
	connectColorButton pickedColor: Color red.
	shapeTypeDropList setSelectedItem: DvtRTDataSetting availableShapeTypes first
]

{ #category : #private }
DvtRTDataSettingsEditor >> saveLastSelectedSetting [
	| name |
	lastSelectedSetting ifNil: [ ^ self ].
	(name := nameTextinput text) ifNotEmpty: [ 
		lastSelectedSetting name: name
	].
	lastSelectedSetting
		xKey: xKeyTextInput text;
		yKey: yKeyTextInput text;
		shapeColor: shapeColorButton pickedColor;
		connectColor: connectColorButton pickedColor;
		shapeType: shapeTypeDropList selectedItem
]

{ #category : #private }
DvtRTDataSettingsEditor >> selectedSetting [
	| i |
	(i := self selectedSettingIndex) isZero ifTrue: [ ^ nil ].
	^ settingsDataTable widget dataSource elementAt: i
]

{ #category : #private }
DvtRTDataSettingsEditor >> selectedSettingIndex [
	^ settingsDataTable widget selectedRowIndex
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> settings [
	^ settings
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> settings: anOrderedCollectionOfDvtRTDataSetting [
	| dataSource |
	settings := anOrderedCollectionOfDvtRTDataSetting.
	dataSource := DvtRTDataSettingDataSource elements: settings.
	dataSource addColumnsTo: settingsDataTable widget.
	settingsDataTable widget dataSource: dataSource
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> settingsDataTable [
	^ settingsDataTable
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> shapeColorButton [
	^ shapeColorButton
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> shapeTypeDropList [
	^ shapeTypeDropList
]

{ #category : #private }
DvtRTDataSettingsEditor >> updateSettingsDataTable [
	settingsDataTable widget refresh
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> xKeyTextInput [
	^ xKeyTextInput
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> yKeyTextInput [
	^ yKeyTextInput
]
