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

{ #category : #accessing }
DvtApplicationController >> description [
	^ '{1} ({2})
Данил Захаров, г. Нижневартовск, НВГУ
danilzakharovm@yandex.ru
2022' format: { self appName. self version }
]

{ #category : #'as yet unclassified' }
DvtApplicationController >> folderRoot [
	^ 'data visualization tool/'
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
	appPresenters
		detect: [ :p | p class = presenterClass ] ifFound: [ :p | p window flash. ^ self ];
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

{ #category : #versions }
DvtApplicationController >> version [
	^ '1.0'
]
