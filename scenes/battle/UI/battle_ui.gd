extends CanvasLayer

signal next_wave

enum State {
    NONE,
    IN_WAVE,
    MENU
}

var state: State = State.NONE

@onready var wave_label: Label = %WaveLabel
@onready var wave_ui : Control = %WaveUI
@onready var menu_container: Control = %MenuContainer

func _ready() -> void:
    self.set_state(State.NONE)

func set_wave(number: int) -> void:
    wave_label.text = "Wave %d" % number
    self.set_state(State.IN_WAVE)

func set_intermission() -> void:
    wave_label.text = "Intermission"

func set_state(new_state: State) -> void:
    state = new_state
    match state:
        State.IN_WAVE:
            menu_container.visible = false
            wave_ui.visible = true
        State.MENU:
            menu_container.visible = true
            wave_ui.visible = false
        State.NONE:
            menu_container.visible = false
            wave_ui.visible = false

func _on_button_pressed() -> void:
    Log.info("Menu button pressed")


func _on_next_wave_button_pressed() -> void:
    self.set_state(State.IN_WAVE)
    next_wave.emit()
    get_tree().paused = false
