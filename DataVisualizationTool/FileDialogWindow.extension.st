Extension { #name : #FileDialogWindow }

{ #category : #'*DataVisualizationTool' }
FileDialogWindow class >> askForFileRefToSaveWithExtensions: extensions [
	| fileDialog topWindow |
	(fileDialog := self new)
		validExtensions: extensions;
		answerSaveFile.
	topWindow := SystemWindow topWindow.
	topWindow modalLockTo: fileDialog.
	fileDialog openModal.
	topWindow modalUnlockFrom: fileDialog. 
	fileDialog cancelled ifTrue: [ ^ nil ].
	^ fileDialog answer
]
