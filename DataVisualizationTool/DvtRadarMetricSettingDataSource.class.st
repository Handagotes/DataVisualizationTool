Class {
	#name : #DvtRadarMetricSettingDataSource,
	#superclass : #DvtDataSource,
	#category : #'DataVisualizationTool-Util'
}

{ #category : #adding }
DvtRadarMetricSettingDataSource >> addColumnsTo: aTable [
	aTable
		addColumn: (FTColumn new
			id: 'Название';
			yourself);
		addColumn: (FTColumn new
			id: 'Ключ';
			yourself)
]

{ #category : #accessing }
DvtRadarMetricSettingDataSource >> cellColumn: column row: rowIndex [
	| setting |
	setting := self elementAt: rowIndex.
	column id = 'Название' ifTrue: [ ^ (setting title) asStringMorph ].
	column id = 'Ключ' ifTrue: [ ^ (setting key) asStringMorph ]
]
