extends PlayerState

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	pass

func update(_delta: float) -> void:
	if player.is_on_floor() or player.is_on_wall_only():
		player.velocity.y = player.JUMP_VELOCITY
	state_machine.transition_to(player.states.Idle)
