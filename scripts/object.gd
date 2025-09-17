extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimatedSprite2D/Anim
@onready var particles: GPUParticles2D = $GPUParticles2D
@export var max_health : int = 1
@onready var area: Area2D = $Area2D
@onready var staticbody: StaticBody2D = $StaticBody2D
@onready var chunk: Node2D = $"../../"

var health : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	chunk.object_list.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func hit(damage : int) -> void:
	health -= damage
	if health >= 0:
		if health >= max_health / 3:
			sprite.play("break2")
		if health >= (max_health / 3) * 2:
			sprite.play("break1")
		if health >= max_health:
			sprite.play("break1")
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
		sprite.queue_free()
		area.queue_free()
		staticbody.queue_free()
		particles.amount *= 2
		particles.emitting = true
		await particles.finished
		queue_free()
