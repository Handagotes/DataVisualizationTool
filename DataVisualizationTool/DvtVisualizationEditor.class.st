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

{ #category : #private }
DvtVisualizationEditor >> addTextInput: name label: label [
	| labelName |
	labelName := name , 'Label'.
	self instantiatePresenters: { 
		name. #TextInputFieldPresenter.
		labelName. #LabelPresenter
	}.
	(widgets at: name)	autoAccept: true.
	(widgets at: labelName) label: label
]

{ #category : #accessing }
DvtVisualizationEditor >> config [
	^ config
]

{ #category : #accessing }
DvtVisualizationEditor >> config: aDictionary [
	config := aDictionary
]

{ #category : #api }
DvtVisualizationEditor >> generateScript [
	self subclassResponsibility
]

{ #category : #api }
DvtVisualizationEditor >> generateView [
	| view |
	self updateConfig.
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
DvtVisualizationEditor >> keyFor: keyTextInputName [
	| key type |
	key := (widgets at: keyTextInputName) text.
	key ifEmpty: [ ^ key ].
	(key first = $' and: [ key last = $' ]) ifTrue: [ ^ key ].
	type := DvtDataTableProcessor resolveTypeForValueString: key.
	type = #string ifTrue: [ key := '''{1}''' format: { key } ].
	^ key
]

{ #category : #private }
DvtVisualizationEditor >> loadConfigToWidgets [
	self subclassResponsibility
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
	^ 'sample := NeoJSONReader fromString: (''{1}'' asFileReference readStreamDo: [ :rs | rs upToEnd ]).{2}' format: { sampleFilePath. String cr }
]

{ #category : #initialization }
DvtVisualizationEditor >> setPickedColor: aColor for: colorPickButtonName [
	| button |
	button := widgets at: colorPickButtonName.
	button icon fillColor: aColor.
	button icon: button icon
]

{ #category : #api }
DvtVisualizationEditor >> updateConfig [
	self subclassResponsibility
]

{ #category : #api }
DvtVisualizationEditor >> updateConfigFile [
	| json |
	config ifNil: [ ^ self ].
	json := NeoJSONWriter toStringPretty: config.
	(DvtApp visualizationFileRefFor: visualization)
		ensureDelete;
		writeStreamDo: [ :ws | ws nextPutAll: json	]
]

{ #category : #accessing }
DvtVisualizationEditor >> visualization [
	^ visualization
]

{ #category : #accessing }
DvtVisualizationEditor >> visualization: aDvtVisualization [
	visualization := aDvtVisualization.
	config := DvtPresenter readJSONDataFromFileRef: (DvtApp visualizationFileRefFor: visualization).
	self loadConfigToWidgets
]
