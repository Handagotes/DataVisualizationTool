Class {
	#name : #DvtRadarVisualizationEditor,
	#superclass : #DvtVisualizationEditor,
	#instVars : [
		'radarMetricSettings'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtRadarVisualizationEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				row
					add: #nameKeyTextLabel width: 150;
					add: #nameKeyText
			] height: self buttonHeight;
			add: #editRadarMetricSettingsButton height: self buttonHeight;
			add: #newNullPresenter
	];
	yourself
]

{ #category : #api }
DvtRadarVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| view |';
			
			nextPutAll: '^ view'
	]
]

{ #category : #initialization }
DvtRadarVisualizationEditor >> initializeWidgets [
	self
		addTextInput: #nameKeyText label: 'Ключ названия:';
		instantiatePresenters: { #editRadarMetricSettingsButton. #ButtonPresenter }.
	(widgets at: #editRadarMetricSettingsButton) label: 'Редактировать метрики'.
]

{ #category : #private }
DvtRadarVisualizationEditor >> loadConfigToWidgets [
	(widgets at: #nameKeyText) text: (config at: #sliceKeyText ifAbsentPut: [ '' ]).
	radarMetricSettings := config at: #radarMetricSettings ifAbsentPut: [ OrderedCollection new ].
	radarMetricSettings withIndexDo: [ :s :i |
		radarMetricSettings at: i put: (DvtRadarMetricSetting new
			title: (s at: #title ifAbsent: [ '' ]);
			key: (s at: #key ifAbsent: [ '' ]);
			yourself)
	]
]

{ #category : #api }
DvtRadarVisualizationEditor >> updateConfig [
	| settingsAsDicts |
	settingsAsDicts := radarMetricSettings collect: [ :s |
		{ 
			#title -> s title.
			#key -> s key.
		} asDictionary
	].
	(config at: #radarMetricSettings put: settingsAsDicts).
	config at: #nameKeyText put: (self keyFor: #nameKeyText)
]
