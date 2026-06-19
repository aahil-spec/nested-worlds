extends Node3D

var is_pulled:bool=false

func interact():
	if is_pulled:
		return
	is_pulled=true
	GameState.set_state("blue_case_unlocked",true)
	rotation_degrees.x-=45
	$LeverSound.play()
