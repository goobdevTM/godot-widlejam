extends Control

var animating : bool = false
@onready var upgrade_container: HBoxContainer = $Upgrades
@onready var reroll_button: Button = $Reroll
@onready var dark_bg: Panel = $"../DarkBG"
@onready var reroll_sfx: AudioStreamPlayer = $"../../Reroll"
@onready var money_sfx: AudioStreamPlayer = $"../../Money"
@onready var buzzer: AudioStreamPlayer = $"../../Buzzer"

var reroll_cost : int = 3
var upgrades : Array = [{},{},{}]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Global.enter_shop.connect(open)
	reroll(false)
	
	
func open() -> void:
	if not visible:
		if not animating:
			Global.in_shop = true
			dark_bg.modulate = Color("290c0700")
			scale = Vector2(0,0)
			get_tree().paused = true
			animating = true
			show()
			dark_bg.show()
			var tween : Tween = create_tween()
			tween.set_parallel()
			tween.tween_property(self, "scale", Vector2(1,1), 0.1)
			tween.tween_property(dark_bg, "modulate", Color("290c07c8"), 0.1)
			animating = false
			
func close() -> void:
	if visible:
		if not animating:
			Global.in_shop = false
			get_tree().paused = false
			animating = true
			var tween : Tween = create_tween()
			tween.set_parallel()
			tween.tween_property(self, "scale", Vector2(0,0), 0.1)
			tween.tween_property(dark_bg, "modulate", Color("290c0700"), 0.1)
			await tween.finished
			hide()
			dark_bg.hide()
			animating = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func reroll(spend_money : bool = true) -> void:
	if spend_money:
		if Global.money >= reroll_cost:
			reroll_sfx.play()
			reroll_cost += 1
			Global.money -= reroll_cost
		else:
			buzzer.play()
			return
	reroll_button.text = "Reroll ($" + str(reroll_cost) + ")"
	upgrades = [{},{},{}]
	var index : int = 0
	if Global.pickaxe_tier >= 3:
		Global.upgrades[0] = {}
	if Global.axe_tier >= 3:
		Global.upgrades[1] = {}
	if Global.sword_tier >= 3:
		Global.upgrades[2] = {}
	for i in upgrade_container.get_children():
		i.pressed.disconnect(button_pressed)
		i.disabled = false
		var current_upgrade : Dictionary
		var upgrade_idx : int
		while current_upgrade == {}:
			upgrade_idx = randi_range(0, len(Global.upgrades) - 1)
			current_upgrade = Global.upgrades[upgrade_idx]
			upgrades[index] = current_upgrade
			
		i.get_child(0).texture = load(current_upgrade['sprite'])
		i.get_child(1).text = "[center]$" + str(current_upgrade['cost'])
		i.get_child(2).text = "[center]" + str(current_upgrade['name'])
		if current_upgrade.has('tool'):
			match current_upgrade.tool:
				0:
					i.get_child(0).texture = load(Global.pickaxes[Global.pickaxe_tier + 1]['sprite'])
					i.get_child(2).text = "[center]" + str(Global.pickaxes[Global.pickaxe_tier + 1]['name'])
				1:
					i.get_child(0).texture = load(Global.axes[Global.axe_tier + 1]['sprite'])
					i.get_child(2).text = "[center]" + str(Global.axes[Global.axe_tier + 1]['name'])
				2:
					i.get_child(0).texture = load(Global.swords[Global.sword_tier + 1]['sprite'])
					i.get_child(2).text = "[center]" + str(Global.swords[Global.sword_tier + 1]['name'])
		
		i.pressed.connect(button_pressed.bind(i, current_upgrade, upgrade_idx))
		
		index += 1
		
func button_pressed(button : Button, upgrade : Dictionary, upgrade_idx):
	print(upgrade)
	if not Global.money >= upgrade['cost']:
		buzzer.play()
		return
	if reroll_cost > 3:
		reroll_cost -= 1
		if reroll_cost >= 5:
			reroll_cost -= 2
			if reroll_cost >= 10:
				reroll_cost -= 3
				if reroll_cost >= 20:
					reroll_cost -= 4
					if reroll_cost >= 30:
						reroll_cost -= 5
	reroll_button.text = "Reroll ($" + str(reroll_cost) + ")"
	money_sfx.play()
	button.disabled = true
	Global.money -= upgrade.cost
	if upgrade.has('mult'):
		Global.upgrades[upgrade_idx]['cost'] *= upgrade['mult']
	else:
		Global.upgrades[upgrade_idx]['cost'] *= 1.5
	Global.upgrades[upgrade_idx]['cost'] = int(round(Global.upgrades[upgrade_idx]['cost']))
	if upgrade.has('tool'):
		match upgrade['tool']:
			0:
				print("pickaxe upgrade")
				Global.pickaxe_tier += 1
			1:
				print("axe upgrade")
				Global.axe_tier += 1
			2:
				print("sword upgrade")
				Global.sword_tier += 1
		await get_tree().create_timer(0).timeout
		Global.emit_signal("hotbar_swapped")
	if upgrade.has('var'):
		match upgrade['var']:
			1:
				Global.walk_speed *= upgrade['inc_mult']
			2:
				Global.dash_speed *= upgrade['inc_mult']
			3:
				Global.attack_speed /= upgrade['inc_mult']
			4:
				Global.max_health += upgrade['inc_add']
				Global.health += (upgrade['inc_add'] / 2)
			5:
				Global.health = Global.max_health
			6:
				Global.money_mult += upgrade['inc_add']
			7:
				Global.chunk_money_mult += upgrade['inc_add']
			8:
				Global.land_mines += upgrade['inc_add']

	await get_tree().create_timer(0).timeout
	reroll(false)

		
		

		
func _input(event: InputEvent) -> void:
	if visible and animating == false:
		if event is InputEventKey:
			if Input.is_action_just_pressed("escape") or Input.is_action_just_pressed("interact"):
				close()
