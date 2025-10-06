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
@onready var intermission_tip_label: Label = %IntermissionTip

func _ready() -> void:
    self.set_state(State.NONE)

func _process(delta: float) -> void:
    current_time -= delta
    if not in_intermission:
        if current_time < Music.BATTLE_CROSSFADE_TIME and not launched_transition:
            launched_transition = true
            var random_transition_track = Music.get_random_transition_track()
            Music.remove_queued_track()
            Music.play_track(random_transition_track, false, true, Music.VOLUME_DEFAULT, Music.BATTLE_CROSSFADE_TIME, 0.2)
    set_display_timer(current_time)

func set_display_timer(dur: float) -> void:
    wave_timer.text = "%d" % int(dur)

func set_wave(number: int, duration: float) -> void:
    wave_label.text = "Wave %d" % number
    target_time = duration
    current_time = duration
    elapsed_time = 0.0
    intermission_tip_label.visible = false
    self.in_intermission = false
    self.launched_transition = false
    self.set_state(State.IN_WAVE)

func set_intermission(intermission_length: float) -> void:
    wave_label.text = "Intermission"
    intermission_tip_label.visible = true
    intermission_tip_label.text = "Tip: %s" % get_random_tip()
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

const INTERMISSION_TIPS = [
    "Be careful when absorbing souls! The penalties you get from some souls might outweigh the benefits of their increased Fortitude",
    "GTMF! Mages can become a huge problem if left to their own devices. Bubbling Bile and Bloodfire Wave are effective at hitting them behind ranks of knights… but an expertly guided Howling Geist can work just as well",
    "Red Souls offer powerful bonuses but always come with a steep cost. Make sure you’re willing to pay it before absorbing one?",
    "Blue Souls aren’t particularly powerful but never have any negative effects.",
    "Green Souls offer moderate bonuses, but might also come with negative effects, so make sure to check before absorbing them!",
    "Souls vanish quickly once they’ve dropped to the ground. Make sure you’re close to your foes to collect their delicious life essence.",
    "You can only carry a total of 15 souls at a time. Make room for more by casting spells.",
    "Souls of all colors can rarely drop with super-powerful bonuses. Listen for their unique drop sound and shiny appearance!",
    "The staff bonk is highly effective but risky. Even if you deal some good damage, you always take some damage from using it.",
    "It’s worth it to save your Green and Red Souls for eliminating high concentrations of Mages.",
    "You can check the current effects of absorbed souls by mousing over them in the Soul Queue.",
    "Souls take time to be collected. Don’t move too fast when trying to do so or you’ll outrun them!",
    "Quickly judging whether you should absorb a Soul or use it to cast a spell is key to surviving later waves.",
    "Don’t get swarmed! Keep moving and don’t let those pesky knights catch you unawares.",
    "In a pinch, Blue Souls are always safe to absorb to regain Fortitude quickly without risking negative effects.",
    "Not all enemies are created equal! Enemies have variable speeds, health pools, and damage.",
    "Souls are everything! Collect, collect, COLLECT!",
    "Equipping certain combinations of Souls might result in disastrous or unexpected effects, like inverting your movement controls or disabling your ability to collect sous. Take care to manage negative effects or you may ruin your run!"
]

func get_random_tip() -> String:
    return INTERMISSION_TIPS[Utils.rng.randi_range(0, INTERMISSION_TIPS.size() - 1)]