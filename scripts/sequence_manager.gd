extends Node3D

var expected_sequence:Array=["sun","eye","moon","star"]
var current_sequence:Array=[]

func press_plate(symbol:String):
	if current_sequence.size()==4:
		return
	current_sequence.append(symbol)
	print("you stepped on:",symbol)
	
	for i in range(current_sequence.size()):
		if current_sequence[i]!=expected_sequence[i]:
			print('oops! wrong order! try again')
			current_sequence.clear()
			return
	if current_sequence.size()==4:
		print("YAY! You solved the puzzle!")
		GameState.set_state("garden_temple_open",true)
