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
DvtPresenter class >> parseDataString: dataString [
	| data |
	
	data := nil.
	
	[ 
		data := NeoJSONReader fromString: dataString.
		(data isArray or: [ data isDictionary ]) ifFalse: [ self error ]
	] on: Error do: [ 
		[ 
			data := RTTabTable new
				input: dataString;
				values
		] on: Error do: [ 
			DvtErrorDialog open: 'Формат полученных данных не поддерживается.'.
			data := nil
		]
	].
	
	^ data
]

{ #category : #private }
DvtPresenter class >> requestDropListDisplayBlock [
	^ [ :request | '{1} | {2}' format: { request name. request text } ]
]

{ #category : #private }
DvtPresenter class >> sampleDropListDisplayBlock [
	^ [ :sample | '{1} | {2}' format: { sample name. sample sampleFilePath } ]
]

{ #category : #private }
DvtPresenter class >> visualizationDropListDisplayBlock [
	^ [ :visualization | visualization name ]
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
