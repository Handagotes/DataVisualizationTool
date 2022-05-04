Class {
	#name : #DvtEditRequestDialog,
	#superclass : #DvtDialog,
	#instVars : [
		'nameLabel',
		'nameTextInput',
		'requestLabel',
		'requestTextInput',
		'dataTypeLabel',
		'dataTypeDropList',
		'headerFieldsDataTable',
		'headerTextInput',
		'fieldTextInput',
		'addButton',
		'removeButton',
		'moveUpButton',
		'moveDownButton',
		'okButton',
		'cancelButton',
		'dvtRequest',
		'headerFields',
		'lastSelectedHeaderField'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtEditRequestDialog class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			newRow: [ :row |
				row
					add: #nameLabel width: 125;
					add: #nameTextInput
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #requestLabel width: 125;
					add: #requestTextInput
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #dataTypeLabel width: 125;
					add: #dataTypeDropList
			] height: self buttonHeight;
			add: #headerFieldsDataTable;
			newRow: [ :row |
				row
					add: #headerTextInput;
					add: #fieldTextInput
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #addButton;
					add: #removeButton;
					add: #moveUpButton;
					add: #moveDownButton
			] height: self buttonHeight;
			newRow: [ :row |
				row
					add: #okButton;
					add: #cancelButton
			] height: self buttonHeight
	];
	yourself
]

