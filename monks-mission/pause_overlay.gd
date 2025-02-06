extends CanvasLayer

func _ready() -> void:
	$".".visible = false

func _input(_event) -> void:
	if Input.is_action_just_pressed("pause"):
		get_viewport().set_input_as_handled()
		if get_tree().paused:
			get_tree().paused = false
			$".".visible = false
