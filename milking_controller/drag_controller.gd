extends ColorRect

const MIN_DRAG_DISTANCE: int = 180  
const MIN_DRAG_SPEED: int = 400

signal zone_dragged(zone: String, direction: String)
signal zone_released(zone: String)

@export 
var zone_name: String

var _drag_start_position: Vector2
var _last_direction: String = ""	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			_drag_start_position = event.position
		if event.is_released():
			emit_signal("zone_released", zone_name)
	
	elif event is InputEventScreenDrag:
		var vertical_distance = abs(event.position.y - _drag_start_position.y)
		var vertical_speed = abs(event.velocity.y)	
		
		if vertical_distance >= MIN_DRAG_DISTANCE and vertical_speed >= MIN_DRAG_SPEED:
			var direction = "down" if event.velocity.y > 0 else "up"
			if direction != _last_direction:
				_drag_start_position = event.position
				_last_direction = direction
				emit_signal("zone_dragged", zone_name, direction)

func _on_milking_controller_reset() -> void:
	_drag_start_position = Vector2()
	_last_direction = ""
