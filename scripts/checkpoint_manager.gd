extends Node

var checkpoint_position:Vector3=Vector3(0,15,0)
var checkpoint_world_id:String="HubWorld"

func save(position: Vector3,world_id:String):
	checkpoint_position=position
	checkpoint_world_id=world_id

func respawn(player:CharacterBody3D):
	player.global_position=checkpoint_position
	player.state=player.State.ALIVE
