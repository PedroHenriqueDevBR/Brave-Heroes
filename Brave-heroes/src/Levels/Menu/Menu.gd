extends Control

onready var scene_tree: = get_tree()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		scene_tree.set_input_as_handled()
		start_game()


func _on_Button_pressed() -> void:
	start_game()


func start_game() -> void:
	get_tree().change_scene("res://src/Levels/Level0/Level0.tscn")
