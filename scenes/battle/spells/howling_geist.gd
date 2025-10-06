extends Node3D

const SPEED = 10.0
const TURNING_SPEED = 1.0
const BASE_DAMAGE = 50

const MOUSE_RANGE = 10.0

var is_moving : bool = true

@onready var base : Node3D = %SkullBlue
@onready var explosion_area : Area3D = %ExplosionArea
@onready var explosion_mesh : MeshInstance3D = %ExplosionMesh

func compute_damage() -> int:
    var total_spellpower = GameState.total_stats[Item.Group.SpellDamage]
    var total_spellpower_pc = 1 + (total_spellpower / 100.0)
    Log.info("Total damage: %.2f" % (BASE_DAMAGE * total_spellpower_pc))
    return BASE_DAMAGE * total_spellpower_pc

func _ready() -> void:
    explosion_mesh.visible = false

func _physics_process(delta: float) -> void:
    self.check_bounds()
    if not is_moving:
        return
    var mouse_pos = Utils.get_mouse_pos(get_viewport().get_camera_3d())
    if self.global_position.distance_to(mouse_pos) < MOUSE_RANGE:
        var target_direction = (Vector3(mouse_pos.x, self.global_position.y, mouse_pos.z) - self.global_position).normalized()
        var current_direction = -transform.basis.z
        var new_direction = current_direction.slerp(target_direction, TURNING_SPEED * delta).normalized()
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
    if area.get_parent().is_in_group("enemies"):
        self.start_explode()

func start_explode():
    self.is_moving = false
    self.base.visible = false
    self.explosion_mesh.visible = true
    self.explosion_area.monitoring = true
    var timer := Timer.new()
    self.add_child(timer)
    timer.wait_time = 0.25
    timer.one_shot = true
    timer.timeout.connect(end_explode)
    timer.start()

func end_explode():
    for area in explosion_area.get_overlapping_areas():
        if area.get_parent().is_in_group("enemies") and area.is_in_group("enemy_hitbox"):
            area.get_parent().get_hit(compute_damage())
    self.queue_free()
