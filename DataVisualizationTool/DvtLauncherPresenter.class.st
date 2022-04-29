Class {
	#name : #DvtLauncherPresenter,
	#superclass : #DvtPresenter,
	#instVars : [
		'dataFetcherButton',
		'dataFetcherText',
		'sampleEditorButton',
		'sampleEditorText',
		'visualizerButton',
		'visualizerText',
		'menu'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtLauncherPresenter class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #menu height: self toolbarHeight;
			newRow: [ :row |
				row
					add: #dataFetcherButton width: 71;
					add: #dataFetcherText
			] height: 75;
			newRow: [ :row |
				row
					add: #sampleEditorButton width: 71;
					add: #sampleEditorText
			] height: 75;
			newRow: [ :row |
				row
					add: #visualizerButton width: 71;
					add: #visualizerText
			] height: 75
	];
	yourself
]

{ #category : #accessing }
DvtLauncherPresenter >> dataFetcherButton [
	^ dataFetcherButton
]

{ #category : #accessing }
DvtLauncherPresenter >> dataFetcherText [
	^ dataFetcherText
]

{ #category : #api }
DvtLauncherPresenter >> extent [
	^ 375 @ 291
]

{ #category : #initialization }
DvtLauncherPresenter >> initializeMenu [
	(menu := MenuPresenter new) addGroup: [ :group |
		group addItem: [ :appMenuItem | | subMenu |
			(subMenu := MenuPresenter new) addGroup: [ :appGroup |
				appGroup
					addItem: [ :item |
						item
							name: 'Очистить БД';
							action: [ self onClearDBMenuItemAction ]
					];
					addItem: [ :item |
						item
							name: 'Выход';
							action: [ self onExitMenuItemAction ]
					]
			].
			appMenuItem
				name: 'Приложение';
				subMenu: subMenu
		]
	].
]

{ #category : #initialization }
DvtLauncherPresenter >> initializePresenter [
	super initializePresenter.
	dataFetcherButton action: [ self onDataFetcherButtonAction ].
	sampleEditorButton action: [ self onSampleEditorButtonAction ].
	visualizerButton action: [ self onVisualizerButtonAction ].
]

{ #category : #initialization }
DvtLauncherPresenter >> initializeWidgets [
	self initializeMenu.
	dataFetcherButton := self newButton.
	dataFetcherText := self newText.
	sampleEditorButton := self newButton.
	sampleEditorText := self newText.
	visualizerButton := self newButton.
	visualizerText := self newText.
	
	dataFetcherButton icon: (DvtImages loadImageNamed: #requestIcon).
	visualizerButton icon: (DvtImages loadImageNamed: #graphIcon).
	sampleEditorButton icon: (DvtImages loadImageNamed: #sampleIcon).
	
	dataFetcherText
		disable;
		text: 'Сборщик данных. Помогает составлять запросы, получать и сохранять через них данные.'.
	sampleEditorText
		disable;
		text: 'Редактор выборки. Комбинирует данные из разных файлов чтобы подготовить их к анализу.'.
	visualizerText
		disable;
		text: 'Визуализатор. Позволяет создавать, настраивать, и экспортировать визуализации.'.
	
	self focusOrder
		add: dataFetcherButton;
		add: sampleEditorButton;
		add: visualizerButton
]

{ #category : #accessing }
DvtLauncherPresenter >> menu [
	^ menu
]

{ #category : #private }
DvtLauncherPresenter >> onClearDBMenuItemAction [
	(DvtYesNoDialog open: 'Все сохраненные запросы, визуализации и выборки будут уничтожены. Продолжить?' ) ifFalse: [ ^ self ].
	DvtApp folderRoot asFileReference ensureDeleteAll.
	DvtApp clearDB
]

{ #category : #private }
DvtLauncherPresenter >> onDataFetcherButtonAction [
	DvtApp openDataFetcher
]

{ #category : #private }
DvtLauncherPresenter >> onExitMenuItemAction [
	DvtApp close
]

{ #category : #private }
DvtLauncherPresenter >> onSampleEditorButtonAction [
	DvtApp openSampleEditor
]

{ #category : #private }
DvtLauncherPresenter >> onVisualizerButtonAction [
	DvtApp openVisualizer
]

{ #category : #private }
DvtLauncherPresenter >> onWindowOpened [
	self window containingWindow
		beUnresizeable;
		removeExpandBox
]

{ #category : #accessing }
DvtLauncherPresenter >> sampleEditorButton [
	^ sampleEditorButton
]

{ #category : #accessing }
DvtLauncherPresenter >> sampleEditorText [
	^ sampleEditorText
]

{ #category : #accessing }
DvtLauncherPresenter >> visualizerButton [
	^ visualizerButton
]

{ #category : #accessing }
DvtLauncherPresenter >> visualizerText [
	^ visualizerText
]
