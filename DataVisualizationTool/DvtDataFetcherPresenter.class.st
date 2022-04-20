Class {
	#name : #DvtDataFetcherPresenter,
	#superclass : #DvtPresenter,
	#instVars : [
		'requestLabel',
		'requestDropList',
		'dataSetLabel',
		'dataSetDropList',
		'createRequestButton',
		'editRequestButton',
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
							add: #editRequestButton;
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

{ #category : #private }
DvtDataFetcherPresenter >> editRequest: r headerFields: hfs create: shouldCreate [
	| result request headerFields |
	request := r.
	headerFields := hfs.
	[ 
		(result := DvtEditRequestDialog open: request headerFields: headerFields) ifNil: [ 
			^ self updateRequestDropList.
		].
		request := result at: 1.
		headerFields := result at: 2.
		[ 
			shouldCreate
				ifTrue: [ DvtAppDB insertRequest: request headerFields: headerFields ];
				ifFalse: [ DvtAppDB updateRequest: request headerFields: headerFields ].
			^ self updateRequestDropList
		] on: SQLite3ConstraintViolation do: [ 
			DvtErrorDialog open: ('Запрос с именем "{1}" уже существует.' format: { request name }).
			false
		]
	] whileFalse
]

{ #category : #accessing }
DvtDataFetcherPresenter >> editRequestButton [
	^ editRequestButton
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
	editRequestButton action: [ self onEditRequestButtonAction ].
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
	editRequestButton := self newButton.
	deleteRequestButton := self newButton.
	fetchDataSetButton := self newButton.
	deleteDataSetButton := self newButton.
	dataSetText := self newText.
	dataSetTable := self newDvtDataSetTable.
	
	requestDropList displayBlock: [ :request | '{1} | {2}' format: { request name. request text } ].
	dataSetDropList displayBlock: [ :dataSet | '{1} {2} | {3}' format: { dataSet fetchDate. dataSet fetchTime. dataSet dataFilePath } ].
	requestLabel label: 'Запрос:'.
	dataSetLabel label: 'Набор данных:'.
	createRequestButton label: 'Создать запрос'.
	editRequestButton label: 'Редактировать запрос'.
	deleteRequestButton label: 'Удалить запрос'.
	fetchDataSetButton label: 'Запросить данные'.
	deleteDataSetButton label: 'Удалить данные'.
	dataSetText disable
]

{ #category : #private }
DvtDataFetcherPresenter >> onCreateRequestButtonAction [
	| request headerFields |
	request := DvtRequest default.
	headerFields := OrderedCollection empty.
	self editRequest: request headerFields: headerFields create: true
]

{ #category : #private }
DvtDataFetcherPresenter >> onDataSetDropListSelectedItemChanged [
	
]

{ #category : #private }
DvtDataFetcherPresenter >> onDeleteDataSetButtonAction [
	
]

{ #category : #private }
DvtDataFetcherPresenter >> onDeleteRequestButtonAction [
	| request |
	(request := requestDropList selectedItem) ifNil: [ ^ self ].
	(DvtYesNoDialog open: 'Удалить запрос и все полученные им наборы данных?') ifFalse: [ ^ self ].
	DvtAppDB deleteRequest: request.
	self updateRequestDropList
]

{ #category : #private }
DvtDataFetcherPresenter >> onEditRequestButtonAction [
	| request headerFields |
	(request := requestDropList selectedItem) ifNil: [ ^ self ].
	headerFields := DvtAppDB headerFieldsOfRequest: request.
	self editRequest: request headerFields: headerFields create: false
]

{ #category : #private }
DvtDataFetcherPresenter >> onFetchDataSetButtonAction [
	
]

{ #category : #private }
DvtDataFetcherPresenter >> onRequestDropListSelectedItemChanged [
	
]

{ #category : #private }
DvtDataFetcherPresenter >> onWindowOpened [
	self
		updateRequestDropList;
		updateDataSetDropList
]

{ #category : #accessing }
DvtDataFetcherPresenter >> requestDropList [
	^ requestDropList
]

{ #category : #accessing }
DvtDataFetcherPresenter >> requestLabel [
	^ requestLabel
]

{ #category : #private }
DvtDataFetcherPresenter >> updateDataSetDropList [
	
]

{ #category : #private }
DvtDataFetcherPresenter >> updateRequestDropList [
	requestDropList items: DvtAppDB requests
]
