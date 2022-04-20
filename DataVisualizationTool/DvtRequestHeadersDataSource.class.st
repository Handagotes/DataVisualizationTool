Class {
	#name : #DvtRequestHeadersDataSource,
	#superclass : #DvtDataSource,
	#category : #'DataVisualizationTool-Util'
}

{ #category : #'instance creation' }
DvtRequestHeadersDataSource class >> headerFields: headerFields [
	^ self elements: headerFields
]

{ #category : #adding }
DvtRequestHeadersDataSource >> addColumnsTo: aTable [
	aTable
		addColumn: (FTColumn new
			id: 'Заголовок';
			yourself);
		addColumn: (FTColumn new
			id: 'Значение';
			yourself)
]

{ #category : #accessing }
DvtRequestHeadersDataSource >> cellColumn: column row: rowIndex [
	| headerField |
	headerField := self elementAt: rowIndex.
	column id = 'Заголовок' ifTrue: [ ^ headerField header asStringMorph ].
	column id = 'Значение' ifTrue: [ ^ headerField field asStringMorph ]
]
