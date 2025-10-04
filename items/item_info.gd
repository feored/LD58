extends Node

const SOUL_NAMES = {
    Item.Type.Blue: ["Common Soul", "Soul", "Blue Soul", "Rough Soul"],
    Item.Type.Green: ["Uncommon Soul", "Lesser Soul", "Green Soul", "Fine Soul"],
    Item.Type.Red: ["Rare Soul", "Greater Soul", "Red Soul", "Exquisite Soul"]
}

const BASE_FORTITUDE = {
    Item.Type.Blue: Vector2(1, 5), Item.Type.Green: Vector2(6, 20), Item.Type.Red: Vector2(16, 40)
}

var AFFIXES = {
    Item.Group.Fortitude:
    {
        Item.Balance.Positive:
        [
            Item.Affix.new(Item.Group.Fortitude, 0, "Sturdy", "Of the Sturdy", Vector2(1, 5)),
            Item.Affix.new(Item.Group.Fortitude, 1, "Hulking", "Of the Hulking", Vector2(6, 15)),
            Item.Affix.new(Item.Group.Fortitude, 2, "Titanic", "Of the Titanic", Vector2(16, 40)),
        ],
        Item.Balance.Negative:
        [
            Item.Affix.new(Item.Group.Fortitude, 0, "Weak-Kneed", "Of the Weak-Kneed", Vector2(-5, -1), true),
            Item.Affix.new(Item.Group.Fortitude, 1, "Weakling's", "Of the Weakling", Vector2(-15, -6), true),
            Item.Affix.new(Item.Group.Fortitude, 2, "Decrepit", "Of Decrepitude", Vector2(-40, -16), true),
        ]
    },
    Item.Group.MovementSpeed:
    {
        Item.Balance.Positive:
        [
            Item.Affix.new(Item.Group.MovementSpeed, 0, "Swift", "Of Swiftness", Vector2(1, 5)),
            Item.Affix.new(Item.Group.MovementSpeed, 1, "Fleet", "Of Fleetness", Vector2(6, 15)),
            Item.Affix.new(Item.Group.MovementSpeed, 2, "Lightning", "Of Lightning", Vector2(16, 40)),
        ],
        Item.Balance.Negative:
        [
            Item.Affix.new(Item.Group.MovementSpeed, 0, "Leisurely", "Of Leisureness", Vector2(-5, -1), true),
            Item.Affix.new(Item.Group.MovementSpeed, 1, "Slow", "Of Slowness", Vector2(-15, -6), true),
            Item.Affix.new(Item.Group.MovementSpeed, 2, "Sluggish", "Of Sluggishness", Vector2(-40, -16), true),
        ]
    },
    Item.Group.SpellSpeed:
    {
        Item.Balance.Positive:
        [
            Item.Affix.new(Item.Group.SpellSpeed, 0, "Quick", "Of Quickness", Vector2(1, 5)),
            Item.Affix.new(Item.Group.SpellSpeed, 1, "Rapid", "Of Rapidity", Vector2(6, 15)),
            Item.Affix.new(Item.Group.SpellSpeed, 2, "Hasty", "Of Hastiness", Vector2(16, 40)),
        ],
        Item.Balance.Negative:
        [
            Item.Affix.new(Item.Group.SpellSpeed, 0, "Lingering", "Of Lingering", Vector2(-5, -1), true),
            Item.Affix.new(Item.Group.SpellSpeed, 1, "Lethargic", "Of Lethargy", Vector2(-15, -6), true),
            Item.Affix.new(Item.Group.SpellSpeed, 2, "Dilatory", "Of Dilatoriness", Vector2(-40, -16), true),
        ]
    },
    Item.Group.SpellDamage:
    {
        Item.Balance.Positive:
        [
            Item.Affix.new(Item.Group.SpellDamage, 0, "Potent", "Of Potency", Vector2(1, 5)),
            Item.Affix.new(Item.Group.SpellDamage, 1, "Mighty", "Of Might", Vector2(6, 15)),
            Item.Affix.new(Item.Group.SpellDamage, 2, "Powerful", "Of Power", Vector2(16, 40)),
        ],
        Item.Balance.Negative:
        [
            Item.Affix.new(Item.Group.SpellDamage, 0, "Feeble", "Of Feebleness", Vector2(-5, -1), true),
            Item.Affix.new(Item.Group.SpellDamage, 1, "Puny", "Of Punyness", Vector2(-15, -6), true),
            Item.Affix.new(Item.Group.SpellDamage, 2, "Infirm", "Of Infirmity", Vector2(-40, -16), true),
        ]
    }
}

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
        var affix = get_random_affix(random_group, Item.Balance.Positive, 1)
        item.rolled_affixes.append(Item.RolledAffix.new(affix))
        already_rolled_groups.append(affix.group)
    item.item_name = generate_name(item)
    return item
    
