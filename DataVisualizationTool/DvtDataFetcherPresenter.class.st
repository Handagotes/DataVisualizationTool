Class {
	#name : #DvtDataFetcherPresenter,
	#superclass : #DvtPresenter,
	#instVars : [
		'requestLabel',
		'requestDropList',
		'dataSetLabel',
		'dataSetDropList',
		'createRequestButton',
		'deleteRequestButton',
		'fetchDataSetButton',
		'deleteDataSetButton',
		'dataSetText',
		'dataSetTable'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtDataFetcherPresenter class >> defaultSpec [
	^ SpecLayout composed newRow: [ :row |
		row
			newColumn: [ :column |
				column
					newRow: [ :requestRow | 
						requestRow
							add: #requestLabel width: 50;
							add: #requestDropList
					] height: self toolbarHeight;
					newRow: [ :requestButtonsRow |
						requestButtonsRow
							add: #createRequestButton;
							add: #deleteRequestButton
					] height: self buttonHeight;
					add: #dataSetText
			];
			addSplitter;
			newColumn: [ :column |
				column
					newRow: [ :dataSetRow |
						dataSetRow
							add: #dataSetLabel width: 90;
							add: #dataSetDropList
					] height: self toolbarHeight;
					newRow: [ :dataSetButtonsRow |
						dataSetButtonsRow
							add: #fetchDataSetButton;
							add: #deleteDataSetButton
					] height: self buttonHeight;
					add: #dataSetTable
			]
	]
]

{ #category : #accessing }
DvtDataFetcherPresenter >> createRequestButton [
	^ createRequestButton
]

{ #category : #accessing }
DvtDataFetcherPresenter >> dataSetDropList [
	^ dataSetDropList
]

{ #category : #accessing }
DvtDataFetcherPresenter >> dataSetLabel [
	^ dataSetLabel
]

{ #category : #accessing }
DvtDataFetcherPresenter >> dataSetTable [
	^ dataSetTable
]

{ #category : #accessing }
DvtDataFetcherPresenter >> dataSetText [
	^ dataSetText
]

{ #category : #accessing }
DvtDataFetcherPresenter >> deleteDataSetButton [
	^ deleteDataSetButton
]

{ #category : #accessing }
DvtDataFetcherPresenter >> deleteRequestButton [
	^ deleteRequestButton
]

{ #category : #api }
DvtDataFetcherPresenter >> extent [
	^ 900 @ 500
]

{ #category : #accessing }
DvtDataFetcherPresenter >> fetchDataSetButton [
	^ fetchDataSetButton
]

{ #category : #initialization }
DvtDataFetcherPresenter >> initializePresenter [
	super initializePresenter.
	requestDropList whenSelectedItemChanged: [ self onRequestDropListSelectedItemChanged ].
	dataSetDropList whenSelectedItemChanged: [ self onDataSetDropListSelectedItemChanged ].
	createRequestButton action: [ self onCreateRequestButtonAction ].
	deleteRequestButton action: [ self onDeleteRequestButtonAction ].
	fetchDataSetButton action: [ self onFetchDataSetButtonAction ].
	deleteDataSetButton action: [ self onDeleteDataSetButtonAction ]
]

{ #category : #initialization }
DvtDataFetcherPresenter >> initializeWidgets [
	requestLabel := self newLabel.
	requestDropList := self newDropList.
	dataSetLabel := self newLabel.
	dataSetDropList := self newDropList.
	createRequestButton := self newButton.
	deleteRequestButton := self newButton.
	fetchDataSetButton := self newButton.
	deleteDataSetButton := self newButton.
	dataSetText := self newText.
	dataSetTable := self newDvtDataSetTable.
	
	requestLabel label: 'Запрос:'.
	dataSetLabel label: 'Набор данных:'.
	createRequestButton label: 'Создать запрос...'.
	deleteRequestButton label: 'Удалить запрос'.
	fetchDataSetButton label: 'Запросить данные'.
	deleteDataSetButton label: 'Удалить данные'.
	dataSetText disable
]

{ #category : #private }
DvtDataFetcherPresenter >> onCreateRequestButtonAction [
	| result request headerFields |
	(result := DvtEditRequestDialog open) ifNil: [ ^ self ].
	request := result at: 1.
	headerFields := result at: 2.
	
]

{ #category : #private }
DvtDataFetcherPresenter >> onDataSetDropListSelectedItemChanged [
	
]

{ #category : #private }
DvtDataFetcherPresenter >> onDeleteDataSetButtonAction [
	
]

{ #category : #private }
DvtDataFetcherPresenter >> onDeleteRequestButtonAction [
	
]

{ #category : #private }
DvtDataFetcherPresenter >> onFetchDataSetButtonAction [
	
]

{ #category : #private }
DvtDataFetcherPresenter >> onRequestDropListSelectedItemChanged [
	
]

{ #category : #accessing }
DvtDataFetcherPresenter >> requestDropList [
	^ requestDropList
]

{ #category : #accessing }
DvtDataFetcherPresenter >> requestLabel [
	^ requestLabel
]
