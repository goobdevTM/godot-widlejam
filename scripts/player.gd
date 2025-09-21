extends CharacterBody2D

class_name Player

@onready var model: Node2D = $Model
@onready var anim: AnimationPlayer = $Model/Anim
@onready var dash_effects: Node2D = $"../Effects/Dash"
@onready var eyes: AnimatedSprite2D = $Model/Eyes
@onready var walk_particles: Node2D = $WalkParticles
@onready var hand_offset: Node2D = $HandOffset
@onready var hand: Node2D = $HandOffset/Hand
@onready var punch_sound: AudioStreamPlayer = $PunchSound
@onready var tool_sprite: Sprite2D = $HandOffset/Hand/Tool
@onready var hand_collision: CollisionShape2D = $HandOffset/Hand/Tool/HandArea/CollisionShape2D


enum ToolTypes {
	PICKAXE,
	AXE,
	SWORD
}

const WALK_SPEED : int = 100
const DASH_SPEED : int = 200

var attack_speed : float = 0.05
var speed : int = 20
var friction : float = 0.7
var direction : Vector2
var dash_cooldown : float = 0
var dashes : int = 0
var walking : bool = false
var swing_dir : Vector2
var swinging : bool = false
var swing_cooldown : float = 0
var tool_type : ToolTypes = ToolTypes.SWORD

func _ready() -> void:
	Global.hotbar_swapped.connect(change_tool)
	await get_tree().create_timer(0).timeout
	Global.emit_signal("hotbar_swapped")

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	dash_cooldown -= delta
	swing_cooldown -= delta
	
	if Input.is_action_just_pressed("dash") and dash_cooldown <= 0:
		speed = DASH_SPEED
		dash_cooldown = 2
		dash(dashes)
		dashes += 1
		
		
		
	if swing_cooldown <= attack_speed - (attack_speed / 5):
		hand_collision.disabled = true
		swinging = false
	
	swing_dir = Input.get_vector("swing_left", "swing_right", "swing_up", "swing_down")
	var old_rot : float = hand_offset.rotation
	hand_offset.look_at(position + swing_dir)
	tool_sprite.look_at(position + swing_dir)
	tool_sprite.rotation += deg_to_rad(-90)
	var new_rot : float = hand_offset.rotation
	hand_offset.rotation = old_rot
	hand_offset.rotation = lerp(hand_offset.rotation, new_rot, delta * 20)
	if swing_dir and swing_cooldown <= 0:
		punch_sound.play()
		hand_collision.disabled = false
		swinging = true
		swing_cooldown = attack_speed
		hand.position = Vector2(0,0)
		
	if swinging:
		tool_sprite.scale = lerp(tool_sprite.scale, Vector2(1,1), delta * 60)
		hand.position = lerp(hand.position, Vector2(24,0), delta * 40)
	else:
		tool_sprite.scale = lerp(tool_sprite.scale, Vector2(0,0), delta * 20)
		hand.position = lerp(hand.position, Vector2(0,0), delta * 12)
		
	hand.global_rotation = 0
		
	direction = Input.get_vector("left", "right", "up", "down")
	
	velocity += direction.normalized() * speed
	velocity *= friction
	
	eyes.position = direction
	
	if direction:
		if walking == false:
			for i : GPUParticles2D in walk_particles.get_children():
				i.emitting = true
		walking = true
	else:
		if walking == true:
			for i : GPUParticles2D in walk_particles.get_children():
				i.emitting = false
		walking = false
	
	speed = lerp(speed, WALK_SPEED, delta * 20)
	
	
	if Input.is_action_just_pressed("1"):
		tool_type = ToolTypes.SWORD
		Global.selected_slot = 0
		Global.emit_signal("hotbar_swapped")
		
	if Input.is_action_just_pressed("2"):
		tool_type = ToolTypes.PICKAXE
		Global.selected_slot = 1
		Global.emit_signal("hotbar_swapped")
		
	if Input.is_action_just_pressed("3"):
		tool_type = ToolTypes.AXE
		Global.selected_slot = 2
		Global.emit_signal("hotbar_swapped")
		
		
	move_and_slide()
	
func change_tool() -> void:
	await get_tree().create_timer(0).timeout
	tool_sprite.texture = Global.current_tool_sprite

func dash(dash_idx) -> void:
	for i in range(3):
		var new_model = model.duplicate()
		var new_anim = new_model.get_child(0)
		dash_effects.add_child(new_model)
		new_anim.play("fade")
		new_model.global_position = global_position
		new_model.set_meta("dash_idx", dash_idx)
		await get_tree().create_timer(0.05).timeout
	for i in dash_effects.get_children():
		if i.get_meta("dash_idx") == dash_idx:
			await i.get_child(0).animation_finished
			if i.is_inside_tree():
				i.queue_free()


func _on_hand_area_area_entered(area: Area2D) -> void:
	var object : Node2D = area.get_parent()
	match tool_type:
		ToolTypes.PICKAXE:
			if object.is_in_group("pickaxe"):
				object.hit(Global.pickaxes[Global.pickaxe_tier]['damage'])
		ToolTypes.AXE:
			if object.is_in_group("axe"):
				object.hit(Global.axes[Global.axe_tier]['damage'])
		ToolTypes.SWORD:
			if object.is_in_group("sword"):
				object.hit(Global.swords[Global.sword_tier]['damage'])
