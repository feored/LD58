extends Node3D

@export var battle: Battle
@export var animation_player: AnimationPlayer
@onready var model: Node3D = %lich
const howling_geist = preload("res://scenes/battle/spells/howling_geist.tscn")
const bubbling_bile = preload("res://scenes/battle/spells/bubbling_bile.tscn")

const movement_speed: float = 2.5
var time_elapsed: float = 0.0

func _ready() -> void:
    self.hover_animation()

func _physics_process(delta: float) -> void:
    time_elapsed += delta
    self.global_position += movement_vector() * movement_speed * delta
    self.look_at_mouse()

func _unhandled_input(event):
    self.shoot(event)

func shoot(event) -> void:
    if event.is_action_pressed("spell_1"):
        var spell_instance = howling_geist.instantiate()
        battle.add_child(spell_instance)
        spell_instance.global_position = self.global_position + Vector3(0, 1.0, 0) - transform.basis.z * 1.5
        var spell_direction = (Utils.get_mouse_pos(get_viewport().get_camera_3d()) - self.global_position).normalized()
        spell_instance.look_at(spell_instance.global_position + spell_direction)
        self.play_animation("lich_spec")
    elif event.is_action_pressed("spell_2"):
        var spell_instance = bubbling_bile.instantiate()
        battle.add_child(spell_instance)
        spell_instance.global_position = self.global_position + Vector3(0, 0.5, 0) - transform.basis.z * 1.5
        var spell_direction = (Utils.get_mouse_pos(get_viewport().get_camera_3d()) - self.global_position).normalized()
        spell_instance.look_at(spell_instance.global_position + spell_direction)
        spell_instance.set_destination(Utils.get_mouse_pos(get_viewport().get_camera_3d()))
        self.play_animation("lich_spec")

func movement_vector() -> Vector3:
    var movement: Vector3 = Vector3.ZERO
    if Input.is_action_pressed("left"):
        movement += Vector3.LEFT
    elif Input.is_action_pressed("right"):
        movement += Vector3.RIGHT
    if Input.is_action_pressed("up"):
        movement += Vector3.FORWARD
    elif Input.is_action_pressed("down"):
        movement += Vector3.BACK
    return movement.normalized()

func look_at_mouse() -> void:
    var mouse_pos = Utils.get_mouse_pos(get_viewport().get_camera_3d())
    self.look_at(Vector3(mouse_pos.x, self.global_position.y, mouse_pos.z))

func hover_animation() -> void:
    var tween = self.create_tween().set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EaseType.EASE_IN_OUT).set_loops()
    tween.tween_property(self.model, "position:y", 0.25, 1.0)
    tween.tween_property(self.model, "position:y", 0, 1.0)

func get_hit(damage: int) -> void:
    self.play_animation("lich_hurt")

func play_animation(anim: String) -> void:
    self.animation_player.clear_queue()
    self.animation_player.play(anim)
    self.animation_player.animation_set_next(anim, "reset")

func add_item(item: Item) -> void:
    Log.info("Picked up item: %s" % item)
