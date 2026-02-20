class_name EnemySpawnState extends EnemyState

func enter() -> void:
	playback.play_spawn()
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
