Class {
	#name : #DvtVisualizerPresenter,
	#superclass : #DvtPresenter,
	#instVars : [
		'sampleLabel',
		'sampleDropList',
		'sampleTable',
		'visualizationLabel',
		'visualizationDropList',
		'createVisualizationButton',
		'deleteVisualizationButton',
		'visualizationEditorPanel'
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
			addSplitter;
			newColumn: [ :column |
				column
					newRow: [ :visualizationRow |
						visualizationRow
							add: #visualizationLabel width: 90;
							add: #visualizationDropList
					] height: self toolbarHeight;
					newRow: [ :visualizationButtonsRow |
						visualizationButtonsRow
							add: #createVisualizationButton;
							add: #deleteVisualizationButton
					] height: self buttonHeight;
					add: #visualizationEditorPanel
			]
	];
	yourself
]

{ #category : #api }
DvtVisualizerPresenter class >> openPickVisualizationTypeDialog [
	^ DvtDropListDialog
		open: 'Выберите тип визуализации'
		items: #(graph scatterPlot barChart pieChart radar tree)
		displayBlock: [ :option | 
			{
				#graph -> 'График'.
				#barChart -> 'Столбчатая диаграмма'.
				#pieChart -> 'Круговая диаграмма'.
				#radar -> 'Радиальная диаграмма'.
				#tree -> 'Дерево'.
			} asDictionary at: option
		]
		descriptionBlock: [ :option |
			{ 
				#graph -> 'График зависимости одного значения от другого.'.
				#barChart -> 'Диаграмма сравнения нескольких дискретных категорий.'.
				#pieChart -> 'Секторная диаграмма, отображающая доли величин в общем объёме.'.
				#radar -> 'Диаграмма с несколькими осями для одновременного отображения нескольких независимых величин.'.
				#tree -> 'Диаграмма для иерархического представления данных.'.
			} asDictionary at: option
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
	^ 1200 @ 600
]

{ #category : #initialization }
DvtVisualizerPresenter >> initializePresenter [
	super initializePresenter.
	sampleDropList whenSelectedItemChanged: [ self onSampleDropListSelectedItemChanged ].
	visualizationDropList whenSelectedItemChanged: [ self onVisualizationDropListSelectedItemChanged ].
	createVisualizationButton action: [ self onCreateVisualizationButtonAction ].
	deleteVisualizationButton action: [ self onDeleteVisualizationButtonAction ]
]

{ #category : #initialization }
DvtVisualizerPresenter >> initializeWidgets [
	'sampleLabel sampleDropList sampleTable visualizationLabel visualizationsDropList createVisualizationButton deleteVisualizationButton'.
	sampleLabel := self newLabel.
	sampleDropList := self newDropList.
	sampleTable := self newDvtDataTable.
	visualizationLabel := self newLabel.
	visualizationDropList := self newDropList.
	createVisualizationButton := self newButton.
	deleteVisualizationButton := self newButton.
	visualizationEditorPanel := self instantiate: DvtVisualizationEditorPanel.
	
	sampleLabel label: 'Выборка:'.
	sampleDropList displayBlock: self class sampleDropListDisplayBlock.
	visualizationLabel label: 'Визуализация:'.
	visualizationDropList displayBlock: self class visualizationDropListDisplayBlock.
	createVisualizationButton label: 'Новая визуализация'.
	deleteVisualizationButton label: 'Удалить визуализацию'
]

{ #category : #private }
DvtVisualizerPresenter >> onCreateVisualizationButtonAction [
	| sample name visualizationType visualization basicConfig |
	sampleDropList selectedIndex isZero ifTrue: [ 
		^ DvtErrorDialog open: 'Перед тем как создать визуализацию, укажите выборку в выпадающем списке слева.'
	].
	sample := sampleDropList selectedItem.
	name := ''.
	[ 
		(name := (DvtTextInputDialog open: 'Введите имя визуализации.' default: name)) ifNil: [ ^ self ].
		(visualizationType := self class openPickVisualizationTypeDialog) ifNil: [ ^ self ].
		
		visualization := (DvtVisualization new
			name: name;
			configFilePath: name , '.json';
			sampleId: sample id;
			yourself).
		[ 
			DvtAppDB insertVisualization: visualization.
			true
		] on: SQLite3ConstraintViolation do: [ 
			DvtErrorDialog open: ('Визуализация с именем "{1}" уже существует.' format: { name }).
			false
		]
	] whileFalse.
	
	basicConfig := NeoJSONWriter toStringPretty: { 'type' -> visualizationType } asDictionary.
	(DvtApp visualizationFileRefFor: visualization)
		ensureCreateFile;
		writeStreamDo: [ :ws | ws nextPutAll: basicConfig	].
	
	self updateVisualizationDropList
]

{ #category : #private }
DvtVisualizerPresenter >> onDeleteVisualizationButtonAction [
	| visualization |
	visualizationDropList selectedIndex isZero ifTrue: [ ^ self ].
	visualization := visualizationDropList selectedItem.
	(DvtYesNoDialog open: ('Визуализация {1} будет удалёна из базы данных и из файловой системы. Продолжить?' format: { visualization name })) ifFalse: [ ^ self ].
	DvtAppDB deleteVisualization: visualization.
	(DvtApp visualizationFileRefFor: visualization) delete.
	self updateVisualizationDropList
]

{ #category : #private }
DvtVisualizerPresenter >> onSampleDropListSelectedItemChanged [
	| sample sampleData |
	sampleTable data: nil.
	sampleDropList selectedIndex isZero ifTrue: [ ^ self ].
	sample := sampleDropList selectedItem.
	(sampleData := self class readJSONDataFromFileRef: (DvtApp sampleFileRefFor: sample)) ifNil: [ ^ self ].
	sampleTable data: sampleData.
	self updateVisualizationDropList
]

{ #category : #private }
DvtVisualizerPresenter >> onVisualizationDropListSelectedItemChanged [
	| visualization sample configData editorClass |
	visualizationDropList selectedIndex isZero ifTrue: [ ^ visualizationEditorPanel closeEditor ].
	visualization := visualizationDropList selectedItem.
	sample := sampleDropList selectedItem.
	(configData := self class readJSONDataFromFileRef: (DvtApp visualizationFileRefFor: visualization)) ifNil: [ ^ self ].
	editorClass := { 
		#graph -> DvtGraphVisualizationEditor.
		#barChart -> DvtBarChartVisualizationEditor.
		#pieChart -> DvtPieChartVisualizationEditor.
		#radar -> DvtRadarVisualizationEditor.
		#tree -> DvtTreeVisualizationEditor.
	} asDictionary at: (configData at: #type).
	
	visualizationEditorPanel
		openEditorClass: editorClass
		visualization: visualization
		sampleFilePath: (DvtApp samplesFolder , sample sampleFilePath)
		sampleData: sampleTable data
	
]

{ #category : #private }
DvtVisualizerPresenter >> onWindowClosed [
	visualizationEditorPanel updateVisualizationConfigFile
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
	visualizationDropList
		setIndex: 0;
		items: (DvtAppDB visualizationsOfSample: sample)
]

{ #category : #accessing }
DvtVisualizerPresenter >> visualizationDropList [
	^ visualizationDropList
]

{ #category : #accessing }
DvtVisualizerPresenter >> visualizationEditorPanel [
	^ visualizationEditorPanel
]

{ #category : #accessing }
DvtVisualizerPresenter >> visualizationLabel [
	^ visualizationLabel
]
