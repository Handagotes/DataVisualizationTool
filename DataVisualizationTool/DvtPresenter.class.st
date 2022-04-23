Class {
	#name : #DvtPresenter,
	#superclass : #ComposablePresenter,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtPresenter class >> dataSetDropListDisplayBlock [
	^ [ :dataSet | '{1} {2} | {3}' format: { dataSet fetchDate. dataSet fetchTime. dataSet dataFilePath } ]
]

{ #category : #private }
DvtPresenter class >> requestDropListDisplayBlock [
	^ [ :request | '{1} | {2}' format: { request name. request text } ]
]

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
