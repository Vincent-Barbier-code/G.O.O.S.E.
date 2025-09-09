extends Structure
class_name Building

func _ready():
	# Affichage visuel simple selon le type
	var icon = ColorRect.new()
	icon.size = Vector2(48, 48)
	icon.position = Vector2(-24, -24)
	match structure_type:
		"farm": icon.color = Color(0,1,0)
		"mine": icon.color = Color(0.5,0.5,0.5)
		"plant": icon.color = Color(1,0.5,0)
		_: icon.color = Color(1,1,1)
	add_child(icon)
