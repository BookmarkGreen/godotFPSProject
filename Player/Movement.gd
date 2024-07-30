extends PlayerState

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	pass

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		if direction:
			player.velocity.x = player.direction.x * player.speed
			player.velocity.z = player.direction.z * player.speed
		else:
			player.velocity.x = lerp(player.velocity.x, player.direction.x * player.speed, player.delta * 7.0)
			player.velocity.z = lerp(player.velocity.z, player.direction.z * player.speed, player.delta * 7.0)
	else:
		player.velocity.x = lerp(player.velocity.x, player.direction.x * player.speed, player.delta * 4.0)
		player.velocity.z = lerp(player.velocity.z, player.direction.z * player.speed, player.delta * 4.0)
	player.t_bob += player.delta * player.velocity.length() * float(player.is_on_floor())
	player.camera.transform.origin = player._headbob(player.t_bob)
	
	var velocity_clamped = clamp(player.velocity.length(), 0.5, player.SPRINT_SPEED * 2)
	var target_fov = player.BASE_FOV + player.FOV_MULT * velocity_clamped
	player.camera.fov = lerp(player.camera.fov, target_fov, player.delta * 8.0)
	player.move_and_slide()
