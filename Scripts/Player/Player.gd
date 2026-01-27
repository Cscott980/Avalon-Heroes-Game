extends CharacterBody3D
class_name Player

@onready var hero_class_data: Dictionary = {} 
@onready var player_inventory: CharacterSheetandInventory
@onready var state_machine: PlayerStateMachine = %StateMachine
@onready var hurt_box: Area3D = %HurtBox
@onready var targets_in_range: Area3D = %TargetsInRange
@onready var model: Node3D = %Model
@onready var anim_tree: AnimationTree = %AnimationTree
@onready var anim_state: AnimationNodeStateMachinePlayback = (anim_tree.get("parameters/Movement/playback"))
@onready var world_collision: CollisionShape3D = %WorldCollision
@onready var hurt_collission: CollisionShape3D = %HurtCollission
@onready var health_bar: ProgressBar = %PlayerUI/Control/AbilityBar/VBoxContainer/PlayerHealth as ProgressBar
@onready var resource_bar: ProgressBar = %PlayerUI/Control/AbilityBar/VBoxContainer/HBoxContainer/ResourceBar as ProgressBar
@onready var exp_bar: ProgressBar = %PlayerUI/Control/AbilityBar/VBoxContainer/HBoxContainer/ExperianceBar as ProgressBar
@onready var level_display: Label = %PlayerUI/Control/AbilityBar/VBoxContainer/HBoxContainer/ExperianceBar/TextureRect/Label as Label

@onready var ability_1: TextureButton = %PlayerUI/Control/AbilityBar/HBoxContainer/Ability1
@onready var ability_2: TextureButton = %PlayerUI/Control/AbilityBar/HBoxContainer/Ability2
@onready var ability_3: TextureButton = %PlayerUI/Control/AbilityBar/HBoxContainer/Ability3

var world_gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 
#-------- Inventory -------
var inv_data: Array = []

#-------- Item Equip -----

@onready var main_hand_weapon: InitWeapon = %MainHandWeapon as Node3D
@onready var off_hand_weapon: InitWeapon = %OffHandWeapon as Node3D
@onready var main_hand_slot: BoneAttachment3D = %MainHand
@onready var off_hand_slot: BoneAttachment3D = %OffHand
@onready var sheath_back: BoneAttachment3D = %SheathBack as Node3D
@onready var sheath_hip_right: BoneAttachment3D = %SheathHipRight as Node3D
@onready var sheath_hip_left: BoneAttachment3D = %SheathHipLeft as Node3D
@onready var mesh_arm_left: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_arm_left
@onready var mesh_arm_right: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_arm_right
@onready var mesh_helm: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_helm
@onready var mesh_helm_addon: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_helm_addon
@onready var mesh_armor: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_armor
@onready var mesh_head: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_head
@onready var mesh_leg_left: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_leg_left
@onready var mesh_leg_right: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_leg_right
@onready var mesh_accessory_1: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_accessory1
@onready var mesh_accessory_2: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_accessory2
@onready var mesh_accessory_3: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_accessory3

var enemies_in_range: Array[Node3D] = []
var current_target: Node3D = null 
var input_locked: bool = false
#--------- Stats ---------
@export var class_picked: ClassData.HERO_CLASS
@export var move_speed: float = 10.0
@export var turn_speed: float = 10.0
@export var max_health: int = 0
@export var player_level: int = 1
@export var attack_range: float = 3.0
var health = 100
var player_resource: int = 0
var player_class: String = ""
var player_stats: Dictionary = {}
var player_allowed_armor: Array = []
var player_allowed_weapons: Array = []
var player_allowed_offhand: Array = []
var player_abilities: Array = []
var player_exp_collected: int = 0
var required_exp: int = 100

#--------------------------

#------ Weapons Properties -------

var weapon_slots: Array = []
var sheathed_weapons: Array = []
var weapon_is_sheathed: bool = false
var is_dual_wielding: bool = false
var is_dead: bool = false
var is_getting_hit: bool = false

#----------------------------------

