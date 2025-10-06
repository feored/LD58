extends Node3D
class_name Battle

const WAVE_DURATION = 90.0
const BASE_INTERMISSION_DURATION = 8.0

enum State {
	Wave,
	Intermission
}

var wave_number: int = 1
var spawn_rate: float = 2.0 # seconds between spawns
var next_spawn_time: float = 0.0

var knight_scene = preload("res://scenes/battle/enemy/knight.tscn")
var soul_scene = preload("res://scenes/battle/souls/soul_skull.tscn")
var enemies: Array = []

var state: State = State.Wave
var time_elapsed: float = 0.0

@onready var UI = %UI
@onready var player_character = %Character


func _ready() -> void:
	Music.play_track(Music.Track.Battle4, true)
	UI.set_wave(wave_number)

func manage_spawn() -> void:
	if time_elapsed > next_spawn_time: 
		spawn_enemy()
		next_spawn_time = time_elapsed + Utils.rng.randf_range(spawn_rate * 0.75, spawn_rate * 1.25)

func spawn_enemy() -> void:
	var enemy_instance = knight_scene.instantiate()
	enemy_instance.position = Vector3(
		randf() * Constants.ARENA_SIZE_X - (Constants.ARENA_SIZE_X / 2.0),
		0.5,
		randf() * Constants.ARENA_SIZE_Y - (Constants.ARENA_SIZE_Y / 2.0)
	)
	enemy_instance.died.connect(enemy_died)
	add_child(enemy_instance)
	enemy_instance.player_character = player_character
	# enemy_instance.get_enemies = func(): return self.enemies
	enemies.push_back(enemy_instance)

func enemy_died(enemy: Node3D) -> void:
	var enemy_position = enemy.global_position
	enemies.erase(enemy)
	enemy.queue_free()
	spawn_soul(enemy_position, enemy.type)

func spawn_soul(spawn_position: Vector3, enemy_type : Constants.EnemyType = Constants.EnemyType.Knight) -> void:
	var soul_instance = soul_scene.instantiate()
	var item_type: Item.Type = ItemInfo.generate_item_type(enemy_type)
	soul_instance.item = ItemInfo.generate_item(item_type)
	soul_instance.position = spawn_position + Vector3(0, 0.5, 0)
	add_child(soul_instance)

func check_wave() -> void:
	if time_elapsed > WAVE_DURATION:
		start_intermission()


func start_intermission() -> void:
	state = State.Intermission
	var total_intermission = BASE_INTERMISSION_DURATION + GameState.total_stats[Item.Group.IntermissionDuration]
	var timer = Timer.new()
	timer.wait_time = total_intermission
	timer.one_shot = true
	timer.autostart = true
	Log.info("Starting intermission for %.2f seconds" % total_intermission)
	timer.timeout.connect(func():
		Log.info("Intermission over, starting next wave")
		start_next_wave()
		timer.queue_free()
	)
	add_child(timer)
	for enemy in enemies:
		enemy.die()
	UI.set_intermission()

func _process(delta: float) -> void:
	time_elapsed += delta
	if state == State.Intermission:
		return
	manage_spawn()
	check_wave()

func _on_ui_next_wave() -> void:
	return
	

func start_next_wave() -> void:
	state = State.Wave
	spawn_rate = max(0.5, spawn_rate - 0.2)
	next_spawn_time = 0.0
	time_elapsed = 0.0
	wave_number += 1
	UI.set_wave(wave_number)

func _on_equipped_souls_died() -> void:
	Log.info("Player has died")
	SceneTransition.change_scene(SceneTransition.Scene.MainMenu)
