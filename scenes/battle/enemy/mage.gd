extends Node3D

signal died(enemy: Node3D)

const fireball_scene: PackedScene = preload("res://scenes/battle/enemy/mage_fireball.tscn")

var life: int = Utils.rng.randi_range(30, 60)

const DAMAGE = 50
const HIT_ANIMATION_TIME = 0.15
const DISTANCE_TO_PLAYER = 5.0
const COOLDOWN_BETWEEN_ATTACKS = 5.0

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var mesh = %mage

var type: Constants.EnemyType = Constants.EnemyType.Mage
var player_character: Node3D = null
var speed: float = Utils.rng.randf_range(2, 3.4)
var is_hit: bool = false
var is_dead : bool = false
var is_swinging: bool = false
var time_since_last_attack: float = COOLDOWN_BETWEEN_ATTACKS


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
            is_swinging = true
            self.animation_player.play("mage_chant")
            Sfx.play_multitrack(Sfx.MultiTrack.MageChant, self.global_position)
            time_since_last_attack = 0.0


func hit_recover() -> void:
    self.is_hit = false
    self.mesh.get_active_material(0).albedo_color = Color.WHITE


func hit_red_tween() -> void:
    self.animation_player.play("mage_hit")
    var tween = create_tween()
    tween.tween_property(self.mesh.get_active_material(0), "albedo_color", Color.RED, HIT_ANIMATION_TIME)
    tween.tween_callback(hit_recover)


func launch_fireball() -> void:
    var fireball_instance = fireball_scene.instantiate()
    self.get_parent().add_child(fireball_instance)
    fireball_instance.global_position = self.global_position + Vector3(0, 0.5, 0) - (transform.basis.z * 0.5)
    fireball_instance.look_at(player_character.global_position + Vector3(0, 0.5, 0))
    Sfx.play(Sfx.Track.HowlingGeistLaunch, self.global_position)


func die() -> void:
    self.is_dead = true
    self.animation_player.play("mage_death")
    await Utils.wait(0.5)
    %EnemyDeath.emitting = true
    self.died.emit(self)

func get_hit(damage: int, knockback = false) -> void:
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
    self.animation_player.play("mage_walk")