func _ready() -> void:	
	level_display.text = "%s" % player_level
	hero_class_data = ClassData.classdb
	exp_bar.value = player_exp_collected
	player_inventory = get_tree().get_first_node_in_group("playersheet")
	
	
	if hero_class_data.is_empty():
		push_error("Player: No ClassDB found.")
		return
	var class_key: String = ClassData.load_class_id(class_picked)
	if class_key == "":
		push_error("Player: Unknown class_picked: %s" % [class_picked])
		return

	var class_hero = hero_class_data.get(class_key,{})
	player_class = class_hero.get("class", "")
	print(player_class)
	
	var stats = class_hero.get("stats", {})
	if player_class == "warrior":
		player_resource = stats.get("rage", 0)
	elif player_class in ["mage", "paladin", "ranger", "druid"]:
		player_resource = stats.get("mana", 0)
	elif player_class == "rogue":
		player_resource = stats.get("energy", 0)
	elif player_class == "engineer":
		player_resource = stats.get("scraps", 0)
	
	resource_bar.value = player_resource
	max_health = stats.get("health", 0)
	health = max_health
	health_bar.max_value = health
	health_bar.value = health
	player_stats = {
		"strength": stats.get("strength", 0),
		"intellect": stats.get("intellect", 0),
		"dexterity": stats.get("dexterity", 0),
		"vitality": stats.get("vitality", 0),
		"wisdom": stats.get("wisdom", 0)
	}
	player_abilities = class_hero.get("abilities", [])
	player_allowed_armor = class_hero.get("allowed_armor_types", [])
	player_allowed_offhand = class_hero.get("allowed_off_hand", [])
	player_allowed_weapons = class_hero.get("allowed_weapons", [])
		
	for child in state_machine.get_children():
		if child is PlayerState:
			child.player = self
			child.state_machine = state_machine
	anim_tree.active = true
	state_machine.Initializer()

	sheathed_weapons = [
		sheath_back,
		sheath_hip_right,
		sheath_hip_left
	]

func _physics_process(delta: float) -> void:
	if state_machine.current_state:
		state_machine.current_state.physics_process(delta)

func _unhandled_input(event: InputEvent) -> void:		
	if state_machine.current_state:
		state_machine.current_state.handle_input(event)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sheeth"):
		if weapon_is_sheathed:
			unsheeth_weapon()
		else:
			sheeth_weapon()

func update_dual_wielding_state() -> void:
	is_dual_wielding = false
	
	var mh := main_hand_weapon.WEAPON_TYPE
	var oh := off_hand_weapon.WEAPON_TYPE
	
	if mh == null or oh == null:
		return
	
	if mh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		return
	if oh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		return
	
	if oh.weapon_type == "Shield":
		return
	
	is_dual_wielding = true
	print("DUAL WIELD ENABLED")

func face_direction(dir: Vector3, delta: float) -> void: 
	if dir == Vector3.ZERO:
		return
	
	dir.y = 0.0
	dir = dir.normalized()
	
	var target_yaw := atan2(-dir.x, -dir.z)
	var current_yaw := model.rotation.y
	
	var new_yaw:= lerp_angle(current_yaw, target_yaw, turn_speed * delta)
	model.rotation.y = new_yaw

func is_moving() -> bool:
	var h := Vector2(velocity.x, velocity.z).length()
	return h > 0.1

func exp_shard_collected(exp_value: int) -> void:
	player_exp_collected += exp_value
	exp_bar.value = player_exp_collected
	if player_exp_collected >= required_exp:
		level_up()

func sheeth_weapon() -> void:
	if main_hand_weapon.WEAPON_TYPE == null and off_hand_weapon.WEAPON_TYPE == null: 
		return
		
	if input_locked:
		return
	
	var mh := main_hand_weapon.WEAPON_TYPE
	var oh := off_hand_weapon.WEAPON_TYPE
	
	var use_hips := false
	if mh != null and mh.handedness == WeaponResource.HANDEDNESS.ONE_HANDED:
		use_hips = true
	if oh != null and oh.handedness == WeaponResource.HANDEDNESS.ONE_HANDED and oh.weapon_type != "Shield":
		use_hips = true
	
	if use_hips:
		if mh != null and main_hand_weapon.get_parent() == main_hand_slot:
			main_hand_slot.remove_child(main_hand_weapon)
			sheath_hip_left.add_child(main_hand_weapon)
			main_hand_slot.transform = Transform3D.IDENTITY
			main_hand_weapon.mesh.transform = main_hand_weapon.left_hip_sheath.transform
		if oh != null and off_hand_weapon.get_parent() == off_hand_slot:
			off_hand_slot.remove_child(off_hand_weapon)
			sheath_hip_right.add_child(off_hand_weapon)
			off_hand_slot.transform = Transform3D.IDENTITY
			off_hand_weapon.mesh.transform = off_hand_weapon.right_hip_sheath.transform
	else:
		if mh != null and main_hand_weapon.get_parent() == main_hand_slot:
			main_hand_slot.remove_child(main_hand_weapon)
			sheath_back.add_child(main_hand_weapon)
			main_hand_slot.transform = Transform3D.IDENTITY
			main_hand_weapon.mesh.transform = main_hand_weapon.back_sheath.transform
		if oh != null and off_hand_weapon.get_parent() == off_hand_slot and oh.weapon_type == "Shield":
			sheath_back.add_child(off_hand_weapon)
			off_hand_slot.transform = Transform3D.IDENTITY
			off_hand_weapon.mesh.transform = main_hand_weapon.back_sheath.transform
			
	weapon_is_sheathed = true

