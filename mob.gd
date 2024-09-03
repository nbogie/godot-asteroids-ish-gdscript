extends RigidBody2D

signal fire(position, angle);

@export var target = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var targetPos = Vector2(target.position)
	var toTarget = targetPos - position
	rotation = toTarget.angle() - PI/2

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	fire.emit(self.position, self.rotation + PI/2)


func _on_body_entered(body: Node) -> void:
	print("mob: _on_body_entered", body.name)


func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	print("mob: _on_body_shape_entered", body.name)
