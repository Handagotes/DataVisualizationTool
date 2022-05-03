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
