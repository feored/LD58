extends Node3D

const WAVE_DURATION = 10.0
var wave_number: int = 1
var spawn_rate: float = 2.0 # seconds between spawns
var next_spawn_time: float = 0.0

var enemy_scene = preload("res://scenes/battle/enemy/enemy.tscn")
var enemies: Array = []

var time_elapsed: float = 0.0

@onready var UI = %UI
@onready var player_character = %Character

func _ready() -> void:
    UI.set_wave(wave_number)

func manage_spawn() -> void:
    if time_elapsed > next_spawn_time: 
        spawn_enemy()
        next_spawn_time = time_elapsed + Utils.rng.randf_range(spawn_rate * 0.75, spawn_rate * 1.25)

func spawn_enemy() -> void:
    var enemy_instance = enemy_scene.instantiate()
    enemy_instance.position = Vector3(
        randf() * Constants.ARENA_SIZE_X - Constants.ARENA_SIZE_X / 2,
        0.5,
        randf() * Constants.ARENA_SIZE_Y - Constants.ARENA_SIZE_Y / 2
    )
    add_child(enemy_instance)
    enemy_instance.player_character = player_character
    # enemy_instance.get_enemies = func(): return self.enemies
    enemies.push_back(enemy_instance)

func check_wave() -> void:
    if time_elapsed > WAVE_DURATION:
        get_tree().paused = true
        UI.set_state(UI.State.MENU)

func _process(delta: float) -> void:
    time_elapsed += delta
    manage_spawn()
    check_wave()

func _on_ui_next_wave() -> void:
    Log.info("Starting next wave")
    for enemy in enemies:
        enemy.queue_free()
    enemies.clear()
    spawn_rate = max(0.5, spawn_rate - 0.2)
    time_elapsed = 0.0
    wave_number += 1
    UI.set_wave(wave_number)
