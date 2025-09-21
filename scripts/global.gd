extends Node

signal new_chunk_generated
signal hotbar_swapped
signal enter_shop
var chunks : Dictionary[Vector2i, Node2D]

var pickaxe_tier : int = 0
var axe_tier : int = 0
var sword_tier : int = 0

var money : int = 0
var money_mult : float = 0.25
var chunk_money_mult : float = 0.25
var selected_slot : int = 0

var current_tool_sprite : Texture2D


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
	{'name': "Walk Faster", 'cost': 30, 'sprite': "res://sprites/enemies/pumpkin.png"},
	{'name': "Dash Faster", 'cost': 25, 'sprite': "res://sprites/enemies/pumpkin.png"},
	{'name': "Swing Faster", 'cost': 75, 'sprite': "res://sprites/enemies/pumpkin.png"},
	{'name': "More Health", 'cost': 50, 'sprite': "res://sprites/enemies/pumpkin.png"},
	{'name': "Recover Health", 'cost': 15, 'sprite': "res://sprites/enemies/pumpkin.png"},
	{'name': "+Money Per Chunk", 'cost': 50, 'sprite': "res://sprites/enemies/pumpkin.png"},
	{'name': "+Money Per Object", 'cost': 50, 'sprite': "res://sprites/enemies/pumpkin.png"},
	{'name': "Landmine (x1)", 'cost': 10, 'sprite': "res://sprites/enemies/pumpkin.png", 'mult': 1.25},
	{'name': "Landmine (x3)", 'cost': 25, 'sprite': "res://sprites/enemies/pumpkin.png", 'mult': 1.25},
	{'name': "Landmine (x5)", 'cost': 40, 'sprite': "res://sprites/enemies/pumpkin.png", 'mult': 1.25},
	]
