extends Node
#tracks the worlds
var recursion_stack:Array=[]

var socket_stack:Array=[]
#tracks which world the player is in 
var current_world_id:String="HubWorld"

func dive(target_world_id:String,source_socket:Node3D):
	recursion_stack.append(current_world_id)
	socket_stack.append(source_socket)
	current_world_id=target_world_id
	
	var main_scene=get_tree().root.get_node("Main")
	main_scene.execute_world_transfer(target_world_id,null)

#surface function
func surface():
	if recursion_stack.is_empty() or socket_stack.is_empty():
		return
	var target_world_id=recursion_stack.pop_back()
	var target_socket=socket_stack.pop_back()
	current_world_id=target_world_id
	
	var main_scene=get_tree().root.get_node("Main")
	main_scene.execute_world_transfer(target_world_id,target_socket)
