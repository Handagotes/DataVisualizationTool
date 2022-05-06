Class {
	#name : #DvtVisualizationSetting,
	#superclass : #Object,
	#instVars : [
		'variableName'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #api }
DvtVisualizationSetting class >> keyForString: aString [
	| type |
	aString ifEmpty: [ ^ aString ].
	(aString first = $' and: [ aString last = $' ]) ifTrue: [ ^ aString ].
	type := DvtDataTableProcessor resolveTypeForValueString: aString.
	^ type = #string
		ifTrue: [ '''{1}''' format: { aString } ]
		ifFalse: [ aString ]
]

{ #category : #api }
DvtVisualizationSetting >> createLine [
	self subclassResponsibility
]

{ #category : #accessing }
DvtVisualizationSetting >> variableName [
	^ variableName
]

{ #category : #accessing }
DvtVisualizationSetting >> variableName: anObject [
	variableName := anObject
]
