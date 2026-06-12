extends Node3D


var is_red_locked:bool=false
var is_blue_locked:bool=false
var closed_global_y:float=0.0

func _ready():
	closed_global_y=global_position.y
	GameState.state_changed.connect(_on_global_state_changed)
	
func _on_global_state_changed(key:String,new_value:bool):
	if key=="red_plate_pressed":
		is_red_locked=new_value
	elif key=="blue_plate_pressed":
		is_blue_locked=new_value
		
	if is_red_locked==true and is_blue_locked==true:
		open_vault()
		
func open_vault():
	var door_tween=create_tween()
	door_tween.tween_property(self,"global_position:y",closed_global_y+6.0,1.5)
