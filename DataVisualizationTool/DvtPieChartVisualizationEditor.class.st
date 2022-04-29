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
