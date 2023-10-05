extends CharacterBody2D

var direction: String
@onready var animations = $Sprite2D/AnimationPlayer
@onready var detector = $RayCast2D
@export var speed: int = 60


func run():
	speed = 90
	animations.speed_scale = 1.5

func walk():
	speed = 60
	animations.speed_scale = 1

func getInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_pressed("ui_shift"):
		run()
	elif Input.is_action_just_released("ui_shift"):
		walk()

	velocity = moveDirection * speed
	
func updateAnimation():
	if velocity.length() != 0:
		if velocity.x > 0:
			direction = "Right"
			detector.target_position = Vector2(25, 0)
		elif velocity.x < 0:
			direction = "Left"
			detector.target_position = Vector2(-25, 0)
		elif velocity.y < 0:
			direction = "Up"
			detector.target_position = Vector2(0, -25)
		elif velocity.y > 0:
			direction = "Down"
			detector.target_position = Vector2(0, 25)
		animations.play("move" + direction)
	
	
	if velocity.length() == 0:
		walk()
		animations.play("idle" + direction)
	
	
func _process(delta):
	getInput()
	move_and_slide()
	updateAnimation()
