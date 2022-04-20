Extension { #name : #RTLabel }

{ #category : #'*DataVisualizationTool' }
RTLabel >> cropTextFor: anElement toWidth: width [
	| t s n |
	
	t := self textFor: anElement.
	t ifEmpty: [ ^ t ].
	
	n := 1.
	s := t first asString.
	
	[ (self widthOfString: s element: anElement) <= width ] whileTrue: [ 
		(n = t size) ifTrue: [ ^ s ].
		n := n + 1.
		s := t copyFrom: 1 to: n
	].
	
	^ t copyFrom: 1 to: n - 1
]

{ #category : #'*DataVisualizationTool' }
RTLabel >> widthOfString: aString element: anElement [
	^ TRLabelShape widthOfText: aString fontName: fontName fontSize: (self heightFor: anElement)
]
