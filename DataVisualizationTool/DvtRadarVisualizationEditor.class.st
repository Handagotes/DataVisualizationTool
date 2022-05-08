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

{ #category : #private }
DvtRadarVisualizationEditor >> addLegendColorLine [
	^ 'sample do: [ :e | legend addColor: (normalizer rtValue: e) text: (e at: {1}) ].{2}' format: { 
		self keyFor: #nameKeyText.
		String cr
	}
]

{ #category : #api }
DvtRadarVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| radar sample normalizer legend |'; cr;
			nextPutAll: 'radar := RTKiviatBuilder new.'; cr;
			nextPutAll: self sampleLoadLine;
			nextPutAll: 'radar objects: sample.'; cr;
			nextPutAll: self createNormalizerLine;
			nextPutAll: 'radar shape circle color: [ :e | normalizer rtValue: e kiviatNode named ]; size: 5.'; cr.
		radarMetricSettings do: [ :s |
			s variableName: 'radar'.
			ws nextPutAll: s addMetricLine
		].
		ws
			nextPutAll: 'radar activateAxisTitle; activatePolygons; build.'; cr;
			nextPutAll: 'legend := RTLegendBuilder new.'; cr;
			nextPutAll: 'legend view: radar view.'; cr;
			nextPutAll: self addLegendColorLine;
			nextPutAll: 'legend build.'; cr;
			nextPutAll: '^ radar view'
	]
]

{ #category : #initialization }
DvtRadarVisualizationEditor >> initializePresenter [
	(widgets at: #editRadarMetricSettingsButton) action: [ self onEditRadarMetricSettingsButtonAction ]
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
	(widgets at: #nameKeyText) text: (config at: #nameKeyText ifAbsentPut: [ '' ]).
	radarMetricSettings := config at: #radarMetricSettings ifAbsentPut: [ OrderedCollection new ].
	radarMetricSettings withIndexDo: [ :s :i |
		radarMetricSettings at: i put: (DvtRadarMetricSetting new
			title: (s at: #title ifAbsent: [ '' ]);
			key: (s at: #key ifAbsent: [ '' ]);
			yourself)
	]
]

{ #category : #private }
DvtRadarVisualizationEditor >> onEditRadarMetricSettingsButtonAction [
	DvtRadarMetricSettingsEditor openForSettings: radarMetricSettings
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
