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
	];
	yourself
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
				ifTrue: [ DvtAppDB insertRequest: request headerFields: headerFields ]
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
	^ 1150 @ 500
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
	dataSetTable := self newDvtDataTable.
	
	requestDropList displayBlock: [ :request | '{1} | {2}' format: { request name. request text } ].
	dataSetDropList displayBlock: [ :dataSet | '{1} {2} | {3}' format: { dataSet fetchDate. dataSet fetchTime. dataSet dataFilePath } ].
	requestLabel label: 'Запрос:'.
	dataSetLabel label: 'Набор данных:'.
	createRequestButton label: 'Создать запрос'.
	editRequestButton label: 'Редактировать запрос'.
	deleteRequestButton label: 'Удалить запрос'.
	fetchDataSetButton label: 'Запросить данные'.
	deleteDataSetButton label: 'Удалить данные'.
	dataSetText
		disable;
		beForCode
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
	| dataSet dataString data request |
	dataSetDropList selectedIndex isZero ifTrue: [ 
		dataSetText text: String empty.
		dataSetTable data: nil.
		^ self
	].
	request := requestDropList selectedItem.
	dataSet := dataSetDropList selectedItem.
	dataString := (DvtApp dataSetFileRefFor: dataSet) contents.
	(data := self class parseDataString: dataString dataType: request dataType) ifNil: [ ^ self ].
	dataSetText text: dataString.
	dataSetTable data: data
]

{ #category : #private }
DvtDataFetcherPresenter >> onDeleteDataSetButtonAction [
	| dataSet |
	dataSetDropList selectedIndex isZero ifTrue: [ ^ self ].
	(DvtYesNoDialog open: 'Набор данных будет удалён из базы данных и из файловой системы. Продолжить?') ifFalse: [ ^ self ].
	dataSet := dataSetDropList selectedItem.
	DvtAppDB deleteDataSet: dataSet.
	(DvtApp dataSetFileRefFor: dataSet) delete.
	self updateDataSetDropList
]

{ #category : #private }
DvtDataFetcherPresenter >> onDeleteRequestButtonAction [
	| request |
	requestDropList selectedIndex isZero ifTrue: [ ^ self ].
	request := requestDropList selectedItem.
	(DvtYesNoDialog open: 'Удалить запрос и все полученные им наборы данных?') ifFalse: [ ^ self ].
	DvtAppDB deleteRequest: request.
	('{1}{2}/' format: { DvtApp dataSetsFolder. request name }) asFileReference ensureDeleteAll.
	self
		updateRequestDropList;
		updateDataSetDropList
]

{ #category : #private }
DvtDataFetcherPresenter >> onEditRequestButtonAction [
	| request headerFields |
	requestDropList selectedIndex isZero ifTrue: [ ^ self ].
	request := requestDropList selectedItem.
	headerFields := DvtAppDB headerFieldsOfRequest: request.
	self editRequest: request headerFields: headerFields create: false
]

{ #category : #private }
DvtDataFetcherPresenter >> onFetchDataSetButtonAction [
	| request headerFields client response |
	requestDropList selectedIndex isZero ifTrue: [ ^ self ].
	request := requestDropList selectedItem.
	headerFields := DvtAppDB headerFieldsOfRequest: request.
	
	(client := ZnClient new)
		beOneShot;
		url: request text.
	
	headerFields
		sort: [ :a :b | a order < b order ];
		do: [ :hf | client headerAt: hf header add: hf field ].
	
	response := nil.
	
	[ 
		response := client
			get;
			response
	] on: Error do: [ :e |
		DvtErrorDialog open: ('Произошла ошибка при выполнении запроса, возможно он был неправильно сформулирован. "{1}"' format: { e messageText }).
		^ self
	].
	
	response isSuccess ifFalse: [ 
		DvtErrorDialog open: ('Не удалось получить данные: {1}' format: { response contents }).
		^ self
	].
	
	self processNewDataSet: response contents
]

{ #category : #private }
DvtDataFetcherPresenter >> onRequestDropListSelectedItemChanged [
	self updateDataSetDropList
]

{ #category : #private }
DvtDataFetcherPresenter >> onWindowOpened [
	self
		updateRequestDropList;
		updateDataSetDropList
]

{ #category : #private }
DvtDataFetcherPresenter >> processNewDataSet: dataString [
	| request dataType filePath date time dataSet |
	request := requestDropList selectedItem.
	dataType := request dataType.
	(self class parseDataString: dataString dataType: dataType) ifNil: [ ^ self ].
	
	date := Date today.
	time := Time now.
	filePath := String streamContents: [ :ws |
		ws
			nextPutAll: request name;
			nextPut: $/;
			nextPutAll: date yyyymmdd;
			nextPut: $_;
			nextPutAll: (time print24 replaceAll: $: with: $-);
			nextPut: $.;
			nextPutAll: (dataType = #auto ifTrue: [ 'txt' ] ifFalse: [ dataType ])
	].
	
	dataSet := DvtDataSet new
		requestId: request id;
		fetchDate: date;
		fetchTime: time;
		dataFilePath: filePath;
		yourself.
	
	DvtAppDB insertDataSet: dataSet.
	
	(DvtApp dataSetFileRefFor: dataSet)
		ensureCreateFile;
		writeStreamDo: [ :ws |
			ws nextPutAll: dataString
		].
	
	self updateDataSetDropList
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
	dataSetDropList setIndex: 0.
	requestDropList selectedIndex isZero ifTrue: [ 
		dataSetDropList items: OrderedCollection empty
	] ifFalse: [ | request |
		request := requestDropList selectedItem.
		dataSetDropList items: (DvtAppDB dataSetsOfRequest: request)
	]
]

{ #category : #private }
DvtDataFetcherPresenter >> updateRequestDropList [
	requestDropList
		setIndex: 0;
		items: DvtAppDB requests
]
