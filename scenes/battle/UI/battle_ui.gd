extends CanvasLayer

signal next_wave

enum State {
    NONE,
    IN_WAVE,
    MENU
}

var state: State = State.NONE
var target_time : float = 9999
var current_time : float = 9999
var elapsed_time : float = 0.0
var in_intermission: bool = false
var launched_transition: bool = false

@onready var wave_label: Label = %WaveLabel
@onready var wave_ui : Control = %WaveUI
@onready var wave_timer: Label = %WaveTimer
@onready var menu_container: Control = %MenuContainer

func _ready() -> void:
    self.set_state(State.NONE)

func _process(delta: float) -> void:
    current_time -= delta
    if not in_intermission:
        if current_time < Music.BATTLE_CROSSFADE_TIME and not launched_transition:
            current_time = 0.0
            launched_transition = true
            var random_transition_track = Music.get_random_transition_track()
            Music.remove_queued_track()
            Music.play_track(random_transition_track, false, true, Music.VOLUME_DEFAULT, Music.BATTLE_CROSSFADE_TIME)
    set_display_timer(current_time)

func set_display_timer(dur: float) -> void:
    wave_timer.text = "%d" % int(dur)

func set_wave(number: int, duration: float) -> void:
    wave_label.text = "Wave %d" % number
    target_time = duration
    current_time = duration
    elapsed_time = 0.0
    self.in_intermission = false
    self.launched_transition = false
    self.set_state(State.IN_WAVE)

func set_intermission(intermission_length: float) -> void:
    wave_label.text = "Intermission"
    target_time = intermission_length
    current_time = intermission_length
    self.in_intermission = true
    self.launched_transition = false
    elapsed_time = 0.0

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
