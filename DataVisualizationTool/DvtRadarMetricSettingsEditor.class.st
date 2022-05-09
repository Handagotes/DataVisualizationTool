Class {
	#name : #DvtRadarMetricSettingsEditor,
	#superclass : #DvtVisualizationSettingsEditorDialog,
	#instVars : [
		'titleTextInput',
		'keyTextInput'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtRadarMetricSettingsEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #settingsDataTable;
			newRow: [ :row |
				row
					add: #titleTextInput;
					add: #keyTextInput
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #addButton;
					add: #removeButton
			] height: self buttonHeight;
			add: #closeButton height: self buttonHeight
	]
]

{ #category : #private }
DvtRadarMetricSettingsEditor >> createSettingFromInputs [
	^ DvtRadarMetricSetting new
		title: titleTextInput text;
		key: keyTextInput text
		yourself
]

{ #category : #private }
DvtRadarMetricSettingsEditor >> dvtDataSourceForSettings [
	^ DvtRadarMetricSettingDataSource elements: settings
]

{ #category : #api }
DvtRadarMetricSettingsEditor >> extent [
	^ 400 @ 300
]

{ #category : #initialization }
DvtRadarMetricSettingsEditor >> initializeWidgets [
	super initializeWidgets.
	titleTextInput := self newTextInput.
	keyTextInput := self newTextInput.
	titleTextInput autoAccept: true.
	keyTextInput autoAccept: true.
	
	self focusOrder
		add: settingsDataTable;
		add: titleTextInput;
		add: keyTextInput;
		add: addButton;
		add: removeButton;
		add: closeButton
]

{ #category : #accessing }
DvtRadarMetricSettingsEditor >> keyTextInput [
	^ keyTextInput
]

{ #category : #private }
DvtRadarMetricSettingsEditor >> onSettingSelected [
	| setting |
	setting := self selectedSetting.
	titleTextInput text: setting title.
	keyTextInput text: setting key
]

{ #category : #private }
DvtRadarMetricSettingsEditor >> resetInputs [
	titleTextInput text: String empty.
	keyTextInput text: String empty
]

{ #category : #private }
DvtRadarMetricSettingsEditor >> saveLastSelectedSetting [
	lastSelectedSetting
		title: titleTextInput text;
		key: keyTextInput text
]

{ #category : #accessing }
DvtRadarMetricSettingsEditor >> titleTextInput [
	^ titleTextInput
]
