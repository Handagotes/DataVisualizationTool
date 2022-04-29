Class {
	#name : #DvtBarChartVisualizationEditor,
	#superclass : #DvtGrapherVisualizationEditor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtBarChartVisualizationEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				
			]
	];
	yourself
]

{ #category : #api }
DvtBarChartVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| view |';
			
			nextPutAll: '^ view'
	]
]
