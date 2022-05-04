Class {
	#name : #DvtGraphVisualizationEditor,
	#superclass : #DvtGrapherVisualizationEditor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtGraphVisualizationEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				row
					add: #xKeyTextLabel width: 150;
					add: #xKeyText
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #yKeyTextLabel width: 150;
					add: #yKeyText
			] height: self buttonHeight;
			add: #dotColorButton height: self buttonHeight;
			add: #connectColorButton height: self buttonHeight;
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
			add: #newNullPresenter
	];
	yourself
]

{ #category : #private }
DvtGraphVisualizationEditor >> connectColorLine [
	| color |
	color := self pickedColorFor: #connectColorButton.
	^ color alpha > 0
		ifTrue: [ ('data connectColor: {1}.{2}' format: { color storeString. String cr }) ]
		ifFalse: [ '' ]
]

{ #category : #private }
DvtGraphVisualizationEditor >> dotColorLine [
	| color |
	color := self pickedColorFor: #dotColorButton.
	^ 'data dotShape size: 5; color: {1}.{2}' format: { color storeString. String cr }
]

{ #category : #api }
DvtGraphVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| grapher data sample |'; cr;
			nextPutAll: 'grapher := RTGrapher new.'; cr;
			nextPutAll: 'data := RTData new.'; cr;
			nextPutAll: self dotColorLine;
			nextPutAll: self scriptSnippetForSampleLoad;
			nextPutAll: 'data points: sample.'; cr;
			nextPutAll: self xKeyLine;
			nextPutAll: self yKeyLine;
			nextPutAll: self connectColorLine;
			nextPutAll: 'grapher add: data.'; cr;
			nextPutAll: self xTitleLine;
			nextPutAll: self yTitleLine;
			"nextPutAll: 'grapher extent: 650 @ 650.'; cr;"
			nextPutAll: 'grapher build.'; cr;
			nextPutAll: '^ grapher view'; cr
	]
]

{ #category : #initialization }
DvtGraphVisualizationEditor >> initializeWidgets [
	self
		addTextInput: #xKeyText label: 'Ключ оси абсцисс:';
		addTextInput: #yKeyText label: 'Ключ оси ординат:';
		addColorPickButton: #dotColorButton label: 'Цвет точек' defaultColor: Color red;
		addColorPickButton: #connectColorButton label: 'Цвет линий' defaultColor: Color red;
		addTextInput: #xTitleText label: 'Название оси абсцисс:';
		addTextInput: #yTitleText label: 'Название оси ординат:'
]

{ #category : #private }
DvtGraphVisualizationEditor >> loadConfigToWidgets [
	(widgets at: #xKeyText) text: (config at: #xKeyText ifAbsent: [ '' ]).
	(widgets at: #yKeyText) text: (config at: #yKeyText ifAbsent: [ '' ]).
	(widgets at: #dotColorButton) pickedColor: (Color fromArray: (config at: #dotColor ifAbsent: [ #(1 0 0) ])).
	(widgets at: #connectColorButton) pickedColor: (Color fromArray: (config at: #connectColor ifAbsent: [ #(1 0 0) ])).
	(widgets at: #xTitleText) text: (config at: #xTitleText ifAbsent: [ '' ]).
	(widgets at: #yTitleText) text: (config at: #yTitleText ifAbsent: [ '' ])
]

{ #category : #api }
DvtGraphVisualizationEditor >> updateConfig [
	config at: #xKeyText put: (self keyFor: #xKeyText).
	config at: #yKeyText put: (self keyFor: #yKeyText).
	config at: #dotColor put: (self pickedColorFor: #dotColorButton) asArray.
	config at: #connectColor put: (self pickedColorFor: #connectColorButton) asArray.
	config at: #xTitleText put: (self textOf: #xTitleText).
	config at: #yTitleText put: (self textOf: #yTitleText)
]

{ #category : #private }
DvtGraphVisualizationEditor >> xKeyLine [
	| key |
	key := self keyFor: #xKeyText.
	^ key
		ifNotEmpty: [ ('data x: [ :e | e at: {1} ].{2}' format: { key. String cr }) ]
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
DvtGraphVisualizationEditor >> yKeyLine [
	| key |
	key := self keyFor: #yKeyText.
	^ key
		ifNotEmpty: [ ('data y: [ :e | e at: {1} ].{2}' format: { key. String cr }) ]
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
