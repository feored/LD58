extends Node

var rng : RandomNumberGenerator
var grid_map : GridMap

func _ready():
    rng = RandomNumberGenerator.new()
    rng.randomize()
    grid_map = GridMap.new()
    grid_map.cell_size = Vector3(Constants.TILE_SIZE, Constants.TILE_SIZE, Constants.TILE_SIZE)
    self.add_child(grid_map)

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

func get_tile_coords_from_position(pos: Vector3) -> Vector3i:
    return grid_map.local_to_map(pos)

func get_tile_position_from_position(mouse_pos: Vector3) -> Vector3:
    # Convert mouse position to tile position
    var coords : Vector3i = get_tile_coords_from_position(mouse_pos)
    return get_tile_position_from_coords(Vector3i(coords.x, 0, coords.z))

func get_tile_position_from_coords(coords: Vector3i) -> Vector3:
    var pos : Vector3 = grid_map.map_to_local(coords)
    return Vector3(pos.x, pos.y - Constants.TILE_SIZE/2, pos.z) # Adjust y to be at the base of the tile (not center)

func get_closest_tile_position_from_position(pos: Vector3) -> Vector3:
    # Get the closest tile position from a given position
    var coords := get_tile_coords_from_position(pos)
    return get_tile_position_from_coords(coords)

func get_vector_direction(from: Vector3i, to: Vector3i) -> Vector2i:
    # Get the direction vector from one tile coordinate to another
    assert(from != to, "Cannot get direction from the same tile coordinates")
    var x : float = 0
    var z : float = 0
    if from.x < to.x:
        x = 1
    elif from.x > to.x:
        x = -1
    if from.z < to.z:
        z = 1
    elif from.z > to.z:
        z = -1
    return Vector2i(Vector2(x, z))

func get_direction(from: Vector3i, to: Vector3i) -> Constants.Direction:
    # Get the direction from one tile coordinate to another
    var vector_direction := get_vector_direction(from, to)
    print("Vector direction: ", vector_direction)
    return Constants.DIRECTION_FROM_VECTOR[vector_direction]

func get_neighbouring_cells(tile: Vector2i) -> Array[Vector2i]:
    # Get all neighbouring tile coordinates around a given tile
    var neighbours : Array[Vector2i] = [
        Vector2i(tile.x - 1, tile.y),   # Left
        Vector2i(tile.x + 1, tile.y),   # Right
        Vector2i(tile.x, tile.y - 1),   # Down
        Vector2i(tile.x, tile.y + 1),   # Up
    ]
    return neighbours
        

func get_mouse_pos(camera: Camera3D) -> Vector3:
    var mpos := get_viewport().get_mouse_position()
    var origin := camera.project_ray_origin(mpos)
    var direction := camera.project_ray_normal(mpos)
    var distance := -origin.y/direction.y
    var xz_pos := origin + direction * distance
    return Vector3(xz_pos.x, 0.0, xz_pos.z)


func rotate_point(point: Vector3i, rotation: int, origin: Vector3i = Vector3i.ZERO) -> Vector3i:
    # Rotate a point around the origin by a given angle in degrees
    rotation = rotation % 360  # Normalize the rotation to be within 0-359 degrees
    var point_delta : Vector3i = point - origin
    match rotation:
        0:
            return point
        90:
            return origin + Vector3i(point_delta.z, point_delta.y, -point_delta.x)
        180:
            return origin + Vector3i(-point_delta.x, point_delta.y, -point_delta.z)
        270:
            return origin + Vector3i(-point_delta.z, point_delta.y, point_delta.x)
        _:
            assert(false, "Invalid rotation direction")
            return point  # Fallback to original point if invalid direction
