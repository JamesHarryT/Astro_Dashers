extends Node2D

@onready var cpu_particles: CPUParticles2D = $CPU_particles

func set_emitting(is_emmitting: bool) -> void:
	cpu_particles.emitting = is_emmitting

func set_velocity(value: float) -> void:
	cpu_particles.initial_velocity_min = abs(value * 0.5)
