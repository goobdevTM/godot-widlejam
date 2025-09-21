extends CharacterBody2D


@onready var model: Node2D = $Model
@onready var eyes: Sprite2D = $Model/Eyes

var speed : int = 10
var friction : float = 0.7
var direction : Vector2

var player : CharacterBody2D

func _physics_process(delta: float) -> void:

	if player:
		direction = player.global_position - global_position
	
	velocity += direction.normalized() * speed
	velocity *= friction
	
	eyes.position = direction.normalized()
	
	if direction.x:
		if direction.x > 0:
			eyes.scale.x = 1
		else:
			eyes.scale.x = -1
	
		
	move_and_slide()
	


func _on_player_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_player_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
