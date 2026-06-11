extends Area3D

@export var state_key:String="red_plate_pressed"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node):
	if body is CharacterBody3D:
		GameState.set_state(state_key,true)
		
