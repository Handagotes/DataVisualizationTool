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
					add: #xKeyTextLabel width: 125;
					add: #xKeyText
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #yKeyTextLabel width: 125;
					add: #yKeyText
			] height: self buttonHeight;
			add: #dotColorButton height: self buttonHeight;
			add: #connectColorButton height: self buttonHeight;
			add: #newNullPresenter
	];
	yourself
]

{ #category : #api }
DvtGraphVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws | | xKey yKey dotColor connectColor |
		xKey := self keyFor: #xKeyText.
		yKey := self keyFor: #yKeyText.
		dotColor := self pickedColorFor: #dotColorButton.
		connectColor := self pickedColorFor: #connectColorButton.
		ws
			nextPutAll: '| grapher data sample |'; cr;
			nextPutAll: 'grapher := RTGrapher new.'; cr;
			nextPutAll: 'data := RTData new.'; cr.
		dotColor = Color transparent ifFalse: [ ws nextPutAll: ('data dotShape size: 5; color: {1}.' format: { dotColor }); cr ].
		ws
			nextPutAll: self scriptSnippetForSampleLoad; cr;
			nextPutAll: 'data points: sample.'; cr;
			nextPutAll: 'data connectColor: Color red.'; cr.
		xKey ifNotEmpty: [ ws nextPutAll: ('data x: [ :e | e at: {1} ].' format: { xKey }); cr ].
		yKey ifNotEmpty: [ ws nextPutAll: ('data y: [ :e | e at: {1} ].' format: { yKey }); cr ].
		connectColor = Color transparent ifFalse: [ ws nextPutAll: ('data connectColor: {1}.' format: { connectColor }); cr ].
		ws
			nextPutAll: 'grapher add: data.'; cr;
			nextPutAll: 'grapher extent: 650 @ 650.'; cr;
			nextPutAll: 'grapher build.'; cr;
			nextPutAll: '^ grapher view'; cr
	]
]

{ #category : #initialization }
DvtGraphVisualizationEditor >> initializeWidgets [
	self
		addKeyTextInput: #xKeyText label: 'Ключ оси абсцисс:';
		addKeyTextInput: #yKeyText label: 'Ключ оси ординат:';
		addColorPickButton: #dotColorButton label: 'Цвет точек' defaultColor: Color red;
		addColorPickButton: #connectColorButton label: 'Цвет линий' defaultColor: Color red.
]
