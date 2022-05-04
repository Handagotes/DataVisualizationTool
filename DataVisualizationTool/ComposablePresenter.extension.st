Extension { #name : #ComposablePresenter }

{ #category : #'*DataVisualizationTool' }
ComposablePresenter >> makeWindowUnresizeable [
	self whenBuiltDo: [ self window containingWindow beUnresizeable ]
]

{ #category : #'*DataVisualizationTool' }
ComposablePresenter >> newColorPickerButton [
	^ self instantiate: ColorPickerButtonPresenter
]

{ #category : #'*DataVisualizationTool' }
ComposablePresenter >> newDataTable [
	^ FTTableMorph new
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		beResizable;
		asSpecAdapter
]

{ #category : #'*DataVisualizationTool' }
ComposablePresenter >> newDvtDataTable [
	^ self instantiate: DvtDataTablePresenter
]
