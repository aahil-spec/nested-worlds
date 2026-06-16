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
	
	_apply_environment(target_world_id)
	_update_vignette()

#surface function
func surface():
	if recursion_stack.is_empty() or socket_stack.is_empty():
		return
	var target_world_id=recursion_stack.pop_back()
	var target_socket=socket_stack.pop_back()
	current_world_id=target_world_id
	
	var main_scene=get_tree().root.get_node("Main")
	main_scene.execute_world_transfer(target_world_id,target_socket)
	
	_apply_environment(target_world_id)
	_update_vignette()

func _apply_environment(world_id:String):
	var main_scene=get_tree().root.get_node_or_null("Main")
	if not main_scene:return
	
	var active_env_node=main_scene.get_node_or_null("WorldEnvironment")
	
	var target_env=null
	if world_id=="HubWorld":
		target_env=main_scene.get_node_or_null("Worlds/HubWorld/WorldEnvironment")
	elif world_id=="red_world":
		target_env=main_scene.get_node_or_null("Worlds/RedWorld/WorldEnvironment")
	elif world_id=="blue_world":
		target_env=main_scene.get_node_or_null("Worlds/BlueWorld/WorldEnvironment")
	elif world_id=="blue_micro_world":
		target_env=main_scene.get_node_or_null("Worlds/BlueMicroWorld/WorldEnvironment")
	elif world_id=="green_world":
		target_env=main_scene.get_node_or_null("Worlds/GreenWorld/WorldEnvironment")
	elif world_id=="void_world":
		target_env=main_scene.get_node_or_null("Worlds/VoidWorld/WorldEnvironment")
	if target_env and active_env_node:
		active_env_node.environment=target_env.environment
		
func _update_vignette():
	var depth=recursion_stack.size()
	var vignette=get_tree().get_first_node_in_group("vignette")
	if not vignette:return
	var mat=vignette.material as ShaderMaterial
	if not mat:return
	
	mat.set_shader_parameter("intensity",clamp(depth*0.25,0.0,0.8))
	
	var orb_colors={"HubWorld":Color(1,0.8,0.2),"red_world":Color(1,0.1,0),"blue_world": Color(0, 0.4, 1)}
	if orb_colors.has(current_world_id):
		mat.set_shader_parameter("vignette_color", orb_colors[current_world_id])
	
	
