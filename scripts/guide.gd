extends Node2D

@onready var anim: AnimationPlayer = $Hint/Anim


var in_area : bool = false

func _on_talk_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = true
		anim.play("open")
		while in_area:
			if Input.is_action_just_pressed("interact"):
				Global.emit_signal("enter_shop")
			await get_tree().create_timer(0).timeout

func _on_talk_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = false
		anim.play("close")
