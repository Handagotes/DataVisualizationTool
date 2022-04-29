Class {
	#name : #DvtScatterPlotVisualizationEditor,
	#superclass : #DvtGrapherVisualizationEditor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtScatterPlotVisualizationEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				
			]
	];
	yourself
]

{ #category : #api }
DvtScatterPlotVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| view |';
			
			nextPutAll: '^ view'
	]
]
