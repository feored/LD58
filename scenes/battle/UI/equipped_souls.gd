extends HBoxContainer
class_name EquippedSouls

signal died

const STARTING_SOULS: int = 3
const MAX_SOULS: int = 5
const equipped_soul_scene = preload("res://scenes/battle/UI/equipped_soul.tscn")

var equipped_souls: Array = []
var elapsed_time: float = 0.0


func _physics_process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time >= 1.0:
		elapsed_time = 0.0
		var total_heal = GameState.total_stats[Item.Group.SoulHoT]
		if total_heal > 0:
			equipped_souls[-1].heal(total_heal)


func _ready() -> void:
	for i in range(STARTING_SOULS):
		self.equip_soul(ItemInfo.generate_item(Item.Type.Blue), false)
	GameState.total_stats = get_total_stats()


func can_equip() -> bool:
	return equipped_souls.size() < MAX_SOULS


func equip_soul(item: Item, play_sound = true) -> void:
	if play_sound:
		Sfx.play_multitrack(Sfx.MultiTrack.SoulEquip)
	var soul_instance = equipped_soul_scene.instantiate()
	soul_instance.item = item
	self.add_child(soul_instance)
	self.move_child(soul_instance, 0)  # Move to the front
	equipped_souls.push_front(soul_instance)
	GameState.total_stats = get_total_stats()


func break_soul(soul) -> void:
	equipped_souls.erase(soul)
	soul.queue_free()
	GameState.total_stats = get_total_stats()


func get_hit(damage: int, can_die = true) -> void:
	var leftover_damage = damage
	var broken_souls = []
	for i in range(equipped_souls.size() - 1, -1, -1):
		var soul = equipped_souls[i]
		leftover_damage = soul.get_hit(leftover_damage)
		if leftover_damage > 0:
			broken_souls.append(soul)
		else:
			break
	for soul in broken_souls:
		break_soul(soul)
	if equipped_souls.size() == 0 and can_die:
		self.died.emit()


func _on_character_got_hit(damage: int, can_die = true) -> void:
	get_hit(damage, can_die)


func get_total_stats() -> Dictionary:
	var total_stats = {}
	for group in Item.Group.values():
		total_stats[group] = 0
	for soul in equipped_souls:
		var item = soul.item
		for rolled_affix in item.rolled_affixes:
			total_stats[rolled_affix.affix.group] += rolled_affix.value
	print(total_stats)
	return total_stats
