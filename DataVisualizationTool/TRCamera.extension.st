Extension { #name : #TRCamera }

{ #category : #'*DataVisualizationTool' }
TRCamera >> viewCanvasRect [
	| viewHalf |
	canvas ifNil: [ ^ (0 @ 0 corner: 0 @ 0) ].
	viewHalf := canvas extent / scale / 2.
	^ (position - viewHalf) corner: (position + viewHalf)
]
