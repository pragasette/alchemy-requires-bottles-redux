Scriptname _p7ARBR_PlayerAlias extends ReferenceAlias

Idle Property IdleAlchemyExit Auto
Keyword Property WICraftingAlchemy Auto
Message Property _p7ARBR_ExitMessage Auto
MiscObject Property _p7ARBR_EmptyBottle Auto

Int MIN_BOTTLE_COUNT = 1

Bool isMenuDisabled = False

Event OnSit(ObjectReference ref)
	If ref.HasKeyword(WICraftingAlchemy)
		Self.ExitIfNotEnoughBottles()
	EndIf
EndEvent

Event OnGetUp(ObjectReference ref)
	If isMenuDisabled
		Debug.ToggleMenus()
		isMenuDisabled = False
	EndIf
EndEvent

Function ExitIfNotEnoughBottles()
	Actor playerRef = Self.GetReference() as Actor

	If playerRef.GetItemCount(_p7ARBR_EmptyBottle) < MIN_BOTTLE_COUNT
		_p7ARBR_ExitMessage.Show()
		playerRef.PlayIdle(IdleAlchemyExit)
		; wait until the message dialog is closed
		Utility.Wait(0.1)
		; disallow interactions with the crafting menu
		Debug.ToggleMenus()
		isMenuDisabled = True
	EndIf
EndFunction
