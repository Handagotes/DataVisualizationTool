Class {
	#name : #DvtVisualizationEditorPanel,
	#superclass : #ComposablePresenter,
	#instVars : [
		'editor',
		'openVisualizationButton',
		'exportScriptButton'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #specs }
DvtVisualizationEditorPanel class >> defaultSpec [
	^ SpecLayout composed newColumn: [ :column |
		column
			add: #editor;
			newRow: [ :row |
				row
					add: #openVisualizationButton;
					add: #exportScriptButton
			] height: self buttonHeight
	];
	yourself
]

{ #category : #api }
DvtVisualizationEditorPanel >> closeEditor [
	editor := self newNullPresenter.
	self
		needRebuild: false;
		buildWithSpec
]

{ #category : #accessing }
DvtVisualizationEditorPanel >> editor [
	^ editor
]

{ #category : #accessing }
DvtVisualizationEditorPanel >> exportScriptButton [
	^ exportScriptButton
]

{ #category : #initialization }
DvtVisualizationEditorPanel >> initializePresenter [
	openVisualizationButton action: [ self onOpenVisualizationButtonAction ].
	exportScriptButton action: [ self onExportScriptButtonAction ]
]

{ #category : #initialization }
DvtVisualizationEditorPanel >> initializeWidgets [
	editor := self newNullPresenter.
	openVisualizationButton := self newButton.
	exportScriptButton := self newButton.
	
	openVisualizationButton label: 'Открыть визуализацию'.
	exportScriptButton label: 'Экспортировать сценарий...'
]

{ #category : #private }
DvtVisualizationEditorPanel >> onExportScriptButtonAction [
	| script path |
	(editor isKindOf: NullPresenter) ifTrue: [ ^ nil ].
	script := editor generateScript.
	path := (FileDialogWindow onFileSystem: FileSystem disk)
		openModal;
		answer
]

{ #category : #private }
DvtVisualizationEditorPanel >> onOpenVisualizationButtonAction [
	(editor isKindOf: NullPresenter) ifTrue: [ ^ nil ].
	DvtVisualizationViewPresenter openForView: editor generateView
]

{ #category : #api }
DvtVisualizationEditorPanel >> openEditorClass: aClass visualization: visualization sampleFilePath: sampleFilePath sampleData: sampleData [
	self assert: [ aClass isKindOf: DvtVisualizationEditor ].
	(editor := self instantiate: aClass)
		visualization: visualization;
		sampleFilePath: sampleFilePath;
		sampleData: sampleData.
	self
		needRebuild: false;
		buildWithSpec
]

{ #category : #accessing }
DvtVisualizationEditorPanel >> openVisualizationButton [
	^ openVisualizationButton
]

{ #category : #accessing }
DvtVisualizationEditorPanel >> sampleFilePath [
	(editor isKindOf: NullPresenter) ifTrue: [ ^ nil ].
	^ editor sampleFilePath
]

{ #category : #accessing }
DvtVisualizationEditorPanel >> sampleFilePath: aString [
	self assert: [ editor isKindOf: DvtVisualizationEditor ].
	editor sampleFilePath: aString
]
