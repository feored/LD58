extends Node3D


func _on_button_pressed() -> void:
	SceneTransition.change_scene(SceneTransition.Scene.MainMenu)
