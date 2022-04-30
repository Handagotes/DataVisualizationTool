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
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| grapher data sample |'; cr;
			nextPutAll: 'grapher := RTGrapher new.'; cr;
			nextPutAll: 'data := RTData new.'; cr;
			nextPutAll: ('data dotShape size: 5; color: {1}.' format: { self pickedColorFor: #dotColorButton }); cr;
			nextPutAll: self scriptSnippetForSampleLoad; cr;
			nextPutAll: 'data points: sample.'; cr;
			nextPutAll: 'data connectColor: Color red.'; cr;
			nextPutAll: ('data x: [ :e | e at: {1} ].' format: { self keyFor: #xKeyText }); cr;
			nextPutAll: ('data y: [ :e | e at: {1} ].' format: { self keyFor: #yKeyText }); cr;
			nextPutAll: ('data connectColor: {1}.' format: { self pickedColorFor: #connectColorButton }); cr;
			nextPutAll: 'grapher add: data.'; cr;
			nextPutAll: 'grapher extent: 350 @ 350.'; cr;
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
