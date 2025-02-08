@tool
extends GPUParticles3D

var previous_position
@export var min_distance = 0.1
var distance_accum = 0.0

func _ready() -> void:
	previous_position = global_position

func _process(_delta):
	distance_accum = distance_accum + previous_position.distance_to(global_position)
	if distance_accum >= min_distance:
		var particles_to_emit = int(ceil(distance_accum / min_distance))
		for particle in particles_to_emit:
			var particle_position = previous_position.lerp(global_position, float(particle) / particles_to_emit)
			emit_particle(Transform3D(Basis(), particle_position), Vector3(), Color(), Color(), 0)
	
		distance_accum = 0.0
	
	previous_position = global_position
