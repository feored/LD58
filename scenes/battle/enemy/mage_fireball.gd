extends Node3D

const SPEED = 8.0
const DAMAGE = 25


func _physics_process(delta: float) -> void:
    self.check_bounds()
    self.global_position += -transform.basis.z * SPEED * delta


func check_bounds() -> void:
    if self.global_position.y < 0:
        self.global_position.y = 0
    if self.global_position.x > Constants.ARENA_SIZE_X / 2.0:
        self.queue_free()
    elif self.global_position.x < -Constants.ARENA_SIZE_X / 2.0:
        self.queue_free()
    elif self.global_position.z > Constants.ARENA_SIZE_Y / 2.0:
        self.queue_free()
    elif self.global_position.z < -Constants.ARENA_SIZE_Y / 2.0:
        self.queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
    if area.is_in_group("player_hitbox"):
        area.get_parent().get_hit(DAMAGE)
        self.explode()


func explode():
    %Fireball.emitting = false
    %FireballExplosion.emitting = true
    Sfx.play(Sfx.Track.FireMagicImpact, self.global_position)
    await Utils.wait(0.5)
    self.queue_free()
