Class {
	#name : #RTDraggableViewWithLimit,
	#superclass : #RTDraggableView,
	#instVars : [
		'limitRect'
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

{ #category : #initialization }
RTDraggableViewWithLimit >> initialize [
	limitRect := (-200 @ -200) corner: (200 @ 200)
]

{ #category : #hooks }
RTDraggableViewWithLimit >> initializeElement: aView [
	super initializeElement: aView.
	aView canvas when: TRMouseDragging do: [ :e | | camera pos |
		camera := aView canvas camera.
		pos := camera position.
		
		pos x < limitRect left ifTrue: [ 
			pos := limitRect left @ pos y.
		] ifFalse: [ 
			pos x > limitRect right ifTrue: [ 
				pos := limitRect right @ pos y
			]
		].
		
		pos y < limitRect top ifTrue: [ 
			pos := pos x @ limitRect top.
		] ifFalse: [ 
			pos y > limitRect bottom ifTrue: [ 
				pos := pos x @ limitRect bottom
			]
		].
		
		camera translateTo: pos
	]
]

{ #category : #accessing }
RTDraggableViewWithLimit >> limitRect [
	^ limitRect
]

{ #category : #accessing }
RTDraggableViewWithLimit >> limitRect: anObject [
	limitRect := anObject
]
