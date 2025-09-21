extends CharacterBody2D


@export var max_health : int = 5
@export var damage : int = 1
@export var speed : int = 18

@onready var model: Node2D = $Model
@onready var eyes: Sprite2D = $Model/Eyes
@onready var hurt_player_area: Area2D = $HurtPlayerArea
@onready var anim: AnimationPlayer = $Model/Anim
@onready var hurt_sound: AudioStreamPlayer2D = $Hurt
@onready var death_sound: AudioStreamPlayer2D = $Death
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var sprite: AnimatedSprite2D = $Model/AnimatedSprite2D


var friction : float = 0.7
var direction : Vector2
var health : float
var dead : bool = false

var player : CharacterBody2D

var player_in_hurt : bool = false

func _ready() -> void:
	speed *= (Global.walk_speed / 120) + 0.5
	speed *= randf_range(0.9, 1.1)
	hurt_player_area.position = Vector2(100000000,0)
	hurt_player_area.scale = Vector2(0,0)
	health = max_health
	await get_tree().create_timer(1).timeout
	hurt_player_area.scale = Vector2(1,1)
	hurt_player_area.position = Vector2(0,0)

func _physics_process(delta: float) -> void:

	if player:
		direction = player.global_position - global_position
	
	velocity += direction.normalized() * speed
	velocity *= friction
	
	sprite.speed_scale = velocity.length()
	
	eyes.position = direction.normalized()
	
	if direction.x:
		if direction.x > 0:
			eyes.scale.x = 1
			hurt_player_area.scale.x = 1
		else:
			eyes.scale.x = -1
			hurt_player_area.scale.x = -1
		
	move_and_slide()
	


func _on_player_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_player_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null


func _on_hurt_player_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_hurt = true
		while player_in_hurt:
			body.take_damage(damage)
			await get_tree().create_timer(0.06).timeout


func _on_hurt_player_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_hurt = false
		
func take_damage(amount : int) -> void:
	if not dead:
		anim.play("hurt")
		hurt_sound.play()
		health -= amount
		if health <= 0:
			particles.emitting = true
			dead = true
			hurt_sound.stop()
			death_sound.play()
			hurt_player_area.position = Vector2(0,10000000000)
			anim.play("fade")
			await anim.animation_finished
			queue_free()
