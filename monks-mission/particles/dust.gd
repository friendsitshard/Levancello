extends CPUParticles2D

@export var particle_lifetime: float = 0.8  
@export var speed: float = 150  
@export var spread_angle: float = 80 
@export var gravity_strength: float = 5  
@export var particle_amount: int = 2  

func _ready() -> void:
	lifetime = particle_lifetime
	amount = particle_amount  
	one_shot = true 
	emitting = true 
	direction = Vector2(0, -1)  
	spread = spread_angle
	gravity = Vector2(0, gravity_strength)  
	speed_scale = speed / 100.0  
	scale = Vector2(1.0, 1.0)  

	color_ramp = Gradient.new()
	color_ramp.add_point(0.0, Color(0.4, 0.0, 0.6, 1.0)) 
	color_ramp.add_point(0.5, Color(0.6, 0.1, 0.8, 0.8))  
	color_ramp.add_point(0.75, Color(0.3, 0.0, 0.5, 0.5))  
	color_ramp.add_point(1.0, Color(0.1, 0.0, 0.2, 0.3))  
	self.color_ramp = color_ramp
