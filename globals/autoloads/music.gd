extends Node

const VOLUME_MIN: float = -80 # Minimum volume in dB
const VOLUME_DEFAULT: float = 1.0 # Default volume in linear scale

const CROSSFADE_VOLUME_MIN: float = -50
const CROSSFADE_TIME: float = 0.5

const MUSIC_BUS_NAME: String = "Music"

@onready var MUSIC_BUS: int = AudioServer.get_bus_index(MUSIC_BUS_NAME)

## Tracks
enum Track {
    Battle1,
    Battle2,
    Battle3,
}#Untitled } # Add more tracks here

const MUSIC_TRACKS = {
    Track.Battle1: preload("res://audio/music/kolekta_battle.wav"),
    Track.Battle2: preload("res://audio/music/kolekta_battle_2.wav"),
    Track.Battle3: preload("res://audio/music/kolekta_battle_3.wav"),
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
    crossfade_time = CROSSFADE_TIME
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


func _play(track: Track):
    Log.info("Playing track: %s" % Track.keys()[track])
    self.audio_stream_player.stream = MUSIC_TRACKS[track]
    self.audio_stream_player.play()
