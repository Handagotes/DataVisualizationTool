Class {
	#name : #RTGridViewCellSelectable,
	#superclass : #RTAbstractInteractionView,
	#instVars : [
		'view',
		'gridView',
		'selectionElement',
		'selectionStart',
		'selectionEnd',
		'prevCoord',
		'ignoreDragging',
		'dragStartBlock',
		'draggingBlock',
		'leftClickBlock'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #'as yet unclassified' }
RTGridViewCellSelectable class >> forGridView: aGridView [
	^ self new
		gridView: aGridView;
		yourself
]

{ #category : #resolution }
RTGridViewCellSelectable >> clearSelection [
	selectionElement ifNotNil: [ 
		selectionElement remove.
		selectionElement := nil
	].
	prevCoord := nil.
	selectionStart := nil.
	selectionEnd := nil.
	self updateCanvasAndSelection
]

{ #category : #api }
RTGridViewCellSelectable >> coverElementEvents: anElement [
	anElement
		when: TRMouseLeftDragStart do: dragStartBlock;
		when: TRMouseDragging do: draggingBlock;
		when: TRMouseLeftClick do: leftClickBlock
]

{ #category : #accessing }
RTGridViewCellSelectable >> gridSize [
	| size |
	(size := gridView gridSize) isPoint ifTrue: [ ^ size ].
	^ size @ size
]

{ #category : #accessing }
RTGridViewCellSelectable >> gridView [
	^ gridView
]

{ #category : #accessing }
RTGridViewCellSelectable >> gridView: anObject [
	^ gridView := anObject
]

{ #category : #initialization }
RTGridViewCellSelectable >> initialize [
	super initialize.
	ignoreDragging := true.
	dragStartBlock := [ :e |
		ignoreDragging := false.
		self processDragStart: e positionFromCamera
	].
	draggingBlock := [ :e |
		ignoreDragging ifFalse: [ 
			self processDragging: e positionFromCamera
		]
	].
	leftClickBlock := [ :e |
		self processDragStart: e position
	]
]

{ #category : #hooks }
RTGridViewCellSelectable >> initializeElement: aView [
	(view := aView) canvas
		when: TRMouseLeftDragStart do: dragStartBlock;
		when: TRMouseDragging do: draggingBlock;
		when: TRMouseLeftClick do: leftClickBlock;
		when: TRMouseRightDragStart do: [ :e |
			ignoreDragging := true
		]
]

{ #category : #private }
RTGridViewCellSelectable >> processDragStart: mousePos [
	| gridSize coord |
	
	self clearSelection.
	gridSize := self gridSize.
	
	selectionElement := RTBox new
		color: Color transparent;
		borderWidth: 2;
		borderColor: Color black;
		width: gridSize x;
		height: gridSize y;
		element.
	
	view add: selectionElement.
	coord := gridView cellCoordForPoint: mousePos.
	selectionElement translateTo: (gridView pointForCellCoord: coord).
	prevCoord := coord.
	selectionStart := coord.
	selectionEnd := coord.
	self updateCanvasAndSelection
]

{ #category : #private }
RTGridViewCellSelectable >> processDragging: mousePos [
	| coord gridSize |
	selectionElement ifNil: [ ^ self ].
	coord := gridView cellCoordForPoint: mousePos.
	coord = prevCoord ifTrue: [ ^ self ].
	selectionEnd := coord.
	gridSize := self gridSize.
	selectionElement shape
		width: gridSize x * ((selectionEnd x - selectionStart x) abs + 1);
		height: gridSize y * ((selectionEnd y - selectionStart y) abs + 1).
	selectionElement translateTo: ((selectionEnd + selectionStart + (1 @ 1)) / 2) * gridSize.
	self updateCanvasAndSelection.
	prevCoord := coord
]

{ #category : #accessing }
RTGridViewCellSelectable >> selectionEnd [
	^ selectionEnd
]

{ #category : #accessing }
RTGridViewCellSelectable >> selectionStart [
	^ selectionStart
]

{ #category : #private }
RTGridViewCellSelectable >> updateCanvasAndSelection [
	selectionElement ifNotNil: [ 
		selectionElement update.
	].
	view canvas signalUpdate
]
