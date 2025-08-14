extends CanvasLayer

@export
var pixel_block: int = 16

@onready
var _shader_holder: ColorRect = get_node("ColorRect")

func _ready():
	_shader_holder.material.set_shader_parameter("pixel_block", pixel_block)
