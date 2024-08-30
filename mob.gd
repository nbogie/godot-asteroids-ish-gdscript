extends RigidBody2D

@export var velocity = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	print("mob _ready")
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	velocity = Vector2.from_angle(randf_range(0, 2 * PI)) * 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("mob freeing")
	queue_free()
