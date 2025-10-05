extends Control
class_name SoulItem

signal equipped(item: Item)
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
        item_view.global_position = mpos + Vector2(16, 16)

func _on_mouse_entered() -> void:
    item_view.visible = true

func _on_mouse_exited() -> void:
    item_view.visible = false

func _on_gui_input(event: InputEvent) -> void:
    if not item_view.visible:
        return
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            self.equipped.emit(item)
