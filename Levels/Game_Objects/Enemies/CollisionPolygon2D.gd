extends CollisionPolygon2D

@export var show: bool = true
@export var color: Color = Color(Color.GREEN, 0.3)

func _draw():
	if not show:
		return
	
	var points = get_polygon()
	draw_colored_polygon(points, color)

func changeColor(newColor):
	color = newColor
	queue_redraw()
