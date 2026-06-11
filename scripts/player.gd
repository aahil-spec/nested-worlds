extends CharacterBody3D

@export var speed: float =5.0
@export var jump_velocity:float=4.5

var gravity:float=ProjectSettings.get_setting("physics/3d/default_gravity")

#interact
@onready var hold_position:Marker3D=$HoldPosition
@onready var interact_reach:Area3D=$InteractReach

#orb holding
var held_orb: Node3D=null
func _physics_process(delta):
	if not is_on_floor():
		velocity.y-=gravity*delta
	#jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y=jump_velocity
	#walking
	var input_dir=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var direction=(transform.basis*Vector3(input_dir.x,0,input_dir.y)).normalized()
	
	if direction:
		velocity.x=direction.x*speed
		velocity.z=direction.z*speed
	else:
		velocity.x=move_toward(velocity.x,0,speed)
		velocity.z=move_toward(velocity.z,0,speed)
	move_and_slide()
@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if held_orb !=null:
			drop_orb()
		else:
			pick_up_orb()
#orb function
func pick_up_orb():
	if held_orb!=null:
		return
	var touching_areas=interact_reach.get_overlapping_areas()
	
	for area in touching_areas:
		if area.is_in_group("orb_zone"):
			var orb=area.get_parent()
			
			if orb.world_id == WorldManager.current_world_id:
				return
			
			var orb_parent=orb.get_parent()
			if orb_parent and "socketed_orb" in orb_parent:
				orb_parent.socketed_orb=null
				
			var orb_mesh=orb.get_node_or_null("MeshInstance3D")
			if orb_mesh:
				orb_mesh.material_override=null
				
			orb.reparent(hold_position)
			orb.position=Vector3.ZERO
			held_orb=orb
			if orb.world_id=="red_world":
				GameState.set_state("carrying_red_orb",true)
			return
#drop orb
func drop_orb():
	if held_orb==null:
		return
	var orb=held_orb
	held_orb=null
	
	if orb.world_id=="red_world":
		GameState.set_state("carrying_red_orb",false)

	var touching_areas=interact_reach.get_overlapping_areas()
	for area in touching_areas:
		if area.is_in_group("socket_zone"):
			var socket=area.get_parent()
			if socket.socketed_orb==null:
				socket.socketed_orb=orb
				orb.reparent(socket)
				orb.global_position=socket.global_position
				orb.global_position.y=1.8
				return
	var main_scene=get_tree().current_scene
	orb.reparent(main_scene)
	orb.global_position=global_position
	orb.global_position.y=1.0
