extends Area2D
signal hit
signal fire_laser

@export var cooldown_timer = 0.2

@export var thrustAmount = 0.05
@export var heading = 0
@export var turnSpeed = 0.1
@export var velocity = Vector2.ZERO

var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	toggle_audio_mute()
	screen_size = get_viewport_rect().size
	print("in _ready.  screen_size is: ")
	print(screen_size)

func start(pos):
	print("Player: start()")
	position = pos
	show()
	$CollisionShape2D.disabled = false

func my_handle_inputs(delta: float) -> void:
	var accel = 2
	if (Input.is_action_pressed("move_left")):
		heading -= turnSpeed * delta
	if (Input.is_action_pressed("move_right")):
		heading += turnSpeed * delta
	if (Input.is_action_pressed("thrust")):
		var thrustVec = Vector2.RIGHT.rotated(heading) * thrustAmount * delta
		velocity += thrustVec
		$CPUParticles2D.emitting = true
	else:		
		$CPUParticles2D.emitting = false
		
	if (Input.is_action_pressed("fire")):
		if cooldown_timer <= 0:
			fire_laser.emit(position, heading)
			cooldown_timer = 0.2
			$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.1)
			$AudioStreamPlayer2D.play(0)
	
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
	cooldown_timer -= delta


func _on_body_entered(body: Node2D) -> void:
	print("Player: _on_body_entered");
	#hide()
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_M:
			toggle_audio_mute()

func toggle_audio_mute() -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	var isCurrentlyMuted = AudioServer.is_bus_mute(bus_index)
	AudioServer.set_bus_mute(bus_index, !isCurrentlyMuted)
	
	
