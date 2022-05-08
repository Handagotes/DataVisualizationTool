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
	^ '{1} addMetric: [ :e | e at: {2} ] title: ''{3}''.{4}' format: { 
		variableName.
		self class keyForString: key.
		title.
		String cr
	}
]

{ #category : #api }
DvtRadarMetricSetting >> createLine [
	^ self addMetricLine
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
