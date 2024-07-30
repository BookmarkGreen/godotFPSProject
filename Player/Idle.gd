extends PlayerState

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	pass

func update(_delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (player.head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_pressed("jump"):
		state_machine.transition_to(player.states.Jump)

func physics_update(_delta: float) -> void:
	pass
func handle_input(InputEvent) -> void:
	pass
