extends Node

signal new_chunk_generated
signal hotbar_swapped
signal enter_shop
signal death

var in_shop : bool = false

var chunks : Dictionary[Vector2i, Node2D]

var pickaxe_tier : int = 0
var axe_tier : int = 0
var sword_tier : int = 0

var money : int = 10000
var money_mult : float = 0.25
var chunk_money_mult : float = 0.25
var selected_slot : int = 0

var current_tool_sprite : Texture2D

var health : float = 4
var max_health : float = 5
var land_mines : int = 0
var walk_speed : float = 20
var dash_speed  : float = 100
var attack_speed : float = 1


var pickaxes : Array[Dictionary] = [
	{'name': "Wood Pickaxe", 'damage': 1, 'sprite': "res://sprites/tools/pickaxe/wood_pickaxe.png"},
	{'name': "Copper Pickaxe", 'damage': 2, 'sprite': "res://sprites/tools/pickaxe/copper_pickaxe.png"},
	{'name': "Iron Pickaxe", 'damage': 3, 'sprite': "res://sprites/tools/pickaxe/iron_pickaxe.png"},
	{'name': "Ruby Pickaxe", 'damage': 5, 'sprite': "res://sprites/tools/pickaxe/ruby_pickaxe.png"}
	] 

var axes : Array[Dictionary] = [
	{'name': "Wood Axe", 'damage': 1, 'sprite': "res://sprites/tools/axe/wood_axe.png"},
	{'name': "Copper Axe", 'damage': 2, 'sprite': "res://sprites/tools/axe/copper_axe.png"},
	{'name': "Iron Axe", 'damage': 3, 'sprite': "res://sprites/tools/axe/iron_axe.png"},
	{'name': "Ruby Axe", 'damage': 5, 'sprite': "res://sprites/tools/axe/ruby_axe.png"}
	] 

var swords : Array[Dictionary] = [
	{'name': "Wood Sword", 'damage': 1, 'sprite': "res://sprites/tools/sword/wood_sword.png"},
	{'name': "Copper Sword", 'damage': 2, 'sprite': "res://sprites/tools/sword/copper_sword.png"},
	{'name': "Iron Sword", 'damage': 3, 'sprite': "res://sprites/tools/sword/iron_sword.png"},
	{'name': "Ruby Sword", 'damage': 5, 'sprite': "res://sprites/tools/sword/ruby_sword.png"}
	] 
	
	
var upgrades : Array = [
	{'name': "New Pickaxe", 'cost': 50, 'sprite': "res://sprites/tools/pickaxe/wood_pickaxe.png", 'tool': 0, 'mult': 2},
	{'name': "New Axe", 'cost': 50, 'sprite': "res://sprites/tools/axe/wood_axe.png", 'tool': 1, 'mult': 2},
	{'name': "New Sword", 'cost': 50, 'sprite': "res://sprites/tools/sword/wood_sword.png", 'tool': 2, 'mult': 2},
	{'name': "Walk Faster", 'cost': 30, 'sprite': "res://sprites/walk_upgrade.png", 'var': 1, 'inc_mult': 1.25, 'mult': 1.25},
	{'name': "Dash Faster", 'cost': 25, 'sprite': "res://sprites/dash_upgrade.png", 'var': 2, 'inc_mult': 1.3, 'mult': 1.25},
	{'name': "Swing Faster", 'cost': 75, 'sprite': "res://sprites/swing_upgrade.png", 'var': 3, 'inc_mult': 1.25, 'mult': 1.25},
	{'name': "More Health", 'cost': 50, 'sprite': "res://sprites/heart_plus.png", 'var': 4, 'inc_add': 1, 'mult': 1.25},
	{'name': "Recover Health", 'cost': 15, 'sprite': "res://sprites/heart_16.png", 'var': 5, 'recover' : true},
	{'name': "+Money Per Chunk", 'cost': 50, 'sprite': "res://sprites/money_chunk.png", 'var': 6, 'inc_add': 0.35, 'mult': 1.25},
	{'name': "+Money Per Object", 'cost': 50, 'sprite': "res://sprites/money_object.png", 'var': 7, 'inc_add': 0.25, 'mult': 1.25},
	{'name': "Landmine (x1)", 'cost': 10, 'sprite': "res://sprites/enemies/pumpkin.png", 'mult': 1.1, 'var': 8, 'inc_add': 1},
	{'name': "Landmine (x3)", 'cost': 25, 'sprite': "res://sprites/enemies/pumpkin.png", 'mult': 1.1, 'var': 8, 'inc_add': 3},
	{'name': "Landmine (x5)", 'cost': 40, 'sprite': "res://sprites/enemies/pumpkin.png", 'mult': 1.1, 'var': 8, 'inc_add': 5},
	]
	
var tips : PackedStringArray = [
	"Check Settings [ESC] for controls.",
	"Use the right tool for the job!",
	"More money = more good.",
	"Place landmines [Q] to blow up enemies.",
	"Talk to the Guide if you are stuck.",
	"Subscribe to GlaggleWares!",
	"Focus on one chunk at a time.",
	"Kill enemies before mining other objects.",
	"Buy more upgrades!",
	"If you dont like the shop's upgrades, re-roll!",
	"Press [CTRL] or [SHIFT] to dash!",
	"Use the arrow keys to attack in a certain direction!",
	"Unlock as many chunks as possible!"
]


var volumes : Dictionary[String, float] = {
	'master' : 50,
	'music' : 50,
	'sfx' : 50
	
}

const save_path : String = "user://save.save"

func _ready() -> void:
	load_data()
	
func load_data() -> void:
	pass
	
func save() -> void:
	pass
	
func save_and_quit() -> void:
	save()
	await get_tree().create_timer(0).timeout
	get_tree().quit()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_and_quit()
