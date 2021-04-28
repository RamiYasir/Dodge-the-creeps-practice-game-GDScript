extends Node

export (PackedScene) var Mob
var score
var mob_counter = 0

signal mob_entered_scene

func _ready():
	randomize() 
	
func _on_MobTimer_timeout():
	#spawn mob
	$MobPath/MobSpawnLocation.offset = randi()
	var mob = Mob.instance()
	add_child(mob)
	
	#set direction for mob
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
	#check how many mobs have entered the scene
	emit_signal("mob_entered_scene")
	if $MobTimer.wait_time <= 0.1:
		return
	elif mob_counter % 10 == 0:
		$MobTimer.wait_time -= 0.05
	


func _on_ScoreTimer_timeout():
	score += 10
	var text = "+10!"
	$HUD.show_message(text)
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	get_tree().call_group("mobs", "queue_free")

func new_game():
	score = 0
	mob_counter = 0
	$Music.play()
	$MobTimer.wait_time = 0.5
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	

func _on_mob_entered_scene():
	score += 1
	mob_counter += 1
	$HUD.update_score(score)
