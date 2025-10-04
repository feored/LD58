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
enum Group { Fortitude, MovementSpeed, SpellSpeed, SpellDamage }


class RolledAffix:
	var affix: Affix
	var value: float

	func _init(affix: Affix):
		self.affix = affix
		self.value = Utils.rng.randf_range(affix.value_range.x, affix.value_range.y)

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
		group: Group,
		tier: int,
		prefix: String,
		suffix: String,
		value_range: Vector2,
		is_negative: bool = false
	):
		self.group = group
		self.tier = tier
		self.prefix = prefix
		self.suffix = suffix
		self.value_range = value_range
		self.is_negative = is_negative

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
