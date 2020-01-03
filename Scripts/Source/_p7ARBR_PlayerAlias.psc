Scriptname _p7ARBR_PlayerAlias extends ReferenceAlias

FormList Property _p7ARBR_PoisonList Auto
Idle Property IdleAlchemyExit Auto
Keyword Property VendorItemPotion Auto
Keyword Property WICraftingAlchemy Auto
Message Property _p7ARBR_ExitMessage Auto
MiscObject Property _p7ARBR_EmptyBottle Auto

Int REMOVED_BOTTLE_COUNT = 1
String POISONS_USED_STAT = "Poisons Used"

Bool isMenuDisabled = False
Int poisonCount

Event OnInit()
	Self.AddInventoryEventFilter(_p7ARBR_PoisonList)
	poisonCount = Game.QueryStat(POISONS_USED_STAT)
EndEvent

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

Event OnObjectEquipped(Form object, ObjectReference ref)
	; this event is not fired when using a poison;
	; only consider actual ingestibles, in order to exclude false positives
	; such as mortars from Campfire and CACO and hopefully other items labeled
	; as potions
	If (object as Potion) && object.HasKeyword(VendorItemPotion)
		(Self.GetReference() as Actor).AddItem(_p7ARBR_EmptyBottle, 1)
	EndIf
EndEvent

Event OnItemRemoved(Form item, Int count, ObjectReference itemRef, ObjectReference containerRef)
	; detect a poison was used: since we are using an inventary event filter,
	; this only fires for forms in _p7ARBR_PoisonList; the event still fires
	; twice under normal circumstances, so we need to ensure the poison was
	; actually applied, by checking whether the corresponding stat changed
	Int newCount = Game.QueryStat(POISONS_USED_STAT)

	If newCount > poisonCount
		(Self.GetReference() as Actor).AddItem(_p7ARBR_EmptyBottle, 1)
		poisonCount = newCount
	EndIf
EndEvent

Function ExitIfNotEnoughBottles()
	Actor playerRef = Self.GetReference() as Actor

	If playerRef.GetItemCount(_p7ARBR_EmptyBottle) < REMOVED_BOTTLE_COUNT
		_p7ARBR_ExitMessage.Show()
		playerRef.PlayIdle(IdleAlchemyExit)
		; wait until the message dialog is closed
		Utility.Wait(0.1)
		; disallow interactions with the crafting menu
		Debug.ToggleMenus()
		isMenuDisabled = True
	EndIf
EndFunction

Function HandleCraftItem()
	; this function is invoked by a fragment in _p7ARBR_CraftQuest, see that
	; script for more details about the implementation
	Actor playerRef = Self.GetReference() as Actor
	playerRef.RemoveItem(_p7ARBR_EmptyBottle, REMOVED_BOTTLE_COUNT)
	Self.ExitIfNotEnoughBottles()
EndFunction
