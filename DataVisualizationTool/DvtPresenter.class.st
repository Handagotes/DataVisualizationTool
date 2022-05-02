Class {
	#name : #DvtPresenter,
	#superclass : #ComposablePresenter,
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtPresenter class >> dataSetDropListDisplayBlock [
	^ [ :dataSet | '{1} {2} | {3}' format: { dataSet fetchDate. dataSet fetchTime. dataSet dataFilePath } ]
]

{ #category : #api }
DvtPresenter class >> parseDataString: dataString dataType: dataType [
	| data |
	
	dataType = #auto ifTrue: [ 
		(data := self tryParseJSON: dataString)
			ifNotNil: [ ^ data ].
		
		(data := self tryParseTSV: dataString)
			ifNotNil: [ ^ data ].
		
		DvtErrorDialog open: 'Формат данных не поддерживается.'.
		^ nil
	].
	
	dataType = #json ifTrue: [ 
		(data := self tryParseJSON: dataString)
			ifNotNil: [ ^ data ].
	].
	
	dataType = #csv ifTrue: [ 
		(data := self tryParseTSV: dataString usingDelimiter: $,)
			ifNotNil: [ ^ data ].
	].
	
	dataType = #tsv ifTrue: [ 
		(data := self tryParseTSV: dataString usingDelimiter: Character tab)
			ifNotNil: [ ^ data ].
	].
	
	DvtErrorDialog open: ('Не удалось обработать данные в формате {1}.' format: { dataType }).
	^ nil
]

{ #category : #api }
DvtPresenter class >> readJSONDataFromFileRef: fileRef [
	| dataString data |
	dataString := nil.
	[
		dataString := fileRef contents
	] on: FileDoesNotExistException do: [ 
		DvtErrorDialog open: ('Файл {1} отсутствует в файловой системе.' format: { fileRef fullName }).
		^ nil
	].
	(data := self tryParseJSON: dataString) ifNil: [ 
		DvtErrorDialog open: ('Не удаётся прочитать файл "{1}" в формате JSON.' format: { fileRef fullName }).
		^ nil
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

{ #category : #api }
DvtPresenter class >> tryParseJSON: dataString [
	[ | data |
		data := (NeoJSONReader on: dataString readStream)
			listClass: OrderedCollection;
			next.
		(DvtDataTableProcessor isNode: data) ifFalse: [ self error ].
		^ data
	] on: Error do: [ ^ nil ]
]

{ #category : #api }
DvtPresenter class >> tryParseTSV: dataString [
	^ self tryParseTSV: dataString usingDelimiter: (RTTabTable new detectDelimiterIn: dataString)
]

{ #category : #api }
DvtPresenter class >> tryParseTSV: dataString usingDelimiter: aCharacter [
	[ | values |
		values := RTTabTable new
			input: dataString usingDelimiter: aCharacter;
			values.
		values := values asOrderedCollection.
		values withIndexDo: [ :row :i |
			values at: i put: row asOrderedCollection
		].
		^ values
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
