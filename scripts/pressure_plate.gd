extends Area3D

@export var state_key:String="red_plate_pressed"
@export var plate_symbol:String=""
func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if not body is CharacterBody3D:
		return
	if body is CharacterBody3D:
		if plate_symbol !="":
			var brain=get_tree().get_first_node_in_group("sequence_manager")
			if brain:brain.press_plate(plate_symbol)
		GameState.set_state(state_key,true)
		$StepSound.play()
		
