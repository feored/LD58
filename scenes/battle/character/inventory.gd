extends Node3D
class_name Inventory

signal updated

const MAX_TOTAL_SOULS: int = 15
var items: Array[Item] = []

func add_item(item: Item) -> void:
    Log.info(item)
    items.append(item)
    emit_signal("updated")

func count_items_of_type(item_type: Item.Type) -> int:
    var count = 0
    for item in items:
        if item.item_type == item_type:
            count += 1
    return count

func use_last_item_of_type(item_type: Item.Type) -> void:
    for i in range(items.size()):
        if items[i].item_type == item_type:
            items.remove_at(i)
            emit_signal("updated")
            return

func remove_item(item: Item) -> void:
    items.erase(item)
    emit_signal("updated")