extends CanvasLayer


# Top-down camera used for minimap
# player instance to make the camera follow
@onready var sub_viewport: SubViewport = $Minimap/MinimapContainer/SubViewport
@onready var mini_camera: Camera2D = $Minimap/MinimapContainer/SubViewport/Camera2D
@onready var player: Player = $"../Player"
@onready var minimap_coords: RichTextLabel = $Minimap/MinimapCoords
@onready var hud: HBoxContainer = $HUD
@onready var money: RichTextLabel = $Money

var coords : Vector2i


# Thanks to: https://stackoverflow.com/questions/77315722/split-screen-in-godot-3d-with-a-single-scene-containing-2-cameras
# For teaching me how to render with 2 cameras without scene replication as in general SubViewport usage


func _ready() -> void:
	sub_viewport.world_2d = get_viewport().world_2d
	Global.hotbar_swapped.connect(update_hud)
	
func _process(delta: float) -> void:
	money.text = "[right]$" + str(Global.money)
	coords = round(Vector2(player.global_position.x, - player.global_position.y) / 256)
	mini_camera.global_position = lerp(mini_camera.global_position, round(player.global_position / 256) * 256, delta * 8)
	minimap_coords.text = "[center][X:" + str(coords.x) + " Y:" + str(coords.y) + "]"

func update_hud() -> void:
	var index : int = 0
	for i in hud.get_children():
		match index:
			0:
				i.get_child(1).texture = load(Global.swords[Global.sword_tier]['sprite'])
			1:
				i.get_child(1).texture = load(Global.pickaxes[Global.pickaxe_tier]['sprite'])
			2:
				i.get_child(1).texture = load(Global.axes[Global.axe_tier]['sprite'])
				
		if Global.selected_slot == index:
			i.get_child(0).play("hover")
			Global.current_tool_sprite = i.get_child(1).texture
		else:
			i.get_child(0).play("default")
		index += 1
