extends Control
class_name ItemView

@onready var name_label: Label = %NameLabel
@onready var fortitude_label: Label = %FortitudeLabel
@onready var soul_color_label: Label = %SoulColorLabel
@onready var affix_container: VBoxContainer = %AffixContainer

var item: Item = null

func _ready() -> void:
    if item:
        self.set_item(self.item)

func set_item(item: Item) -> void:
    self.item = item
    name_label.text = item.item_name
    match item.item_type:
        Item.Type.Blue:
            soul_color_label.text = "Blue Soul"
            soul_color_label.add_theme_color_override("font_color", Color(0.2, 0.2, 1, 1))
        Item.Type.Green:
            soul_color_label.text = "Green Soul"
            soul_color_label.add_theme_color_override("font_color", Color(0.2, 1, 0.2, 1))
        Item.Type.Red:
            soul_color_label.text = "Red Soul"
            soul_color_label.add_theme_color_override("font_color", Color(1, 0.2, 0.2, 1))
    fortitude_label.text = "Base Fortitude: %d" % item.fortitude
    for child in affix_container.get_children():
        affix_container.remove_child(child)
        child.queue_free()
    for affix in item.rolled_affixes:
        var affix_label = Label.new()
        affix_label.add_theme_font_size_override("font_size", 12)
        affix_label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
        var sign = ""
        if affix.value > 0:
            sign = "+"
        else:
            affix_label.add_theme_color_override("font_color", Color(1, 0.2, 0.2, 1))
        var value_display = ItemInfo.GROUP_STEP_DISPLAY[affix.affix.group] % affix.value
        var final_value = "%s%s" % [sign, value_display]
        affix_label.text = ItemInfo.GROUP_DISPLAY_TEXT[affix.affix.group] % final_value
        # var affix_val_str = "%affix.value
                
        affix_container.add_child(affix_label)
