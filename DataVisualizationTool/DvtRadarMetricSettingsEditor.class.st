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

{ #category : #initialization }
DvtRadarMetricSettingsEditor >> resetInputs [
	titleTextInput text: String empty.
	keyTextInput text: String empty
]
