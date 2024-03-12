extends Area2D

@export var speed = 150
@onready var screensize = get_viewport_rect().size
@onready var spritesize : Vector2 = Vector2(0, $Ship.texture.get_width()/2)
@export var cooldown = 0.25
@export var bullet_scene : PackedScene
var can_shoot = true

signal died
signal shield_changed

@export var max_shield = 10
var shield = max_shield:
	set = set_shield
	
func set_shield(value):
	shield = min(max_shield, value)
	shield_changed.emit(max_shield, shield)
	if shield <= 0:
		hide()
		died.emit()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func start():
	position = Vector2(screensize.x / 2, screensize.y - 64)
	$GunCoolDown.wait_time = cooldown
	
	
func _process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	if input.x > 0:
		$Ship.frame = 2
		$Ship/Boosters.animation = "right"
	elif input.x < 0:
		$Ship.frame = 0
		$Ship/Boosters.animation = "left"
	else:
		$Ship.frame = 1
		$Ship/Boosters.animation = "forward"
		
	position += input * speed * delta
	position = position.clamp(Vector2.ZERO + spritesize, screensize-spritesize)
	if Input.is_action_pressed("shoot"):
		shoot()
	
func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$GunCoolDown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position + Vector2(0, -8))

func _on_gun_cool_down_timeout():
	can_shoot = true


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.explode()
		shield -= max_shield/2
