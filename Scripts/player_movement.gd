extends CharacterBody2D

@export var movement_speed: float = 500
@onready var _animated_sprite = %sprite
var character_direction: Vector2
var last_direction: Vector2 = Vector2.DOWN  # default facing down

func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()
	
	if character_direction != Vector2.ZERO:
		last_direction = character_direction
		velocity = character_direction * movement_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)

	move_and_slide()

	# Animation logic
	if character_direction != Vector2.ZERO:
		if abs(character_direction.y) > abs(character_direction.x):
			if character_direction.y > 0:
				_animated_sprite.play("run_down")
			else:
				_animated_sprite.play("run_up")
		else:
			_animated_sprite.play("run_side")
			_animated_sprite.flip_h = character_direction.x > 0
	else:
		if abs(last_direction.y) > abs(last_direction.x):
			if last_direction.y > 0:
				_animated_sprite.play("idle_front")
			else:
				_animated_sprite.play("idle_back")
		else:
			_animated_sprite.play("idle_side")
			_animated_sprite.flip_h = last_direction.x > 0