func unsheeth_weapon() -> void:
	if main_hand_weapon.WEAPON_TYPE != null and main_hand_weapon.get_parent() != main_hand_slot:
		main_hand_weapon.get_parent().remove_child(main_hand_weapon)
		main_hand_slot.add_child(main_hand_weapon)
		main_hand_slot.transform = Transform3D.IDENTITY
		main_hand_weapon.mesh.transform = main_hand_weapon.weapon_defult_position
	if off_hand_weapon.WEAPON_TYPE != null and off_hand_weapon.get_parent() != off_hand_slot:
		off_hand_weapon.get_parent().remove_child(off_hand_weapon)
		off_hand_slot.add_child(off_hand_weapon)
		off_hand_slot.transform = Transform3D.IDENTITY
		off_hand_weapon.mesh.transform = off_hand_weapon.weapon_defult_position
	weapon_is_sheathed = false

func take_damage(amount: int) -> void:
	if is_dead:
		return
	
	health -= amount
	health_bar.value = health
	if not state_machine.is_attacking:
		state_machine.change_state("HurtState")
	
	if health <= 0:
		is_dead = true
		health = 0
		velocity = Vector3.ZERO
		state_machine.change_state("DeadState")

func level_up() -> void:
	player_level += 1
	if player_level <= 30:
		level_display.text = "%s" % player_level
	ability_unlock()

func recalculate_stats() -> void:
	pass

func ability_unlock() -> void:
	if player_level > 30:
		return
	for ability in player_abilities:
		if ability.get("level", 0) >= player_level:
			if player_level == 10:
				ability_1.disabled = false
			elif  player_level == 20:
				ability_2.disabled = false
			elif  player_level == 30:
				ability_3.disabled = false
			else:
				return

func _on_level_up_pressed() -> void:
	level_up()
	print("%s" %player_level)

func inventory_open(open: bool) -> void:
	input_locked = open

func weapon_hit_box_on() -> void:
	if main_hand_weapon:
		main_hand_weapon.hit_box.monitoring = true
	if off_hand_weapon and not off_hand_weapon.is_in_group("shield"):
		off_hand_weapon.hit_box.monitoring = true
		
func weapon_hit_box_off() -> void:
	if main_hand_weapon:
		main_hand_weapon.hit_box.monitoring = false
	if off_hand_weapon and not off_hand_weapon.is_in_group("shield"):
		off_hand_weapon.hit_box.monitoring = false

func _update_closest_target() -> void:
	for i in range(enemies_in_range.size() -1, -1, -1):
		var e := enemies_in_range[i]
		if e == null or not is_instance_valid(e) or e.is_dead:
			enemies_in_range.remove_at(i)
		
	var closest: Node3D = null
	var closest_dist_sq := INF
	
	for e in enemies_in_range:
		var d_sq := global_position.distance_squared_to(e.global_position)
		if d_sq < closest_dist_sq:
			closest_dist_sq = d_sq
			closest = e
	if closest == current_target:
		return
		
	if current_target != null and is_instance_valid(current_target) and current_target.has_method("highlighter_off"):
		current_target.highlighter_off()
	
	current_target = closest
	
	if current_target != null and current_target.has_method("highlighter_on"):
		current_target.highlighter_on()
	
	for e in enemies_in_range:
		if e != current_target and e != null and is_instance_valid(e) and e.has_method("highlighter_off"):
			e.highlighter_off()

