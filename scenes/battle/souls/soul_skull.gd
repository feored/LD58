extends Node3D

const blue_skull_scene = preload("res://scenes/battle/souls/skull_blue.tscn")
const red_skull_scene = preload("res://scenes/battle/souls/skull_red.tscn")
const green_skull_scene = preload("res://scenes/battle/souls/skull_green.tscn")

const LIFETIME = 10.0

var item: Item = null


func _ready() -> void:
    self.start_lifetime_timer()
    if item == null:
        return
    self.add_color_skull(item.item_type)


func start_lifetime_timer() -> void:
    var timer := Timer.new()
    self.add_child(timer)
    timer.wait_time = LIFETIME
    timer.timeout.connect(queue_free)
    timer.start()


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
        if item != null:
            area.get_parent().add_item(item)
        self.queue_free()
