extends Node3D

var t;
var lifetime = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	t = 0
	$GPUParticles3D.process_material.spread = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	$GPUParticles3D.process_material.initial_velocity_min = max(0,10.0 - 20*t)
	$GPUParticles3D.process_material.initial_velocity_max = max(0,15.0 - 20*t)
	#$GPUParticles3D.amount = int(100 - 5*t)
	if t > lifetime:
		queue_free()
