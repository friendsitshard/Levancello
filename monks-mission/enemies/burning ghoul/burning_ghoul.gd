extends CharacterBody2D

class_name BurningGhoul

@onready var animated_sprite = $AnimatedSprite2D

@export var speed = 100
var direction : Vector2 = Vector2.LEFT
var is_ghoul_chase : bool
var is_dead : bool = false

var health = 50
@export var health_max = 50
@export var damage_to_deal = 20

func _ready():
	$direction_timer.wait_time = 1.5
	$direction_timer.start()  

func _process(delta: float) -> void:
	if !is_dead:
		if is_on_floor():
			velocity.x = direction.x * speed  
		else:
			direction = Vector2.RIGHT
			velocity.x = direction.x * speed  
	else:
		velocity.x = 0  
	move_and_slide()  
	update_facing_direction()

func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false

func _on_direction_timer_timeout() -> void:
	if direction == Vector2.LEFT:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT

func take_damage(damage: int) -> void:
	if !is_dead:
		health -= damage
		if health <= 0:
			die()

func die() -> void:
	$DeathSound.play()
	animated_sprite.play("death")
	is_dead = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "death":
		queue_free()
