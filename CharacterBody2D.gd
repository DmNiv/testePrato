extends CharacterBody2D

@onready var direction: String
@onready var carriedObject: StaticBody2D
@onready var screenSize = get_viewport_rect().size
@onready var animations = $Sprite2D/AnimationPlayer
@onready var detector = $RayCast2D
@onready var player = $"."
@onready var detectorPoint: Vector2
@export var speed: int = 60



func run():
	speed = 90
	animations.speed_scale = 1.5

func walk():
	speed = 60
	animations.speed_scale = 1

func interact():
	var target = detector.get_collider()
	if target != null:
		target.interacted(self)
		
		

func carrying(object: StaticBody2D):
	if carriedObject == null:
		carriedObject = object
		carriedObject.carried()

func drop():
	carriedObject.throw(self.direction)
	carriedObject.global_position.x = snapped(floor((detectorPoint).x / 16) * 16, 16)
	carriedObject.global_position.y = snapped(floor((detectorPoint).y / 16) * 16, 16)
	carriedObject.global_position = carriedObject.global_position.clamp(Vector2.ZERO, screenSize)
	carriedObject = null

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
			detector.rotation_degrees = -90
			detectorPoint = detector.global_position + Vector2(16, 0)
		elif velocity.x < 0:
			direction = "Left"
			detector.rotation_degrees = 90
			detectorPoint = detector.global_position + Vector2(-16, 0)
		elif velocity.y < 0:
			direction = "Up"
			detector.rotation_degrees = 180
			detectorPoint = detector.global_position + Vector2(0, -16)
		elif velocity.y > 0:
			direction = "Down"
			detector.rotation_degrees = 0
			detectorPoint = detector.global_position + Vector2(0, 16)
		animations.play("move" + direction)
	
	
	if velocity.length() == 0:
		walk()
		animations.play("idle" + direction)
	
	
func _process(delta):
	getInput()
	move_and_slide()
	updateAnimation()
	position = position.clamp(Vector2.ZERO, screenSize)
	if Input.is_action_just_pressed("ui_accept"):
		interact()
	if carriedObject != null:
		carriedObject.global_position = $Sprite2D.global_position + Vector2(8, 0) 
		if Input.is_action_just_pressed("ui_c"):
			drop()
