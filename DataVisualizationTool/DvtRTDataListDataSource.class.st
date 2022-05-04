Class {
	#name : #DvtRTDataListDataSource,
	#superclass : #DvtDataSource,
	#category : #'DataVisualizationTool-Util'
}

{ #category : #adding }
DvtRTDataListDataSource >> addColumnsTo: aTable [
	aTable
		addColumn: (FTColumn new
			id: 'Имя';
			yourself);
		addColumn: (FTColumn new
			id: 'Ключ X';
			yourself);
		addColumn: (FTColumn new
			id: 'Ключ Y';
			yourself);
		addColumn: (FTColumn new
			id: 'Цвет точек';
			yourself);
		addColumn: (FTColumn new
			id: 'Цвет соединений';
			yourself)
]

{ #category : #accessing }
DvtRTDataListDataSource >> cellColumn: column row: rowIndex [
	| setting |
	setting := self elementAt: rowIndex.
	column id = 'Имя' ifTrue: [ ^ (setting at: #name) asStringMorph ].
	column id = 'Ключ X' ifTrue: [ ^ (setting at: #xKey) asStringMorph ].
	column id = 'Ключ Y' ifTrue: [ ^ (setting at: #yKey) asStringMorph ].
	column id = 'Цвет точек' ifTrue: [ ^ (setting at: #dotColor) asHexString asStringMorph ].
	column id = 'Цвет соединений' ifTrue: [ ^ (setting at: #connectColor) asHexString asStringMorph ]
]
