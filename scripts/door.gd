extends Node3D

@export var state_key:String="red_plate_pressed"
@export var open_distance:float=-4.0

var closed_global_y:float=0.0

func _ready():
	closed_global_y=global_position.y
	GameState.state_changed.connect(_on_global_state_changed)
	print("Door ready! Starting global height is:",closed_global_y)

func _on_global_state_changed(key:String,new_value:bool):
	if key ==state_key:
		print("Door recieved signal! key:",key,"Value:",new_value)
		var door_tween=create_tween()
		
		if new_value==true:
			var target_open_y= closed_global_y+open_distance
			print("Sliding door DOWN to global Y: ", target_open_y)
			door_tween.tween_property(self,"global_position:y",closed_global_y+open_distance,0.4)
		else:
			print("Sliding door UP to global Y: ", closed_global_y)
			door_tween.tween_property(self,"global_position:y",closed_global_y,0.4)
