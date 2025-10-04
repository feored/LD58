extends Camera3D

@export var character: Node3D

var pivot: Vector3

func _ready():
    pivot = self.global_position

func _physics_process(delta: float) -> void:
    if character:
        var target_position = character.global_position + pivot
        self.global_position = self.global_position.lerp(target_position, 0.1)