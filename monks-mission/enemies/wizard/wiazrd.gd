extends CharacterBody2D

class_name Wizard

@onready var animated_sprite = $AnimatedSprite2D

var is_dead : bool = false

var health = 50
@export var health_max = 50

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
		if get_tree().current_scene.scene_file_path == "res://second_node.tscn":
			get_tree().change_scene_to_file("res://menu/menu.tscn")
