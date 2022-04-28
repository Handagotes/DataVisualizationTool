Class {
	#name : #DvtVisualizerPresenter,
	#superclass : #DvtPresenter,
	#instVars : [
		'sampleLabel',
		'sampleDropList',
		'sampleTable',
		'visualizationLabel',
		'visualizationsDropList',
		'createVisualizationButton',
		'deleteVisualizationButton'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtVisualizerPresenter class >> defaultSpec [
	'sampleLabel sampleDropList sampleTable visualizationLabel visualizationsDropList createVisualizationButton deleteVisualizationButton'.
	^ SpecLayout composed newRow: [ :row |
		row
			newColumn: [ :column |
				column
					newRow: [ :sampleRow |
						sampleRow
							add: #sampleLabel width: 75;
							add: #sampleDropList
					]  height: self toolbarHeight;
					add: #sampleTable
			];
			newColumn: [ :column |
				column
					newRow: [ :visualizationRow |
						visualizationRow
							add: #visualizationLabel width: 90;
							add: #visualizationsDropList
					] height: self toolbarHeight;
					newRow: [ :visualizationButtonsRow |
						visualizationButtonsRow
							add: #createVisualizationButton;
							add: #deleteVisualizationButton
					] height: self buttonHeight
					
			]
	]
]

{ #category : #accessing }
DvtVisualizerPresenter >> createVisualizationButton [
	^ createVisualizationButton
]

{ #category : #accessing }
DvtVisualizerPresenter >> deleteVisualizationButton [
	^ deleteVisualizationButton
]

{ #category : #api }
DvtVisualizerPresenter >> extent [
	^ 1050 @ 600
]

{ #category : #initialization }
DvtVisualizerPresenter >> initializePresenter [
	super initializePresenter.
	sampleDropList whenSelectedItemChanged: [ self onSampleDropListSelectedItemChanged ].
	visualizationsDropList whenSelectedItemChanged: [ self onVisualizationDropListSelectedItemChanged ].
	createVisualizationButton action: [ self onCreateVisualizationButtonAction ].
	deleteVisualizationButton action: [ self onDeleteVisualizationButtonAction ].
]

{ #category : #initialization }
DvtVisualizerPresenter >> initializeWidgets [
	'sampleLabel sampleDropList sampleTable visualizationLabel visualizationsDropList createVisualizationButton deleteVisualizationButton'.
	sampleLabel := self newLabel.
	sampleDropList := self newDropList.
	sampleTable := self newDvtDataSetTable.
	visualizationLabel := self newLabel.
	visualizationsDropList := self newDropList.
	createVisualizationButton := self newButton.
	deleteVisualizationButton := self newButton.
	
	sampleLabel label: 'Выборка:'.
	sampleDropList displayBlock: self class sampleDropListDisplayBlock.
	visualizationLabel label: 'Визуализация:'.
	visualizationsDropList displayBlock: self class visualizationDropListDisplayBlock.
	createVisualizationButton label: 'Новая визуализация'.
	deleteVisualizationButton label: 'Удалить визуализацию'
]

{ #category : #private }
DvtVisualizerPresenter >> onCreateVisualizationButtonAction [
	
]

{ #category : #private }
DvtVisualizerPresenter >> onDeleteVisualizationButtonAction [
	
]

{ #category : #private }
DvtVisualizerPresenter >> onSampleDropListSelectedItemChanged [
	| sample sampleData |
	sampleTable data: nil.
	sampleDropList selectedIndex isZero ifTrue: [ ^ self ].
	sample := sampleDropList selectedItem.
	(sampleData := self class readSampleData: sample) ifNil: [ ^ self ].
	sampleTable data: sampleData
]

{ #category : #private }
DvtVisualizerPresenter >> onVisualizationDropListSelectedItemChanged [
	
]

{ #category : #private }
DvtVisualizerPresenter >> onWindowOpened [
	self
		updateSampleDropList;
		updateVisualizationDropList
]

{ #category : #accessing }
DvtVisualizerPresenter >> sampleDropList [
	^ sampleDropList
]

{ #category : #accessing }
DvtVisualizerPresenter >> sampleLabel [
	^ sampleLabel
]

{ #category : #accessing }
DvtVisualizerPresenter >> sampleTable [
	^ sampleTable
]

{ #category : #private }
DvtVisualizerPresenter >> updateSampleDropList [
	sampleDropList
		setIndex: 0;
		items: DvtAppDB samples
]

{ #category : #private }
DvtVisualizerPresenter >> updateVisualizationDropList [
	| sample |
	sampleDropList selectedIndex isZero ifTrue: [ ^ self ].
	sample := sampleDropList selectedItem.
	visualizationsDropList
		items: (DvtAppDB visualizationsOfSample: sample);
		setIndex: 0.
]

{ #category : #accessing }
DvtVisualizerPresenter >> visualizationLabel [
	^ visualizationLabel
]

{ #category : #accessing }
DvtVisualizerPresenter >> visualizationsDropList [
	^ visualizationsDropList
]
