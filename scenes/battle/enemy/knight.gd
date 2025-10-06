extends Node3D

signal died(enemy: Node3D)

var life: int = Utils.rng.randi_range(50, 100)

const DAMAGE = 70
const HIT_ANIMATION_TIME = 0.15
const DISTANCE_TO_PLAYER = 1.0
const COOLDOWN_BETWEEN_ATTACKS = 1.0

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var mesh = %knight_001
@onready var melee_area: Area3D = %MeleeArea3D

var type: Constants.EnemyType = Constants.EnemyType.Knight
var player_character: Node3D = null
var speed: float = Utils.rng.randf_range(0.75, 1.25)
var is_hit: bool = false
var is_dead : bool = false
var is_swinging: bool = false
var time_since_last_attack: float = 0.0


func _physics_process(delta: float) -> void:
    time_since_last_attack += delta
    if not player_character:
        return
    if is_hit:
        self.global_position += (transform.basis.z * delta * speed * 5)
        return
    if is_dead:
        return
    if is_swinging:
        return
    look_at(player_character.global_position)
    if player_character.global_position.distance_to(self.global_position) > DISTANCE_TO_PLAYER:
        self.global_position += (-transform.basis.z * delta * speed)
    else:
        if time_since_last_attack > COOLDOWN_BETWEEN_ATTACKS:
            self.animation_player.play("knightswing")
            time_since_last_attack = 0.0

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
    return
    # if area.get_parent() == player_character and not area.is_in_group("melee_hitbox"):
    #     self.hit_red_tween()
    #     self.is_hit = true
    #     player_character.get_hit(DAMAGE)


func hit_recover() -> void:
    self.is_hit = false
    self.mesh.get_active_material(0).albedo_color = Color.WHITE


func hit_red_tween() -> void:
    self.animation_player.play("knighthit")
    var tween = create_tween()
    tween.tween_property(self.mesh.get_active_material(0), "albedo_color", Color.RED, HIT_ANIMATION_TIME)
    tween.tween_callback(hit_recover)


func melee_hit() -> void:
    Sfx.play_multitrack(Sfx.MultiTrack.KnightSwordLaunch, self.global_position)
    for area in self.melee_area.get_overlapping_areas():
        if area.get_parent() == player_character and area.is_in_group("player_hitbox"):
            player_character.get_hit(DAMAGE)


func die() -> void:
    Sfx.play_multitrack(Sfx.MultiTrack.KnightDeath, self.global_position)
    self.is_dead = true
    self.animation_player.play("knightdeath")
    await Utils.wait(0.5)
    self.died.emit(self)

func get_hit(damage: int, knockback = false) -> void:
    Sfx.play_multitrack(Sfx.MultiTrack.KnightHit, self.global_position)
    life -= damage
    if life <= 0:
        die()
    else:
        hit_red_tween()
        if knockback:
            is_hit = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if is_swinging:
        is_swinging = false
    self.animation_player.play("knightwalk")
