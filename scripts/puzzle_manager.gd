extends Node3D

var correct_sequence:Array=["SunPlate","EyePlate","MoonPlate","StarPlate"]
var current_sequence:Array=[]

@export var hub_orb:Node3D

@onready var correct_sfc=$CorrectSound
@onready var fail_sfx=$FailSound
@onready var victory_sfx=$VictorySound
func _ready():
	if hub_orb:
		hub_orb.visible=false
		
	for child in get_children():
		if child is Area3D:
			child.body_entered.connect(_on_plate_stepped.bind(child.name))
			
func _on_plate_stepped(body:Node3D,plate_name:String):
	if not body.is_in_group("player") and not body.name=="Player":
		return
	if current_sequence.size()>0 and current_sequence.back()==plate_name:
		return
	current_sequence.append(plate_name)
	var current_step=current_sequence.size()-1
	
	if current_sequence[current_step] !=correct_sequence[current_step]:
		fail_sfx.play()
		current_sequence.clear()
		return
		
	correct_sfc.play()
	if current_sequence.size()==correct_sequence.size():
		win_puzzle()
func win_puzzle():
	victory_sfx.play()
	if hub_orb:
		hub_orb.visible=true
	GameState.set_state("garden_temple_open",true)
	for child in get_children():
		if child is Area3D:
			child.body_entered.disconnect(_on_plate_stepped)
