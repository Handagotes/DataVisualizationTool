Class {
	#name : #DvtRTDataSettingsEditor,
	#superclass : #DvtVisualizationSettingsEditorDialog,
	#instVars : [
		'nameTextinput',
		'xKeyTextInput',
		'yKeyTextInput',
		'shapeColorButton',
		'connectColorButton',
		'shapeTypeDropList'
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

{ #category : #accessing }
DvtRTDataSettingsEditor >> connectColorButton [
	^ connectColorButton
]

{ #category : #private }
DvtRTDataSettingsEditor >> dvtDataSourceForSettings [
	^ DvtRTDataSettingDataSource elements: settings
]

{ #category : #api }
DvtRTDataSettingsEditor >> extent [
	^ 780 @ 300
]

{ #category : #initialization }
DvtRTDataSettingsEditor >> initializePresenter [
	super initializePresenter.
	nameTextinput whenTextChanged: [ self onNameTextInputTextChanged ]
]

{ #category : #initialization }
DvtRTDataSettingsEditor >> initializeWidgets [
	super initializeWidgets.
	nameTextinput := self newTextInput.
	xKeyTextInput := self newTextInput.
	yKeyTextInput := self newTextInput.
	shapeColorButton := self newColorPickerButton.
	connectColorButton := self newColorPickerButton.
	shapeTypeDropList := self newDropList.
	
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
	addButton label: 'Добавить данные графика'; disable.
	removeButton label: 'Удалить данные графика'.
	
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
		yourself)
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
	settings remove: setting
]

{ #category : #private }
DvtRTDataSettingsEditor >> onSettingSelected [
	| setting |
	setting := self selectedSetting.
	nameTextinput text: setting name.
	xKeyTextInput text: setting xKey.
	yKeyTextInput text: setting yKey.
	shapeColorButton
		pickedColor: setting shapeColor;
		enable.
	connectColorButton
		pickedColor: setting connectColor;
		enable.
	shapeTypeDropList setSelectedItem: setting shapeType
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

{ #category : #accessing }
DvtRTDataSettingsEditor >> shapeColorButton [
	^ shapeColorButton
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> shapeTypeDropList [
	^ shapeTypeDropList
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> xKeyTextInput [
	^ xKeyTextInput
]

{ #category : #accessing }
DvtRTDataSettingsEditor >> yKeyTextInput [
	^ yKeyTextInput
]
