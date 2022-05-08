Class {
	#name : #DvtRadarMetricSetting,
	#superclass : #DvtVisualizationSetting,
	#instVars : [
		'title',
		'key'
	],
	#category : #'DataVisualizationTool-Util'
}

{ #category : #api }
DvtRadarMetricSetting >> addMetricLine [
	^ '{1} addMetric: [ :e | e at: {2} ] title: ''{3}''.' format: { 
		variableName.
		self class keyForString: key.
		title.
	}
]

{ #category : #api }
DvtRadarMetricSetting >> createLine [
	^ '{1} := RTKiviatBuilder new.{2}' format: { variableName. String cr }
]

{ #category : #accessing }
DvtRadarMetricSetting >> key [
	^ key
]

{ #category : #accessing }
DvtRadarMetricSetting >> key: anObject [
	key := anObject
]

{ #category : #accessing }
DvtRadarMetricSetting >> title [
	^ title
]

{ #category : #accessing }
DvtRadarMetricSetting >> title: anObject [
	title := anObject
]
