Class {
	#name : #DvtPresenter,
	#superclass : #ComposablePresenter,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #initialization }
DvtPresenter >> initializePresenter [
	self whenBuiltDo: [ 
		self window whenClosedDo: [ 
			DvtApp onAppPresenterClosed: self.
			self onWindowClosed
		].
		self onWindowOpened
	].
	
	self aboutText: DvtApp description
]

{ #category : #private }
DvtPresenter >> onWindowClosed [
	
]

{ #category : #private }
DvtPresenter >> onWindowOpened [
	
]

{ #category : #api }
DvtPresenter >> title [
	^ DvtApp appName
]
