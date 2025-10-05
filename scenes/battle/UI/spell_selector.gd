extends PanelContainer

@onready var spell_label: Label = %SpellLabel
@onready var spell_texture: TextureRect = %SpellTexture
var tween: Tween = null


func _ready() -> void:
    set_spell(Character.Spell.HowlingGeist)

func set_spell(spell: Character.Spell) -> void:
    if spell_label == null or spell_texture == null:
        return
    match spell:
        Character.Spell.HowlingGeist:
            spell_label.text = "Howling Geist"
            spell_texture.modulate = Color(0.2, 0.2, 1, 1)
        Character.Spell.BubblingBile:
            spell_label.text = "Bubbling Bile"
            spell_texture.modulate = Color(0.2, 1, 0.2, 1)
        Character.Spell.BloodshardArrows:
            spell_label.text = "Bloodshard Arrows"
            spell_texture.modulate = Color(1, 0.2, 0.2, 1)

func _on_character_spell_changed(new_spell: Character.Spell) -> void:
    set_spell(new_spell)

func no_ammo() -> void:
    if self.tween:
        self.tween.kill()
    self.tween = self.create_tween().set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EaseType.EASE_IN_OUT)
    tween.tween_property(self, "modulate", Color(1, 0.2, 0.2, 1), 0.1)
    tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_character_spell_no_ammo() -> void:
    no_ammo()
