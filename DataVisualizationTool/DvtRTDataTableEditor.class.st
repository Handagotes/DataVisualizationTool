Class {
	#name : #DvtRTDataTableEditor,
	#superclass : #DvtDialog,
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
DvtRTDataTableEditor class >> defaultSpec [
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
DvtRTDataTableEditor class >> open [
	^ self openForSettings: OrderedCollection new
]

{ #category : #'instance creation' }
DvtRTDataTableEditor class >> openForSettings: anOrderedCollectionOfDvtRTDataSetting [
	^ self openDialogConfiguredAs: [ :dialog |
		dialog settings: anOrderedCollectionOfDvtRTDataSetting
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

{ #category : #api }
DvtRTDataTableEditor >> extent [
	^ 700 @ 300
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
		label: 'Цвет точек';
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
DvtRTDataTableEditor >> nameTextInput [
	^ nameTextinput
]

{ #category : #private }
DvtRTDataTableEditor >> onAddButtonAction [
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
DvtRTDataTableEditor >> onCloseButtonAction [
	self
		saveLastSelectedSetting;
		closeDialog: settings
]

{ #category : #private }
DvtRTDataTableEditor >> onNameTextInputTextChanged [
	| name |
	name := nameTextinput text.
	addButton enabled: (name isNotEmpty and: [ settings allSatisfy: [ :s | s name ~= name ] ])
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
DvtRTDataTableEditor >> removeButton [
	^ removeButton
]

{ #category : #private }
DvtRTDataTableEditor >> resetInputs [
	nameTextinput text: String empty.
	xKeyTextInput text: String empty.
	yKeyTextInput text: String empty.
	shapeColorButton pickedColor: Color red.
	connectColorButton pickedColor: Color red.
	shapeTypeDropList setSelectedItem: DvtRTDataSetting availableShapeTypes first
]

{ #category : #private }
DvtRTDataTableEditor >> saveLastSelectedSetting [
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
DvtRTDataTableEditor >> settings: anOrderedCollectionOfDvtRTDataSetting [
	| dataSource |
	settings := anOrderedCollectionOfDvtRTDataSetting.
	dataSource := DvtRTDataSettingDataSource elements: settings.
	dataSource addColumnsTo: settingsDataTable widget.
	settingsDataTable widget dataSource: dataSource
]

{ #category : #accessing }
DvtRTDataTableEditor >> settingsDataTable [
	^ settingsDataTable
]

{ #category : #accessing }
DvtRTDataTableEditor >> shapeColorButton [
	^ shapeColorButton
]

{ #category : #accessing }
DvtRTDataTableEditor >> shapeTypeDropList [
	^ shapeTypeDropList
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
