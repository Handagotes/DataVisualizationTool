Class {
	#name : #DvtSampleEditorPresenter,
	#superclass : #DvtPresenter,
	#instVars : [
		'requestLabel',
		'requestDropList',
		'dataSetLabel',
		'dataSetDropList',
		'dataSetTable',
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
	]
]

{ #category : #accessing }
DvtSampleEditorPresenter >> clearButton [
	^ clearButton
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
	copyButton action: [ self onCopyButtonAction ].
	clearButton action: [ self onClearButtonAction ].
	createSampleButton action: [ self onCreateSampleButtonAction ].
	deleteSampleButton action: [ self onDeleteSampleButtonAction ]
]

{ #category : #initialization }
DvtSampleEditorPresenter >> initializeWidgets [
	requestLabel := self newLabel.
	requestDropList := self newDropList.
	dataSetLabel := self newLabel.
	dataSetDropList := self newDropList.
	dataSetTable := self newDvtDataSetTable.
	
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
	
	copyButton icon: (DvtImages loadImageNamed: #moveIcon).
	clearButton icon: (DvtImages loadImageNamed: #crossIcon).
	
	sampleLabel label: 'Выборка:'.
	sampleDropList displayBlock: self class sampleDropListDisplayBlock.
	createSampleButton label: 'Новая выборка'.
	deleteSampleButton label: 'Удалить выборку'
	
]

{ #category : #private }
DvtSampleEditorPresenter >> onClearButtonAction [
	
]

{ #category : #private }
DvtSampleEditorPresenter >> onCopyButtonAction [
	
]

{ #category : #private }
DvtSampleEditorPresenter >> onCreateSampleButtonAction [
	
]

{ #category : #private }
DvtSampleEditorPresenter >> onDataSetDropListSelectedItemChanged [
	
]

{ #category : #private }
DvtSampleEditorPresenter >> onDeleteSampleButtonAction [
	
]

{ #category : #private }
DvtSampleEditorPresenter >> onRequestDropListSelectedItemChanged [
	
]

{ #category : #private }
DvtSampleEditorPresenter >> onSampleDropListSelectedItemChanged [
	
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
