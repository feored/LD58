extends Node3D

const SPEED = 20.0


func compute_damage() -> int:
	var total_spellpower = GameState.total_stats[Item.Group.SpellDamage]
	var total_spellpower_pc = 1 + (total_spellpower / 100.0)
	return Constants.BASE_SPELL_DAMAGE / 20 * total_spellpower_pc


func _physics_process(delta: float) -> void:
	self.check_bounds()
	self.global_position += -transform.basis.z * SPEED * delta


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("enemies") and area.is_in_group("enemy_hitbox"):
		area.get_parent().get_hit(compute_damage())


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
