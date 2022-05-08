Class {
	#name : #DvtVisualizationSettingsEditorDialog,
	#superclass : #DvtDialog,
	#instVars : [
		'settingsDataTable',
		'closeButton',
		'settings',
		'addButton',
		'removeButton',
		'lastSelectedSetting'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #'instance creation' }
DvtVisualizationSettingsEditorDialog class >> open [
	^ self openForSettings: OrderedCollection new
]

{ #category : #'instance creation' }
DvtVisualizationSettingsEditorDialog class >> openForSettings: anOrderedCollectionOfDvtSettings [
	^ self openDialogConfiguredAs: [ :dialog |
		dialog settings: anOrderedCollectionOfDvtSettings
	]
]

{ #category : #accessing }
DvtVisualizationSettingsEditorDialog >> addButton [
	^ addButton
]

{ #category : #accessing }
DvtVisualizationSettingsEditorDialog >> closeButton [
	^ closeButton
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> createSettingFromInputs [
	self subclassResponsibility
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> dvtDataSourceForSettings [
	self subclassResponsibility
]

{ #category : #initialization }
DvtVisualizationSettingsEditorDialog >> initializePresenter [
	settingsDataTable when: FTSelectionChanged do: [ self onSettingsDataTableSelectionChanged ].
	addButton action: [ self onAddButtonAction ].
	removeButton action: [ self onRemoveButtonAction ].
	closeButton action: [ self onCloseButtonAction ].
	self makeWindowUnresizeable
]

{ #category : #initialization }
DvtVisualizationSettingsEditorDialog >> initializeWidgets [
	settingsDataTable := self newDataTable.
	closeButton := self newButton.
	settingsDataTable widget beSingleSelection.
	closeButton label: 'Закрыть'.
	addButton := self newButton.
	removeButton := self newButton.
	addButton
		label: '+';
		enable.
	removeButton
		label: '-';
		disable
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> onAddButtonAction [
	| setting |
	self selectedSettingIndex > 0 ifTrue: [ ^ self ].
	(setting := self createSettingFromInputs) ifNil: [ ^ self ].
	settings add: setting.
	self
		resetInputs;
		updateSettingsDataTable
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> onCloseButtonAction [
	lastSelectedSetting ifNotNil: [ self saveLastSelectedSetting ].
	self closeDialog: settings
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> onRemoveButtonAction [
	| setting |
	(setting := self selectedSetting) ifNil: [ ^ self ].
	settings remove: setting.
	self
		resetInputs;
		updateSettingsDataTable.
		settingsDataTable widget selectRowIndex: 0
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> onSettingSelected [
	self subclassResponsibility
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> onSettingsDataTableSelectionChanged [
	| setting |
	setting := self selectedSetting.
	setting == lastSelectedSetting ifFalse: [ 
		lastSelectedSetting ifNotNil: [ self saveLastSelectedSetting ].
		lastSelectedSetting := setting
	].
	setting ifNil: [ 
		self resetInputs.
		addButton enable.
		removeButton disable
	] ifNotNil: [ 
		self onSettingSelected.
		addButton disable.
		removeButton enable
	]
]

{ #category : #accessing }
DvtVisualizationSettingsEditorDialog >> removeButton [
	^ removeButton
]

{ #category : #initialization }
DvtVisualizationSettingsEditorDialog >> resetInputs [
	self subclassResponsibility
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> saveLastSelectedSetting [
	self subclassResponsibility
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> selectedSetting [
	| i |
	(i := self selectedSettingIndex) isZero ifTrue: [ ^ nil ].
	^ settingsDataTable widget dataSource elementAt: i
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> selectedSettingIndex [
	^ settingsDataTable widget selectedRowIndex
]

{ #category : #accessing }
DvtVisualizationSettingsEditorDialog >> settings [
	^ settings
]

{ #category : #accessing }
DvtVisualizationSettingsEditorDialog >> settings: anOrderedCollectionOfSettings [
	| dataSource |
	settings := anOrderedCollectionOfSettings.
	dataSource := self dvtDataSourceForSettings.
	dataSource addColumnsTo: settingsDataTable widget.
	settingsDataTable widget dataSource: dataSource
]

{ #category : #accessing }
DvtVisualizationSettingsEditorDialog >> settingsDataTable [
	^ settingsDataTable
]

{ #category : #private }
DvtVisualizationSettingsEditorDialog >> updateSettingsDataTable [
	settingsDataTable widget refresh
]
