extends Node

const SOUL_NAMES = {
	Item.Type.Blue: ["Sapphire Soul", "Blue Soul", "Azure Soul", "Beryl Soul"],
	Item.Type.Green: ["Jade Soul", "Sage Soul", "Green Soul", "Emerald Soul"],
	Item.Type.Red: ["Crimson Soul", "Red Soul", "Ruby Soul", "Scarlet Soul"]
}
const ITEM_TYPE_COLOR = {
	Item.Type.Blue: Color(0.2, 0.2, 1, 1),
	Item.Type.Green: Color(0.2, 1, 0.2, 1),
	Item.Type.Red: Color(1, 0.2, 0.2, 1)
}

const BASE_FORTITUDE = {
	Item.Type.Blue: Vector2(1, 5), Item.Type.Green: Vector2(6, 20), Item.Type.Red: Vector2(16, 40)
}

const GROUP_STEP = {
	Item.Group.Fortitude            : 1.0,
	Item.Group.MovementSpeed        : 0.01,
	Item.Group.MagicFind            : 0.01,
	Item.Group.SpellDamage          : 0.01,
	Item.Group.CollectionRange      : 0.05,
	Item.Group.MeleeDamage          : 1.0,
	Item.Group.SoulHoT              : 0.5,
	Item.Group.SoulDuration         : 0.5,
	Item.Group.IntermissionDuration : 0.5,
	Item.Group.GeistAbility         : 0.1,
	Item.Group.BileAbility          : 0.1,
	Item.Group.BloodshardAbility    : 0.1
}

const GROUP_STEP_DISPLAY = {
	Item.Group.Fortitude            : "%.0f",
	Item.Group.MovementSpeed        : "%.2f",
	Item.Group.MagicFind            : "%.2f",
	Item.Group.SpellDamage          : "%.2f",
	Item.Group.CollectionRange      : "%.2f",
	Item.Group.MeleeDamage          : "%.0f",
	Item.Group.SoulHoT              : "%.1f",
	Item.Group.SoulDuration         : "%.1f",
	Item.Group.IntermissionDuration : "%.1f",
	Item.Group.GeistAbility         : "%.1f",
	Item.Group.BileAbility          : "%.1f",
	Item.Group.BloodshardAbility    : "%.1f"
}

const GROUP_DISPLAY_TEXT = {
	Item.Group.Fortitude            : "%s to Fortitude",
	Item.Group.MovementSpeed        : "%s to Movement Speed",
	Item.Group.MagicFind            : "%s to Magic Find",
	Item.Group.SpellDamage          : "%s to Spell Damage",
	Item.Group.CollectionRange      : "%s to Collection Range",
	Item.Group.MeleeDamage          : "%s to Melee Damage",
	Item.Group.SoulHoT              : "%s to Soul Heal over Time",
	Item.Group.SoulDuration         : "%s to Soul Duration",
	Item.Group.IntermissionDuration : "%s to Intermission Duration",
	Item.Group.GeistAbility         : "%s to Howling Geist Ability",
	Item.Group.BileAbility          : "%s to Bubbling Bile Ability",
	Item.Group.BloodshardAbility    : "%s to Bloodshard Arrows Ability"
}

const DROP_CHANCES = {
	Constants.EnemyType.Knight: {
		Item.Type.Blue: 0.6,
		Item.Type.Green: 0.3,
		Item.Type.Red: 0.1
	}
}

