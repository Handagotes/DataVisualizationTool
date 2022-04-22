Class {
	#name : #RTDraggableSnapToRectangularGrid,
	#superclass : #RTDraggableSnapToGrid,
	#category : #'DataVisualizationTool-Util'
}

{ #category : #initialization }
RTDraggableSnapToRectangularGrid >> defaultGridSize [
	^ 20 @ 10
]

{ #category : #accessing }
RTDraggableSnapToRectangularGrid >> gridSize: size [
	gridSize := size
]

{ #category : #accessing }
RTDraggableSnapToRectangularGrid >> gridSizeFor: anElement [
	^ gridSize
]

{ #category : #hooks }
RTDraggableSnapToRectangularGrid >> initializeElementForCenter: element [
	| totalD spacing|
	totalD := 0 @ 0.
	element when: TRMouseDragStart do: [ :event | totalD := 0 @ 0 ].
	spacing := self gridSizeFor: element.
	element
		when: TRMouseDragging
		do:
			[ :event | 
			| d t |
			t := RTGroup withAll: groupToDrag.
			(t includes: element)
				ifFalse: [ t add: element ].
			d := element encompassingRectangle center.
			d := d + (element view canvas camera distanceFromPixelToSpace: event step).
			totalD := totalD + d.
			d := spacing * (totalD // spacing).
			totalD := totalD - d.
			d := d - element encompassingRectangle center.
			t translateBy: d.
			event signalUpdate ]
]

{ #category : #hooks }
RTDraggableSnapToRectangularGrid >> initializeElementForTopLeft: element [
	| totalD spacing|
	totalD := 0 @ 0.
	element when: TRMouseDragStart do: [ :event | totalD := 0 @ 0 ].
	spacing := self gridSizeFor: element.
	element
		when: TRMouseDragging
		do:
			[ :event |
			| d t |
			t := RTGroup withAll: groupToDrag.
			(t includes: element)
				ifFalse: [ t add: element ].
			d := element encompassingRectangle topLeft.
			d := d + (element view canvas camera distanceFromPixelToSpace: event step).
			totalD := totalD + d.
			d := spacing * (totalD // spacing).
			totalD := totalD - d.
			d := d - element encompassingRectangle topLeft.
			t translateBy: d.
			event signalUpdate ]
]
