Class {
	#name : #TRCanvasRectangularGridShape,
	#superclass : #TRCanvasGridShape,
	#category : #'DataVisualizationTool-Util'
}

{ #category : #private }
TRCanvasRectangularGridShape >> computePath [
	| width height |
	width := self canvas extent x / canvas camera scale roundUpTo: spacing x.
	height := self canvas extent y / canvas camera scale roundUpTo: spacing y.
	path := self athensCanvas
		createPath:
			[ :builder | 
			builder absolute.
			height negated to: height by: spacing y do: [ :i | 
				builder
					moveTo: width negated @ i;
					lineTo: width @ i ].
			width negated to: width by: spacing x do: [ :i | 
				builder
					moveTo: i @ height negated;
					lineTo: i @ height ] ]
]

{ #category : #drawing }
TRCanvasRectangularGridShape >> drawOn: athensCanvas [
	"The shape is first moved by offset, which will always center it on camera, then it is moved by moduled offset, so it will alway move only by at most the modulo"
 
	| s |
	athensCanvas pathTransform
		restoreAfter:
			[ athensCanvas pathTransform translateBy: offset.
			athensCanvas pathTransform
				translateBy: ((offset x % spacing x) @ (offset y % spacing y)) negated.
			athensCanvas setShape: self path.
			s := athensCanvas setStrokePaint: self color.
			s width: 1.
			dashes ifNotNil: [ 
				 s dashes: dashes offset: spacing x ].
			athensCanvas draw ]
]

{ #category : #accessing }
TRCanvasRectangularGridShape >> spacing: aSpacingSize [
	spacing := aSpacingSize
]
