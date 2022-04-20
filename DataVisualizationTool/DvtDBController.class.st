Class {
	#name : #DvtDBController,
	#superclass : #DvtSingleton,
	#instVars : [
		'connection',
		'attrDict',
		'traceQueries'
	],
	#category : #'DataVisualizationTool-Control'
}

{ #category : #removing }
DvtDBController class >> remove [
	instance ifNotNil: [ instance closeConnection ].
	super remove
]

{ #category : #private }
DvtDBController >> attributesForEntity: aPMAEntity [
	| entityClass |
	entityClass := aPMAEntity class.
	self inspect.
	^ attrDict at: entityClass ifAbsentPut: [ | columns |
		(columns := connection columnNamesFor: entityClass tableName)
			remove: #id.
		(columns collect: [ :c | | snake camel |
			snake := '"{1}"' format: { c }.
			camel := c snakeToCamel uncapitalized asSymbol.
			snake -> camel
		]) asDictionary
	]
]

{ #category : #private }
DvtDBController >> closeConnection [
	connection ifNil: [ ^ self ].
	connection close.
	connection := nil
]

{ #category : #accessing }
DvtDBController >> connection [
	^ connection
]

{ #category : #private }
DvtDBController >> createTableIfNotExistsQueries [
	^ self subclassResponsibility
]

{ #category : #api }
DvtDBController >> dbFilename [
	^ self subclassResponsibility
]

{ #category : #api }
DvtDBController >> deleteEntity: aPMAEntity [
	| table query |
	self assert: connection isNotNil.
	table := aPMAEntity class tableName storeString.
	query := String streamContents: [ :stream |
		stream
			nextPutAll: 'DELETE FROM ';
			nextPutAll: table;
			nextPutAll: ' WHERE id = ?;'
	].
	traceQueries ifTrue: [ query traceCr ].
	connection execute: query value: aPMAEntity id
]

{ #category : #private }
DvtDBController >> dropTableQueries [
	^ self subclassResponsibility
]

{ #category : #api }
DvtDBController >> dropTables [
	connection ifNil: [ ^ self ].
	self dropTableQueries do: [ :q | connection execute: q ]
]

{ #category : #initialization }
DvtDBController >> initialize [
	connection := nil.
	attrDict := Dictionary new.
	traceQueries := false
]

{ #category : #api }
DvtDBController >> insertEntity: aPMAEntity [
	| table attributes query args |
	self assert: connection isNotNil.
	table := aPMAEntity class tableName storeString.
	attributes := self attributesForEntity: aPMAEntity.
	query := String streamContents: [ :stream |
		stream
			nextPutAll: 'INSERT INTO ';
			nextPutAll: table;
			nextPut: $(;
			nextPutAll: (', ' join: attributes keys);
			nextPutAll: ') VALUES (';
			nextPutAll: (', ' join: ('?' repeat: attributes size));
			nextPutAll: ');'
	].
	traceQueries ifTrue: [ query traceCr ].
	args := attributes values collect: [ :a | aPMAEntity perform: a ].
	connection
		beginTransaction;
		execute: query with: args.
	aPMAEntity id: self lastId.
	connection commitTransaction.
	^ aPMAEntity id
]

{ #category : #testing }
DvtDBController >> isConnected [
	^ self connection isNotNil
]

{ #category : #accessing }
DvtDBController >> lastId [
	^ (connection execute: 'SELECT last_insert_rowid()') next at: 1
]

{ #category : #api }
DvtDBController >> openConnection [
	| path |
	connection ifNotNil: [ ^ self ].
	path := (Smalltalk imageDirectory / self dbFilename) fullName.
	connection := SQLite3Connection openOn: path.
	self createTableIfNotExistsQueries do: [ :q | connection execute: q ]
]

{ #category : #private }
DvtDBController >> selectAllFrom: table entityClass: entityClass [
	| cursor |
	cursor := connection execute: 'SELECT * FROM ' , table asString storeString.
	^ cursor rowsOfClassFixed: entityClass
]

{ #category : #accessing }
DvtDBController >> traceQueries [
	^ traceQueries
]

{ #category : #accessing }
DvtDBController >> traceQueries: anObject [
	traceQueries := anObject
]

{ #category : #private }
DvtDBController >> updateEntity: aPMAEntity [
	| table attributes query args |
	self assert: connection isNotNil.
	table := aPMAEntity class tableName storeString.
	attributes := self attributesForEntity: aPMAEntity.
	query := String streamContents: [ :stream | | columns |
		stream
			nextPutAll: 'UPDATE ';
			nextPutAll: table;
			nextPutAll: ' SET '.
		(columns := attributes keys)
			doWithIndex: [ :column :i |
				stream
					nextPutAll: column;
					nextPutAll: ' = ?'.
				i = columns size ifFalse: [ 
					stream nextPutAll: ', '
				]
			].
		stream
			nextPutAll: ' WHERE id = ?;'
	].
	traceQueries ifTrue: [ query traceCr ].
	args := attributes values collect: [ :a | aPMAEntity perform: a ].
	connection execute: query with: args , { aPMAEntity id }
]
