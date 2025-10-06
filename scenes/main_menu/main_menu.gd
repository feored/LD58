extends Node3D


func _ready() -> void:
    Log.info("Main menu has been loaded.")
    Music.stop()


func _on_play_button_pressed() -> void:
    SceneTransition.change_scene(SceneTransition.Scene.Battle)


func _on_exit_button_pressed() -> void:
    get_tree().quit()


func _on_instructions_button_pressed() -> void:
    SceneTransition.change_scene(SceneTransition.Scene.Instructions)
