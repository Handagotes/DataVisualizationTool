Class {
	#name : #DvtVisualizationEditor,
	#superclass : #DynamicComposablePresenter,
	#instVars : [
		'visualization',
		'sampleFilePath',
		'sampleData',
		'config'
	],
	#category : #'DataVisualizationTool-Boundary'
}

{ #category : #private }
DvtVisualizationEditor >> addColorPickButton: name label: label defaultColor: color [
	| button form |
	self instantiatePresenters: { name. #ButtonPresenter }.
	form := color asFormOfExtent: 16 @ 16.
	(button := widgets at: name)
		label: ' ' , label;
		icon: form;
		action: [ | picker topWindow |
			picker := ColorSelectorDialogWindow new.
			topWindow := SystemWindow topWindow.
			picker selectedColor: (form colorAt: 1 @ 1).
			topWindow modalLockTo: picker.
			picker openModal.
			topWindow modalUnlockFrom: picker.
			picker cancelled ifFalse: [ 
				form fillColor: picker selectedColor.
				button icon: form
			].
		]
]

{ #category : #accessing }
DvtVisualizationEditor >> config [
	^ config
]

{ #category : #accessing }
DvtVisualizationEditor >> config: aCollectionOfCollections [
	config := aCollectionOfCollections
]

{ #category : #api }
DvtVisualizationEditor >> generateScript [
	self subclassResponsibility
]

{ #category : #api }
DvtVisualizationEditor >> generateView [
	| view |
	[ 
		view := Smalltalk compiler evaluate: self generateScript
	] on: Error do: [ :e |
		DvtErrorDialog open: ('Произошла ошибка выполнения сценария. "{1}"' format: { e messageText }).
		^ nil
	].
	self assert: [ view isKindOf: RTView ].
	^ view
]

{ #category : #api }
DvtVisualizationEditor >> pickedColorFor: colorPickButtonName [
	^ (widgets at: colorPickButtonName) icon colorAt: 1 @ 1
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleData [
	^ sampleData
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleData: anObject [
	sampleData := anObject
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleFilePath [
	^ sampleFilePath
]

{ #category : #accessing }
DvtVisualizationEditor >> sampleFilePath: anObject [
	sampleFilePath := anObject
]

{ #category : #private }
DvtVisualizationEditor >> scriptSnippetForSampleLoad [
	^ 'sample := NeoJSONReader fromString: (''{1}'' asFileReference readStreamDo: [ :rs | rs upToEnd ]).' format: { sampleFilePath }
]

{ #category : #api }
DvtVisualizationEditor >> updateConfigFile [
	| json |
	config ifNil: [ ^ self ].
	json := NeoJSONWriter toString: config.
	(DvtApp visualizationFileRefFor: visualization)
		ensureCreateFile;
		writeStreamDo: [ :ws | ws nextPutAll: json	]
]

{ #category : #accessing }
DvtVisualizationEditor >> visualization [
	^ visualization
]

{ #category : #accessing }
DvtVisualizationEditor >> visualization: anObject [
	visualization := anObject
]
