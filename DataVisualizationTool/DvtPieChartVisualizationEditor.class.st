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
			newRow: [ :row |
				row
					add: #legendTitleTextLabel width: 100;
					add: #legendTitleText
			] height: self buttonHeight;
			add: #newNullPresenter
	]
]

{ #category : #api }
DvtPieChartVisualizationEditor >> generateScript [
	| legendTextLine |
	legendTextLine := self legendTextLine.
	^ String streamContents: [ :ws |
		ws
			nextPutAll: ('| pie sample normalizer {1}|' format: { legendTextLine ifNotEmpty: [ 'legend ' ] ifEmpty: [ '' ] }); cr;
			nextPutAll: 'pie := RTPieBuilder new.'; cr;
			nextPutAll: self sampleLoadLine;
			nextPutAll: 'normalizer := RTMultiLinearColorForIdentity new objects: sample.'; cr;
			nextPutAll: 'pie objects: sample.'; cr;
			nextPutAll: 'pie shape color: [ :e | normalizer rtValue: e ].'; cr;
			nextPutAll: self sliceKeyLine;
			nextPutAll: 'pie normalizer distinctColor.'; cr;
			nextPutAll: self labelKeyLine;
			nextPutAll: 'pie build.'; cr;
			nextPutAll: legendTextLine;
			nextPutAll: '^ pie view'
	]
]

{ #category : #initialization }
DvtPieChartVisualizationEditor >> initializeWidgets [
	self
		addTextInput: #sliceKeyText label: 'Ключ сектора:';
		addTextInput: #labelKeyText label: 'Ключ надписи:';
		addTextInput: #legendTitleText label: 'Текст легенды:'
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
DvtPieChartVisualizationEditor >> legendTextLine [
	| text label |
	(text := self textOf: #legendTitleText) ifEmpty: [ ^ '' ].
	label := self keyFor: #labelKeyText.
	label := label
		ifNotEmpty: [ '(e at: {1})' format: { label } ]
		ifEmpty: [ 'e asString' ].
	^ String streamContents: [ :ws |
		ws
			nextPutAll: 'legend := RTLegendBuilder new.'; cr;
			nextPutAll: 'legend view: pie view.'; cr;
			nextPutAll: ('legend addText: {1}.' format: { text storeString }); cr;
			nextPutAll: 'sample do: [ :e | | color |'; cr;
			nextPutAll: '	color := (pie view elementFromModel: e) trachelShape color.'; cr;
			nextPutAll: ('	legend addColor: color text: {1}.' format: { label }); cr;
			nextPutAll: '].'; cr;
			nextPutAll: 'legend build.'; cr
	]
]

{ #category : #private }
DvtPieChartVisualizationEditor >> loadConfigToWidgets [
	(widgets at: #sliceKeyText) text: (config at: #sliceKeyText ifAbsentPut: [ '' ]).
	(widgets at: #labelKeyText) text: (config at: #labelKeyText ifAbsentPut: [ '' ]).
	(widgets at: #legendTitleText) text: (config at: #legendTitleText ifAbsentPut: [ '' ])
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
	config at: #labelKeyText put: (self keyFor: #labelKeyText).
	config at: #legendTitleText put: (self textOf: #legendTitleText)
]
