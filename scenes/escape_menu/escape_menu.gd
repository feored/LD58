extends CanvasLayer

enum State {Esc, Settings}

@onready var esc_menu = $"%EscMenu"
@onready var esc_panel = %EscPanel

var is_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    self.esc_panel.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass

func _on_menu_button_pressed():
    self.disappear()
    SceneTransition.change_scene(SceneTransition.Scene.MainMenu)

func _on_resume_button_pressed():
    self.disappear()

func appear():
    if is_active or self.esc_panel.visible or SceneTransition.is_scene_alive(SceneTransition.Scene.MainMenu):
        return
    is_active = true
    self.get_tree().paused = true
    self.esc_panel.show()

func disappear():
    is_active = false
    self.get_tree().paused = false
    self.esc_panel.hide()

func _unhandled_input(event):
    if event.is_action_pressed("escape"):
        if self.esc_panel.visible:
            self.disappear()
        else:
            self.appear()

func _on_settings_button_pressed():
    #self.disappear()
    SceneTransition.push_scene(SceneTransition.Scene.SettingsMenu)
    

func _on_esc_button_pressed():
    self.appear()
