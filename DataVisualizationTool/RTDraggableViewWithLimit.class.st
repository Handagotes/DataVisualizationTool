Class {
	#name : #RTDraggableViewWithLimit,
	#superclass : #RTDraggableView,
	#instVars : [
		'limitRect',
		'view',
		'move',
		'mouseBlock',
		'draggingBlock',
		'dragEndBlock'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #'instance creation' }
RTDraggableViewWithLimit class >> allWithLimit: aRect [
	^ self all
		limitRect: aRect;
		yourself
]

{ #category : #'instance creation' }
RTDraggableViewWithLimit class >> leftWithLimit: aRect [
	^ self left
		limitRect: aRect;
		yourself
]

{ #category : #'instance creation' }
RTDraggableViewWithLimit class >> middleWithLimit: aRect [
	^ self middle
		limitRect: aRect;
		yourself
]

{ #category : #'instance creation' }
RTDraggableViewWithLimit class >> rightWithLimit: aRect [
	^ self right
		limitRect: aRect;
		yourself
]

{ #category : #api }
RTDraggableViewWithLimit >> coverElementEvents: anElement [
	anElement
		when: self mouse do: mouseBlock;
		when: TRMouseDragEnd do: dragEndBlock;
		when: TRMouseDragging do: draggingBlock
]

{ #category : #initialization }
RTDraggableViewWithLimit >> initialize [
	super initialize.
	limitRect := (-200 @ -200) corner: (200 @ 200).
	move := false.
	mouseBlock := [ move := true].
	dragEndBlock := [ move := false ].
	draggingBlock := [ :e |
		move ifTrue: [ | camera |
			(camera := view canvas camera)
				translateBy: e step negated / camera scale;
				translateBy: (camera viewCanvasRect amountToTranslateWithin: limitRect).
			view canvas signalUpdate
		]
	]
]

{ #category : #hooks }
RTDraggableViewWithLimit >> initializeElement: aView [
	view := aView.
	view canvas
		when: self mouse do: mouseBlock;
		when: TRMouseDragEnd do: dragEndBlock;
		when: TRMouseDragging do: draggingBlock
]

{ #category : #testing }
RTDraggableViewWithLimit >> isCameraOutsideLimits [
	^ (limitRect intersects: view canvas camera viewCanvasRect) not
]

{ #category : #accessing }
RTDraggableViewWithLimit >> limitRect [
	^ limitRect
]

{ #category : #accessing }
RTDraggableViewWithLimit >> limitRect: anObject [
	limitRect := anObject
]

{ #category : #api }
RTDraggableViewWithLimit >> moveCameraToLimitCenter [
	view canvas camera translateTo: limitRect center
]

{ #category : #api }
RTDraggableViewWithLimit >> moveCameraToLimitTopLeft [
	view canvas camera translateTo: limitRect topLeft + (view canvas extent // 2)
]
