Class {
	#name : #DvtApplicationController,
	#superclass : #DvtSingleton,
	#instVars : [
		'launcher',
		'appPresenters'
	],
	#category : #'DataVisualizationTool-Control'
}

{ #category : #accessing }
DvtApplicationController class >> globalName [
	^ #DvtApp
]

{ #category : #api }
DvtApplicationController >> appName [
	^ 'Инструмент визуализации данных'
]

{ #category : #api }
DvtApplicationController >> clearDB [
	| wasConnected |
	(wasConnected := DvtAppDB isConnected)
		ifFalse: [ DvtAppDB openConnection ].
	DvtAppDB
		dropTables;
		closeConnection.
	wasConnected ifTrue: [ DvtAppDB openConnection ]
]

{ #category : #'initialize-release' }
DvtApplicationController >> close [
	launcher ifNil: [ ^ self ].
	launcher close.
	launcher := nil
]

{ #category : #api }
DvtApplicationController >> colorForLiteralValue [
	^ Color fromHexString: 'E0A831'
]

{ #category : #api }
DvtApplicationController >> colorForNodeValue [
	^ Color fromHexString: '0B4E60'
]

{ #category : #api }
DvtApplicationController >> colorForNumberValue [
	^ Color fromHexString: '2F78E6'
]

{ #category : #api }
DvtApplicationController >> colorForStringValue [
	^ Color fromHexString: '9837C4'
]

{ #category : #api }
DvtApplicationController >> dataSetFileRefFor: dataSet [
	^ (self dataSetsFolder , dataSet dataFilePath) asFileReference
]

{ #category : #api }
DvtApplicationController >> dataSetsFolder [
	^ self folderRoot , 'datasets/'
]

{ #category : #accessing }
DvtApplicationController >> description [
	^ '{1} ({2})
Данил Захаров, г. Нижневартовск, НВГУ
danilzakharovm@yandex.ru
2022' format: { self appName. self version }
]

{ #category : #api }
DvtApplicationController >> folderRoot [
	^ 'data visualization tool/'
]

{ #category : #private }
DvtApplicationController >> ifPresenterExists: presenterClass do: aBlock [
	appPresenters detect: [ :p | p class = presenterClass ] ifFound: [ :p | aBlock value: p ]
]

{ #category : #initialization }
DvtApplicationController >> initialize [
	launcher := nil.
	appPresenters := IdentitySet new
]

{ #category : #accessing }
DvtApplicationController >> launch [
	(launcher isNil or: [ launcher isClosed ]) ifFalse: [ ^ launcher window flash ].
	DvtApplicationDBController initialize.
	launcher := DvtLauncherPresenter new openWithSpec
]

{ #category : #private }
DvtApplicationController >> onAppPresenterClosed: presenter [
	presenter window = launcher ifTrue: [ ^ self ].
	appPresenters
		remove: presenter;
		ifEmpty: [ DvtAppDB closeConnection ]
]

{ #category : #private }
DvtApplicationController >> openAppPresenter: presenterClass [
	self ifPresenterExists: presenterClass do: [ :p | p window flash. ^ self ].
	appPresenters
		ifEmpty: [ DvtAppDB openConnection ];
		add: (presenterClass new
			openWithSpec;
			yourself)
]

{ #category : #api }
DvtApplicationController >> openDataFetcher [
	self openAppPresenter: DvtDataFetcherPresenter
]

{ #category : #api }
DvtApplicationController >> openSampleEditor [
	self openAppPresenter: DvtSampleEditorPresenter
]

{ #category : #api }
DvtApplicationController >> openVisualizer [
	self openAppPresenter: DvtVisualizerPresenter
]

{ #category : #api }
DvtApplicationController >> sampleFileRefFor: sample [
	^ (self samplesFolder , sample sampleFilePath) asFileReference
]

{ #category : #api }
DvtApplicationController >> samplesFolder [
	^ self folderRoot , 'samples/'
]

{ #category : #private }
DvtApplicationController >> updateSampleEditorDataSetDropList [
	self ifPresenterExists: DvtSampleEditorPresenter do: [ :p | p updateDataSetDropList ]
]

{ #category : #private }
DvtApplicationController >> updateSampleEditorRequestDropList [
	self ifPresenterExists: DvtSampleEditorPresenter do: [ :p | p updateRequestDropList ]
]

{ #category : #private }
DvtApplicationController >> updateVisualizerSampleDropList [
	self ifPresenterExists: DvtVisualizerPresenter do: [ :p | p updateSampleDropList ]
]

{ #category : #versions }
DvtApplicationController >> version [
	^ '1.0'
]

{ #category : #api }
DvtApplicationController >> visualizationFileRefFor: visualization [
	^ (self visualizationsFolder , visualization configFilePath) asFileReference
]

{ #category : #api }
DvtApplicationController >> visualizationsFolder [
	^ self folderRoot , 'visualizations/'
]
