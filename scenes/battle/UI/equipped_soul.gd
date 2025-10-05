extends TextureRect
class_name EquippedSoul

var item : Item = null
var current_fortitude : int = 0
var max_fortitude : int = 0

signal broke(soul : EquippedSoul)

@onready var progress_bar : ProgressBar = $ProgressBar
@onready var item_name_label : Label = %ItemNameLabel

func _ready() -> void:
    if item:
        set_item(item)

func set_item(new_item : Item) -> void:
    item = new_item
    item_name_label.text = item.item_name
    max_fortitude = item.calculate_total_fortitude()
    current_fortitude = max_fortitude
    progress_bar.value = 100

func get_hit(damage : int) -> void:
    if item:
        current_fortitude = max(current_fortitude - damage, 0)
        progress_bar.value = float(current_fortitude) / float(max_fortitude) * 100.0
        if current_fortitude <= 0:
            self.broke.emit(self)