var AFFIXES = {
	Item.Group.Fortitude:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.Fortitude, 0, "Plucky", "of a Tough Guy", Vector2(2, 5)),
			Item.Affix.new(Item.Group.Fortitude, 1, "Enduring", "of a Bruiser", Vector2(6, 15)),
			Item.Affix.new(Item.Group.Fortitude, 2, "Unstoppable", "of a Giant", Vector2(18, 45)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.Fortitude, 0, "Sickly", "of a Wimp", Vector2(-2, -5), true),
			Item.Affix.new(Item.Group.Fortitude, 1, "Frail", "of a Pushover", Vector2(-6, -15), true),
			Item.Affix.new(Item.Group.Fortitude, 2, "Feeble", "of a Weakling", Vector2(-18, -45), true),
		]
	},
	Item.Group.MovementSpeed:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.MovementSpeed, 0, "Fleet", "of a Health Nut", Vector2(0.05, 0.1)),
			Item.Affix.new(Item.Group.MovementSpeed, 1, "Swift", "of a Jock", Vector2(0.1, 0.2)),
			Item.Affix.new(Item.Group.MovementSpeed, 2, "Hasty", "of an Athlete", Vector2(0.2, 0.5)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.MovementSpeed, 0, "Lazy", "of a Dawdler", Vector2(-0.05, -0.1), true),
			Item.Affix.new(Item.Group.MovementSpeed, 1, "Lethargic", "of an Idler", Vector2(-0.1, -0.2), true),
			Item.Affix.new(Item.Group.MovementSpeed, 2, "Indolent", "of a Sluggard", Vector2(-0.2, -0.5), true),
		]
	},
	Item.Group.MagicFind:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.MagicFind, 0, "Fortunate", "of a Winner", Vector2(0.01, 0.02)),
			Item.Affix.new(Item.Group.MagicFind, 1, "Lucky", "of a Lucky Dog", Vector2(0.02, 0.03)),
			Item.Affix.new(Item.Group.MagicFind, 2, "Blessed", "of a Born Winner", Vector2(0.03, 0.04)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.MagicFind, 0, "Unfortunate", "of a Loser", Vector2(-0.01, -0.02), true),
			Item.Affix.new(Item.Group.MagicFind, 1, "Unlucky", "of an Unlucky Bastard", Vector2(-0.02, 0.03), true),
			Item.Affix.new(Item.Group.MagicFind, 2, "Cursed", "of a Born Loser", Vector2(-0.03, -0.04), true),
		]
	},
	Item.Group.SpellDamage:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.SpellDamage, 0, "Ley-touched", "of a Dabbler", Vector2(0.05, 0.1)),
			Item.Affix.new(Item.Group.SpellDamage, 1, "Magical", "of a Mage", Vector2(0.1, 0.2)),
			Item.Affix.new(Item.Group.SpellDamage, 2, "Arcane", "of a Wizard", Vector2(0.2, 0.5)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.SpellDamage, 0, "Ungifted", "of a Skeptic", Vector2(-0.05, -0.1), true),
			Item.Affix.new(Item.Group.SpellDamage, 1, "Leyless", "of a Cynic", Vector2(-0.1, -0.2), true),
			Item.Affix.new(Item.Group.SpellDamage, 2, "Cold-Iron", "of a Realist", Vector2(-0.2, -0.5), true),
		]
	},
	Item.Group.CollectionRange:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.CollectionRange, 0, "Greedy", "of a Cheapskate", Vector2(0.1, 0.2)),
			Item.Affix.new(Item.Group.CollectionRange, 1, "Voracious", "of a Hoarder", Vector2(0.2, 0.5)),
			Item.Affix.new(Item.Group.CollectionRange, 2, "Insatiable", "of a Miser", Vector2(0.5, 1.0)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.CollectionRange, 0, "Austere", "of a Cottager", Vector2(-0.1, -0.2), true),
			Item.Affix.new(Item.Group.CollectionRange, 1, "Spartan", "of a Hermit", Vector2(-0.2, -0.5), true),
			Item.Affix.new(Item.Group.CollectionRange, 2, "Ascetic", "of a Monk", Vector2(-0.5, -1.0), true),
		]
	},
	Item.Group.MeleeDamage:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.MeleeDamage, 0, "Strong", "of a Fighter", Vector2(5, 10)),
			Item.Affix.new(Item.Group.MeleeDamage, 1, "Powerful", "of a Soldier", Vector2(10, 20)),
			Item.Affix.new(Item.Group.MeleeDamage, 2, "Mighty", "of a Warrior", Vector2(20, 40)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.MeleeDamage, 0, "Timid", "of a Scaredycat", Vector2(-5, -10), true),
			Item.Affix.new(Item.Group.MeleeDamage, 1, "Cowardly", "of a Poltroon", Vector2(-10, -20), true),
			Item.Affix.new(Item.Group.MeleeDamage, 2, "Craven", "of a Chickenheart", Vector2(-20, -40), true),
		]
	},
	Item.Group.SoulHoT:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.SoulHoT, 0, "Healing", "of a Fast Healer", Vector2(1, 2)),
			Item.Affix.new(Item.Group.SoulHoT, 1, "Regenerating", "of a Mutant", Vector2(2, 3)),
			Item.Affix.new(Item.Group.SoulHoT, 2, "Resurrecting", "of an Immortal", Vector2(4, 5)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.SoulHoT, 0, "Poisoned", "of a Seoc", Vector2(-1, -2), true),
			Item.Affix.new(Item.Group.SoulHoT, 1, "Decaying", "of a Lunger", Vector2(-2, -3), true),
			Item.Affix.new(Item.Group.SoulHoT, 2, "Ephemeral", "of a Leper", Vector2(-4, -6), true),
		]
	},
	Item.Group.SoulDuration:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.SoulDuration, 0, "Thoughtful", "of a Window-Shopper", Vector2(1, 2)),
			Item.Affix.new(Item.Group.SoulDuration, 1, "Deliberate", "of a Trader", Vector2(3, 4)),
			Item.Affix.new(Item.Group.SoulDuration, 2, "Calculating", "of a Monger", Vector2(5, 6)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.SoulDuration, 0, "Negligent", "of an Airhead", Vector2(-1, -2), true),
			Item.Affix.new(Item.Group.SoulDuration, 1, "Carefree", "of a Ninny", Vector2(-2, -3), true),
			Item.Affix.new(Item.Group.SoulDuration, 2, "Reckless", "of a Dingbat", Vector2(-4, -6), true),
		]
	},
	Item.Group.IntermissionDuration:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.IntermissionDuration, 0, "Lingering", "of a Stroller", Vector2(1, 2)),
			Item.Affix.new(Item.Group.IntermissionDuration, 1, "Patient", "of a Stoic", Vector2(3, 4)),
			Item.Affix.new(Item.Group.IntermissionDuration, 2, "Zen", "of a Saint", Vector2(5, 6)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.IntermissionDuration, 0, "Hurried", "of a Fidgeter", Vector2(-1, -2), true),
			Item.Affix.new(Item.Group.IntermissionDuration, 1, "Impatient", "of an Eager Beaver", Vector2(-2, -3), true),
			Item.Affix.new(Item.Group.IntermissionDuration, 2, "Impetuous", "of a Maniac", Vector2(-4, -6), true),
		]
	},
	Item.Group.GeistAbility:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.GeistAbility, 0, "Spooky", "of a Medium", Vector2(0.1, 0.2)),
			Item.Affix.new(Item.Group.GeistAbility, 1, "Ghastly", "of a Conjurer", Vector2(0.2, 0.3)),
			Item.Affix.new(Item.Group.GeistAbility, 2, "Macabre", "of a Warlock", Vector2(0.3, 0.5)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.GeistAbility, 0, "Corny", "of a Phony", Vector2(-0.1, -0.2), true),
			Item.Affix.new(Item.Group.GeistAbility, 1, "Laughable", "of a Charlatan", Vector2(-0.2, -0.3), true),
			Item.Affix.new(Item.Group.GeistAbility, 2, "Pathetic", "of a Sham", Vector2(-0.3, -0.5), true),
		]
	},
	Item.Group.BileAbility:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.BileAbility, 0, "Sizzling", "of a Mixologist", Vector2(0.1, 0.2)),
			Item.Affix.new(Item.Group.BileAbility, 1, "Eroding", "of a Sage", Vector2(0.2, 0.3)),
			Item.Affix.new(Item.Group.BileAbility, 2, "Caustic", "of an Alchemist", Vector2(0.3, 0.5)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.BileAbility, 0, "Tidy", "of a Neatnik", Vector2(-0.1, -0.2), true),
			Item.Affix.new(Item.Group.BileAbility, 1, "Untarished", "of a Clean Freak", Vector2(-0.2, -0.3), true),
			Item.Affix.new(Item.Group.BileAbility, 2, "Spotless", "of a Germaphobe", Vector2(-0.3, -0.5), true),
		]
	},
	Item.Group.BloodshardAbility:
	{
		Item.Balance.Positive:
		[
			Item.Affix.new(Item.Group.BloodshardAbility, 0, "Dripping", "of a Killer", Vector2(0.1, 0.2)),
			Item.Affix.new(Item.Group.BloodshardAbility, 1, "Gushing", "of a Murderer", Vector2(0.2, 0.3)),
			Item.Affix.new(Item.Group.BloodshardAbility, 2, "Hemorraging", "of a Diablerist", Vector2(0.3, 0.5)),
		],
		Item.Balance.Negative:
		[
			Item.Affix.new(Item.Group.BloodshardAbility, 0, "Staunched", "of a Thinblood", Vector2(-0.1, -0.2), true),
			Item.Affix.new(Item.Group.BloodshardAbility, 1, "Cauterized", "of an Anemic", Vector2(-0.2, -0.3), true),
			Item.Affix.new(Item.Group.BloodshardAbility, 2, "Bloodless", "of a Goner", Vector2(-0.3, -0.5), true),
		]
	},
}