{ #category : #'instance creation' }
DvtEditRequestDialog class >> open [
	^ self open: DvtRequest default
]

{ #category : #api }
DvtEditRequestDialog class >> open: aDvtRequest [
	^ self open: aDvtRequest headerFields: OrderedCollection empty
]

{ #category : #api }
DvtEditRequestDialog class >> open: aDvtRequest headerFields: headerFields [
	^ self openDialogConfiguredAs: [ :dialog |
		dialog
			dvtRequest: aDvtRequest;
			headerFields: headerFields
	]
]

{ #category : #accessing }
DvtEditRequestDialog >> addButton [
	^ addButton
]

{ #category : #accessing }
DvtEditRequestDialog >> cancelButton [
	^ cancelButton
]

{ #category : #accessing }
DvtEditRequestDialog >> dataTypeDropList [
	^ dataTypeDropList
]

{ #category : #accessing }
DvtEditRequestDialog >> dataTypeLabel [
	^ dataTypeLabel
]

{ #category : #accessing }
DvtEditRequestDialog >> dvtRequest [
	^ dvtRequest
]

{ #category : #accessing }
DvtEditRequestDialog >> dvtRequest: aDvtRequest [
	dvtRequest := aDvtRequest.
	nameTextInput text: dvtRequest name.
	requestTextInput text: dvtRequest text
]

{ #category : #api }
DvtEditRequestDialog >> extent [
	^ 500 @ 400
]

{ #category : #accessing }
DvtEditRequestDialog >> fieldTextInput [
	^ fieldTextInput
]

{ #category : #accessing }
DvtEditRequestDialog >> headerFields [
	^ headerFields
]

{ #category : #accessing }
DvtEditRequestDialog >> headerFields: headerFieldOrderedCollection [
	| dataSource |
	headerFields := headerFieldOrderedCollection.
	dataSource := DvtRequestHeadersDataSource headerFields: headerFields.
	dataSource addColumnsTo: headerFieldsDataTable widget.
	headerFieldsDataTable widget dataSource: dataSource
]

{ #category : #accessing }
DvtEditRequestDialog >> headerFieldsDataTable [
	^ headerFieldsDataTable
]

{ #category : #accessing }
DvtEditRequestDialog >> headerTextInput [
	^ headerTextInput
]

{ #category : #initialization }
DvtEditRequestDialog >> initializePresenter [
	nameTextInput whenTextChanged: [ self updateOkButton ].
	requestTextInput whenTextChanged: [ self onRequestTextInputTextChanged ].
	headerFieldsDataTable when: FTSelectionChanged do: [ self onHeaderFieldsDataTableSelectionChanged ].
	addButton action: [ self onAddButtonAction ].
	removeButton action: [ self onRemoveButtonAction ].
	moveUpButton action: [ self onMoveUpButtonAction ].
	moveDownButton action: [ self onMoveDownButtonAction ].
	okButton action: [ self onOkButtonAction ].
	cancelButton action: [ self onCancelButtonAction ].
	self makeWindowUnresizeable
]

{ #category : #initialization }
DvtEditRequestDialog >> initializeWidgets [
	nameLabel := self newLabel.
	nameTextInput := self newTextInput.
	requestLabel := self newLabel.
	requestTextInput := self newTextInput.
	dataTypeLabel := self newLabel.
	dataTypeDropList := self newDropList.
	headerFieldsDataTable := self newDataTable.
	headerTextInput := self newTextInput.
	fieldTextInput := self newTextInput.
	addButton := self newButton.
	removeButton := self newButton.
	moveUpButton := self newButton.
	moveDownButton := self newButton.
	okButton := self newButton.
	cancelButton := self newButton.
	
	nameLabel label: 'Название запроса:'.
	nameTextInput autoAccept: true.
	requestLabel label: 'Текст запроса:'.
	requestTextInput autoAccept: true.
	dataTypeLabel label: 'Тип данных:'.
	dataTypeDropList
		displayBlock: [ :i |
			{ 
				#auto -> 'Определить автоматически'.
				#json -> 'JSON'.
				#csv -> 'CSV (значения, разделенные запятой)'.
				#tsv -> 'TSV (значения, разделенные табуляцией)'.
			} asDictionary at: i
		];
		items: #(auto json csv tsv).
	headerFieldsDataTable widget beSingleSelection.
	headerTextInput autoAccept: true.
	fieldTextInput autoAccept: true.
	addButton label: '+'.
	removeButton
		disable;
		label: '-'.
	moveUpButton
		disable;
		label: '^'.
	moveDownButton
		disable;
		label: 'v'.
	okButton
		disable;
		label: 'Ок'.
	cancelButton label: 'Отмена'.
	
	self focusOrder
		add: nameTextInput;
		add: requestTextInput;
		add: dataTypeDropList;
		add: headerFieldsDataTable;
		add: headerTextInput;
		add: fieldTextInput;
		add: addButton;
		add: removeButton;
		add: moveUpButton;
		add: moveDownButton;
		add: okButton;
		add: cancelButton
]

{ #category : #testing }
DvtEditRequestDialog >> isHeaderFieldSelectionValid [
	| i |
	i := self selectedHeaderFieldIndex.
	^ i > 0 and: [ i <= headerFields size ]
]

{ #category : #accessing }
DvtEditRequestDialog >> moveDownButton [
	^ moveDownButton
]

{ #category : #accessing }
DvtEditRequestDialog >> moveUpButton [
	^ moveUpButton
]

{ #category : #accessing }
DvtEditRequestDialog >> nameLabel [
	^ nameLabel
]

{ #category : #accessing }
DvtEditRequestDialog >> nameTextInput [
	^ nameTextInput
]

{ #category : #accessing }
DvtEditRequestDialog >> okButton [
	^ okButton
]

{ #category : #private }
DvtEditRequestDialog >> onAddButtonAction [
	headerTextInput text ifEmpty: [ ^ self ].
	headerFields add: (DvtHeaderField new
		header: headerTextInput text;
		field: fieldTextInput text;
		yourself).
	headerTextInput text: String empty.
	fieldTextInput text: String empty.
	self updateHeadersDataTable
]

{ #category : #private }
DvtEditRequestDialog >> onCancelButtonAction [
	self closeDialog
]

{ #category : #private }
DvtEditRequestDialog >> onHeaderFieldsDataTableSelectionChanged [
	| headerField i |
	headerField := self selectedHeaderField.
	self saveLastSelectedHeaderFieldChanges.
	lastSelectedHeaderField := headerField.
	
	headerField ifNil: [ 
		headerTextInput text: String empty.
		fieldTextInput text: String empty.
		moveUpButton disable.
		moveDownButton disable.
		removeButton disable.
		addButton enable.
		^ self
	].
	
	headerTextInput text: headerField header.
	fieldTextInput text: headerField field.
	i := self selectedHeaderFieldIndex.
	moveUpButton enabled: i > 1.
	moveDownButton enabled: i < headerFields size.
	removeButton enable.
	addButton disable
]

{ #category : #private }
DvtEditRequestDialog >> onMoveDownButtonAction [
	| i |
	self isHeaderFieldSelectionValid ifFalse: [ ^ self ].
	i := self selectedHeaderFieldIndex.
	headerFields swap: i with: i + 1.
	self updateHeadersDataTable.
	headerFieldsDataTable widget selectRowIndex: i + 1
]

{ #category : #private }
DvtEditRequestDialog >> onMoveUpButtonAction [
	| i |
	self isHeaderFieldSelectionValid ifFalse: [ ^ self ].
	i := self selectedHeaderFieldIndex.
	headerFields swap: i with: i - 1.
	self updateHeadersDataTable.
	headerFieldsDataTable widget selectRowIndex: i - 1
]

{ #category : #private }
DvtEditRequestDialog >> onOkButtonAction [
	self saveLastSelectedHeaderFieldChanges.
	
	dvtRequest
		name: nameTextInput text;
		dataType: dataTypeDropList selectedItem asString;
		text: requestTextInput text.
	
	headerFields doWithIndex: [ :headerField :i |
		headerField order: i
	].
	
	self closeDialog: { dvtRequest. headerFields }
]

{ #category : #private }
DvtEditRequestDialog >> onRemoveButtonAction [
	self isHeaderFieldSelectionValid ifFalse: [ ^ self ].
	headerFields removeAt: self selectedHeaderFieldIndex.
	headerTextInput text: String empty.
	fieldTextInput text: String empty.
	self updateHeadersDataTable
]

{ #category : #private }
DvtEditRequestDialog >> onRequestTextInputTextChanged [
	| text |
	self updateOkButton.
	text := requestTextInput text.
	(text endsWith: '.json') ifTrue: [ ^ dataTypeDropList setSelectedItem: #json ].
	(text endsWith: '.csv') ifTrue: [ ^ dataTypeDropList setSelectedItem: #csv ].
	(text endsWith: '.tsv') ifTrue: [ ^ dataTypeDropList setSelectedItem: #tsv ].
	dataTypeDropList setSelectedItem: #auto
]

{ #category : #accessing }
DvtEditRequestDialog >> removeButton [
	^ removeButton
]

{ #category : #accessing }
DvtEditRequestDialog >> requestLabel [
	^ requestLabel
]

{ #category : #accessing }
DvtEditRequestDialog >> requestTextInput [
	^ requestTextInput
]

{ #category : #private }
DvtEditRequestDialog >> saveLastSelectedHeaderFieldChanges [
	| header field |
	lastSelectedHeaderField ifNil: [ ^ self ].
	header := headerTextInput text.
	field := fieldTextInput text.
	header ifEmpty: [ ^ self ].
	lastSelectedHeaderField
		header: header;
		field: field
]

{ #category : #private }
DvtEditRequestDialog >> selectedHeaderField [
	self isHeaderFieldSelectionValid ifFalse: [ ^ nil ].
	^ headerFieldsDataTable widget dataSource elementAt: self selectedHeaderFieldIndex
]

{ #category : #private }
DvtEditRequestDialog >> selectedHeaderFieldIndex [
	^ headerFieldsDataTable widget selectedRowIndex
]

{ #category : #private }
DvtEditRequestDialog >> updateAddButton [
	addButton enabled: headerTextInput text isNotEmpty
]

{ #category : #private }
DvtEditRequestDialog >> updateHeadersDataTable [
	headerFieldsDataTable widget refresh
]

{ #category : #private }
DvtEditRequestDialog >> updateOkButton [
	okButton enabled: (nameTextInput text isValidFileName and: [ requestTextInput text isNotEmpty ])
]
