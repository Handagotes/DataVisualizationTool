Extension { #name : #ComposablePresenter }

{ #category : #'*DataVisualizationTool' }
ComposablePresenter >> newDataTable [
	^ FTTableMorph new
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		beResizable;
		asSpecAdapter
]

{ #category : #'*DataVisualizationTool' }
ComposablePresenter >> newDvtDataSetTable [
	^ self instantiate: DvtDataSetTablePresenter
]
