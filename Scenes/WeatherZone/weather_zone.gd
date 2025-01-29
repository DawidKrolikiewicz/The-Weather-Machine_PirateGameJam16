extends Node2D
class_name WeatherZone

signal disolve_finished(me)

# DATA OBJECT
@export var data: WeatherData

# VISUAL
@onready var visual: Node2D = $Visual
@onready var weather_sprite: Sprite2D = $Visual/WeatherSprite
@onready var gpu_particles_2d: GPUParticles2D = $Visual/GPUParticles2D
@onready var animated_effects: AnimatedSprite2D = $Visual/AnimatedEffects

# ROTATION
@onready var axle: Node2D = $Axle
@onready var direction_marker: Marker2D = $Axle/DirectionMarker

# HITBOX
@onready var drag_area_2d: Area2D = $DragArea2D
@onready var drag_collision: CollisionShape2D = $DragArea2D/CollisionShape2D
@onready var effect_area_2d: Area2D = $EffectArea2D
@onready var effect_collision: CollisionShape2D = $EffectArea2D/CollisionShape2D

var direction: Vector2
var rotation_vel: float = 0

var size: float

var mouse_in: bool = false
var follow: bool = false

var life_start: bool = false
var lifetime: int

func _ready() -> void:
	SignalBus.tick.connect(_on_tick_timer_timeout)
	
	visual.scale = Vector2.ZERO
	
	visual.modulate = data.debug_color
	weather_sprite.texture = data.texture
	weather_sprite.hframes = data.h_frames
	weather_sprite.vframes = data.v_frames
	weather_sprite.frame = data.frame
	gpu_particles_2d.texture = data.particle_texture
	if data.animation_name:
		animated_effects.visible = true
		animated_effects.play(data.animation_name)
	
	drag_collision.shape = CapsuleShape2D.new()
	drag_collision.shape.radius = 0
	drag_collision.shape.height = 0
	
	effect_collision.shape = CapsuleShape2D.new()
	effect_collision.shape.radius = 0
	effect_collision.shape.height = 0
	
	axle.rotation = randf_range(-PI, PI)
	
	size = randi_range(data.min_full_size, data.max_full_size)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(drag_collision.shape, "radius", size/5, data.form_time / (Settings.game_speed/100))
	tween.tween_property(drag_collision.shape, "height", size, data.form_time / (Settings.game_speed/100))
	tween.tween_property(effect_collision.shape, "radius", size/5, data.form_time / (Settings.game_speed/100))
	tween.tween_property(effect_collision.shape, "height", size, data.form_time / (Settings.game_speed/100))
	tween.tween_property(visual, "scale", Vector2(0.25, 0.25) * size/200, data.form_time / (Settings.game_speed/100))
	await tween.finished
	
	lifetime = randi_range(data.min_lifetime, data.max_lifetime)
	life_start = true
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("RMB") and mouse_in:
		follow = true
		
	if Input.is_action_just_released("RMB"):
		follow = false
	
	# NOTE: SHOULD PROBABLY MULT ROTATION_ACC BY DELTA HONESTLY (SEE: WeatherData RESOURCE)
	rotation_vel += randf_range(-data.rotation_acceleration, data.rotation_acceleration)
	rotation_vel = clampf(rotation_vel, -data.max_rotation_velocity, data.max_rotation_velocity)
	axle.rotate(deg_to_rad(rotation_vel) * delta)
	
	if !follow:
		direction = (direction_marker.global_position - global_position).normalized()
		position += direction * data.speed * delta * (Settings.game_speed / 100)
	else:
		direction = (get_global_mouse_position() - global_position).normalized()
		position += direction * min(data.speed * delta * data.speed_mult * (Settings.game_speed / 100), (get_global_mouse_position() - global_position).length())
	
	if mouse_in:
		SignalBus.display_weather_info.emit(data)

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
	
func _on_tick_timer_timeout() -> void:
	var overlapping_poi = effect_area_2d.get_overlapping_areas()
	for o in overlapping_poi:
		o.owner.on_tick(data)
	
	if life_start:
		lifetime -= (Settings.game_speed / 100)
		if lifetime <= 0:
			var tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(drag_collision.shape, "radius", 0, data.dissolve_time / (Settings.game_speed/100))
			tween.tween_property(drag_collision.shape, "height", 0, data.dissolve_time / (Settings.game_speed/100))
			tween.tween_property(effect_collision.shape, "radius", 0, data.dissolve_time / (Settings.game_speed/100))
			tween.tween_property(effect_collision.shape, "height", 0, data.dissolve_time / (Settings.game_speed/100))
			tween.tween_property(visual, "scale", Vector2.ZERO, data.dissolve_time / (Settings.game_speed/100))
			await tween.finished
			disolve_finished.emit(self)


	
