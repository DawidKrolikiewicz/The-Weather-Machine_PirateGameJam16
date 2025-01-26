extends ProgressBar
class_name GaugeBar

var vis: bool = true

func _process(delta: float) -> void:
	if vis:
		modulate.a += delta
		visible = true
	else:
		modulate.a -=  delta/3
		if modulate.a <= 0:
			visible = false
			
	modulate.a = clampf(modulate.a, 0, 1)
	
