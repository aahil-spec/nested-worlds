extends Node

var story_flags: Dictionary={
	"hub_plaque_entry_heard":false,
	"forge_echo_lyra_01_heard":false
}
#signal brodcast
signal state_changed(key:String,new_value:bool)

#hold our puzzel data
var puzzle_data:Dictionary={
	"red_plate_pressed":false,
	"blue_plate_pressed":false,
	"carrying_red_orb":false
}

#function for puzzle state
func set_state(key:String,new_value:bool):
	puzzle_data[key]=new_value
	state_changed.emit(key,new_value)
