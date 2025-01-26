extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
var pan_speed = 50.0  # How fast the camera pans
var rim_width = 300  # Width of the rim zone (pixels from the edges)
var center_speed = 5.0
var center_position = Vector2(0, 0)

func _process(delta):
	panning(delta)
	
func panning(delta):
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()

	# Initialize panning offset
	var pan_offset = Vector2()

	# Horizontal rim zones
	if mouse_pos.x < rim_width:  # Left rim
		pan_offset.x -= 1
	elif mouse_pos.x > viewport_size.x - rim_width:  # Right rim
		pan_offset.x += 1

	# Vertical rim zones
	if mouse_pos.y < rim_width:  # Top rim
		pan_offset.y -= 1
	elif mouse_pos.y > viewport_size.y - rim_width:  # Bottom rim
		pan_offset.y += 1

	# Apply smooth panning
	if pan_offset != Vector2():
		position += pan_offset.normalized() * pan_speed * delta
	else:
		# Smoothly pan back to the center when not in the rim zones
		position = position.lerp(center_position, center_speed * delta)
	# Debugging: Print which rim zone is being activated
	if mouse_pos.x < rim_width:
		print("Mouse in left rim")
	elif mouse_pos.x > viewport_size.x - rim_width:
		print("Mouse in right rim")

	if mouse_pos.y < rim_width:
		print("Mouse in top rim")
	elif mouse_pos.y > viewport_size.y - rim_width:
		print("Mouse in bottom rim")
		
	position.x = clamp(position.x, -30, 30)  # Adjust these bounds for your world
	position.y = clamp(position.y, -30, 30)
	
