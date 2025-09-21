extends Node2D

@export var max_health : int = 10
@export var enemy : PackedScene
@export var max_enemies : int = 3

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimatedSprite2D/Anim
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var area: Area2D = $Area2D
@onready var staticbody: StaticBody2D = $StaticBody2D
@onready var chunk: Node2D = $"../../"
@onready var mine_sound: AudioStreamPlayer2D = $MineSound
@onready var break_sound: AudioStreamPlayer2D = $BreakSound

var unc : bool = false
var health : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_enemies += (Vector2(0,0).distance_to(global_position) / 400)
	print("max enemies: ")
	print(max_enemies)
	health = max_health
	chunk.object_list.append(self)
	await get_tree().create_timer(0).timeout
	await get_tree().create_timer(0).timeout
	unc = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func hit(damage : int) -> void:
	health -= damage
	if health >= 0:
		mine_sound.play()
		if health >= max_health / 3:
			sprite.play("break2")
		if health >= (max_health / 3) * 2:
			sprite.play("break1")
		if health >= max_health:
			sprite.play("break1")
		particles.amount = randi_range(7,9)
		particles.emitting = true
		var rand : int = randi_range(1,3)
		match rand:
			1:
				anim.play("hit")
			2:
				anim.play("hit2")
			3:
				anim.play("hit3")
		
	else:
		if enemy:
			for i in range(randi_range(0,max_enemies)):
				var new_enemy : CharacterBody2D = enemy.instantiate()
				get_parent().get_parent().get_parent().add_child(new_enemy)
				new_enemy.global_position = global_position + Vector2(randi_range(-20,20), randi_range(-10,10))
		Global.money += max_health * Global.money_mult
		break_sound.play()
		sprite.queue_free()
		area.queue_free()
		staticbody.queue_free()
		particles.amount = 16
		particles.emitting = true
		await particles.finished
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("pickaxe") or area.get_parent().is_in_group("axe") or area.get_parent().is_in_group("sword"):
		if not unc:
			area.get_parent().unc = true
			queue_free()
