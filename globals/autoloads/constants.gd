extends Node
const TILE_SIZE: int = 10
const TILE_CENTER: Vector3 = Vector3(-TILE_SIZE / 2.0, 0, TILE_SIZE / 2.0)

const VECTOR2_NULL: Vector2 = Vector2(-9999, -9999)
const VECTOR3_NULL: Vector3 = Vector3(-9999, -9999, -9999)
const VECTOR2I_NULL: Vector2i = Vector2i(-9999, -9999)
const VECTOR3I_NULL: Vector3i = Vector3i(-9999, -9999, -9999)

enum Direction { Up, Down, Left, Right}

const VECTOR_FROM_DIRECTION: Dictionary[Direction, Vector2i] = {
	Direction.Up: Vector2i(0, 1),
	Direction.Down: Vector2i(0, -1),
	Direction.Left: Vector2i(-1, 0),
	Direction.Right: Vector2i(1, 0)
}
const DIRECTION_FROM_VECTOR: Dictionary[Vector2i, Direction] = {
	Vector2i(0, 1): Direction.Up,
	Vector2i(0, -1): Direction.Down,
	Vector2i(-1, 0): Direction.Left,
	Vector2i(1, 0): Direction.Right
}

const ROTATION_FROM_DIRECTION: Dictionary[Direction, int] = {
	Direction.Up: 0,
	Direction.Down: 180,
	Direction.Left: 270,
	Direction.Right: 90
}

const DIRECTION_FROM_ROTATION: Dictionary[int, Direction] = {
	0: Direction.Up,
	180: Direction.Down,
	270: Direction.Left,
	90: Direction.Right
}