extends CPUParticles2D

@export var particle_lifetime: float = 1.0 
@export var spread_angle: float = 45.0 
@export var initial_speed: float = 200.0  
@export var gravity_strength: float = 500.0  
@export var burst_count: int = 10  

func _ready() -> void:
	lifetime = particle_lifetime 
	direction = Vector2(0, -1)  
	spread = spread_angle  
	speed_scale = initial_speed/150 
	emitting = true  
	gravity = Vector2(0, gravity_strength)
	amount = burst_count  
	emission_shape = CPUParticles2D.EMISSION_SHAPE_POINT

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = particle_lifetime
	timer.connect("timeout", Callable(self, "queue_free"))
	add_child(timer)
	timer.start()
