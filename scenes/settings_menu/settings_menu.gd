extends CanvasLayer

@onready var full_screen_button: Button = %FullScreenButton
@onready var master_volume_slider: HSlider = %MasterVolumeSlider
@onready var music_volume_slider: HSlider = %MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = %SFXVolumeSlider
@onready var resolution_dropdown: OptionButton = %ResolutionDropdown

# Called when the node enters the scene tree for the first time.
func _ready():
    full_screen_button.button_pressed = Settings.get_setting(Settings.Setting.FullScreen)
    master_volume_slider.value = Settings.get_setting(Settings.Setting.MasterVolume)
    music_volume_slider.value = Settings.get_setting(Settings.Setting.MusicVolume)
    sfx_volume_slider.value = Settings.get_setting(Settings.Setting.SfxVolume)
    for resolution in Settings.DEFAULT_WINDOW_RESOLUTIONS:
        resolution_dropdown.add_item(resolution)
    if Settings.DEFAULT_WINDOW_RESOLUTIONS.values().has(Settings.get_setting(Settings.Setting.WindowResolution)):
        # Select the resolution that matches the current setting
        # This is necessary because the resolution might not be in the dropdown if it was added later
        # or if the user has a custom resolution.
        resolution_dropdown.select(Settings.DEFAULT_WINDOW_RESOLUTIONS.values().find(Settings.get_setting(Settings.Setting.WindowResolution)))


func _on_full_screen_button_toggled(button_pressed:bool):
    Settings.set_setting(Settings.Setting.FullScreen, button_pressed)
    Settings.apply_fullscreen()

func _on_resolution_dropdown_item_selected(index:int):
    Settings.set_setting(Settings.Setting.WindowResolution, Settings.DEFAULT_WINDOW_RESOLUTIONS.values()[index])
    Settings.apply_window_resolution()

func _on_sfx_volume_slider_value_changed(value:float):
    Settings.set_setting(Settings.Setting.SfxVolume, value)
    Settings.apply_volume_sfx()

func _on_music_volume_slider_value_changed(value:float):
    Settings.set_setting(Settings.Setting.MusicVolume, value)
    Settings.apply_volume_music()

func _on_master_volume_slider_value_changed(value:float):
    Settings.set_setting(Settings.Setting.MasterVolume, value)
    Settings.apply_volume_master()


func _on_settings_return_button_pressed():
    SceneTransition.pop_scene()
