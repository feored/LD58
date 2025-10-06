extends Node3D
class_name Character

@export var battle: Battle
@export var animation_player: AnimationPlayer
@onready var model: Node3D = %lich
@onready var melee_area: Area3D = %MeleeArea3D
@onready var inventory: Inventory = %Inventory

const SPELL_CAST_WAIT_TIME: float = 0.25

const howling_geist = preload("res://scenes/battle/spells/howling_geist.tscn")
const bubbling_bile = preload("res://scenes/battle/spells/bubbling_bile.tscn")

signal spell_changed(new_spell: Spell)
signal spell_no_ammo()
signal got_hit(damage: int)

enum Spell {
    HowlingGeist,
    BubblingBile,
    BloodshardArrows
}

var current_spell: Spell = Spell.HowlingGeist

const BASE_MELEE_DAMAGE: int = 25
const movement_speed: float = 2.5
var time_elapsed: float = 0.0

func _ready() -> void:
    self.hover_animation()

func _physics_process(delta: float) -> void:
    time_elapsed += delta
    self.global_position += movement_vector() * movement_speed * delta
    self.look_at_mouse()

func _unhandled_input(event):
    self.switch_spells(event)
    self.shoot(event)

func switch_spells(event) -> void:
    if event.is_action_pressed("wheel_up"):
        var next_index = (int(current_spell) + 1) % Spell.size()
        current_spell = Spell.values()[next_index] as Spell
        self.emit_signal("spell_changed", current_spell)
    elif event.is_action_pressed("wheel_down"):
        var next_index = (int(current_spell) - 1) % Spell.size()
        current_spell = Spell.values()[next_index] as Spell
        self.emit_signal("spell_changed", current_spell)

func shoot(event) -> void:
    if event.is_action_pressed("left_click"):
        self.animation_player.play("lich_m1")
    if event.is_action_pressed("spell_1"):
        shoot_howling_geist()
    elif event.is_action_pressed("spell_2"):
        shoot_bubbling_bile()
    elif event.is_action_pressed("spell_3"):
        pass
    if event.is_action_pressed("right_click"):
        match current_spell:
            Spell.HowlingGeist:
                shoot_howling_geist()
            Spell.BubblingBile:
                shoot_bubbling_bile()
            Spell.BloodshardArrows:
                pass

func shoot_howling_geist() -> void:
    self.spell_changed.emit(Spell.HowlingGeist)
    if inventory.count_items_of_type(Item.Type.Blue) <= 0:
        #Sfx.play(Sfx.Track.Cancel)
        self.spell_no_ammo.emit()
        return
    self.animation_player.play("lich_spec")
    await Utils.wait(SPELL_CAST_WAIT_TIME)
    var spell_instance = howling_geist.instantiate()
    battle.add_child(spell_instance)
    spell_instance.global_position = self.global_position + Vector3(0, 1.0, 0) - transform.basis.z * 1.5
    var spell_direction = (Utils.get_mouse_pos(get_viewport().get_camera_3d()) - self.global_position).normalized()
    spell_instance.look_at(spell_instance.global_position + spell_direction)
    inventory.use_last_item_of_type(Item.Type.Blue)

func shoot_bubbling_bile() -> void:
    self.spell_changed.emit(Spell.BubblingBile)
    if inventory.count_items_of_type(Item.Type.Green) <= 0:
        #Sfx.play(Sfx.Track.Cancel)
        self.spell_no_ammo.emit()
        return
    self.animation_player.play("lich_spec")
    await Utils.wait(SPELL_CAST_WAIT_TIME)
    var spell_instance = bubbling_bile.instantiate()
    battle.add_child(spell_instance)
    spell_instance.global_position = self.global_position + Vector3(0, 0.5, 0) - transform.basis.z * 1.5
    var spell_direction = (Utils.get_mouse_pos(get_viewport().get_camera_3d()) - self.global_position).normalized()
    spell_instance.look_at(spell_instance.global_position + spell_direction)
    spell_instance.set_destination(Utils.get_mouse_pos(get_viewport().get_camera_3d()))
    inventory.use_last_item_of_type(Item.Type.Green)


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
    self.animation_player.play("lich_hurt")
    self.emit_signal("got_hit", damage)

func add_item(item: Item) -> bool:
    if inventory.items.size() >= Inventory.MAX_TOTAL_SOULS:
        return false
    self.inventory.add_item(item)
    return true

func can_add_item(item: Item) -> bool:
    return inventory.items.size() < Inventory.MAX_TOTAL_SOULS


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    self.animation_player.play("lich_idle")

func melee_hit() -> void:
    var areas = self.melee_area.get_overlapping_areas()
    for area in areas:
        if area.is_in_group("enemy_hitbox"):
            if area.get_parent().is_in_group("enemies"):
                area.get_parent().get_hit(BASE_MELEE_DAMAGE, true)
