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
	script := editor generateScript.
	path := (FileDialogWindow onFileSystem: FileSystem disk)
		openModal;
		answer
]

{ #category : #private }
DvtVisualizationEditorPanel >> onOpenVisualizationButtonAction [
	DvtVisualizationViewPresenter openForView: editor generateView
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
