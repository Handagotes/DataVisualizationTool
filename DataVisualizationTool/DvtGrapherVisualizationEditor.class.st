Class {
	#name : #DvtGrapherVisualizationEditor,
	#superclass : #DvtVisualizationEditor,
	#instVars : [
		'rtDataSettings'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtGrapherVisualizationEditor class >> defaultSpec [
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
			add: #legendCheckBox height: self buttonHeight;
			add: #newNullPresenter
	];
	yourself
]

{ #category : #api }
DvtGrapherVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| grapher sample '.
		1 to: rtDataSettings size do: [ :i | ws nextPutAll: ('data{1} ' format: { i }) ].
		ws
			nextPut: $|; cr;
			nextPutAll: 'grapher := RTGrapher new.'; cr;
			nextPutAll: self sampleLoadLine.
		rtDataSettings withIndexDo: [ :s :i |
			s variableName: 'data' , i asString.
			ws
				nextPutAll: s createLine;
				nextPutAll: s labelLine;
				nextPutAll: s shapeColorLine;
				nextPutAll: s variableName; nextPutAll: ' points: sample.'; cr;
				nextPutAll: s xKeyLine;
				nextPutAll: s yKeyLine;
				nextPutAll: s connectColorLine;
				nextPutAll: 'grapher add: '; nextPutAll: s variableName; nextPut: $.; cr
		].
		ws
			nextPutAll: self xTitleLine;
			nextPutAll: self yTitleLine;
			nextPutAll: self legendLine;
			nextPutAll: 'grapher build.'; cr;
			nextPutAll: '^ grapher view'; cr
	]
]

{ #category : #initialization }
DvtGrapherVisualizationEditor >> initializePresenter [
	(widgets at: #editRTDataTableButton) action: [ self onEditRTDataTableButton ]
]

{ #category : #initialization }
DvtGrapherVisualizationEditor >> initializeWidgets [
	self
		instantiatePresenters: { #editRTDataTableButton. #ButtonPresenter };
		addTextInput: #xTitleText label: 'Название оси абсцисс:';
		addTextInput: #yTitleText label: 'Название оси ординат:';
		addCheckBox: #legendCheckBox label: 'Добавить легенду' checked: false.
	(widgets at: #editRTDataTableButton) label: 'Редактировать данные графика'
]

{ #category : #private }
DvtGrapherVisualizationEditor >> legendLine [
	^ (self isChecked: #legendCheckBox)
		ifTrue: [ 'grapher legend.' , String cr ]
		ifFalse: [ '' ]
]

{ #category : #private }
DvtGrapherVisualizationEditor >> loadConfigToWidgets [
	(widgets at: #xTitleText) text: (config at: #xTitleText ifAbsentPut: [ '' ]).
	(widgets at: #yTitleText) text: (config at: #yTitleText ifAbsentPut: [ '' ]).
	(widgets at: #legendCheckBox) state: (config at: #legend ifAbsentPut: [ false ]).
	rtDataSettings := config at: #rtDataSettings ifAbsentPut: [ OrderedCollection new ].
	rtDataSettings withIndexDo: [ :s :i |
		rtDataSettings at: i put: (DvtRTDataSetting new
			name: (s at: #name ifAbsent: [ '' ]);
			xKey: (s at: #xKey ifAbsent: [ '' ]);
			yKey: (s at: #yKey ifAbsent: [ '' ]);
			shapeColor: (Color fromArray: (s at: #shapeColor ifAbsent: [ #(1 0 0) ]));
			connectColor: (Color fromArray: (s at: #connectColor ifAbsent: [ #(1 0 0) ]));
			shapeType: (s at: #shapeType ifAbsent: [ DvtRTDataSetting availableShapeTypes first ]);
			yourself)
	]
]

{ #category : #private }
DvtGrapherVisualizationEditor >> onEditRTDataTableButton [
	DvtRTDataTableEditor openForSettings: rtDataSettings
]

{ #category : #api }
DvtGrapherVisualizationEditor >> updateConfig [
	| settingsAsDicts |
	settingsAsDicts := rtDataSettings collect: [ :s |
		{ 
			#name -> s name.
			#xKey -> s xKey.
			#yKey -> s yKey.
			#shapeColor -> s shapeColor asArray.
			#connectColor -> s connectColor asArray.
			#shapeType -> s shapeType.
		} asDictionary
	].
	(config at: #rtDataSettings put: settingsAsDicts).
	config at: #xTitleText put: (self textOf: #xTitleText).
	config at: #yTitleText put: (self textOf: #yTitleText).
	config at: #legend put: (self isChecked: #legendCheckBox)
]

{ #category : #private }
DvtGrapherVisualizationEditor >> xTitleLine [
	| title |
	title := self textOf: #xTitleText.
	^ title
		ifNotEmpty: [ ('grapher axisX title: {1}.{2}' format: { title storeString. String cr }) ]
		ifEmpty: [ '' ]
]

{ #category : #private }
DvtGrapherVisualizationEditor >> yTitleLine [
	| title |
	title := self textOf: #yTitleText.
	^ title
		ifNotEmpty: [ ('grapher axisY title: {1}.{2}' format: { title storeString. String cr }) ]
		ifEmpty: [ '' ]
]