func apply_equipment(slot_res: EquipmentSlotResource, item: ItemResource, sub_index: int = -1, hand: StringName = &"main"):
	match slot_res.equipment_slot_type:
		EquipmentSlotResource.SlotType.Helm:
			var a := item as ArmorResource
			mesh_helm.mesh = a.mesh_helm if a != null else null
			mesh_helm.skin = a.skin if a != null else null
			mesh_helm_addon.mesh = a.mesh_helm_addon if a != null else null
			mesh_helm_addon.skin = a.skin if a != null else null
		EquipmentSlotResource.SlotType.Armor:
			var a := item as ArmorResource
			mesh_arm_left.mesh = a.mesh_arm_left if a != null else null
			mesh_arm_left.skin = a.skin if a != null else null
			mesh_arm_right.mesh = a.mesh_arm_right if a != null else null
			mesh_arm_right.skin = a.skin if a != null else null
			mesh_armor.mesh = a.mesh_armor if a != null else null
			mesh_armor.skin = a.skin if a != null else null
			mesh_leg_left.mesh = a.mesh_leg_left if a != null else null
			mesh_leg_left.skin = a.skin if a != null else null
			mesh_leg_right.mesh = a.mesh_leg_right if a != null else null
			mesh_leg_right.skin = a.skin if a != null else null
		EquipmentSlotResource.SlotType.Accessory:
			var a := item as ArmorResource
			var target: MeshInstance3D = null
			match sub_index:
				0: target = mesh_accessory_1
				1: target = mesh_accessory_2
				2: target = mesh_accessory_3
			if target != null:
				target.mesh = a.mesh_accessory if a != null else null
				target.skin = a.skin if a != null else null
			
		EquipmentSlotResource.SlotType.Weapon:
			if item == null:
				if hand == &"off":
					off_hand_weapon.clear_weapon()
				else:
					main_hand_weapon.clear_weapon()
				update_dual_wielding_state()
				return
				
			var w:= item as WeaponResource
			if w == null:
				return
				
			if hand == &"off":
				var mh := main_hand_weapon.WEAPON_TYPE
				if mh != null and mh.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
					main_hand_weapon.clear_weapon()
				off_hand_weapon.load_weapon(w)
			else:
				if w != null and w.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
					off_hand_weapon.clear_weapon()
				main_hand_weapon.load_weapon(w)
			update_dual_wielding_state()

func _on_targets_in_range_body_entered(body: Node3D) -> void:
	if not body.is_in_group("enemy") or body.is_dead :
		return
	
	if not enemies_in_range.has(body):
		enemies_in_range.append(body)
		
	_update_closest_target()

func _on_targets_in_range_body_exited(body: Node3D) -> void:
	if enemies_in_range.has(body):
		enemies_in_range.erase(body)
	
	_update_closest_target()

#--------- Animations -----------
func play_idle_animation() -> void:
	if anim_state:
		if main_hand_weapon.weapon_handedness == WeaponResource.HANDEDNESS.TWO_HANDED and main_hand_weapon.WEAPON_TYPE != null and not weapon_is_sheathed:
			anim_state.travel("2_Handed_Weapom_Idle")
		elif main_hand_weapon.weapon_handedness == WeaponResource.HANDEDNESS.ONE_HANDED or main_hand_weapon.WEAPON_TYPE == null or weapon_is_sheathed:
			anim_state.travel("Idle")
func play_run_animation() -> void:
	if anim_state:
		anim_state.travel("Run")
func play_attack_1_animation() -> void:
	if main_hand_weapon.WEAPON_TYPE != null and main_hand_weapon.WEAPON_TYPE.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
		if anim_state:
			anim_state.travel("2_Hand_Attack_1")
	if is_dual_wielding:
		if anim_state:
			anim_state.travel("Dualwield_Attack_1")
	if main_hand_weapon.WEAPON_TYPE != null and main_hand_weapon.WEAPON_TYPE.handedness == WeaponResource.HANDEDNESS.ONE_HANDED and not is_dual_wielding:
		if anim_state:
			anim_state.travel("1_Hand_Attack_1")
func play_attack_2_animation() -> void:
	if main_hand_weapon.WEAPON_TYPE != null and main_hand_weapon.WEAPON_TYPE.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
		if anim_state:
			anim_state.travel("2_Hand_Attack_2")
	if is_dual_wielding:
		if anim_state:
			anim_state.travel("Dualwield_Attack_2")
	if main_hand_weapon.WEAPON_TYPE != null and main_hand_weapon.WEAPON_TYPE.handedness == WeaponResource.HANDEDNESS.ONE_HANDED and not is_dual_wielding:
		if anim_state:
			anim_state.travel("1_Hand_Attack_2")
func play_attack_3_animation() -> void:
	if main_hand_weapon.WEAPON_TYPE != null and main_hand_weapon.WEAPON_TYPE.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
		if anim_state:
			anim_state.travel("2_Hand_Attack_3")
	if is_dual_wielding:
		if anim_state:
			anim_state.travel("Dualwield_Attack_3")
	if main_hand_weapon.WEAPON_TYPE != null and main_hand_weapon.WEAPON_TYPE.handedness == WeaponResource.HANDEDNESS.ONE_HANDED and not is_dual_wielding:
		if anim_state:
			anim_state.travel("1_Hand_Attack_3")
func play_death_animation() -> void:
	anim_state.travel("Death")
func play_hurt_animation() -> void:
	anim_state.travel("Hurt")
func play_hurt_run_animation() -> void:
	anim_state.travel("Running_Hurt")
