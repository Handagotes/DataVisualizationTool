Class {
	#name : #DvtRTModelEditable,
	#superclass : #RTInteraction,
	#category : #'DataVisualizationTool-Util'
}

{ #category : #hooks }
DvtRTModelEditable >> initializeElement: element [
	element when: TRMouseDoubleLeftClick do: [ :e | | result |
		result := element model asString.
		
		[ 
			(result := DvtTextInputDialog open: 'Введите новое значение.' default: result)
				isNotNil and: [ result includesAny: '<>' ]
		] whileTrue: [ 
			DvtErrorDialog open: 'Значение не должно содержать символы < и >.'.
		].
		
		result ifNotNil: [ 
			element
				model: result;
				update
		]
	]
]
