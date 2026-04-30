extends Node2D

@onready var cpu_particles: CPUParticles2D = $CPU_particles

func set_emitting(is_emmitting: bool) -> void:
	cpu_particles.emitting = is_emmitting

func set_velocity(value: float) -> void:
	cpu_particles.initial_velocity_min = abs(value * 0.9)
	
	#sets amount of particles according to velocity of player as well
	cpu_particles.scale_amount_min = abs(value/300)
