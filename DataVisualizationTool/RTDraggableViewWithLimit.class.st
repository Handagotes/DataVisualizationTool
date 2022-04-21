Class {
	#name : #RTDraggableViewWithLimit,
	#superclass : #RTDraggableView,
	#instVars : [
		'limitRect',
		'view',
		'move',
		'mouseBlock',
		'draggingBlock',
		'afterDraggingBlock',
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
		when: TRMouseDragging do: draggingBlock;
		when: TRMouseDragging do: afterDraggingBlock
]

{ #category : #initialization }
RTDraggableViewWithLimit >> initialize [
	super initialize.
	limitRect := (-200 @ -200) corner: (200 @ 200).
	move := false.
	mouseBlock := [ move := true].
	dragEndBlock := [ move := false ].
	draggingBlock := [ :e |
		move ifTrue: [ 
			view canvas camera translateBy: e step negated / view canvas camera scale.
			e signalUpdate
		]
	].
	afterDraggingBlock := [ :e | | camera pos |
		camera := view canvas camera.
		pos := camera position.
		camera translateTo: (limitRect pointNearestTo: pos)
	]
]

{ #category : #hooks }
RTDraggableViewWithLimit >> initializeElement: aView [
	view := aView.
	view canvas
		when: self mouse do: mouseBlock;
		when: TRMouseDragEnd do: dragEndBlock;
		when: TRMouseDragging do: draggingBlock;
		when: TRMouseDragging do: afterDraggingBlock
]

{ #category : #testing }
RTDraggableViewWithLimit >> isCameraOutsideLimits [
	| p |
	p := view canvas camera position.
	^ (limitRect containsPoint: p) not
]

{ #category : #accessing }
RTDraggableViewWithLimit >> limitRect [
	^ limitRect
]

{ #category : #accessing }
RTDraggableViewWithLimit >> limitRect: anObject [
	limitRect := anObject
]
