extends HBoxContainer

const skull_icon = preload("res://scenes/battle/UI/skull_icon.tscn")
var skulls : Array[TextureRect] = []

@export var inventory : Inventory


func _ready():
    inventory.updated.connect(_on_inventory_updated)
    _on_inventory_updated()

func clear_skulls():
    for skull in skulls:
        skull.queue_free()
    skulls.clear()

func _on_inventory_updated():
    var item_count = inventory.items.size()
    clear_skulls()
    for i in range(item_count):
        var skull_instance = skull_icon.instantiate() as TextureRect
        add_child(skull_instance)
        skulls.append(skull_instance)
    var blue_count = inventory.count_items_of_type(Item.Type.Blue)
    var green_count = inventory.count_items_of_type(Item.Type.Green)
    var red_count = inventory.count_items_of_type(Item.Type.Red)
    for i in range(blue_count):
        skulls[i].modulate = Color(0.2, 0.2, 1.0)
    for i in range(blue_count, blue_count + green_count):
        skulls[i].modulate = Color(0.2, 1.0, 0.2)
    for i in range(blue_count + green_count, item_count):
        skulls[i].modulate = Color(1.0, 0.2, 0.2)
