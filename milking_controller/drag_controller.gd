extends ColorRect

const MIN_DRAG_DISTANCE: int = 350  
const MIN_DRAG_SPEED: int = 400

signal zone_dragged(zone: String, direction: String)

@export var zone_name: String

var _drag_start_position: Vector2

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_drag_start_position = event.position  # Save start when finger touches down
	
	elif event is InputEventScreenDrag:
		var vertical_distance = abs(event.position.y - _drag_start_position.y)
		var vertical_speed = abs(event.velocity.y)
		
		if vertical_distance >= MIN_DRAG_DISTANCE and vertical_speed >= MIN_DRAG_SPEED:
			var direction = "down" if event.velocity.y > 0 else "up"
			_drag_start_position = event.position
			emit_signal("zone_dragged", zone_name, direction)
