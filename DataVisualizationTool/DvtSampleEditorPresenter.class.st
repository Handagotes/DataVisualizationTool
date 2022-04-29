Class {
	#name : #DvtSampleEditorPresenter,
	#superclass : #DvtPresenter,
	#instVars : [
		'requestLabel',
		'requestDropList',
		'dataSetLabel',
		'dataSetDropList',
		'dataSetTable',
		'newNodeButton',
		'convertButton',
		'copyButton',
		'clearButton',
		'sampleLabel',
		'sampleDropList',
		'createSampleButton',
		'deleteSampleButton',
		'sampleTable'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtSampleEditorPresenter class >> defaultSpec [
	'requestLabel requestDropList dataSetLabel dataSetDropList dataSetTable copyButton sampleLabel sampleDropList createSampleButton deleteSampleButton sampleTable'.
	^ SpecLayout composed newRow: [ :row |
		row
			newColumn: [ :column |
				column
					newRow: [ :requestRow |
						requestRow
							add: #requestLabel width: 90;
							add: #requestDropList
					] height: self toolbarHeight;
					newRow: [ :dataSetRow |
						dataSetRow
							add: #dataSetLabel width: 90;
							add: #dataSetDropList
					] height: self toolbarHeight;
					add: #dataSetTable
			];
			addSplitter;
			newColumn: [ :column |
				column
					add: #newNullPresenter;
					add: #newNodeButton height: 32;
					add: #convertButton height: 32;
					add: #copyButton height: 32;
					add: #clearButton height: 32;
					add: #newNullPresenter
			] width: 36;
			newColumn: [ :column |
				column
					newRow: [ :sampleDropListRow |
						sampleDropListRow
							add: #sampleLabel width: 75;
							add: #sampleDropList
					] height: self toolbarHeight;
					newRow: [ :sampleButtonsRow |
						sampleButtonsRow
							add: #createSampleButton;
							add: #deleteSampleButton
					] height: self buttonHeight;
					add: #sampleTable
			]
	];
	yourself
]

{ #category : #private }
DvtSampleEditorPresenter class >> openPickNodeTypeDialog [
	^ DvtDropListDialog
		open: 'Выберите тип узла'
		items: #(dict array arrayOfArrays arrayOfDicts)
		displayBlock: [ :option | 
			{
				#dict -> 'Объект'.
				#array -> 'Массив'.
				#arrayOfArrays -> 'Двумерный массив'.
				#arrayOfDicts -> 'Массив объектов'.
			} asDictionary at: option
		]
		descriptionBlock: [ :option |
			{ 
				#dict -> 'Множество пар ключ - значение. Первая строка - ключи, вторая - соответствующие значения.'.
				#array -> 'Упорядоченное множество значений. Первый столбец - индекс, второй - значения.'.
				#arrayOfArrays -> 'Таблица со свободным редактированием ячеек.'.
				#arrayOfDicts -> 'Таблица объектов с одинаковыми наборами ключей. Первая строка - ключи, вторая - значения первого объекта, третья - второго, и т.д.'.
			} asDictionary at: option
		]
]

{ #category : #accessing }
DvtSampleEditorPresenter >> clearButton [
	^ clearButton
]

{ #category : #accessing }
DvtSampleEditorPresenter >> convertButton [
	^ convertButton
]

{ #category : #accessing }
DvtSampleEditorPresenter >> copyButton [
	^ copyButton
]

{ #category : #accessing }
DvtSampleEditorPresenter >> createSampleButton [
	^ createSampleButton
]

{ #category : #accessing }
DvtSampleEditorPresenter >> dataSetDropList [
	^ dataSetDropList
]

{ #category : #accessing }
DvtSampleEditorPresenter >> dataSetLabel [
	^ dataSetLabel
]

{ #category : #accessing }
DvtSampleEditorPresenter >> dataSetTable [
	^ dataSetTable
]

{ #category : #accessing }
DvtSampleEditorPresenter >> deleteSampleButton [
	^ deleteSampleButton
]

{ #category : #api }
DvtSampleEditorPresenter >> extent [
	^ 1150 @ 500
]

{ #category : #initialization }
DvtSampleEditorPresenter >> initializePresenter [
	super initializePresenter.
	requestDropList whenSelectedItemChanged: [ self onRequestDropListSelectedItemChanged ].
	dataSetDropList whenSelectedItemChanged: [ self onDataSetDropListSelectedItemChanged ].
	sampleDropList whenSelectedItemChanged: [ self onSampleDropListSelectedItemChanged ].
	newNodeButton action: [ self onNewNodeButtonAction ].
	convertButton action: [ self onConvertButtonAction ].
	copyButton action: [ self onCopyButtonAction ].
	clearButton action: [ self onClearButtonAction ].
	createSampleButton action: [ self onCreateSampleButtonAction ].
	deleteSampleButton action: [ self onDeleteSampleButtonAction ].
	sampleTable whenCellEditedDo: [ self updateSampleFile ]
]

{ #category : #initialization }
DvtSampleEditorPresenter >> initializeWidgets [
	requestLabel := self newLabel.
	requestDropList := self newDropList.
	dataSetLabel := self newLabel.
	dataSetDropList := self newDropList.
	dataSetTable := self newDvtDataSetTable.
	
	newNodeButton := self newButton.
	convertButton := self newButton.
	copyButton := self newButton.
	clearButton := self newButton.
	
	sampleLabel := self newLabel.
	sampleDropList := self newDropList.
	createSampleButton := self newButton.
	deleteSampleButton := self newButton.
	sampleTable := self newDvtDataSetTable.
	
	requestLabel label: 'Запрос:'.
	requestDropList displayBlock: self class requestDropListDisplayBlock.
	dataSetLabel label: 'Набор данных:'.
	dataSetDropList displayBlock: self class dataSetDropListDisplayBlock.
	
	newNodeButton
		icon: (DvtImages loadImageNamed: #newNodeIcon);
		help: 'Создать новый узел в выделенной ячейке'.
	convertButton
		icon: (DvtImages loadImageNamed: #convertIcon);
		help: 'Изменить тип значений выеделенных ячеек'.
	copyButton
		icon: (DvtImages loadImageNamed: #moveIcon);
		help: 'Копировать выделенные ячейки из левой таблицы в правую'.
	clearButton icon:
		(DvtImages loadImageNamed: #crossIcon);
		help: 'Удалить содержимое выделенных ячеек в правой таблице'.
	
	sampleLabel label: 'Выборка:'.
	sampleDropList displayBlock: self class sampleDropListDisplayBlock.
	createSampleButton label: 'Новая выборка'.
	deleteSampleButton label: 'Удалить выборку'.
	
	sampleTable allowCellEdit: true
]

{ #category : #accessing }
DvtSampleEditorPresenter >> newNodeButton [
	^ newNodeButton
]

{ #category : #private }
DvtSampleEditorPresenter >> onClearButtonAction [
	sampleTable data ifNil: [ ^ self ].
	
	sampleTable dataGrid selectedCellsReverseDo: [ :value :coord |
		(sampleTable isCellValueEditable: coord) ifTrue: [ 
			sampleTable putCellValue: nil at: coord
		]
	].
	sampleTable updateNode.
	self updateSampleFile
]

{ #category : #private }
DvtSampleEditorPresenter >> onConvertButtonAction [
	| type success |
	sampleTable dataGrid hasSelection ifFalse: [ ^ self ].
	(type := DvtPickValueTypeDialog open) ifNil: [ ^ self ].
	success := false.
	
	sampleTable dataGrid selectedCellsDo: [ :value :coord |
		(sampleTable isCellValueEditable: coord) ifTrue: [ 
			(sampleTable convertCellValue: value at: coord toType: type) ifTrue: [ 
				success := true
			]
		]
	].
	
	success
		ifFalse: [ DvtErrorDialog open: 'Выделенные ячейки не являются доступными для редактирования.' ]
		ifTrue: [ 
			sampleTable updateNode.
			self updateSampleFile
		]
]

{ #category : #private }
DvtSampleEditorPresenter >> onCopyButtonAction [
	| dataSetSelection sampleSelectionEnd start offset success |
	dataSetTable data ifNil: [ ^ self ].
	sampleTable data ifNil: [ ^ self ].
	(dataSetSelection := dataSetTable dataGrid selectionRect) ifNil: [ ^ self ].
	sampleSelectionEnd := sampleTable dataGrid selectionRect origin + dataSetSelection extent.
	
	start := nil.
	offset := 0 @ 0.
	success := false.
	
	dataSetTable dataGrid selectedCellsReverseDo: [ :value :coord | | sampleCoord |
		start ifNil: [ start := coord ].
		offset := start - coord.
		sampleCoord := sampleSelectionEnd - offset.
		(sampleTable isCellValueEditable: sampleCoord) ifTrue: [ 
			value ifNotNil: [ 
				sampleCoord traceCr.
				sampleTable putCellValue: value at: sampleCoord.
			].
			success := true.
		]
	].
	
	success
		ifFalse: [ DvtErrorDialog open: 'Выделенные ячейки не являются доступными для редактирования или отсутствуют данные для копирования.' ]
		ifTrue: [ 
			sampleTable updateNode.
			self updateSampleFile
		]
]

{ #category : #private }
DvtSampleEditorPresenter >> onCreateSampleButtonAction [
	| name sample rootNodeType |
	name := ''.
	[ 
		(name := (DvtTextInputDialog open: 'Введите имя выборки.' default: name)) ifNil: [ ^ self ].
		(rootNodeType := self class openPickNodeTypeDialog) ifNil: [ ^ self ].
		
		sample := (DvtSample new
			name: name;
			sampleFilePath: name , '.json';
			yourself).
		[ 
			DvtAppDB insertSample: sample.
			true
		] on: SQLite3ConstraintViolation do: [ 
			DvtErrorDialog open: ('Выборка с именем "{1}" уже существует.' format: { name }).
			false
		]
	] whileFalse.
	
	(DvtApp sampleFileRefFor: sample)
		ensureCreateFile
		writeStreamDo: [ :ws |
			ws nextPutAll: ({
				#dict -> '{}'.
				#array -> '[]'.
				#arrayOfArrays -> '[[], []]'.
				#arrayOfDicts -> '[{}, {}]'.
			} asDictionary at: rootNodeType)
		].
	
	self updateSampleDropList
]

{ #category : #private }
DvtSampleEditorPresenter >> onDataSetDropListSelectedItemChanged [
	| dataSet dataString data |
	dataSetDropList selectedIndex isZero ifTrue: [ 
		dataSetTable data: nil.
		^ self
	].
	dataSet := dataSetDropList selectedItem.
	dataString := (DvtApp dataSetFileRefFor: dataSet) contents.
	(data := self class parseDataString: dataString) ifNil: [ ^ self ].
	dataSetTable data: data
]

{ #category : #private }
DvtSampleEditorPresenter >> onDeleteSampleButtonAction [
	| sample |
	sampleDropList selectedIndex isZero ifTrue: [ ^ self ].
	sample := sampleDropList selectedItem.
	(DvtYesNoDialog open: ('Выборка {1} будет удалёна из базы данных и из файловой системы. Продолжить?' format: { sample name })) ifFalse: [ ^ self ].
	DvtAppDB deleteSample: sample.
	(DvtApp sampleFileRefFor: sample) delete.
	self updateSampleDropList
]

{ #category : #private }
DvtSampleEditorPresenter >> onNewNodeButtonAction [
	| selection coord nodeType node |
	(selection := sampleTable dataGrid selectionRect) ifNil: [ ^ self ].
	coord := selection origin.
	(sampleTable isCellValueEditable: coord) ifFalse: [ 
		DvtErrorDialog open: 'Нельзя создать узел в выделенной ячейке.'.
		^ self
	].
	node := nil.
	nodeType := self class openPickNodeTypeDialog.
	(nodeType = #dict) ifTrue: [ node := Dictionary new ].
	(nodeType = #array) ifTrue: [ node := {} ].
	(nodeType = #arrayOfArrays) ifTrue: [ node := { { }. { } } ].
	(nodeType = #arrayOfDicts) ifTrue: [ node := { Dictionary new. Dictionary new } ].
	self assert: [ node isNotNil ].
	sampleTable
		putCellValue: node at: coord;
		updateNode.
	self updateSampleFile
]

{ #category : #private }
DvtSampleEditorPresenter >> onRequestDropListSelectedItemChanged [
	self updateDataSetDropList
]

{ #category : #private }
DvtSampleEditorPresenter >> onSampleDropListSelectedItemChanged [
	| sample sampleData |
	sampleTable data: nil.
	sampleDropList selectedIndex isZero ifTrue: [ ^ self ].
	sample := sampleDropList selectedItem.
	(sampleData := self class readJSONDataFromFileRef: (DvtApp sampleFileRefFor: sample)) ifNil: [ ^ self ].
	sampleTable data: sampleData
]

{ #category : #private }
DvtSampleEditorPresenter >> onWindowOpened [
	self
		updateRequestDropList;
		updateDataSetDropList;
		updateSampleDropList
]

{ #category : #accessing }
DvtSampleEditorPresenter >> requestDropList [
	^ requestDropList
]

{ #category : #accessing }
DvtSampleEditorPresenter >> requestLabel [
	^ requestLabel
]

{ #category : #accessing }
DvtSampleEditorPresenter >> sampleDropList [
	^ sampleDropList
]

{ #category : #accessing }
DvtSampleEditorPresenter >> sampleLabel [
	^ sampleLabel
]

{ #category : #accessing }
DvtSampleEditorPresenter >> sampleTable [
	^ sampleTable
]

{ #category : #private }
DvtSampleEditorPresenter >> updateDataSetDropList [
	dataSetDropList setIndex: 0.
	requestDropList selectedIndex isZero ifTrue: [ 
		dataSetDropList items: OrderedCollection empty
	] ifFalse: [ | request |
		request := requestDropList selectedItem.
		dataSetDropList items: (DvtAppDB dataSetsOfRequest: request)
	]
]

{ #category : #private }
DvtSampleEditorPresenter >> updateRequestDropList [
	requestDropList
		setIndex: 0;
		items: DvtAppDB requests
]

{ #category : #private }
DvtSampleEditorPresenter >> updateSampleDropList [
	sampleDropList
		setIndex: 0;
		items: DvtAppDB samples
]

{ #category : #private }
DvtSampleEditorPresenter >> updateSampleFile [
	| sample json |
	sampleDropList selectedIndex isZero ifTrue: [ ^ self ].
	sampleTable data ifNil: [ ^ self ].
	sample := sampleDropList selectedItem.
	json := NeoJSONWriter toStringPretty: sampleTable data.
	(DvtApp sampleFileRefFor: sample)
		writeStreamDo: [ :ws | ws nextPutAll: json	]
]
