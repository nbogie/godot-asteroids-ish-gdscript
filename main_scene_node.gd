extends Node

@export var mob_scene: PackedScene
@export var laser_scene: PackedScene
@export var mob_laser_scene: PackedScene

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func game_over() -> void:
	print("game over!")
	$ScoreTimer.stop()	
	$MobTimer.stop()


func _on_player_hit() -> void:
	print("player hit!")
	#game_over()

func _on_score_timer_timeout() -> void:
	score += 1

func _on_mob_timer_timeout() -> void:
	spawn_a_mob()

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	
func spawn_a_mob() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	mob.target = $Player;
	mob.connect("fire", _on_mob_fire_laser)

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)	
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	

func spawn_a_laser(pos:Vector2, angle:float) -> void:
	var laser = laser_scene.instantiate()
	laser.position = Vector2(pos.x, pos.y)
	laser.rotation = angle	
	laser.linear_velocity = Vector2.from_angle(angle) * 800	
	add_child(laser)

func _on_player_fire_laser(pos:Vector2, angle:float) -> void:
	spawn_a_laser(pos, angle)
	spawn_a_laser(pos, angle-0.2)
	spawn_a_laser(pos, angle+0.2)

func _on_mob_fire_laser(pos:Vector2, angle:float) -> void:
	spawn_a_laser(pos, angle)
