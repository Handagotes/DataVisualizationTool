Class {
	#name : #DvtSingleton,
	#superclass : #Object,
	#classInstVars : [
		'instance'
	],
	#category : #'DataVisualizationTool-Control'
}

{ #category : #accessing }
DvtSingleton class >> globalName [
	"
		^ #MySingletonInstance
		or if global is not needed:
		^ nil
	"
	self subclassResponsibility
]

{ #category : #'class initialization' }
DvtSingleton class >> initialize [
	| globalName |
	self = DvtSingleton ifTrue: [ ^ self	].
	instance ifNotNil: [ ^ self ].
	(globalName := self globalName) ifNil: [ 
		instance := self basicNew initialize.
		^ self
	].
	(Smalltalk globals includesKey: globalName) ifTrue: [ 
		instance := Smalltalk at: globalName
	]
	ifFalse: [ 
		instance := self basicNew initialize.
		Smalltalk at: globalName put: instance
	]
]

{ #category : #accessing }
DvtSingleton class >> instance [
	^ instance
]

{ #category : #'instance creation' }
DvtSingleton class >> new [
	instance ifNil: [ 
		self initialize.
		^ instance
	].
	
	self error: (String streamContents: [ :s | | globalName |
		s nextPutAll: ('Attempt to instantiate singleton class {1}. Use "{1} instance" ' format: { self name }).
		(globalName := self globalName) ifNotNil: [ 
			s nextPutAll: ('or global "{1}" ' format: { globalName })
		].
		s nextPutAll: 'instead.'
	])
]

{ #category : #removing }
DvtSingleton class >> remove [
	| globalName |
	globalName := self globalName.
	globalName ifNotNil: [ Smalltalk globals removeKey: globalName ifAbsent: [  ] ].
	instance := nil
]

{ #category : #removing }
DvtSingleton class >> removeAll [
	DvtSingleton allSubclassesDo: [ :c |
		c hasAbstractMethods ifFalse: [ 
			c remove
		]
	]
]
