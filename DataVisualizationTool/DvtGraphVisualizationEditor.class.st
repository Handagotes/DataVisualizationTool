Class {
	#name : #DvtGraphVisualizationEditor,
	#superclass : #DvtGrapherVisualizationEditor,
	#instVars : [
		'xKeyLabel',
		'xKeyTextInput',
		'yKeyLabel',
		'yKeyTextInput'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtGraphVisualizationEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				row
					add: #xKeyLabel;
					add: #xKeyTextInput
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #yKeyLabel;
					add: #yKeyTextInput
			] height: self buttonHeight;
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
			nextPutAll: self scriptSnippetForSampleLoad; cr;
			nextPutAll: 'data points: sample.'; cr;
			nextPutAll: 'data connectColor: Color red.'; cr.
		xKeyTextInput text ifNotEmpty: [ 
			ws nextPutAll: 'data x: #'; nextPutAll: xKeyTextInput text; nextPut: $.; cr.
		].
		yKeyTextInput text ifNotEmpty: [ 
			ws nextPutAll: 'data y: #'; nextPutAll: yKeyTextInput text; nextPut: $.; cr
		].
		ws
			nextPutAll: 'grapher add: data.'; cr;
			nextPutAll: 'grapher build.'; cr;
			nextPutAll: '^ grapher view'; cr
	]
]

{ #category : #initialization }
DvtGraphVisualizationEditor >> initializeWidgets [
	xKeyLabel := self newLabel.
	yKeyLabel := self newLabel.
	xKeyTextInput := self newTextInput.
	yKeyTextInput := self newTextInput.
	
	xKeyLabel label: 'Ключ оси абсцисс:'.
	yKeyLabel label: 'Ключ оси ординат:'.
	xKeyTextInput autoAccept: true.
	yKeyTextInput autoAccept: true
]

{ #category : #accessing }
DvtGraphVisualizationEditor >> xKeyLabel [
	^ xKeyLabel
]

{ #category : #accessing }
DvtGraphVisualizationEditor >> xKeyTextInput [
	^ xKeyTextInput
]

{ #category : #accessing }
DvtGraphVisualizationEditor >> yKeyLabel [
	^ yKeyLabel
]

{ #category : #accessing }
DvtGraphVisualizationEditor >> yKeyTextInput [
	^ yKeyTextInput
]
