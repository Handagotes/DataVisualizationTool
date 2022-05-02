Class {
	#name : #DvtVisualizationEditorPanel,
	#superclass : #ComposablePresenter,
	#instVars : [
		'editor',
		'openVisualizationButton',
		'openScriptInPlaygroundButton',
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
					add: #openScriptInPlaygroundButton;
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
	openScriptInPlaygroundButton action: [ self onOpenScriptInPlaygroundButtonAction ].
	exportScriptButton action: [ self onExportScriptButtonAction ]
]

{ #category : #initialization }
DvtVisualizationEditorPanel >> initializeWidgets [
	editor := self newNullPresenter.
	openVisualizationButton := self newButton.
	openScriptInPlaygroundButton := self newButton.
	exportScriptButton := self newButton.
	
	openVisualizationButton label: 'Открыть визуализацию'.
	openScriptInPlaygroundButton label: 'Открыть сценарий в Playground'.
	exportScriptButton label: 'Экспортировать сценарий...'
]

{ #category : #private }
DvtVisualizationEditorPanel >> onExportScriptButtonAction [
	| script fileRef |
	(editor isKindOf: NullPresenter) ifTrue: [ ^ nil ].
	(fileRef := FileDialogWindow askForFileRefToSaveWithExtensions: #(st txt)) ifNil: [ ^ self ].
	editor updateConfig.
	script := editor generateScript.
	fileRef
		ensureCreateFile;
		writeStreamDo: [ :ws | ws nextPutAll: script ]
]

{ #category : #private }
DvtVisualizationEditorPanel >> onOpenScriptInPlaygroundButtonAction [
	| script |
	(editor isKindOf: NullPresenter) ifTrue: [ ^ nil ].
	editor updateConfig.
	script := editor generateScript.
	GTPlayground openContents: script
]

{ #category : #private }
DvtVisualizationEditorPanel >> onOpenVisualizationButtonAction [
	| view |
	(editor isKindOf: NullPresenter) ifTrue: [ ^ self ].
	(view := editor generateView) ifNil: [ ^ self ].
	DvtVisualizationViewPresenter openForView: view
]

{ #category : #api }
DvtVisualizationEditorPanel >> openEditorClass: aClass visualization: visualization sampleFilePath: sampleFilePath sampleData: sampleData [
	self assert: [ aClass isKindOf: DvtVisualizationEditor class ].
	self updateVisualizationConfigFile.
	(editor := self instantiate: aClass)
		visualization: visualization;
		sampleFilePath: sampleFilePath;
		sampleData: sampleData.
	self
		needRebuild: false;
		buildWithSpec
]

{ #category : #accessing }
DvtVisualizationEditorPanel >> openScriptInPlaygroundButton [
	^ openScriptInPlaygroundButton
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

{ #category : #api }
DvtVisualizationEditorPanel >> updateVisualizationConfigFile [
	(editor isKindOf: DvtVisualizationEditor) ifTrue: [ 
		editor
			updateConfig;
			updateConfigFile
	]
]
