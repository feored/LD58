extends Node

const LOWEST_VOLUME = -80
const DEFAULT_VOLUME = 0

enum MultiTrack {
    SoulExpire
}

enum Track {
    Confirm,
    Hover,
    Cancel,
    SoulExpire1,
    SoulExpire2,
    SoulExpire3,
}
enum Ambience { CalmWind }

const MULTITRACKS = {
    MultiTrack.SoulExpire: [Track.SoulExpire1, Track.SoulExpire2, Track.SoulExpire3],
}

const TRACKS = {
    Track.Confirm: preload("res://audio/sfx/UI/UI_Confirm.wav"),
    Track.Hover: preload("res://audio/sfx/UI/UI_Hover.wav"),
    Track.Cancel: preload("res://audio/sfx/UI/UI_Cancel.wav"),
    Track.SoulExpire1: preload("res://audio/sfx/Souls/Soul_Expire.wav"),
    Track.SoulExpire2: preload("res://audio/sfx/Souls/Soul_Expire_2.wav"),
    Track.SoulExpire3: preload("res://audio/sfx/Souls/Soul_Expire_3.wav"),
}

const AMBIENCE_TRACKS = {} #Ambience.CalmWind: preload("res://audio/ambience/wind_calm.wav")}

const RANDOM_PITCH_SCALE = {
    # Track.Move: [0.75, 1.25],
    # Track.Sink: [0.9, 1.1],
}

const CUSTOM_VOLUME = {
    Track.Confirm: -15,
    Track.SoulExpire1: -10,
    Track.SoulExpire2: -10,
    Track.SoulExpire3: -10,
}

const CUSTOM_AMBIENCE_VOLUME = {Ambience.CalmWind: -45}

const CUSTOM_POLYPHONY = {}#Track.Sink: 1}

var players = {}
var ambience_players = {}


# Called when the node enters the scene tree for the first time.
func _ready():
    connect_buttons(get_tree().root)
    get_tree().connect("node_added", _on_SceneTree_node_added)
    for key in TRACKS:
        var player = AudioStreamPlayer3D.new()
        player.stream = TRACKS[key]
        player.max_polyphony = 10  if key not in CUSTOM_POLYPHONY else CUSTOM_POLYPHONY[key]
        player.bus = "SFX"
        if key in CUSTOM_VOLUME:
            player.volume_db = CUSTOM_VOLUME[key]
        self.add_child(player)
        self.players[key] = player
    for key in AMBIENCE_TRACKS:
        var player = AudioStreamPlayer.new()
        player.stream = AMBIENCE_TRACKS[key]
        player.bus = "Ambience"
        if key in CUSTOM_AMBIENCE_VOLUME:
            player.volume_db = CUSTOM_AMBIENCE_VOLUME[key]
        self.add_child(player)
        self.ambience_players[key] = player


func play_ambience(ambience: Ambience):
    self.ambience_players[ambience].play()


func play(track: Track, position: Vector3 = Vector3.ZERO):
    if track in RANDOM_PITCH_SCALE:
        self.players[track].pitch_scale = randf_range(RANDOM_PITCH_SCALE[track][0], RANDOM_PITCH_SCALE[track][1])
    self.players[track].global_transform.origin = position
    self.players[track].play()

func play_multitrack(multi_track: MultiTrack, position: Vector3 = Vector3.ZERO):
    var tracks = MULTITRACKS[multi_track]
    var track = tracks[randi() % tracks.size()]
    self.play(track, position)


func disable_track(track: Track):
    self.players[track].volume_db = LOWEST_VOLUME

func enable_track(track: Track):
    self.players[track].volume_db = DEFAULT_VOLUME if track not in CUSTOM_VOLUME else CUSTOM_VOLUME[track]


func _on_SceneTree_node_added(node):
    if node is Button:
        connect_to_button(node)


func _on_Button_pressed():
    self.play(Track.Confirm)


func on_Button_hovered():
    self.play(Track.Hover)


# recursively connect all buttons
func connect_buttons(root):
    for child in root.get_children():
        if child is BaseButton:
            connect_to_button(child)
        connect_buttons(child)


func connect_to_button(button):
    if not button.pressed.is_connected(_on_Button_pressed):
        button.pressed.connect(_on_Button_pressed)
    if not button.mouse_entered.is_connected(on_Button_hovered):
        button.connect("mouse_entered", on_Button_hovered)

func stop_all():
    for key in self.players:
        self.players[key].stop()
    for key in self.ambience_players:
        self.ambience_players[key].stop()
