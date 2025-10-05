extends Control

const soul_item_scene = preload("res://scenes/battle/UI/soul_item.tscn")

@export var inventory : Inventory
@export var equipped_souls : EquippedSouls

@onready var blue_soul_container = %BlueSoulContainer
@onready var green_soul_container = %GreenSoulContainer
@onready var red_soul_container = %RedSoulContainer

func _ready():
    inventory.updated.connect(_on_inventory_updated)
    _on_inventory_updated()
    self.visible = false

func _unhandled_input(event):
    if event.is_action_pressed("soul_lantern"):
        self.visible = true
    elif event.is_action_released("soul_lantern"):
        self.visible = false

func clear_souls():
    for soul_item in blue_soul_container.get_children():
        soul_item.queue_free()
    for soul_item in green_soul_container.get_children():
        soul_item.queue_free()
    for soul_item in red_soul_container.get_children():
        soul_item.queue_free()

func _on_inventory_updated():
    clear_souls()
    var item_count = inventory.items.size()
    for i in range(item_count):
        var soul_item_instance = soul_item_scene.instantiate()
        soul_item_instance.equipped.connect(func(item):
            if not equipped_souls.can_equip():
                return
            equipped_souls.equip_soul(item)
            inventory.remove_item(item)
        )
        soul_item_instance.item = inventory.items[i]
        match inventory.items[i].item_type:
            Item.Type.Blue:
                blue_soul_container.add_child(soul_item_instance)
            Item.Type.Green:
                green_soul_container.add_child(soul_item_instance)
            Item.Type.Red:
                red_soul_container.add_child(soul_item_instance)
    var blue_count = inventory.count_items_of_type(Item.Type.Blue)
    var green_count = inventory.count_items_of_type(Item.Type.Green)
    var red_count = inventory.count_items_of_type(Item.Type.Red)
