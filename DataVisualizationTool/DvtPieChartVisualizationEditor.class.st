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
				row add: #dotColorButton
			]
	];
	yourself
]

{ #category : #api }
DvtPieChartVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| view |';
			
			nextPutAll: '^ view'
	]
]

{ #category : #initialization }
DvtPieChartVisualizationEditor >> initializeWidgets [
	self addColorPickButton: #dotColorButton label: 'Цвет точек' defaultColor: Color red
]
