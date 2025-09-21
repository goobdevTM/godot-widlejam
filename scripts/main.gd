extends Node2D

const GAME = preload("uid://dtivlhk22so28")
const MENU = preload("uid://d3wuvidfbkx1y")



@onready var fade: ColorRect = $CanvasLayer/Fade

@onready var menu: Node2D = $Menu
var game : Node2D = null

signal fade_done

# Called when the node enters the scene tree for the first time.
func exit_game() -> void:
	fade_in()
	await fade_done
	Global.emit_signal("quit")
	game.queue_free()
	Global.save()
	menu = MENU.instantiate()
	add_child(menu)
	move_child(menu, 0)
	fade_out()
	
func enter_game() -> void:
	fade_in()
	await fade_done
	menu.queue_free()
	game = GAME.instantiate()
	add_child(game)
	move_child(game, 0)
	fade_out()
	
func fade_in() -> void:
	fade.show()
	var tween : Tween = create_tween()
	fade.color = Color(0,0,0,0)
	tween.tween_property(fade, "color", Color(0,0,0,1), 1)
	await tween.finished
	emit_signal("fade_done")
	
func fade_out() -> void:
	var tween : Tween = create_tween()
	fade.color = Color(0,0,0,1)
	tween.tween_property(fade, "color", Color(0,0,0,0), 1)
	await tween.finished
	fade.hide()
	emit_signal("fade_done")
