extends Node3D
class_name Battle

const WAVE_DURATION = 40.0
const BASE_INTERMISSION_DURATION = 8.0

enum State {
    Wave,
    Intermission
}

enum MusicState {
    Intro,
    Battle,
    Transition
}

var wave_number: int = 0
var spawn_rate: float = 2.0 # seconds between spawns
var next_spawn_time: float = 0.0

const knight_scene = preload("res://scenes/battle/enemy/knight.tscn")
const knight_captain_scene = preload("res://scenes/battle/enemy/knight_captain.tscn")
const mage_scene = preload("res://scenes/battle/enemy/mage.tscn")

var soul_scene = preload("res://scenes/battle/souls/soul_skull.tscn")
var enemies: Array = []

var state: State = State.Wave
var time_elapsed: float = 0.0
var music_state: MusicState = MusicState.Intro


@onready var UI = %UI
@onready var player_character = %Character


func _ready() -> void:
    Music.switched_track.connect(_on_music_finished)
    start_next_wave()

func _on_music_finished() -> void:
    match music_state:
        MusicState.Intro:
            Log.info("Battle intro finished, adding one more battle track to queue")
            music_state = MusicState.Battle
            #Music.play_track(Music.get_random_battle_track(), false, true)
            Music.queue_next_track(Music.get_random_battle_track(), false, 0.05)
        MusicState.Battle:
            Log.info("Battle track finished, adding one more battle track to queue")
            music_state = MusicState.Battle
            #Music.play_track(Music.get_random_battle_track(), false, true)
            Music.queue_next_track(Music.get_random_battle_track(), false, 0.05)


func manage_spawn() -> void:
    if time_elapsed > next_spawn_time: 
        spawn_enemy()
        next_spawn_time = time_elapsed + Utils.rng.randf_range(spawn_rate * 0.75, spawn_rate * 1.25)

func get_random_enemy(wave: int) -> PackedScene:
    var chance = Utils.rng.randi_range(0, 100)
    var chances = Constants.ENEMY_SPAWN_CHANCES[wave-1]
    var cumulative = 0
    for enemy_type in chances.keys():
        cumulative += chances[enemy_type]
        if chance < cumulative:
            match enemy_type:
                Constants.EnemyType.Knight:
                    return knight_scene
                Constants.EnemyType.KnightCaptain:
                    return knight_captain_scene
                Constants.EnemyType.Mage:
                    return mage_scene
    return knight_scene

func spawn_enemy() -> void:
    var enemy_instance = get_random_enemy(min(wave_number, Constants.ENEMY_SPAWN_CHANCES.size() - 1)).instantiate()
    const MIN_DISTANCE_FROM_PLAYER = 15.0
    var enemy_position: Vector3 = Vector3.ZERO
    var r = MIN_DISTANCE_FROM_PLAYER * sqrt(Utils.rng.randf())
    var theta = Utils.rng.randf() * 2.0 * PI
    enemy_position.x += r * cos(theta)
    enemy_position.z += r * sin(theta)
    enemy_position.y = 0.5
    enemy_instance.global_position = enemy_position + player_character.global_position
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
    enemies.clear()

    UI.set_intermission(total_intermission)

func _process(delta: float) -> void:
    time_elapsed += delta
    if state == State.Intermission:
        return
    manage_spawn()
    check_wave()

func _on_ui_next_wave() -> void:
    return

func start_next_wave() -> void:
    self.music_state = MusicState.Intro
    Music.play_track(Music.get_random_intro_track(), false, false)
    Music.queue_next_track(Music.get_random_battle_track(), false, 0.05)
    state = State.Wave
    spawn_rate = max(0.25, spawn_rate - 0.2)
    next_spawn_time = 0.0
    time_elapsed = 0.0
    wave_number += 1
    UI.set_wave(wave_number, WAVE_DURATION)


func _on_equipped_souls_died() -> void:
    player_character.die()
    await Utils.wait(3.0)
    # SceneTransition.change_scene(SceneTransition.Scene.MainMenu)
    UI.set_game_over(wave_number)
