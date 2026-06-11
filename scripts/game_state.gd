extends Node


#signal brodcast
signal state_changed(key:String,new_value:bool)

#hold our puzzel data
var puzzle_data:Dictionary={"red_plate_pressed":false}

#function for puzzle state
func set_state(key:String,new_value:bool):
	puzzle_data[key]=new_value
	
	state_changed.emit(key,new_value)
