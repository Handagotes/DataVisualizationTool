Class {
	#name : #DvtApplicationDBController,
	#superclass : #DvtDBController,
	#category : #'DataVisualizationTool-Control'
}

{ #category : #accessing }
DvtApplicationDBController class >> globalName [
	^ #DvtAppDB
]

{ #category : #private }
DvtApplicationDBController >> createTableIfNotExistsQueries [
	^ { 
		'CREATE TABLE IF NOT EXISTS dataset (
			id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
			fetch_date date NOT NULL,
			fetch_time time NOT NULL,
			data_file_path varchar(255) NOT NULL,
			request_id integer(10),
			FOREIGN KEY(request_id) REFERENCES request(id)
		);
		CREATE UNIQUE IF NOT EXISTS INDEX dataset_id ON dataset (id);'.
		'CREATE TABLE IF NOT EXISTS dataset_sample (
			id integer(10) NOT NULL,
			datasetid integer(10) NOT NULL,
			sampleid integer(10) NOT NULL,
			PRIMARY KEY (id, datasetid, sampleid),
			FOREIGN KEY(sampleid) REFERENCES sample(id),
			FOREIGN KEY(datasetid) REFERENCES dataset(id)
		);
		CREATE UNIQUE INDEX IF NOT EXISTS dataset_sample_id ON dataset_sample (id);'.
		'CREATE TABLE IF NOT EXISTS header_field (
			id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
			header varchar(255) NOT NULL,
			field varchar(255) NOT NULL,
			"order" integer(10) NOT NULL,
			request_id integer(10) NOT NULL,
			FOREIGN KEY(request_id) REFERENCES request(id)
		);
		CREATE UNIQUE INDEX IF NOT EXISTS header_field_id ON header_field (id);'.
		'CREATE TABLE IF NOT EXISTS request (
			id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
			name varchar(255) NOT NULL UNIQUE,
			text varchar(255) NOT NULL
		);
		CREATE UNIQUE INDEX IF NOT EXISTS request_id ON request (id);'.
		'CREATE TABLE IF NOT EXISTS sample (
			id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
			name varchar(255) NOT NULL,
			sample_tsv_path varchar(255) NOT NULL
		);
		CREATE UNIQUE INDEX IF NOT EXISTS sample_id ON sample (id);'.
		'CREATE TABLE IF NOT EXISTS visualization (
			id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
			name varchar(255) NOT NULL,
			script varchar(255) NOT NULL,
			sample_id integer(10) NOT NULL,
			FOREIGN KEY(sample_id) REFERENCES sample(id)
		);
		CREATE UNIQUE INDEX IF NOT EXISTS visualization_id ON visualization (id);'.
	}
]

{ #category : #api }
DvtApplicationDBController >> dataSets [
	^ self selectAllFrom: #dataset entityClass: DvtDataSet
]

{ #category : #api }
DvtApplicationDBController >> dataSetsOfRequest: request [
	^ self dataSetsOfRequestWithId: request id
]

{ #category : #api }
DvtApplicationDBController >> dataSetsOfRequestWithId: id [
	| cursor |
	cursor := connection execute: 'SELECT * FROM dataset WHERE request_id = ?' value: id.
	^ cursor rowsOfClassFixed: DvtDataSet
]

{ #category : #api }
DvtApplicationDBController >> dbFilename [
	^ 'dvt.db'
]

{ #category : #api }
DvtApplicationDBController >> deleteDataSet: dataSet [
	connection execute: 'DELETE FROM dataset_sample WHERE dataset_id = ?' value: dataSet id.
	self deleteEntity: dataSet
]

{ #category : #api }
DvtApplicationDBController >> deleteRequest: request [
	connection execute: 'DELETE FROM header_field WHERE request_id = ?' value: request id.
	connection execute: 'DELETE FROM dataset WHERE request_id = ?' value: request id.
	self deleteEntity: request.
]

{ #category : #api }
DvtApplicationDBController >> deleteSample: sample [
	connection execute: 'DELETE FROM visualization WHERE sample_id = ?' value: sample id.
	connection execute: 'DELETE FROM dataset_sample WHERE sample_id = ?' value: sample id.
	self deleteEntity: sample
]

{ #category : #private }
DvtApplicationDBController >> dropTableQueries [
	^ { 
		'DROP TABLE IF EXISTS dataset;'.
		'DROP TABLE IF EXISTS dataset_sample;'.
		'DROP TABLE IF EXISTS header_field;'.
		'DROP TABLE IF EXISTS request;'.
		'DROP TABLE IF EXISTS sample;'.
		'DROP TABLE IF EXISTS visualization;'.
	}
]

{ #category : #accessing }
DvtApplicationDBController >> headerFields [
	^ self selectAllFrom: #header_field entityClass: DvtHeaderField
]

{ #category : #api }
DvtApplicationDBController >> headerFieldsOfRequest: request [
	^ self headerFieldsOfRequestWithId: request id
]

{ #category : #api }
DvtApplicationDBController >> headerFieldsOfRequestWithId: id [
	| cursor |
	cursor := connection execute: 'SELECT * FROM header_field WHERE request_id = ?' value: id.
	^ cursor rowsOfClassFixed: DvtHeaderField
]

{ #category : #api }
DvtApplicationDBController >> insertRequest: request headerFields: headerFields [
	| id |
	id := self insertEntity: request.
	
	headerFields do: [ :hf |
		hf requestId: id.
		self insertEntity: hf
	].
	
	^ id
]

{ #category : #api }
DvtApplicationDBController >> insertVisualization: visualization [
	^ self insertEntity: visualization
]

{ #category : #accessing }
DvtApplicationDBController >> requests [
	^ self selectAllFrom: #request entityClass: DvtRequest
]

{ #category : #api }
DvtApplicationDBController >> updateRequest: request headerFields: headerFields [
	self updateEntity: request.
	connection execute: 'DELETE FROM header_field WHERE request_id = ?' value: request id.
	headerFields do: [ :hf |
		hf requestId: request id.
		self insertEntity: hf
	]
]

{ #category : #api }
DvtApplicationDBController >> visualizationsOfSample: sample [
	^ self visualizationsOfSampleWithId: sample id
]

{ #category : #api }
DvtApplicationDBController >> visualizationsOfSampleWithId: id [
	| cursor |
	cursor := connection execute: 'SELECT * FROM visualization WHERE sample_id = ?' value: id.
	^ cursor rowsOfClassFixed: DvtVisualization
]
