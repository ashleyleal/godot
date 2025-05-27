extends CharacterBody2D

@export var movement_speed: float = 75
@onready var _animated_sprite = %sprite

var character_direction: Vector2
var last_direction: Vector2 = Vector2.DOWN 

enum AnimationState {
	IDLE_FRONT,
	IDLE_BACK,
	IDLE_SIDE,
	RUN_DOWN,
	RUN_UP,
	RUN_SIDE
}

var current_state: AnimationState = AnimationState.IDLE_FRONT

func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()

	var speed_multiplier = 1.0
	if Input.is_action_pressed("sprint"):
		speed_multiplier = 1.5

	var current_speed = movement_speed * speed_multiplier

	if character_direction != Vector2.ZERO:
		last_direction = character_direction
		velocity = character_direction * current_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_speed)

	move_and_slide()
	_animated_sprite.speed_scale = speed_multiplier

	update_animation_state()
	play_animation()


func update_animation_state():
	if character_direction != Vector2.ZERO:
		if abs(character_direction.y) > abs(character_direction.x):
			current_state = AnimationState.RUN_DOWN if character_direction.y > 0 else AnimationState.RUN_UP
		else:
			current_state = AnimationState.RUN_SIDE
	else:
		if abs(last_direction.y) > abs(last_direction.x):
			current_state = AnimationState.IDLE_FRONT if last_direction.y > 0 else AnimationState.IDLE_BACK
		else:
			current_state = AnimationState.IDLE_SIDE


func play_animation():
	match current_state:
		AnimationState.RUN_DOWN:
			_animated_sprite.play("run_down")
		AnimationState.RUN_UP:
			_animated_sprite.play("run_up")
		AnimationState.RUN_SIDE:
			_animated_sprite.play("run_side")
			_animated_sprite.flip_h = character_direction.x > 0
		AnimationState.IDLE_FRONT:
			_animated_sprite.play("idle_front")
		AnimationState.IDLE_BACK:
			_animated_sprite.play("idle_back")
		AnimationState.IDLE_SIDE:
			_animated_sprite.play("idle_side")
			_animated_sprite.flip_h = last_direction.x > 0
