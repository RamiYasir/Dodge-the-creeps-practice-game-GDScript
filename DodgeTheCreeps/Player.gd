extends Area2D

signal hit

export var speed = 400 
var screen_size 

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2()

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play() 
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShapeBody.set_deferred("disabled", true)
	$CollisionShapeLegs.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShapeBody.disabled = false
	$CollisionShapeLegs.disabled = false
	

## my attempt at trying to make the thing accelerate.
#
#const var MAX_SPEED = 600
#var speed = 400
##export var speed = 400
##export var damping_speed = 0.0
#var screen_size 
#
#func _ready():
#	screen_size = get_viewport_rect().size 
#
#func _process(delta):	
#	var initial_velocity = Vector2()
#	var final_velocity = initial_velocity
#	var acceleration = Vector2()
#
#	# do some stuff before normalizing the velocity and multiplying it by speed in order to get acceleration up to max speed
#
#	if Input.is_action_pressed("ui_right"):
#		initial_velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		initial_velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):
#		initial_velocity.y += 1
#	if Input.is_action_pressed("ui_up"):
#		initial_velocity.y -= 1
#	if initial_velocity.length() > 0:
#		final_velocity = initial_velocity.normalized() * speed
#		acceleration = (final_velocity - initial_velocity) / delta
#		initial_velocity = final_velocity
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()
#
##	position += final_velocity * acceleration
#	position += final_velocity * acceleration
#	position.x = clamp(position.x, 0, screen_size.x)
#	position.y = clamp(position.y, 0, screen_size.y)




