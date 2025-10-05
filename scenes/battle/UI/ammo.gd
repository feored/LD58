extends HBoxContainer

const skull_icon = preload("res://scenes/battle/UI/skull_icon.tscn")
var skulls : Array[TextureRect] = []

@export var inventory : Inventory


func _ready():
    inventory.updated.connect(_on_inventory_updated)
    _on_inventory_updated()

func _on_inventory_updated():
    var item_count = inventory.items.size()
    if skulls.size() < item_count:
        for i in range(item_count - skulls.size()):
            var new_skull = skull_icon.instantiate()
            add_child(new_skull)
            skulls.append(new_skull)
    elif skulls.size() > item_count:
        for i in range(skulls.size() - item_count):
            var skull_to_remove = skulls.pop_back()
            remove_child(skull_to_remove)
            skull_to_remove.queue_free()
    for i in range(item_count):
        var item = inventory.items[i]
        match item.item_type:
            Item.Type.Red:
                skulls[i].self_modulate = Color(1, 0.19, 0.19, 1)
            Item.Type.Blue:
                skulls[i].self_modulate = Color(0.19, 0.39, 1, 1)
            Item.Type.Green:
                skulls[i].self_modulate = Color(0.19, 1, 0.39, 1)
