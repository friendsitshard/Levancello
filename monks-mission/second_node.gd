extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$pause_overlay.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(_event) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://menu/menu.tscn")
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		$pause_overlay.visible = true
