Class {
	#name : #DvtPieChartVisualizationEditor,
	#superclass : #DvtVisualizationEditor,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtPieChartVisualizationEditor class >> defaultSpec [
	
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
	
]
