extends Control
class_name SoulItem

var item

@onready var skull_texture: TextureRect = %SkullTexture
@onready var item_view: ItemView = %ItemView

func _ready() -> void:
    if item:
        self.set_item(item)

func set_item(new_item) -> void:
    item = new_item
    skull_texture.modulate = ItemInfo.ITEM_TYPE_COLOR[item.item_type]
    item_view.set_item(item)


func _process(delta: float) -> void:
    if item_view.visible:
        var mpos = get_viewport().get_mouse_position()
        Log.info(mpos)
        item_view.global_position = mpos + Vector2(16, 16)


func _on_mouse_entered() -> void:
    item_view.visible = true

func _on_mouse_exited() -> void:
    item_view.visible = false
