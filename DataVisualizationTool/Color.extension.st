Extension { #name : #Color }

{ #category : #'*DataVisualizationTool' }
Color >> asArray [
	^ { self red. self green. self blue. self alpha }
]

{ #category : #'*DataVisualizationTool' }
Color >> asFormOfExtent: extent [
	^ (Form extent: extent depth: 16)
		fillColor: self;
		yourself
]
