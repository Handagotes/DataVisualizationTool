Class {
	#name : #DvtPieChartVisualizationEditor,
	#superclass : #DvtVisualizationEditor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtPieChartVisualizationEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				row
					add: #sliceKeyTextLabel width: 100;
					add: #sliceKeyText
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #labelKeyTextLabel width: 100;
					add: #labelKeyText
			] height: self buttonHeight;
			add: #newNullPresenter
	]
]

{ #category : #api }
DvtPieChartVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| pie sample |'; cr;
			nextPutAll: 'pie := RTPieBuilder new.'; cr;
			nextPutAll: 'pie interaction popup.'; cr;
			nextPutAll: self scriptSnippetForSampleLoad;
			nextPutAll: 'pie objects: sample.'; cr;
			nextPutAll: self sliceKeyLine;
			nextPutAll: 'pie normalizer distinctColor.'; cr;
			nextPutAll: self labelKeyLine;
			nextPutAll: 'pie build.'; cr;
			nextPutAll: '^ pie view'
	]
]

{ #category : #initialization }
DvtPieChartVisualizationEditor >> initializeWidgets [
	self
		addTextInput: #sliceKeyText label: 'Ключ сектора:';
		addTextInput: #labelKeyText label: 'Ключ надписи:'
]

{ #category : #private }
DvtPieChartVisualizationEditor >> labelKeyLine [
	| key |
	key := self keyFor: #labelKeyText.
	^ key
		ifNotEmpty: [ ('pie labeled: [ :e | e at: {1} ].{2}' format: { key. String cr }) ]
		ifEmpty: [ '' ]
]

{ #category : #private }
DvtPieChartVisualizationEditor >> loadConfigToWidgets [
	(widgets at: #sliceKeyText) text: (config at: #sliceKeyText ifAbsent: [ '' ]).
	(widgets at: #labelKeyText) text: (config at: #labelKeyText ifAbsent: [ '' ])
]

{ #category : #private }
DvtPieChartVisualizationEditor >> sliceKeyLine [
	| key |
	key := self keyFor: #sliceKeyText.
	^ key
		ifNotEmpty: [ ('pie slice: [ :e | e at: {1} ].{2}' format: { key. String cr }) ]
		ifEmpty: [ '' ]
]

{ #category : #api }
DvtPieChartVisualizationEditor >> updateConfig [
	config at: #sliceKeyText put: (self keyFor: #sliceKeyText).
	config at: #labelKeyText put: (self keyFor: #labelKeyText)
]
