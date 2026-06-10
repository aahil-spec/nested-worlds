extends Node

var recursion_stack:Array=[]

var current_world_id:String="HubWorld"

func dive(target_world_id:String):
	recursion_stack.append(current_world_id)
	
	current_world_id=target_world_id
	var main_scene=get_tree().root.get_node("Main")
	main_scene.execute_world_transfer(target_world_id)
