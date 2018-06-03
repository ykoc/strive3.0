extends Node

func _ready():
	pass



func _on_Button_pressed():
	$edittree.show("races")


func _on_BodypartsButton_pressed():
	$edittree.show('bodyparts')


func _on_racetree_item_rmb_edited():
	pass # replace with function body

func editarray(array):
	$EditArray.show(array)