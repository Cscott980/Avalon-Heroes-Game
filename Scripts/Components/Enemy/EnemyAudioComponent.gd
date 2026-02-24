class_name EnemyAudioComponent extends AudioStreamPlayer3D

enum HIT {
	HIT_1,
	HIT_2,
	HIT_3,
	HIT_4,
}
enum DEATH {
	DEATH_1,
	DEATH_2
}

const HURT_1 = preload("uid://kvhydjs8seiy")
const HURT_2 = preload("uid://c71m2hge1ktww")
const HURT_3 = preload("uid://c0j67jjgyrrqg")
const HURT_4 = preload("uid://djtcnwu7yh86c")

const DEAD_1 = preload("uid://cl0rw2nmangoh")
const DEAD_2 = preload("uid://c37egmjuyvgnr")

const ENEMY_HIT_SOUNDS: Dictionary = {
	HIT.HIT_1 : HURT_1,
	HIT.HIT_2 : HURT_2,
	HIT.HIT_3 : HURT_3,
	HIT.HIT_4 : HURT_4
}

const ENEMY_DEATH_SOUNDS: Dictionary = {
	DEATH.DEATH_1 : DEAD_1,
	DEATH.DEATH_2 : DEAD_2
}


func get_random_hit_sound() -> Resource:
	var sound = ENEMY_HIT_SOUNDS.get(randi_range(HIT.HIT_1, HIT.HIT_4))
	return sound

func get_random_death_sound() -> Resource:
	var sound = ENEMY_DEATH_SOUNDS.get(randi_range(DEATH.DEATH_1,DEATH.DEATH_2))
	return sound
