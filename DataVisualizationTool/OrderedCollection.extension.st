Extension { #name : #OrderedCollection }

{ #category : #'*DataVisualizationTool' }
OrderedCollection >> at: index growPut: anObject [
	self
		at: index ifAbsentPut: [ nil ]; "<- grow if necessary"
		at: index put: anObject
]
