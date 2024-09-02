extends RigidBody2D

signal fire;

@export var velocity:Vector2 = Vector2.ZERO
@export var target = null;


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	velocity = Vector2.from_angle(randf_range(0, 2 * PI)) * 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity
	
	var targetPos = Vector2(target.position)
	var toTarget = targetPos - position
	rotation = toTarget.angle() - PI/2

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("mob freeing")
	queue_free()


func _on_timer_timeout() -> void:
	fire.emit()
