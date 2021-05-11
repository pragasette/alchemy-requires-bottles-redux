Scriptname _p7ARBR_PlayerAlias extends ReferenceAlias

Actor Property PlayerRef Auto
FormList Property _p7ARBR_PoisonList Auto
Idle Property IdleAlchemyExit Auto
Keyword Property VendorItemPoison Auto
Keyword Property VendorItemPotion Auto
Keyword Property WICraftingAlchemy Auto
Message Property _p7ARBR_ExitMessage Auto
MiscObject Property _p7ARBR_EmptyBottle Auto
Quest Property UpdateQuest Auto

Int REMOVED_BOTTLE_COUNT = 1
String POISONS_USED_STAT = "Poisons Used"

Bool isMenuDisabled = False
Int poisonCount

Event OnInit()
	Self.AddInventoryEventFilter(_p7ARBR_PoisonList)
	poisonCount = Game.QueryStat(POISONS_USED_STAT)
EndEvent

Event OnPlayerLoadGame()
	If UpdateQuest.GetCurrentStageID() < 1
		UpdateQuest.SetCurrentStageID(1)
	EndIf
EndEvent

Event OnSit(ObjectReference ref)
	If ref.HasKeyword(WICraftingAlchemy)
		Self.GotoState("Crafting")
		Self.ExitIfNotEnoughBottles()
	EndIf
EndEvent

Event OnObjectEquipped(Form object, ObjectReference ref)
	; this event is not fired when using a poison;
	; only consider actual ingestibles, in order to exclude false positives
	; such as mortars from Campfire and CACO and hopefully other items labeled
	; as potions
	If (object as Potion) && object.HasKeyword(VendorItemPotion)
		PlayerRef.AddItem(_p7ARBR_EmptyBottle, 1)
	EndIf
EndEvent

Event OnItemRemoved(Form item, Int count, ObjectReference itemRef, ObjectReference containerRef)
	; detect a poison was used: since we are using an inventary event filter,
	; this only fires for forms in _p7ARBR_PoisonList; the event still fires
	; twice under normal circumstances, so we need to ensure the poison was
	; actually applied, by checking whether the corresponding stat changed
	Int newCount = Game.QueryStat(POISONS_USED_STAT)

	If newCount > poisonCount
		PlayerRef.AddItem(_p7ARBR_EmptyBottle, 1)
		poisonCount = newCount
		Debug.Trace("[Alchemy Requires Bottles Redux] Trying to remove form from _p7ARBR_PoisonList: " + item)
		_p7ARBR_PoisonList.RemoveAddedForm(item)
	EndIf
EndEvent

Function ExitIfNotEnoughBottles()
	If PlayerRef.GetItemCount(_p7ARBR_EmptyBottle) < REMOVED_BOTTLE_COUNT
		_p7ARBR_ExitMessage.Show()
		PlayerRef.PlayIdle(IdleAlchemyExit)
		; wait until the message dialog is closed
		Utility.Wait(0.1)
		; disallow interactions with the crafting menu
		Debug.ToggleMenus()
		isMenuDisabled = True
	EndIf
EndFunction

Function HandleCraftItem()
	; Unused since version 1.0.1, left to prevent errors in mid-game updates
EndFunction

Function Update1()
	If SKSE.GetVersion() > 0
		Int count = PlayerRef.GetNumItems()
		Int i = 0

		While i < count
			Form item = PlayerRef.GetNthForm(i)

			If item.HasKeyword(VendorItemPoison) && !_p7ARBR_PoisonList.HasForm(item)
				Debug.Trace("[Alchemy Requires Bottles Redux] Adding form to _p7ARBR_PoisonList: " + item)
				_p7ARBR_PoisonList.AddForm(item)
			EndIf

			i += 1
		EndWhile
	EndIf
EndFunction

State Crafting
	Event OnBeginState()
		Self.RemoveInventoryEventFilter(_p7ARBR_PoisonList)
	EndEvent

	Event OnEndState()
		Self.AddInventoryEventFilter(_p7ARBR_PoisonList)
	EndEvent

	Event OnGetUp(ObjectReference ref)
		If isMenuDisabled
			Debug.ToggleMenus()
			isMenuDisabled = False
		EndIf

		Self.GotoState("")
	EndEvent

	Event OnItemAdded(Form item, Int count, ObjectReference itemRef, ObjectReference containerRef)
		PlayerRef.RemoveItem(_p7ARBR_EmptyBottle, REMOVED_BOTTLE_COUNT)
		Self.ExitIfNotEnoughBottles()

		If item.HasKeyword(Self.VendorItemPoison) && !_p7ARBR_PoisonList.HasForm(item)
			Debug.Trace("[Alchemy Requires Bottles Redux] Adding form to _p7ARBR_PoisonList: " + item)
			_p7ARBR_PoisonList.AddForm(item)
		EndIf
	EndEvent

	Event OnItemRemoved(Form item, Int count, ObjectReference itemRef, ObjectReference containerRef)
	EndEvent
EndState
