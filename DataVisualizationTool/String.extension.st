Extension { #name : #String }

{ #category : #'*DataVisualizationTool' }
String >> snakeToCamel [
	^ self class streamContents: [ :stream |
		self splitOn: $_ do: [ :sub |
			stream nextPutAll: sub capitalized
		]
	]
]
