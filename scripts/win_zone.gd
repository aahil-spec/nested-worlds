extends Area3D


func _ready():
	body_entered.connect(_on_body_enetered)
	
func _on_body_enetered(body:Node):
	if body is CharacterBody3D:
		var win_screen=get_tree().current_scene.get_node("UI/WinScreen")
		win_screen.visivle=true
		
		body.set_process(false)
		body.set_physics_process(false)
