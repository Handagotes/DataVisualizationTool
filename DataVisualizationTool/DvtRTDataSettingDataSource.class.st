Class {
	#name : #DvtRTDataSettingDataSource,
	#superclass : #DvtDataSource,
	#category : #'DataVisualizationTool-Util'
}

{ #category : #adding }
DvtRTDataSettingDataSource >> addColumnsTo: aTable [
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
			id: 'Цвет вершин';
			yourself);
		addColumn: (FTColumn new
			id: 'Цвет соединений';
			yourself);
		addColumn: (FTColumn new
			id: 'Форма вершин';
			yourself)
]

{ #category : #accessing }
DvtRTDataSettingDataSource >> cellColumn: column row: rowIndex [
	| setting |
	setting := self elementAt: rowIndex.
	column id = 'Имя' ifTrue: [ ^ (setting name) asStringMorph ].
	column id = 'Ключ X' ifTrue: [ ^ (setting xKey) asStringMorph ].
	column id = 'Ключ Y' ifTrue: [ ^ (setting yKey) asStringMorph ].
	column id = 'Цвет вершин' ifTrue: [ ^ (setting shapeColor) asHexString asStringMorph ].
	column id = 'Цвет соединений' ifTrue: [ ^ (setting connectColor) asHexString asStringMorph ].
	column id = 'Форма вершин' ifTrue: [ ^ (setting shapeTypeForUser) asStringMorph ]
]
