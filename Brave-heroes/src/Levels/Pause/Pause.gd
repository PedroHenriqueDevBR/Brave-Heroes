extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
var paused: = false setget set_paused


func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()


func _on_ResumeButton_pressed() -> void:
	self.set_paused(false)


func _on_QuitButton_pressed() -> void:
	set_paused(false)
	get_tree().change_scene("res://src/Levels/Menu/Menu.tscn")
