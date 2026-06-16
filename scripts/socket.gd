extends Node3D

@export var camera_height:float=15.0
@export var state_key:String=""
var socketed_orb:Node3D=null:
	set(value):
		socketed_orb=value
		update_viewport_feed()
		
		if socketed_orb !=null and socketed_orb.world_id=="HubWorld":
			var world_parent=self.get_parent()
			if world_parent and world_parent.name=="VoidWorld":
				var win_screen=get_tree().get_first_node_in_group("win_screen")
				if win_screen:
					win_screen.visible=true
		if state_key!="" and socketed_orb!=null:
			GameState.set_state(state_key,true)

@onready var dive_zone:Area3D=$DiveZone

func _ready():
	dive_zone.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body is CharacterBody3D:
		if socketed_orb !=null:
			var target_world=socketed_orb.world_id
			WorldManager.dive(target_world,self)
			
func update_viewport_feed():
	var main_scene=get_tree().current_scene
	var viewport=main_scene.get_node_or_null("OrbViewport")
	
	if viewport==null:
		return
	var camera =viewport.get_node("OrbCamera") as Camera3D
	
	if socketed_orb!=null:
		if socketed_orb.world_id=="red_world":
			camera.global_position=Vector3(2000,camera_height,0)
		elif socketed_orb.world_id=="blue_world":
			camera.global_position=Vector3(4000,camera_height,0)
			
		camera.rotation_degrees=Vector3(-90,0,0)

		var live_video_feed=viewport.get_texture()
		var portal_material=StandardMaterial3D.new()
		portal_material.albedo_texture=live_video_feed
		var orb_mesh=socketed_orb.get_node("MeshInstance3D")
		orb_mesh.material_override=portal_material
