Extension { #name : #Dictionary }

{ #category : #'*DataVisualizationTool' }
Dictionary >> areKeysCompatibleWith: aDictionary [
	^ self keys asSet = aDictionary keys asSet
]
