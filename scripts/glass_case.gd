extends CSGBox3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_state_changed(key:String,new_value:bool):
	if key=="blue_case_unlocked" and new_value==true:
		queue_free()
