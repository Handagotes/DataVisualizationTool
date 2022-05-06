Class {
	#name : #DvtRTDataSetting,
	#superclass : #DvtVisualizationSetting,
	#instVars : [
		'name',
		'xKey',
		'yKey',
		'shapeColor',
		'connectColor',
		'shapeType'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #api }
DvtRTDataSetting class >> availableShapeTypes [
	^ #(box circle cross bar)
]

{ #category : #api }
DvtRTDataSetting class >> shapeTypeDisplayBlock [
	^ [ :shapeType |
		{ 
			#box -> 'Квадрат'.
			#circle -> 'Круг'.
			#cross -> 'Крест'.
			#bar -> 'Столбец'.
		} asDictionary at: shapeType
	]
]

{ #category : #accessing }
DvtRTDataSetting >> connectColor [
	^ connectColor
]

{ #category : #accessing }
DvtRTDataSetting >> connectColor: anObject [
	connectColor := anObject
]

{ #category : #api }
DvtRTDataSetting >> connectColorLine [
	^ connectColor alpha > 0
		ifTrue: [ ('{1} connectColor: {2}.{3}' format: { variableName. connectColor storeString. String cr }) ]
		ifFalse: [ '' ]
]

{ #category : #api }
DvtRTDataSetting >> createLine [
	^ '{1} := RTData new.{2}' format: { variableName. String cr }
]

{ #category : #'as yet unclassified' }
DvtRTDataSetting >> labelLine [
	^ '{1} label: ''{2}''.{3}' format: { variableName. name. String cr }
]

{ #category : #accessing }
DvtRTDataSetting >> name [
	^ name
]

{ #category : #accessing }
DvtRTDataSetting >> name: anObject [
	name := anObject
]

{ #category : #accessing }
DvtRTDataSetting >> shapeColor [
	^ shapeColor
]

{ #category : #accessing }
DvtRTDataSetting >> shapeColor: anObject [
	shapeColor := anObject
]

{ #category : #api }
DvtRTDataSetting >> shapeColorLine [
	| shapeDef |
	shapeDef := shapeType = #bar
		ifFalse: [ 'dotShape ' , shapeType ]
		ifTrue: [ 'barShape' ].
	^ '{1} {2} color: {3}.{4}' format: { variableName. shapeDef. shapeColor storeString. String cr }
]

{ #category : #accessing }
DvtRTDataSetting >> shapeType [
	^ shapeType
]

{ #category : #accessing }
DvtRTDataSetting >> shapeType: anObject [
	shapeType := anObject
]

{ #category : #api }
DvtRTDataSetting >> shapeTypeForUser [
	^ self class shapeTypeDisplayBlock value: shapeType
]

{ #category : #accessing }
DvtRTDataSetting >> xKey [
	^ xKey
]

{ #category : #accessing }
DvtRTDataSetting >> xKey: anObject [
	xKey := anObject
]

{ #category : #api }
DvtRTDataSetting >> xKeyLine [
	| key |
	key := self class keyForString: xKey.
	^ key
		ifNotEmpty: [ ('{1} x: [ :e | e at: {2} ].{3}' format: { variableName. key. String cr }) ]
		ifEmpty: [ '' ]
]

{ #category : #accessing }
DvtRTDataSetting >> yKey [
	^ yKey
]

{ #category : #accessing }
DvtRTDataSetting >> yKey: anObject [
	yKey := anObject
]

{ #category : #api }
DvtRTDataSetting >> yKeyLine [
	| key |
	key := self class keyForString: yKey.
	^ key
		ifNotEmpty: [ ('{1} y: [ :e | e at: {2} ].{3}' format: { variableName. key. String cr }) ]
		ifEmpty: [ '' ]
]
