extends Node3D

const blue_skull_scene = preload("res://scenes/battle/souls/skull_blue.tscn")
const red_skull_scene = preload("res://scenes/battle/souls/skull_red.tscn")
const green_skull_scene = preload("res://scenes/battle/souls/skull_green.tscn")

const BASE_LIFETIME = 5.0
const DISTANCE_TO_GET = 0.25
const SPEED = 2.0

var target: Node3D = null
var is_targeting: bool = false
var item: Item = null


func _physics_process(delta: float) -> void:
    if is_targeting and target != null and item != null:
        if not target.can_add_item(item):
            is_targeting = false
            target = null
            return
        if self.target.global_position.distance_to(self.global_position) < DISTANCE_TO_GET:
            if item != null and target.can_add_item(item):
                var added = target.add_item(item)
                self.queue_free()
        else:
            var direction = (target.global_position - self.global_position).normalized()
            self.global_position += direction * SPEED * delta


func _ready() -> void:
    var collision_shape = %CollisionShape3D
    collision_shape.shape.radius += GameState.total_stats[Item.Group.CollectionRange]
    self.start_lifetime_timer()
    if item == null:
        return
    self.add_color_skull(item.item_type)


func start_lifetime_timer() -> void:
    var computed_lifetime = BASE_LIFETIME + GameState.total_stats[Item.Group.SoulDuration]
    var timer := Timer.new()
    self.add_child(timer)
    timer.wait_time = computed_lifetime
    timer.timeout.connect(expire)
    timer.start()


func expire() -> void:
    Sfx.play_multitrack(Sfx.MultiTrack.SoulExpire, self.global_position)
    self.queue_free()


func add_color_skull(color: Item.Type) -> void:
    var skull_scene = null
    match color:
        Item.Type.Blue:
            skull_scene = blue_skull_scene.instantiate()
        Item.Type.Red:
            skull_scene = red_skull_scene.instantiate()
        Item.Type.Green:
            skull_scene = green_skull_scene.instantiate()
    self.add_child(skull_scene)


func _on_area_3d_area_entered(area: Area3D) -> void:
    if area.get_parent().is_in_group("player"):
        if item != null and area.get_parent().can_add_item(item):
            self.is_targeting = true
            self.target = area.get_parent()


func _on_area_3d_area_exited(area: Area3D) -> void:
    if area.get_parent().is_in_group("player"):
        is_targeting = false
        target = null
