Extension { #name : #RTGridView }

{ #category : #'*DataVisualizationTool' }
RTGridView >> cellCoordForPoint: aPoint [
	| gs |
	gs := self gridSizeAsPoint.
	^ (aPoint / gs) ceiling - (1 @ 1)
]

{ #category : #'*DataVisualizationTool' }
RTGridView >> gridSizeAsPoint [
	| gs |
	gs := self gridSize.
	^ gs isPoint ifTrue: [ gs ] ifFalse: [ gs @ gs ].
]

{ #category : #'*DataVisualizationTool' }
RTGridView >> pointForCellCoord: coord [
	| gs |
	gs := self gridSizeAsPoint.
	^ coord * gs + (gs / 2)
]
