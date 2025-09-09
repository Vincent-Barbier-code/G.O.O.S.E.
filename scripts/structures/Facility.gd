extends Structure
class_name Facility

func _ready():
	# Affichage visuel simple selon le type
	var icon = ColorRect.new()
	icon.size = Vector2(16, 16)
	icon.position = Vector2(-8, -8)
	match structure_type:
		"pipeline": icon.color = Color(0,0.7,1)
		"route": icon.color = Color(0.7,0.7,0.2)
		"relay": icon.color = Color(1,0.2,0.2)
		_: icon.color = Color(1,1,1)
	add_child(icon)
