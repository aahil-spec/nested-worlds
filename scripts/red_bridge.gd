extends StaticBody3D


@export var power_key:String="carrying_red_orb"

@onready var collision_shape : CollisionShape3D=$CollisionShape3D

func _ready():
	visible=false
	collision_shape.disabled=true
	
	GameState.state_changed.connect(_on_global_state_changed)
	
func _on_global_state_changed(key:String,new_value:bool):
	if key==power_key:
		visible=new_value
		
		collision_shape.disabled=!new_value
