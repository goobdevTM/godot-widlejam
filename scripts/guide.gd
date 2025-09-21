extends Node2D

@onready var anim: AnimationPlayer = $Hint/Anim
@onready var hint_text: RichTextLabel = $Hint
@onready var speak: AudioStreamPlayer2D = $Speak


var tips_said : int = 0
var in_area : bool = false

func _on_talk_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = true
		hint_text.text = "[center]

[E] - ask for help"
		anim.play("open")
		while in_area:
			if Input.is_action_just_pressed("interact"):
				talk()
			await get_tree().create_timer(0).timeout

func _on_talk_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = false
		anim.play("close")
		
func talk() -> void:
	hint_text.visible_characters = 0
	if tips_said > 3:
		hint_text.text = "[center]" + Global.tips[randi_range(0, len(Global.tips) - 1)] + " [E]"
	else:
		match tips_said:
			0:
				hint_text.text = "[center]Chop [ARROW KEYS] that stump over there to unlock more chunks. [E]"
			1:
				hint_text.text = "[center]Check Setttings [ESC] if you need to see controls. [E]"
			2:
				hint_text.text = "[center]Watch out for enemies! They spawn from broken objects. [E]"
			3:
				hint_text.text = "[center]Buy some upgrades with your new money! [E]"
	tips_said += 1
	for i in hint_text.text:
		hint_text.visible_characters += 1
		speak.play()
		await get_tree().create_timer(0.05).timeout
		if in_area == false:
			tips_said -= 1
			break
	
