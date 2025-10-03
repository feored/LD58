extends Node

var rng : RandomNumberGenerator

func _ready():
    rng = RandomNumberGenerator.new()
    rng.randomize()

## General

func wait(time):
    await get_tree().create_timer(time).timeout

func timestamp():
    #var unix_timestamp = Time.get_unix_time_from_system()
    return Time.get_time_string_from_system(false) + ":" #+ str(unix_timestamp).split(".")[1]

func get_child_by_type(parent: Node, node_type: Variant) -> Node:
    for child in parent.get_children():
        if is_instance_of(child, node_type):
            return child
        var grandchild = get_child_by_type(child, node_type)
        if grandchild != null:
            return grandchild
    return null

func vec2i_to_vec3i(vec2: Vector2i, height: int = 0) -> Vector3i:
    # Convert a Vector2i to a Vector3i with y=0
    return Vector3i(vec2.x, height, vec2.y)

func vec3i_to_vec2i(vec3: Vector3i) -> Vector2i:
    # Convert a Vector3i to a Vector2i by ignoring the y component
    return Vector2i(vec3.x, vec3.z)

## Grid

const CELL_NEIGHBORS := [
    Vector3i(-1, 0, 0),
    Vector3i(1, 0, 0),
    Vector3i(0, 0, -1), 
    Vector3i(0, 0, 1), 
]

func get_mouse_pos(camera: Camera3D) -> Vector3:
    var mpos := get_viewport().get_mouse_position()
    var origin := camera.project_ray_origin(mpos)
    var direction := camera.project_ray_normal(mpos)
    var distance := -origin.y/direction.y
    var xz_pos := origin + direction * distance
    return Vector3(xz_pos.x, 0.0, xz_pos.z)