class_name EnemyLeveler extends Node

signal world_level(l: int)

@export var current_level: int = 1

var new_level: int

func get_world_level(world: Node3D) -> void:
	var root = world
	var p_levels: Array = []
	
	for i in world.get_children():
		if i.is_in_group("player"):
			var player: Player = i
			p_levels.append(player.progression_component.player_level)
			
	new_level = level_avarage_formula(p_levels)
	
	if new_level == current_level:
		return 
	current_level = new_level
	world_level.emit(current_level)
	

func level_avarage_formula(arr: Array) -> int:
	var total_weight: float = 0.0
	var weighted_sum: float = 0.0
	
	for level in arr:
		# Using Level^2 as the weight (Higher levels count much more)
		var weight = pow(level, 2) 
		
		weighted_sum += (level * weight)
		total_weight += weight
		
	if total_weight == 0: return 1 # Default if lobby is empty
	
	# Calculate the average and round it
	var average = weighted_sum / total_weight
	return clampi(roundi(average), 1, 30) # Keeps it within 0-30 range
