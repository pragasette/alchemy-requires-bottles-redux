;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _p7ARBR_CraftQuest Extends Quest Hidden

_p7ARBR_PlayerAlias Property PlayerAlias Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
	; This fragment is associated to a quest stage to mimic the effect of an
	; OnStoryCraftItem event, which crashes the game, as also reported at
	; https://www.creationkit.com/index.php?title=OnStoryCraftItem_-_Quest#Notes.
	; For this to allow multiple runs, the quest must be flagged to "Allow
	; Repeated Stages", not to "Run Once" and arrested manually using the Stop
	; function below.
	; An alternative was to skip the Story Manager and use OnItemAdded in the
	; player ReferenceAlias, but that didn't play well with CACO which adds
	; each potion twice and fires two OnItemAdded events.
	PlayerAlias.HandleCraftItem()
	Self.Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
