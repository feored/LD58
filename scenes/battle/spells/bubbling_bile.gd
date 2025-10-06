extends Node3D

const BASE_LIFETIME = 5.0
const HIT_FREQUENCY = 1.0
const SPEED = 5.0
const BASE_DAMAGE = 20

@onready var base: Node3D = %SkullGreen
@onready var bile: Node3D = %Bile
@onready var bile_area: Area3D = %BileArea3D
@onready var explosion: GPUParticles3D = %Explosion

var time_elapsed: float = 0.0
var is_biled: bool = false

func _ready() -> void:
    Sfx.play(Sfx.Track.BubblingBileLaunch, self.global_position)
    bile.visible = false
    bile_area.monitoring = false

func compute_lifetime() -> float:
    return BASE_LIFETIME + GameState.total_stats[Item.Group.BilePoolDuration]

func compute_damage() -> int:
    var total_spellpower = GameState.total_stats[Item.Group.SpellDamage]
    var total_spellpower_pc = 1 + (total_spellpower / 100.0)
    return BASE_DAMAGE * total_spellpower_pc

func set_destination(dest: Vector3) -> void:
    var tween = create_tween()
    tween.tween_property(self, "global_position", Vector3(dest.x, 0.5, dest.z), self.global_position.distance_to(Vector3(dest.x, 0.5, dest.z)) / SPEED)
    tween.tween_callback(explode_bile)

    
func _physics_process(delta: float) -> void:
    self.check_bounds()
    if not is_biled:
        return
    if time_elapsed > HIT_FREQUENCY:
        self.hit_bile()
        time_elapsed = 0.0
    time_elapsed += delta

func hit_bile() -> void:
    for area in bile_area.get_overlapping_areas():
        if area.get_parent().is_in_group("enemies") and area.is_in_group("enemy_hitbox"):
            area.get_parent().get_hit(compute_damage())
    
func explode_bile():
    Sfx.play(Sfx.Track.BubblingBileExplosion, self.global_position)
    self.base.visible = false
    self.bile.visible = true
    self.bile_area.monitoring = true
    self.rotation = Vector3.ZERO
    var timer := Timer.new()
    self.add_child(timer)
    timer.wait_time = compute_lifetime()
    timer.timeout.connect(queue_free)
    timer.start()
    explosion.emitting = true
    is_biled = true

func check_bounds() -> void:
    if self.global_position.y < 0:
        self.global_position.y = 0
    if self.global_position.x > Constants.ARENA_SIZE_X / 2.0:
        self.queue_free()
    elif self.global_position.x < -Constants.ARENA_SIZE_X / 2.0:
        self.queue_free()
    elif self.global_position.z > Constants.ARENA_SIZE_Y / 2.0:
        self.queue_free()
    elif self.global_position.z < -Constants.ARENA_SIZE_Y / 2.0:
        self.queue_free()
