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
		'leftClickBlock',
		'rightDragStartBlock'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #'instance creation' }
RTGridViewCellSelectable class >> forGridView: aGridView [
	^ self new
		gridView: aGridView;
		yourself
]

{ #category : #api }
RTGridViewCellSelectable >> clearSelection [
	selectionElement ifNotNil: [ 
		view removeElement: selectionElement.
		selectionElement view: nil
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
		when: TRMouseLeftClick do: leftClickBlock;
		when: TRMouseRightDragStart do: rightDragStartBlock
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
	gridView := anObject.
]

{ #category : #testing }
RTGridViewCellSelectable >> hasSelection [
	^ selectionStart isNotNil and: [ selectionEnd isNotNil ]
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
	].
	rightDragStartBlock := [ :e |
		ignoreDragging := true
	].
	selectionElement := RTBox new
		color: Color transparent;
		borderWidth: 2;
		borderColor: Color black;
		element.
]

{ #category : #hooks }
RTGridViewCellSelectable >> initializeElement: aView [
	(view := aView) canvas
		when: TRMouseLeftDragStart do: dragStartBlock;
		when: TRMouseDragging do: draggingBlock;
		when: TRMouseLeftClick do: leftClickBlock;
		when: TRMouseRightDragStart do: rightDragStartBlock.
]

{ #category : #private }
RTGridViewCellSelectable >> processDragStart: mousePos [
	| coord gridSize |
	self clearSelection.
	view add: selectionElement.
	coord := gridView cellCoordForPoint: mousePos.
	gridSize := self gridSize.
	selectionElement shape
		width: gridSize x;
		height: gridSize y.
	selectionElement translateTo: (gridView pointForCellCoord: coord).
	prevCoord := coord.
	selectionStart := coord.
	selectionEnd := coord.
	self updateCanvasAndSelection
]

{ #category : #private }
RTGridViewCellSelectable >> processDragging: mousePos [
	| coord |
	selectionElement ifNil: [ ^ self ].
	coord := gridView cellCoordForPoint: mousePos.
	coord = prevCoord ifTrue: [ ^ self ].
	self selectFrom: selectionStart to: coord.
	prevCoord := coord
]

{ #category : #api }
RTGridViewCellSelectable >> selectFrom: fromPoint to: toPoint [
	| gridSize |
	selectionStart ifNil: [ 
		view add: selectionElement
	].
	selectionStart := fromPoint.
	selectionEnd := toPoint.
	gridSize := self gridSize.
	selectionElement shape
		width: gridSize x * ((selectionEnd x - selectionStart x) abs + 1);
		height: gridSize y * ((selectionEnd y - selectionStart y) abs + 1).
	selectionElement translateTo: ((selectionEnd + selectionStart + (1 @ 1)) / 2) * gridSize.
	self updateCanvasAndSelection
]

{ #category : #api }
RTGridViewCellSelectable >> selectionDo: aBlock [
	| rect |
	self hasSelection ifFalse: [ ^ self ].
	rect := self selectionRect.
	rect top to: rect bottom by: 1 do: [ :row |
		rect left to: rect right by: 1 do: [ :column |
			aBlock value: column @ row
		]
	]
]

{ #category : #accessing }
RTGridViewCellSelectable >> selectionEnd [
	^ selectionEnd
]

{ #category : #accessing }
RTGridViewCellSelectable >> selectionRect [
	self hasSelection ifFalse: [ ^ nil ].
	^ selectionStart corner: selectionEnd
]

{ #category : #api }
RTGridViewCellSelectable >> selectionReverseDo: aBlock [
	| rect |
	self hasSelection ifFalse: [ ^ self ].
	rect := self selectionRect.
	rect bottom to: rect top by: -1 do: [ :row |
		rect right to: rect left by: -1 do: [ :column |
			aBlock value: column @ row
		]
	]
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
