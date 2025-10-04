extends Node3D
var enemy_scene = preload("res://scenes/battle/enemy/enemy.tscn")
var enemies: Array = []
@onready var UI 

var time_elapsed: float = 0.0
@onready var player_character = %Character

func manage_spawn() -> void:
    if time_elapsed > 1.0:
        spawn_enemy()
        time_elapsed = 0.0

func spawn_enemy() -> void:
    var enemy_instance = enemy_scene.instantiate()
    enemy_instance.position = Vector3(
        randf() * Constants.ARENA_SIZE_X - Constants.ARENA_SIZE_X / 2,
        0.5,
        randf() * Constants.ARENA_SIZE_Y - Constants.ARENA_SIZE_Y / 2
    )
    add_child(enemy_instance)
    enemy_instance.player_character = player_character
    enemy_instance.get_enemies = func(): return self.enemies
    enemies.push_back(enemy_instance)

func _process(delta: float) -> void:
    time_elapsed += delta
    manage_spawn()
