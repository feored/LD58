extends Node3D

const bloodfire_element = preload("res://scenes/battle/spells/bloodfire_element.tscn")

const BASE_LIFETIME = 3.0
const FREQUENCY = 0.05
var battle : Node3D = null

@onready var skull_red = $SkullRed
var time_elapsed: float = 0.0

func compute_lifetime() -> float:
    return BASE_LIFETIME + GameState.total_stats[Item.Group.BloodfireWaveDuration]

func _physics_process(delta: float) -> void:
    if time_elapsed >= FREQUENCY:
        time_elapsed = 0.0
        spawn_bloodfire_element(self.position)
    time_elapsed += delta


func spawn_bloodfire_element(position: Vector3) -> void:
    var element_instance = bloodfire_element.instantiate()
    self.battle.add_child(element_instance)
    element_instance.global_position = skull_red.global_position
    element_instance.global_rotation = Vector3(self.global_rotation.x, self.global_rotation.y + PI, self.global_rotation.z)

func _ready() -> void:
    var timer := Timer.new()
    self.add_child(timer)
    timer.wait_time = compute_lifetime()
    timer.timeout.connect(queue_free)
    timer.start()
