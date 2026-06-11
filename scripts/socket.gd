extends Node3D

var socketed_orb:Node3D=null

@onready var dive_zone:Area3D=$DiveZone

func _ready():
	dive_zone.body_entered.connect(_on_body_entered)
	

func _on_body_entered(body):
	if body is CharacterBody3D:
		if socketed_orb !=null:
			var target_world=socketed_orb.world_id
			WorldManager.dive(target_world,self)
			
