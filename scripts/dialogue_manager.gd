extends Node

@onready var dialogue_label:Label=get_tree().get_first_node_in_group("dialogue_label")

var current_lines:Array=[]
var current_index:int=0
var is_playing:bool=false

func play(dialogue_id:String):
	if is_playing:
		return
	if not DialogueData.LINES.has(dialogue_id):
		return
	dialogue_label = get_tree().get_first_node_in_group("dialogue_label")
	current_lines=DialogueData.LINES[dialogue_id]
	current_index=0
	is_playing=true
	_show_next_line()
	
func advance():
	if not is_playing:
		return
		
	current_index+=1
	if current_index>=current_lines.size():
		_end_dialogue()
	else:
		_show_next_line()
		
func _show_next_line():
	if dialogue_label:
		dialogue_label.text=current_lines[current_index]
		dialogue_label.get_parent().visible=true
		
func _end_dialogue():
	is_playing=false
	if dialogue_label:
		dialogue_label.get_parent().visible=false
	current_lines=[]