func generate_item_type(enemy_type: Constants.EnemyType) -> Item.Type:
	var roll = Utils.rng.randf()
	var cumulative = 0.0
	for item_type in DROP_CHANCES[enemy_type].keys():
		cumulative += DROP_CHANCES[enemy_type][item_type]
		if roll < cumulative:
			return item_type
	return Item.Type.Blue


func get_random_group(except_groups : Array[Item.Group] = []) -> Item.Group:
	var all_groups = Item.Group.keys()
	var except_groups_str = except_groups.map(func(g): return str(g))
	for except_group in except_groups_str:
		all_groups.erase(except_group)
	var chosen_group = all_groups[Utils.rng.randi_range(0, all_groups.size() - 1)]
	return Item.Group.get(chosen_group)

func get_random_affix(group: Item.Group, balance: Item.Balance, max_tier = -1) -> Item.Affix:
	var affixes = AFFIXES[group][balance]
	if max_tier >= 0:
		affixes = affixes.filter(func(affix):
			return affix.tier <= max_tier
		)
	return affixes[Utils.rng.randi_range(0, affixes.size() - 1)]

func generate_name(item: Item) -> String:
	var highest_affix : Item.Affix = null
	var second_highest_affix : Item.Affix = null
	for rolled_affix in item.rolled_affixes:
		if not highest_affix or rolled_affix.affix.tier > highest_affix.tier:
			second_highest_affix = highest_affix
			highest_affix = rolled_affix.affix
		elif not second_highest_affix or rolled_affix.affix.tier > second_highest_affix.tier:
			second_highest_affix = rolled_affix.affix

	var random_soul_name = SOUL_NAMES[item.item_type][Utils.rng.randi() % SOUL_NAMES[item.item_type].size()]
	var final_name = random_soul_name
	if highest_affix:
		if Utils.rng.randi() % 2 == 0:
			final_name = final_name + " " + highest_affix.suffix
		else:
			final_name = highest_affix.prefix + " " + final_name
	if second_highest_affix:
		if Utils.rng.randi() % 2 == 0:
			final_name = final_name + " " + second_highest_affix.suffix
		else:
			final_name = second_highest_affix.prefix + " " + final_name
	return final_name

