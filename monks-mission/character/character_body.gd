extends CharacterBody2D

class_name Player

@export var speed : float = 100.0
@export var jump_velocity : float = -250.0
@export var double_jump_velocity : float = -200.0
@export var health = 100
@export var damage_to_deal = 50

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar : ProgressBar = $HealthBar

var is_in_air : bool = false
var is_falling : bool = false
var is_crouching : bool = false
var is_flying_kick: bool = false
var is_double_jump : bool = false
var is_punch : bool = false
var is_hurt : bool = false
var is_animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var BloodParticleScene = preload("res://particles/blood.tscn")
	
func _ready() -> void:
	health_bar.value = health
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_in_air = true
		if velocity.y > 0 and not is_falling:
			is_falling = true
			is_animation_locked = false  
	else:
		if is_falling:  # Player just landed
			is_falling = false
			spawn_fall_particle() 
		if is_in_air or is_falling or is_flying_kick:
			is_in_air = false
			is_falling = false
			is_animation_locked = false
			is_flying_kick = false
		is_double_jump = false
		
	if Input.is_action_pressed("ui_down") and is_on_floor():
		crouch()
	elif is_crouching:
		is_crouching = false
		
	if Input.is_action_just_pressed("ui_up"):
		jump()
		
	if Input.is_action_just_pressed("ui_accept"):
		attack()
		
	if not is_crouching:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction:
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	else:
		velocity.x = 0
		
	move_and_slide()
	update_facing_direction()
	update_animation()
	
func jump():
	is_animation_locked = true
	animated_sprite.play("jump")
	if is_on_floor():
		velocity.y = jump_velocity
	elif not is_double_jump:
		velocity.y = double_jump_velocity
		is_double_jump = true
	
func crouch():
	if not is_crouching:
		is_crouching = true
		is_animation_locked = true
		animated_sprite.play("crouch")
	
func attack():
	if not is_animation_locked:
		is_animation_locked = true
		if is_in_air:
			is_flying_kick = true
			animated_sprite.play("flying_kick")
		elif is_crouching:
			animated_sprite.play("crouch_kick")
		else:
			if is_punch:
				animated_sprite.play("punch")
				is_punch = false
			else:
				animated_sprite.play("kick")
				is_punch = true
	$AttackArea2D/AttackShape2D.disabled = false
	$AttackArea2D.visible = true
	
func update_animation():
	if not is_animation_locked:
		if is_hurt:
			animated_sprite.play("hurt")
		elif is_in_air:
			if is_flying_kick:
				animated_sprite.play("flying_kick")
			elif is_falling:
				animated_sprite.play("fall") 
			else:
				animated_sprite.play("jump")
		elif is_crouching:
			animated_sprite.play("crouch")
		elif direction.x != 0:
			animated_sprite.play("walk")
			spawn_dast_particle()
		else:
			animated_sprite.play("idle")
	
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
		$AttackArea2D/AttackShape2D.position.x = abs($AttackArea2D/AttackShape2D.position.x)
	elif direction.x < 0:
		animated_sprite.flip_h = true
		$AttackArea2D/AttackShape2D.position.x = -abs($AttackArea2D/AttackShape2D.position.x)
	
func take_damage(damage: int) -> void:
	is_hurt = true
	health -= damage
	health_bar.value = health
	spawn_blood_particle()
	$HurtSound.play()
	if health <= 0:
		die()
	
func die():
	queue_free()
	get_tree().change_scene_to_file("res://menu/menu.tscn")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "flying_kick":
		is_animation_locked = false
		is_flying_kick = false
	elif animated_sprite.animation == "hurt":
		is_hurt = false
		is_animation_locked = false
	elif animated_sprite.animation in ["punch", "kick", "crouch_kick", "jump", "crouch"]:
		is_animation_locked = false

	$AttackArea2D/AttackShape2D.disabled = true
	$AttackArea2D.visible = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is BurningGhoul:
		take_damage(body.damage_to_deal)

func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body is BurningGhoul:
		body.take_damage(damage_to_deal)
	elif body is Angel:
		body.take_damage(damage_to_deal)
	elif body is Wizard:
		body.take_damage(damage_to_deal)

func spawn_blood_particle() -> void:
	if BloodParticleScene:
		if get_tree().current_scene.scene_file_path == "res://main_node.tscn":
			var blood_particle = BloodParticleScene.instantiate()
			blood_particle.global_position = global_position  + Vector2(-80, -185)
			get_tree().current_scene.add_child(blood_particle)
			blood_particle.emitting = true
		elif get_tree().current_scene.scene_file_path == "res://second_node.tscn":
			var blood_particle = BloodParticleScene.instantiate()
			blood_particle.global_position = global_position  + Vector2(0, 10)
			get_tree().current_scene.add_child(blood_particle)
			blood_particle.emitting = true

func spawn_dast_particle() -> void:
	if get_tree().current_scene.scene_file_path == "res://main_node.tscn":
		var dust_effect = preload("res://particles/dust.tscn").instantiate()
		dust_effect.global_position = global_position + Vector2(-68, -161)
		get_tree().current_scene.add_child(dust_effect)
	elif get_tree().current_scene.scene_file_path == "res://second_node.tscn":
		var dust_effect = preload("res://particles/dust.tscn").instantiate()
		dust_effect.global_position = global_position + Vector2(0, 25)
		get_tree().current_scene.add_child(dust_effect)

func spawn_fall_particle() -> void:
	if get_tree().current_scene.scene_file_path == "res://main_node.tscn":
		var fall_effect = preload("res://particles/fall.tscn").instantiate()
		fall_effect.global_position = global_position + Vector2(-68, -162)
		get_tree().current_scene.add_child(fall_effect)
	elif get_tree().current_scene.scene_file_path == "res://second_node.tscn":
		var fall_effect = preload("res://particles/fall.tscn").instantiate()
		fall_effect.global_position = global_position + Vector2(0, 25)
		get_tree().current_scene.add_child(fall_effect)
