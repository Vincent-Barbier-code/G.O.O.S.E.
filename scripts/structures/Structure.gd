extends Node2D
class_name Structure

# Propriétés de base
var structure_type = ""
var structure_name = ""
var cost = {} # ex: {money: 10}
var base_production = {}
var maintenance = {} # ex : {"energy": 1}
var level = 1
var is_active = true

# Calcul de la production réelle selon le terrain
func get_production(terrain_type):
	# Par défaut, retourne la base
	# Peut être surchargé dans les classes filles
	var prod = base_production.duplicate()
	# Exemple : bonus si terrain_type.name == "plain"
	if terrain_type.name == "plain" and prod.has("food"):
		prod["food"] += 1 * level
	return prod

func _init(_type=""):
	structure_type = _type
