extends Node

const VOLUME_MIN: float = -80 # Minimum volume in dB
const VOLUME_DEFAULT: float = 1.0 # Default volume in linear scale

const CROSSFADE_VOLUME_MIN: float = -50
const CROSSFADE_TIME: float = 0.5
const BATTLE_CROSSFADE_TIME = 5

const MUSIC_BUS_NAME: String = "Music"

@onready var MUSIC_BUS: int = AudioServer.get_bus_index(MUSIC_BUS_NAME)
var timer : Timer = null

signal switched_track()

## Tracks
enum Track {
    BattleIntro,
    BattleTransition1,
    BattleTransition2,
    BattleTransition3,
    BattleTransition4,
    Battle1,
    Battle2,
    Battle3,
    Battle4,
    Battle5,
    Battle6,
    Battle7,
    Menu,
    MenuBass
}

const MUSIC_TRACKS = {
    Track.BattleIntro: preload("res://audio/music/kolekta_intro.mp3"),
    Track.BattleTransition1: preload("res://audio/music/kolekta_transition_1.mp3"),
    Track.BattleTransition2: preload("res://audio/music/kolekta_transition_2.mp3"),
    Track.BattleTransition3: preload("res://audio/music/kolekta_transition_3.mp3"),
    Track.BattleTransition4: preload("res://audio/music/kolekta_transition_4.mp3"),
    Track.Battle1: preload("res://audio/music/kolekta_battle_1.mp3"),
    Track.Battle2: preload("res://audio/music/kolekta_battle_2.mp3"),
    Track.Battle3: preload("res://audio/music/kolekta_battle_3.mp3"),
    Track.Battle4: preload("res://audio/music/kolekta_battle_4.mp3"),
    Track.Battle5: preload("res://audio/music/kolekta_battle_5.mp3"),
    Track.Battle6: preload("res://audio/music/kolekta_battle_6.mp3"),
    Track.Battle7: preload("res://audio/music/kolekta_battle_7.mp3"),
    Track.Menu: preload("res://audio/music/kolekta_menu.mp3"),
    Track.MenuBass: preload("res://audio/music/kolekta_menu_bass.mp3"),
}


var audio_stream_player: AudioStreamPlayer = null
var last_loop_callable: Callable = Callable()

# Called when the node enters the scene tree for the first time.
func _ready():
    self.audio_stream_player = AudioStreamPlayer.new()
    self.audio_stream_player.bus = MUSIC_BUS_NAME
    self.add_child(self.audio_stream_player)
    self.process_mode = Node.PROCESS_MODE_ALWAYS

func set_volume(volume: float):
    # Set the volume of the audio stream player
    self.audio_stream_player.set_volume_linear(volume)

func play_track(
    track: Track,
    loop = false,
    crossfade = true,
    volume = VOLUME_DEFAULT,
    crossfade_time = CROSSFADE_TIME,
    crossfade_out_time = CROSSFADE_TIME
):	
    if crossfade and self.audio_stream_player.stream != null:
        var tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
        tween.tween_property(self.audio_stream_player, "volume_db", CROSSFADE_VOLUME_MIN, crossfade_time)
        tween.tween_callback(_play.bind(track))
        tween.tween_property(self.audio_stream_player, "volume_db", db_to_linear(volume), crossfade_time)
    else:
        self.set_volume(volume)
        _play(track)
            
    if loop:
        last_loop_callable = play_track.bind(track, loop, crossfade, volume, crossfade_time)
        self.audio_stream_player.finished.connect(last_loop_callable, ConnectFlags.CONNECT_ONE_SHOT)
    elif not last_loop_callable.is_null() and self.audio_stream_player.finished.is_connected(last_loop_callable):
        self.audio_stream_player.finished.disconnect(last_loop_callable)

func queue_next_track(new_track, crossfade: bool = true, crossfade_length = CROSSFADE_TIME):
    var current_track_length = self.audio_stream_player.stream.get_length()
    if timer:
        timer.stop()
        timer.queue_free()
    timer = Timer.new()
    timer.wait_time = current_track_length - crossfade_length
    Log.info("Queuing next track in %.2f seconds" % timer.wait_time)
    timer.one_shot = true
    timer.timeout.connect(func ():
        Log.info("Timer finished, queuing next track: %s" % Track.keys()[new_track])
        play_track(new_track, false, crossfade, VOLUME_DEFAULT, crossfade_length)
        self.switched_track.emit()
    )
    timer.autostart = true
    self.add_child(timer)

func remove_queued_track():
    if timer:
        timer.stop()
        timer.queue_free()
        timer = null

func _play(track: Track):
    Log.info("Playing track: %s" % Track.keys()[track])
    self.audio_stream_player.stream = MUSIC_TRACKS[track]
    self.audio_stream_player.play()

func stop():
    self.audio_stream_player.stop()
    if timer:
        timer.stop()
        timer.queue_free()
        timer = null

func get_random_battle_track() -> Track:
    var battle_tracks = [
        Track.Battle1,
        Track.Battle2,
        Track.Battle3,
        Track.Battle4,
        Track.Battle5,
    ]
    return battle_tracks[randi() % battle_tracks.size()]

func get_random_transition_track() -> Track:
    var transition_tracks = [
        Track.BattleTransition1,
        Track.BattleTransition2,
    ]
    return transition_tracks[randi() % transition_tracks.size()]
