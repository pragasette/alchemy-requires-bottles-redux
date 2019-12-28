Scriptname _p7ARB_PlayerAlias extends ReferenceAlias

Idle Property IdleAlchemyExit Auto
Keyword Property WICraftingAlchemy Auto
Message Property _p7ARB_ExitMessage Auto
MiscObject Property _p7ARB_EmptyBottle Auto

Int MIN_BOTTLE_COUNT = 1

Event OnSit(ObjectReference ref)
	If ref.HasKeyword(WICraftingAlchemy)
		Self.ExitIfNotEnoughBottles()
	EndIf
EndEvent

Function ExitIfNotEnoughBottles()
	Actor playerRef = Self.GetReference() as Actor

	If playerRef.GetItemCount(_p7ARB_EmptyBottle) < MIN_BOTTLE_COUNT
		_p7ARB_ExitMessage.Show()
		playerRef.PlayIdle(IdleAlchemyExit)
		; exit immediately
		playerRef.MoveTo(playerRef)
	EndIf
EndFunction
