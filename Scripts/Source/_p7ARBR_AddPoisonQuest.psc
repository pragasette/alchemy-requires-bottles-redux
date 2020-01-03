Scriptname _p7ARBR_AddPoisonQuest extends Quest

FormList Property _p7ARBR_PoisonList Auto

Event OnStoryAddToPlayer(ObjectReference ownerRef, ObjectReference containerRef, Location loc, Form item, Int type)
	; This event is fired when the player receives a new poison which is not
	; already present in _p7ARBR_PoisonList: this is meant to support new
	; poisons added by other mods.
	; Since OnStoryRemoveFromPlayer doesn't fire with item consumption, poison
	; usage is detected using OnItemRemoved in the player ReferenceAlias
	; script; to limit function calls, an inventary event filter is applied so
	; that OnItemRemoved is fired only for actual poisons in such a list.
	Debug.Trace("[Alchemy Requires Bottles Redux] Adding form to _p7ARBR_PoisonList: " + item)
	_p7ARBR_PoisonList.AddForm(item)
	Self.Stop()
EndEvent
