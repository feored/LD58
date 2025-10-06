extends Node3D

const SPEED = 8.0
const BASE_TURNING_SPEED = 1.0

const MOUSE_RANGE = 10.0

var is_moving : bool = true
var turning_speed : float = BASE_TURNING_SPEED

@onready var base : Node3D = %SkullBlue
@onready var explosion_area : Area3D = %ExplosionArea
@onready var ghost_fire_explosion: GPUParticles3D = %GhostFireExplosion

func compute_damage() -> int:
    var total_spellpower = GameState.total_stats[Item.Group.SpellDamage]
    var total_spellpower_pc = 1 + (total_spellpower / 100.0)
    return Constants.BASE_SPELL_DAMAGE * total_spellpower_pc

func compute_tracking() -> float:
    var total_tracking = GameState.total_stats[Item.Group.GeistTracking]
    var total_tracking_pc = 1 + (total_tracking / 100.0)
    return BASE_TURNING_SPEED * total_tracking_pc

func _ready() -> void:
    Sfx.play(Sfx.Track.HowlingGeistLaunch, self.global_position)
    turning_speed = compute_tracking()

func _physics_process(delta: float) -> void:
    self.check_bounds()
    if not is_moving:
        return
    var mouse_pos = Utils.get_mouse_pos(get_viewport().get_camera_3d())
    if self.global_position.distance_to(mouse_pos) < MOUSE_RANGE:
        var target_direction = (Vector3(mouse_pos.x, self.global_position.y, mouse_pos.z) - self.global_position).normalized()
        var current_direction = -transform.basis.z
        var new_direction = current_direction.slerp(target_direction, turning_speed * delta).normalized()
        self.rotation.y = atan2(-new_direction.x, -new_direction.z)
    self.global_position += -transform.basis.z * SPEED * delta

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

func _on_area_3d_area_entered(area: Area3D) -> void:
    if area.get_parent().is_in_group("enemies") and area.is_in_group("enemy_hitbox"):
        self.start_explode()

func start_explode():
    Sfx.play(Sfx.Track.HowlingGeistExplosion, self.global_position)
    self.is_moving = false
    self.base.visible = false
    self.ghost_fire_explosion.emitting = true
    self.explosion_area.monitoring = true
    var timer := Timer.new()
    self.add_child(timer)
    timer.wait_time = 0.4
    timer.one_shot = true
    timer.timeout.connect(end_explode)
    timer.start()

func end_explode():
    for area in explosion_area.get_overlapping_areas():
        if area.get_parent().is_in_group("enemies") and area.is_in_group("enemy_hitbox"):
            area.get_parent().get_hit(compute_damage())
    self.queue_free()
