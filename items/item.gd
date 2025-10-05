extends RefCounted
class_name Item

var fortitude: int = 0
var rolled_affixes: Array = []
var item_type: Type = Type.Blue
var item_name: String = "Item"


func _to_string() -> String:
	var affixes_str = ""
	for affix in rolled_affixes:
		affixes_str += "\n  " + str(affix)
	return (
		"%s (Type: %s, Base Fortitude: %d, Affixes: [%s\n])"
		% [item_name, str(item_type), fortitude, affixes_str]
	)


enum Type { Blue, Green, Red }
enum Balance { Positive, Negative }
enum Group {
	Fortitude,
	MovementSpeed,
	MagicFind,
	SpellDamage,
	CollectionRange,
	MeleeDamage,
	SoulHoT,
	SoulDuration,
	IntermissionDuration,
	GeistAbility,
	BileAbility,
	BloodshardAbility
}


class RolledAffix:
	var affix: Affix
	var value: float

	func _init(init_affix: Affix):
		self.affix = init_affix
		var temp_value = Utils.rng.randf_range(affix.value_range.x, affix.value_range.y)
		var fmod_value = fmod(temp_value, ItemInfo.GROUP_STEP[affix.group])
		var final_value = temp_value - fmod_value
		if final_value < min(affix.value_range.x, affix.value_range.y):
			final_value = min(affix.value_range.x, affix.value_range.y)
		elif final_value > max(affix.value_range.x, affix.value_range.y):
			final_value = max(affix.value_range.x, affix.value_range.y)
		self.value = (temp_value - fmod_value)

	func _to_string() -> String:
		return "%s: %f" % [str(self.affix), self.value]


class Affix:
	var group: Group
	var tier: int
	var prefix: String = ""
	var suffix: String = ""
	var value_range: Vector2
	var is_negative: bool = false

	func _init(
		init_group: Group,
		init_tier: int,
		init_prefix: String,
		init_suffix: String,
		init_value_range: Vector2,
		init_is_negative: bool = false
	):
		self.group = init_group
		self.tier = init_tier
		self.prefix = init_prefix
		self.suffix = init_suffix
		self.value_range = init_value_range
		self.is_negative = init_is_negative

	func _to_string() -> String:
		return (
			"%s (Tier %d) [%f - %f] %s"
			% [
				Group.keys()[self.group],
				self.tier,
				self.value_range.x,
				self.value_range.y,
				"Negative" if self.is_negative else "Positive"
			]
		)