func generate_blue_item() -> Item:
	var item = Item.new()
	item.item_type = Item.Type.Blue
	item.fortitude = Utils.rng.randi_range(BASE_FORTITUDE[Item.Type.Blue].x, BASE_FORTITUDE[Item.Type.Blue].y)
	var NUM_AFFIXES = Utils.rng.randi_range(1, 2)
	var already_rolled_groups: Array[Item.Group] = []
	for i in NUM_AFFIXES:
		var random_group = get_random_group(already_rolled_groups)
		var affix = get_random_affix(random_group, Item.Balance.Positive, 0)
		item.rolled_affixes.append(Item.RolledAffix.new(affix))
		already_rolled_groups.append(affix.group)
	item.item_name = generate_name(item)
	return item
	
func generate_green_item() -> Item:
	var item = Item.new()
	item.item_type = Item.Type.Green
	item.fortitude = Utils.rng.randi_range(BASE_FORTITUDE[Item.Type.Green].x, BASE_FORTITUDE[Item.Type.Green].y)
	var NUM_AFFIXES = Utils.rng.randi_range(1, 3)
	var already_rolled_groups: Array[Item.Group] = []
	for i in NUM_AFFIXES:
		var random_group = get_random_group(already_rolled_groups)
		var random_balance = Item.Balance.Positive if Utils.rng.randi() % 2 == 0 else Item.Balance.Negative
		var affix = get_random_affix(random_group, random_balance, 2)
		item.rolled_affixes.append(Item.RolledAffix.new(affix))
		already_rolled_groups.append(affix.group)
	item.item_name = generate_name(item)
	return item

func generate_red_item() -> Item:
	## At least 1 negative to 2 positive
	return

func generate_item(item_type: Item.Type) -> Item:
	match item_type:
		Item.Type.Blue:
			return generate_blue_item()
		Item.Type.Green:
			return generate_green_item()
		Item.Type.Red:
			return generate_red_item()
	return null
