Class {
	#name : #DvtGraphVisualizationEditor,
	#superclass : #DvtGrapherVisualizationEditor,
	#instVars : [
		'rtDataSettings'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtGraphVisualizationEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				row
					add: #xTitleTextLabel width: 150;
					add: #xTitleText
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #yTitleTextLabel width: 150;
					add: #yTitleText
			] height: self buttonHeight;
			add: #editRTDataTableButton height: self buttonHeight;
			add: #newNullPresenter
	];
	yourself
]

{ #category : #private }
DvtGraphVisualizationEditor >> connectColorLineFor: setting dataName: dataName [
	| color |
	color := setting at: #connectColor.
	^ color alpha > 0
		ifTrue: [ ('{1} connectColor: {2}.{3}' format: { dataName. color storeString. String cr }) ]
		ifFalse: [ '' ]
]

{ #category : #private }
DvtGraphVisualizationEditor >> dotColorLineFor: setting dataName: dataName [
	| color |
	color := setting at: #dotColor.
	^ '{1} dotShape size: 3; color: {2}.{3}' format: { dataName. color storeString. String cr }
]

{ #category : #api }
DvtGraphVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| grapher sample '.
		1 to: rtDataSettings size do: [ :i | ws nextPutAll: ('data{1} ' format: { i }) ].
		ws
			nextPut: $|; cr;
			nextPutAll: 'grapher := RTGrapher new.'; cr;
			nextPutAll: self scriptSnippetForSampleLoad.
		rtDataSettings withIndexDo: [ :s :i | | dataName |
			dataName := 'data' , i asString.
			ws
				nextPutAll: dataName; nextPutAll: ' := RTData new.'; cr;
				nextPutAll: (self dotColorLineFor: s dataName: dataName);
				nextPutAll: dataName; nextPutAll: ' points: sample.'; cr;
				nextPutAll: (self xKeyLineFor: s dataName: dataName);
				nextPutAll: (self yKeyLineFor: s dataName: dataName);
				nextPutAll: (self connectColorLineFor: s dataName: dataName);
				nextPutAll: 'grapher add: '; nextPutAll: dataName; nextPut: $.; cr
		].
		ws
			nextPutAll: self xTitleLine;
			nextPutAll: self yTitleLine;
			"nextPutAll: 'grapher extent: 650 @ 650.'; cr;"
			nextPutAll: 'grapher build.'; cr;
			nextPutAll: '^ grapher view'; cr
	]
]

{ #category : #initialization }
DvtGraphVisualizationEditor >> initializePresenter [
	(widgets at: #editRTDataTableButton) action: [ self onEditRTDataTableButton ]
]

{ #category : #initialization }
DvtGraphVisualizationEditor >> initializeWidgets [
	self
		instantiatePresenters: { #editRTDataTableButton. #ButtonPresenter };
		addTextInput: #xTitleText label: 'Название оси абсцисс:';
		addTextInput: #yTitleText label: 'Название оси ординат:'.
	(widgets at: #editRTDataTableButton) label: 'Редактировать данные графика'
]

{ #category : #private }
DvtGraphVisualizationEditor >> loadConfigToWidgets [
	(widgets at: #xTitleText) text: (config at: #xTitleText ifAbsentPut: [ '' ]).
	(widgets at: #yTitleText) text: (config at: #yTitleText ifAbsentPut: [ '' ]).
	rtDataSettings := config at: #rtDataSettings ifAbsentPut: [ OrderedCollection new ].
	rtDataSettings do: [ :s |
		s at: #dotColor put: (Color fromArray: (s at: #dotColor ifAbsent: [ #(1 0 0) ])).
		s at: #connectColor put: (Color fromArray: (s at: #connectColor ifAbsent: [ #(1 0 0) ]))
	]
]

{ #category : #private }
DvtGraphVisualizationEditor >> onEditRTDataTableButton [
	DvtRTDataTableEditor openForSettings: rtDataSettings
]

{ #category : #api }
DvtGraphVisualizationEditor >> updateConfig [
	| settings |
	settings := rtDataSettings deepCopy.
	settings do: [ :s |
		s at: #dotColor put: (s at: #dotColor) asArray.
		s at: #connectColor put: (s at: #connectColor) asArray
	].
	(config at: #rtDataSettings put: settings).
	config at: #xTitleText put: (self textOf: #xTitleText).
	config at: #yTitleText put: (self textOf: #yTitleText).
]

{ #category : #private }
DvtGraphVisualizationEditor >> xKeyLineFor: setting dataName: dataName [
	| key |
	key := self class keyForString: (setting at: #xKey).
	^ key
		ifNotEmpty: [ ('{1} x: [ :e | e at: {2} ].{3}' format: { dataName. key. String cr }) ]
		ifEmpty: [ '' ]
]

{ #category : #private }
DvtGraphVisualizationEditor >> xTitleLine [
	| title |
	title := self textOf: #xTitleText.
	^ title
		ifNotEmpty: [ ('grapher axisX title: {1}.{2}' format: { title storeString. String cr }) ]
		ifEmpty: [ '' ]
]

{ #category : #private }
DvtGraphVisualizationEditor >> yKeyLineFor: setting dataName: dataName [
	| key |
	key := self class keyForString: (setting at: #yKey).
	^ key
		ifNotEmpty: [ ('{1} y: [ :e | e at: {2} ].{3}' format: { dataName. key. String cr }) ]
		ifEmpty: [ '' ]
]

{ #category : #private }
DvtGraphVisualizationEditor >> yTitleLine [
	| title |
	title := self textOf: #yTitleText.
	^ title
		ifNotEmpty: [ ('grapher axisY title: {1}.{2}' format: { title storeString. String cr }) ]
		ifEmpty: [ '' ]
]
