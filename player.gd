extends Area2D

@export var thrustAmount = 0.05
@export var heading = 0
@export var turnSpeed = 0.1
@export var velocity = Vector2.ZERO

var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	print("in _ready.  screen_size is: ")
	print(screen_size)

func my_handle_inputs(delta: float) -> void:
	var accel = 2
	if (Input.is_action_pressed("move_left")):
		heading -= turnSpeed * delta
	if (Input.is_action_pressed("move_right")):
		heading += turnSpeed * delta
	if (Input.is_action_pressed("thrust")):
		var thrustVec = Vector2.RIGHT.rotated(heading) * thrustAmount * delta
		velocity+=thrustVec
	if (Input.is_action_pressed("fire")):
		pass
	
	if (velocity.length() > 0):
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	velocity *= 0.99
	rotation=heading + PI/2
	position+=velocity	
	position = position.clamp(Vector2.ZERO, screen_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	my_handle_inputs(delta)
