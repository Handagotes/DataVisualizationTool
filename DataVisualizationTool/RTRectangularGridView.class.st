Class {
	#name : #RTRectangularGridView,
	#superclass : #RTGridView,
	#instVars : [
		'mustDrawCenterMarker'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #initialization }
RTRectangularGridView class >> defaultGridSize [
	^ 20 @ 10
]

{ #category : #adding }
RTRectangularGridView >> addCenterMarkerTo: aCanvas [
	mustDrawCenterMarker ifTrue: [ super addCenterMarkerTo: aCanvas ]
]

{ #category : #adding }
RTRectangularGridView >> addGridShapeTo: aCanvas [
	gridShape := TRCanvasRectangularGridShape new.
	gridShape spacing: gridSize.
	gridShape dashes: self dashes.
	gridShape color: self color.
	aCanvas addShape: gridShape
]

{ #category : #accessing }
RTRectangularGridView >> gridSize: size [
	gridSize := size
]

{ #category : #initialization }
RTRectangularGridView >> initialize [
	super initialize.
	mustDrawCenterMarker := true
]

{ #category : #accessing }
RTRectangularGridView >> mustDrawCenterMarker: aBoolean [
	mustDrawCenterMarker := aBoolean
]
