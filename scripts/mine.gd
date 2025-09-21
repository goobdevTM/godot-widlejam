extends Node2D

@onready var explosion: AudioStreamPlayer2D = $Explosion

var enemies_to_explode : Array[CharacterBody2D] = []
var player_to_explode : CharacterBody2D = null
var enabled : bool = false

func _on_explode_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemies_to_explode.append(body)
	if body.is_in_group("player"):
		player_to_explode = body


func _on_explode_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemies_to_explode.erase(body)
	if body.is_in_group("player"):
		player_to_explode = null


func _on_detect_body_entered(body: Node2D) -> void:
	if enabled:
		explosion.play()
		await get_tree().create_timer(0.05).timeout
		for i in enemies_to_explode:
			i.take_damage(99999)
		if player_to_explode:
			player_to_explode.take_damage(99999)


func _on_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		enabled = true
