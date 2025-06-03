extends CharacterBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 350

const GRAVITY = 400

var last_left = false


func _physics_process(delta):
	# Horizontal movement code. First, get the player's input.
	var walk := WALK_FORCE * (Input.get_axis(&"move_left", &"move_right"))
	
	if walk < 0 and !last_left:
		scale.x = -1
		last_left = true
	elif walk > 0 and last_left:
		scale.x = -1
		last_left = false
	
		
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
		$AnimatedSprite2D.play("walk")
		
	if is_zero_approx(velocity.x):
		$AnimatedSprite2D.play("idle")
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += GRAVITY * delta

	move_and_slide()

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		velocity.y = -JUMP_SPEED
	
