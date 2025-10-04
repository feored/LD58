extends Node3D

@export var movement_speed: float = 5.0
var time_elapsed: float = 0.0


func _physics_process(delta: float) -> void:
    time_elapsed += delta
    var initial_position = self.global_position
    if Input.is_action_pressed("left"):
        self.global_position += (Vector3.LEFT * delta * movement_speed)
    elif Input.is_action_pressed("right"):
        self.global_position += (Vector3.RIGHT * delta * movement_speed)
    if Input.is_action_pressed("up"):
        self.global_position += (Vector3.FORWARD * delta * movement_speed)
    elif Input.is_action_pressed("down"):
        self.global_position += (Vector3.BACK  * delta * movement_speed)
    var mouse_pos = Utils.get_mouse_pos(get_viewport().get_camera_3d())
    # Log.info("Mouse pos: %s" % str(mouse_pos))
    # Log.info("Character pos: %s" % str(self.global_position))
    # Log.info("Movement : %s" % str(self.global_position - initial_position))
    self.look_at(Vector3(mouse_pos.x, self.global_position.y, mouse_pos.z))
