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
	
	(data := self tryParseJSON: dataString)
		ifNotNil: [ ^ data ].
	
	(data := self tryParseTSV: dataString)
		ifNotNil: [ ^ data ].
	
	DvtErrorDialog open: 'Формат данных не поддерживается.'.
	^ nil
]

{ #category : #private }
DvtPresenter class >> readSampleData: sample [
	| sampleString sampleData |
	sampleString := nil.
	[
		sampleString := (DvtApp sampleFileRefFor: sample) contents
	] on: FileDoesNotExistException do: [ 
		DvtErrorDialog open: 'Файл выборки отсутствует в файловой системе.'.
		^ nil
	].
	(sampleData := self class tryParseJSON: sampleString) ifNil: [ 
		DvtErrorDialog open: 'Не удаётся прочитать файл выборки в формате JSON.'.
		^ nil
	].
	^ sampleData
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
DvtPresenter class >> tryParseJSON: dataString [
	[ | data |
		data := NeoJSONReader fromString: dataString.
		(data isArray or: [ data isDictionary ]) ifFalse: [ self error ].
		^ data
	] on: Error do: [ ^ nil ]
]

{ #category : #private }
DvtPresenter class >> tryParseTSV: dataString [
	[ 
		^ RTTabTable new
			input: dataString;
			values
	] on: Error do: [ ^ nil ]
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
