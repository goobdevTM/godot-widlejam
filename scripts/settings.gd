extends Control

@onready var master: HSlider = $Panel/Master
@onready var controls: Panel = $Controls
@onready var dark_bg: Panel = $DarkBG
@onready var panel: Panel = $Panel
@onready var score: RichTextLabel = $Panel/Score

@onready var master_slider: HSlider = $Panel/Master
@onready var master_title: RichTextLabel = $Panel/Master/Title

@onready var music_slider: HSlider = $Panel/Music
@onready var music_title: RichTextLabel = $Panel/Music/Title

@onready var sfx_slider: HSlider = $Panel/SFX
@onready var sfx_title: RichTextLabel = $Panel/SFX/Title

@onready var quit_button: Button = $Panel/QuitButton

@export var in_game = false

var animating : bool = false

func _ready() -> void:
	master_slider.value = Global.volumes['master']
	master_title.text = "[center]Master: " + str(int(Global.volumes['master']))
	
	music_slider.value = Global.volumes['music']
	music_title.text = "[center]Music: " + str(int(Global.volumes['music']))
	
	sfx_slider.value = Global.volumes['sfx']
	sfx_title.text = "[center]SFX: " + str(int(Global.volumes['sfx']))
	
	AudioServer.set_bus_volume_linear(0, master_slider.value / 60)
	AudioServer.set_bus_volume_linear(1, music_slider.value / 60)
	AudioServer.set_bus_volume_linear(2, sfx_slider.value / 60)
	hide()
	

func _input(event) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("escape"):
			if not Global.in_shop:
				if visible:
					close()
				else:
					open()


func open() -> void:
	if not visible:
		if not animating:
			Global.check_highscore()
			score.text = "Score:
-Enemies: " + str(Global.score[0]) + "
-Chunks: " + str(Global.score[1]) + "
-Money: " + str(Global.score[2]) + "

Highscore:
-Enemies: " + str(Global.highscore[0]) + "
-Chunks: " + str(Global.highscore[1]) + "
-Money: " + str(Global.highscore[2])


			dark_bg.modulate = Color("290c0700")
			panel.scale = Vector2(0,0)
			get_tree().paused = true
			animating = true
			show()
			dark_bg.show()
			var tween : Tween = create_tween()
			tween.set_parallel()
			tween.tween_property(panel, "scale", Vector2(1,1), 0.1)
			tween.tween_property(dark_bg, "modulate", Color("290c07c8"), 0.1)
			animating = false
			
func close() -> void:
	if visible:
		if not animating:
			get_tree().paused = false
			animating = true
			var tween : Tween = create_tween()
			tween.set_parallel()
			tween.tween_property(panel, "scale", Vector2(0,0), 0.1)
			tween.tween_property(dark_bg, "modulate", Color("290c0700"), 0.1)
			await tween.finished
			hide()
			dark_bg.hide()
			animating = false

func _on_controls_button_pressed() -> void:
	if not animating:
		animating = true
		controls.show()
		controls.scale = Vector2(0,0)
		var tween : Tween = create_tween()
		tween.tween_property(controls, "scale", Vector2(1,1), 0.1)
		await tween.finished
		animating = false


func _on_controls_back_button_pressed() -> void:
	if not animating:
		animating = true
		var tween : Tween = create_tween()
		tween.tween_property(controls, "scale", Vector2(0,0), 0.1)
		await tween.finished
		controls.hide()
		animating = false


func _on_master_value_changed(value: float) -> void:
	Global.volumes['master'] = value
	AudioServer.set_bus_volume_linear(0,value / 60)
	master_title.text = "[center]Master: " + str(int(Global.volumes['master']))


func _on_music_value_changed(value: float) -> void:
	Global.volumes['music'] = value
	AudioServer.set_bus_volume_linear(1,value / 60)
	music_title.text = "[center]Music: " + str(int(Global.volumes['music']))
	
func _on_sfx_value_changed(value: float) -> void:
	Global.volumes['sfx'] = value
	AudioServer.set_bus_volume_linear(2,value / 60)
	sfx_title.text = "[center]SFX: " + str(int(Global.volumes['sfx']))


func _on_quit_button_pressed() -> void:
	Global.save_and_quit()
