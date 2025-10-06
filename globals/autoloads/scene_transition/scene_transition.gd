extends Node
@onready var texture_rect = $TextureRect

enum Scene {
    MainMenu,
    Battle,
    Instructions,
    SettingsMenu
}

const PACKED_SCENES = {
    Scene.MainMenu: preload("res://scenes/main_menu/main_menu.tscn"),
    Scene.Instructions: preload("res://scenes/instructions/instructions.tscn"),
    Scene.Battle: preload("res://scenes/battle/battle.tscn"),
    Scene.SettingsMenu: preload("res://scenes/settings_menu/settings_menu.tscn")
}

class LiveScene:
    var node: Node
    var name: Scene

    func _init(scene: Node, name: Scene):
        self.node = scene
        self.name = name

@onready var animation_player = $AnimationPlayer

var scenes_alive = []

func is_scene_alive(target: Scene) -> bool:
    for scene in self.scenes_alive:
        if scene is LiveScene and scene.name == target:
            return true
    return false

func _ready():
    self.texture_rect.hide()
    var initial_scene : LiveScene = LiveScene.new(self.get_tree().current_scene, Scene.MainMenu)
    scenes_alive = [initial_scene]

func create_scene(target: Scene) -> Node:
    var new_scene = PACKED_SCENES[target].instantiate()
    return new_scene

func change_scene(target: Scene) -> void:
    push_scene(target, true)
    Sfx.stop_all()

func push_scene(target: Scene, exclusive = false) -> void:
    self.get_tree().paused = true
    await self.set_screenshot()
    self.fade_in()
    var new_scene = create_scene(target)
    self.get_tree().root.add_child(new_scene)
    self.get_tree().root.remove_child(self.scenes_alive[-1].node)
    if exclusive:
        for live_scene in self.scenes_alive:
            live_scene.node.queue_free()
        self.scenes_alive.clear()
    var live_scene = LiveScene.new(new_scene, target)
    self.scenes_alive.push_back(live_scene)
    self.fade_out()
    self.get_tree().paused = false

func pop_scene() -> void:
    self.get_tree().paused = true
    await self.set_screenshot()
    self.fade_in()
    self.get_tree().root.remove_child(self.scenes_alive[-1].node)
    self.scenes_alive.pop_back()
    self.get_tree().root.add_child(self.scenes_alive[-1].node)
    self.fade_out()
    self.get_tree().paused = false

func fade_in():
    self.texture_rect.show()
    self.texture_rect.modulate = Color.WHITE

func fade_out():
    var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    tween.tween_property(self.texture_rect, "modulate", Color.TRANSPARENT, 0.25)
    tween.tween_callback(self.texture_rect.hide)

func set_screenshot():
    var capture = get_viewport().get_texture().get_image()
    texture_rect.texture = ImageTexture.create_from_image(capture)
