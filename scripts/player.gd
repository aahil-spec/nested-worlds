extends CharacterBody3D

@export var speed: float =5.0
@export var jump_velocity:float=4.5
@export var mouse_sensitivity:float=0.002
var gravity:float=ProjectSettings.get_setting("physics/3d/default_gravity")

#interact
@onready var hold_position:Marker3D=$HoldPosition
@onready var interact_reach:Area3D=$InteractReach
@onready var camera:Camera3D=$CameraRig/Camera3D
@onready var anim_player:AnimationPlayer=$Character/AnimationPlayer

#orb holding
var held_orb: Node3D=null

enum State{ALIVE,DEAD,DIVING}
var state:State=State.ALIVE

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _physics_process(delta):
	if state !=State.ALIVE:
		return
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
		
		$Character.rotation.y = lerp_angle($Character.rotation.y, atan2(input_dir.x, input_dir.y), 10.0 * delta)
	else:
		velocity.x=move_toward(velocity.x,0,speed)
		velocity.z=move_toward(velocity.z,0,speed)
		
	move_and_slide()
	update_animation()
@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if DialogueManager.is_playing:
			DialogueManager.advance()
			return
		var touching_areas=interact_reach.get_overlapping_areas()
		for area in touching_areas:
			if area.is_in_group("interactable"):
				var interactable_object=area.get_parent()
				if interactable_object.has_method("interact"):
					interactable_object.interact()
					return
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
			GameState.set_state("carrying_any_orb",true)
			return
#drop orb
func drop_orb():
	if held_orb==null:
		return
	var orb=held_orb
	held_orb=null
	
	GameState.set_state("carrying_any_orb",false)

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
func die():
	if state== State.DEAD:
		return
		
	state = State.DEAD
	var fade_animator = get_tree().current_scene.fade_animator
	fade_animator.play("fade")
	await fade_animator.animation_finished
	
	CheckpointManager.respawn(self)
	
	fade_animator.play_backwards("fade")
	
func _on_interact_area_body_entered(body:Node3D):
	if body.is_in_group("hazard"):
		die()
func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x*mouse_sensitivity)
		
		camera.rotate_x(-event.relative.y*mouse_sensitivity)
		camera.rotation.x=clamp(camera.rotation.x,deg_to_rad(-80),deg_to_rad(80))
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func update_animation():
	if not is_on_floor():
		if velocity.y>0:
			anim_player.play("Jump")
		else:
			anim_player.play("Falling")
	else:
		if abs(velocity.x)>0.1 or abs(velocity.z)>0.1:
			anim_player.play("Run")
		else:
			anim_player.play("Idle")
