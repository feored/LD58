extends Node3D

signal died(enemy: Node3D)

var life: int = Utils.rng.randi_range(40, 60)

const DAMAGE = 10
const HIT_ANIMATION_TIME = 0.15

var type: Constants.EnemyType = Constants.EnemyType.Knight
var player_character: Node3D = null
var speed: float = Utils.rng.randf_range(0.75, 1.25)
var is_hit: bool = false


func _physics_process(delta: float) -> void:
    if not player_character:
        return
    if is_hit:
        self.global_position += (transform.basis.z * delta * speed * 5)
        return
    look_at(player_character.global_position)
    if player_character.global_position.distance_to(self.global_position) > 0.5:
        self.global_position += (-transform.basis.z * delta * speed)


# func separate() -> Vector3:
#     var enemies = get_enemies.call()
#     var too_close: Vector3 = Vector3.ZERO
#     var too_close_count = 0
#     for enemy in enemies:
#         if enemy == self:
#             continue
#         var distance = enemy.global_position.distance_to(self.global_position)
#         if distance < ENEMY_BUNCHUP_RANGE:
#             too_close += (self.global_position - enemy.global_position).normalized()
#             too_close_count += 1
#     var center_of_gravity = Vector3.ZERO
#     if too_close_count > 0:
#         center_of_gravity = too_close / too_close_count
#     return center_of_gravity


func _on_area_3d_area_entered(area: Area3D) -> void:
    if area.get_parent() == player_character:
        if area.is_in_group("melee_hitbox"):
            return
        self.hit_red_tween()
        self.is_hit = true
        player_character.get_hit(DAMAGE)


func hit_recover() -> void:
    self.is_hit = false
    $Mesh.get_active_material(0).albedo_color = Color.WHITE


func hit_red_tween() -> void:
    var tween = create_tween()
    tween.tween_property($Mesh.get_active_material(0), "albedo_color", Color.RED, HIT_ANIMATION_TIME)
    tween.tween_callback(hit_recover)


func die() -> void:
    self.died.emit(self)


func get_hit(damage: int, knockback = false) -> void:
    life -= damage
    if life <= 0:
        die()
    else:
        hit_red_tween()
        if knockback:
            is_hit = true
