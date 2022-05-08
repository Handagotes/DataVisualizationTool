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
DvtRadarMetricSettingsEditor >> dvtDataSourceForSettings [
	^ DvtRadarMetricSettingDataSource elements: settings
]

{ #category : #initialization }
DvtRadarMetricSettingsEditor >> initializePresenter [
	super initializePresenter.
	
]

{ #category : #initialization }
DvtRadarMetricSettingsEditor >> initializeWidgets [
	super initializeWidgets.
	
]
