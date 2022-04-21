"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestDataVisualizationTool,
	#superclass : #PackageManifest,
	#category : #'DataVisualizationTool-Manifest'
}

{ #category : #'code-critics' }
ManifestDataVisualizationTool class >> ruleRTInvocationSequenceRuleV1FalsePositive [
	^ #(#(#(#RGPackage #(#DataVisualizationTool)) #'2022-04-21T17:27:02.580795+05:00') )
]
