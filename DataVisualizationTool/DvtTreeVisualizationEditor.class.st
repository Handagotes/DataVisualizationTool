Class {
	#name : #DvtTreeVisualizationEditor,
	#superclass : #DvtVisualizationEditor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtTreeVisualizationEditor class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				
			]
	];
	yourself
]

{ #category : #api }
DvtTreeVisualizationEditor >> generateScript [
	^ String streamContents: [ :ws |
		ws
			nextPutAll: '| view |';
			
			nextPutAll: '^ view'
	]
]
