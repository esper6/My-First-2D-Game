extends Area2D
signal hit

export var speed = 400
var screen_size
var _invincibility: bool

func _ready():
	screen_size = get_viewport_rect().size
	hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	
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
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		

func flash():
	# code to make player sprite flash
	var tween = Tween.new()
	tween.interpolate_property(get_node("Player"), "modulate", Color("white"), Color("red"), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	add_child(tween)
	tween.start()

func set_invincibility(invincibility):
	# set invincibility status
	_invincibility = invincibility

func _on_Player_body_entered(body):
	#hide()
	flash()
	print("flash")
	set_invincibility(true)
	emit_signal("hit")
	#$CollisionShape2D.set_deferred("disabled", true)
	
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
