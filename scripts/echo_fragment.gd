extends Node3D


@export var dialogue_id:String=""
var triggered:bool=false

func _ready():
	$TriggerZone.body_entered.connect(_on_trigger_zone_body_entered)
	
func _on_trigger_zone_body_entered(body:Node3D):
	print("🚨 SOMETHING TOUCHED THE SPHERE: ", body.name)
	if triggered:
		print("❌ Cancelled: Echo was already triggered!")
		return
	if not body is CharacterBody3D:
		print("❌ Cancelled: The thing that touched it wasn't the player!")
		return
	print("✅ PLAYER DETECTED! Attempting to play dialogue ID: ", dialogue_id)
	triggered=true
	DialogueManager.play(dialogue_id)
	GameState.story_flags[dialogue_id+"_heard"]=true
