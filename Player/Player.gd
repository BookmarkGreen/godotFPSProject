class_name Player
extends CharacterBody3D

var speed

@export var states: Dictionary = { Idle = "Idle", Movement = "Movement", Jump = "Jump" }
@export var CROUCH_SPEED: float #2.5
@export var SPRINT_CROUCH_SPEED: float #4.5

@export var WALK_SPEED: float #5.0
@export var SPRINT_SPEED: float #10.0
@export var JUMP_VELOCITY: float #4.5
@export var SENSITIVITY: float #0.003

#BOB
@export var BOB_FREQUENCY: float #2.0
@export var BOB_AMP: float #0.08
@export var t_bob: float #0.0

#CROUCHING/SLIDING
var _is_crouching := false
var _is_sliding := false
#FOV

@onready var player: Player = $"."
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D
@onready var player_animation_player: AnimationPlayer = $PlayerAnimationPlayer
@export var BASE_FOV = 75.0
@export var FOV_MULT = 1.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8


@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	shape_cast_3d.add_exception($".")
	_is_crouching = !_is_crouching
	_is_sliding = !_is_sliding
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Run
	if Input.is_action_pressed("sprint"):
		if _is_crouching == true:
			speed = SPRINT_SPEED
		else:
			speed = SPRINT_CROUCH_SPEED 
	else:
		if _is_crouching == true:
			speed = WALK_SPEED
		else:
			speed = CROUCH_SPEED
	if Input.is_action_pressed("zoom"):
		BASE_FOV = 30.0
	else:
		BASE_FOV = 75.0
	if Input.is_action_just_pressed("crouch"):
		toggle_crouch()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMP
	pos.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMP
	return pos
	
func toggle_crouch():
	if _is_crouching == true and _is_sliding:
		player_animation_player.play("Crouch", -1, 7.0)
	elif _is_crouching == false and shape_cast_3d.is_colliding() == false:
		player_animation_player.play("Crouch", -1, 7.0 * -1, true)
	
func _on_player_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "Crouch":
		_is_crouching = !_is_crouching
	elif anim_name == "CrouchSlide":
		_is_sliding = !_is_sliding
