extends Node3D

@export var player: CharacterBody3D
@export var hub_entry:Marker3D
@export var red_entry:Marker3D
@export var fade_animator:AnimationPlayer

var is_transitioning:bool=false
func execute_world_transfer(target_world_id:String):
	if is_transitioning:
		return
		
	is_transitioning=true
	player.set_process(false)
	player.set_physics_process(false)
	
	fade_animator.play("fade")
	await fade_animator.animation_finished
	
	if target_world_id=="red_world":
		player.global_position=red_entry.global_position
	elif target_world_id=="HubWorld":
		player.global_position=hub_entry.global_position
		
	fade_animator.play_backwards("fade")
	player.set_process(true)
	player.set_physics_process(true)
	is_transitioning=false
