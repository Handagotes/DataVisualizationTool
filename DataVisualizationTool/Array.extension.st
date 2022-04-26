Extension { #name : #Array }

{ #category : #'*DataVisualizationTool' }
Array >> resizeCopy: size [
	| a |
	a := self class new: size.
	1 to: (self size min: a size) do: [ :i |
		a at: i put: (self at: i)
	].
	^ a
]

{ #category : #'*DataVisualizationTool' }
Array >> resizeCopyColumns: columns rows: rows [
	| a |
	a := self class new: rows.
	1 to: (self size min: a size) do: [ :i | | rowCopy |
		rowCopy := (self at: i) resizeCopy: columns.
		a at: i put: rowCopy
	].
	self size + 1 to: a size do: [ :i |
		a at: i put: (self class new: columns)
	].
	^ a
]
