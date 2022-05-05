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
DvtVisualizationEditor class >> keyForString: aString [
	| type |
	aString ifEmpty: [ ^ aString ].
	(aString first = $' and: [ aString last = $' ]) ifTrue: [ ^ aString ].
	type := DvtDataTableProcessor resolveTypeForValueString: aString.
	^ type = #string
		ifTrue: [ '''{1}''' format: { aString } ]
		ifFalse: [ aString ]
]

{ #category : #private }
DvtVisualizationEditor >> addCheckBox: name label: label checked: checked [
	self instantiatePresenters: { name. #CheckBoxPresenter }.
	(widgets at: name)
		label: label;
		state: checked
]

{ #category : #private }
DvtVisualizationEditor >> addColorPickButton: name label: label defaultColor: color [
	self instantiatePresenters: { name. #ColorPickerButtonPresenter }.
	(widgets at: name)
		label: label;
		pickedColor: color
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

{ #category : #testing }
DvtVisualizationEditor >> isChecked: checkBoxName [
	^ (widgets at: checkBoxName) state
]

{ #category : #api }
DvtVisualizationEditor >> keyFor: keyTextInputName [
	^ self class keyForString: (self textOf: keyTextInputName)
]

{ #category : #private }
DvtVisualizationEditor >> loadConfigToWidgets [
	self subclassResponsibility
]

{ #category : #api }
DvtVisualizationEditor >> pickedColorFor: colorPickButtonName [
	^ (widgets at: colorPickButtonName) pickedColor
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

{ #category : #private }
DvtVisualizationEditor >> textOf: textInputName [
	^ (widgets at: textInputName) text
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
