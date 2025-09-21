extends Node2D

@onready var settings: Control = $Settings
@onready var hi: AudioStreamPlayer = $"../Hi"
@onready var bye: AudioStreamPlayer = $"../Bye"


func _on_settings_pressed() -> void:
	settings.open()


func _on_quit_pressed() -> void:
	bye.play()
	await bye.finished
	Global.save_and_quit()


func _on_play_pressed() -> void:
	get_parent().enter_game()
