Extension { #name : #Color }

{ #category : #'*DataVisualizationTool' }
Color >> asFormOfExtent: extent [
	^ (Form extent: extent depth: 16)
		fillColor: self;
		yourself
]
