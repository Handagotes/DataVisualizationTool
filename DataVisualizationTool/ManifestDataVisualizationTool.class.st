"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestDataVisualizationTool,
	#superclass : #PackageManifest,
	#category : #'DataVisualizationTool-Manifest'
}

{ #category : #'code-critics' }
ManifestDataVisualizationTool class >> ruleBadMessageRule2V1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#SQLite3Cursor #nextOfClassFixed: #false)) #'2022-04-22T23:52:22.313938+05:00') #(#(#RGMethodDefinition #(#DvtDBController #updateEntity: #false)) #'2022-04-22T23:52:22.313938+05:00') #(#(#RGMethodDefinition #(#DvtDBController #insertEntity: #false)) #'2022-04-22T23:52:22.313938+05:00') )
]

{ #category : #'code-critics' }
ManifestDataVisualizationTool class >> ruleGRVariableAssignedLiteralRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#RTGridViewCellSelectable)) #'2022-04-22T23:52:22.734938+05:00') #(#(#RGClassDefinition #(#RTDraggableViewWithLimit)) #'2022-04-22T23:52:22.734938+05:00') )
]

{ #category : #'code-critics' }
ManifestDataVisualizationTool class >> ruleMissingSubclassResponsibilityRuleV1FalsePositive [
	^ #(#(#(#RGMetaclassDefinition #(#'DvtDialog class' #DvtDialog)) #'2022-04-22T23:52:21.249938+05:00') )
]

{ #category : #'code-critics' }
ManifestDataVisualizationTool class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGPackage #(#DataVisualizationTool)) #'2022-04-23T12:25:22.819456+05:00') )
]

{ #category : #'code-critics' }
ManifestDataVisualizationTool class >> ruleRTInvocationSequenceRuleV1FalsePositive [
	^ #(#(#(#RGPackage #(#DataVisualizationTool)) #'2022-04-21T17:27:02.580795+05:00') #(#(#RGMethodDefinition #(#DataGridPresenter #updateVisibleCells #false)) #'2022-04-22T23:52:21.871938+05:00') #(#(#RGMethodDefinition #(#DataGridPresenter #updateCellAt: #false)) #'2022-04-22T23:52:21.871938+05:00') #(#(#RGMethodDefinition #(#RTGridViewCellSelectable #selectFrom:to: #false)) #'2022-04-22T23:52:21.871938+05:00') #(#(#RGMethodDefinition #(#RTGridViewCellSelectable #processDragStart: #false)) #'2022-04-22T23:52:21.871938+05:00') )
]

{ #category : #'code-critics' }
ManifestDataVisualizationTool class >> ruleRefersToClassRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'DvtSingleton class' #initialize #true)) #'2022-04-22T23:52:20.829938+05:00') #(#(#RGMethodDefinition #(#'DvtSingleton class' #removeAll #true)) #'2022-04-22T23:52:20.829938+05:00') )
]

{ #category : #'code-critics' }
ManifestDataVisualizationTool class >> ruleVariableReferencedOnceRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#RTGridViewCellSelectable)) #'2022-04-22T23:52:21.660938+05:00') #(#(#RGClassDefinition #(#RTDraggableViewWithLimit)) #'2022-04-22T23:52:21.660938+05:00') )
]
