extends Node2D

@onready var up: VisibleOnScreenNotifier2D = $VisualBorders/Up
@onready var down: VisibleOnScreenNotifier2D = $VisualBorders/Down
@onready var left: VisibleOnScreenNotifier2D = $VisualBorders/Left
@onready var right: VisibleOnScreenNotifier2D = $VisualBorders/Right

@onready var game: Node2D = $"../.."

@onready var grass: TileMapLayer = $Grass
@onready var objects: TileMapLayer = $Objects

@onready var barriers: StaticBody2D = $Barriers
@onready var color_barriers: Node2D = $Grass/ColorBarriers

@onready var text_data: RichTextLabel = $Grass/TextData


@export var first : bool = false

@onready var object_removed_detect: Area2D = $ObjectRemovedDetect


signal finished

var chunk_pos : Vector2i = Vector2i(0,0)

var has_neigbors : bool = false

var neighbors : Array = [null, null, null, null]

var unc : bool = false

var complete : bool = false

var object_list : Array[Node2D] = []

var on_screen : bool
	
func _ready() -> void:
	if first:
		text_data.hide()
	chunk_pos = Vector2i(round(global_position / 256))
	if Global.chunks.has(chunk_pos):
		queue_free()
	#scale = Vector2(randf_range(0.5, 1), randf_range(0.5, 1))
	while not Global.chunks.has(chunk_pos):
		if is_inside_tree():
			await get_tree().create_timer(0.05).timeout
	Global.chunks[chunk_pos] = self
	print(Global.chunks.has(chunk_pos))
	Global.new_chunk_generated.connect(update_neighbors_from_dict)
	Global.emit_signal("new_chunk_generated")
	unc = true


	
func generate_objects() -> void:
	var max : int = 5
	if chunk_pos.length() <= 1:
		max = 10
	elif chunk_pos.length() <= 3:
		max = 7
	for x in range(-8, 8):
		for y in range(-8, 8):
			if randi_range(0, max) <= 0:
				grass.set_cell(Vector2i(x,y), 0, Vector2i(3, 0))
				objects.set_cell(Vector2i(x,y), randi_range(1,6), Vector2i(0, 0), 1)
				
	while len(object_list) <= 0:
		await get_tree().create_timer(0.1).timeout
		text_data.text = "[center]" + str(len(object_list))
		


func neighbor_finished(idx : int) -> void:
	if is_inside_tree():
		var timer : SceneTreeTimer = get_tree().create_timer(0.05)
		while neighbors[idx].barriers:
			if is_inside_tree():
				await timer.timeout
				timer.time_left = 0.05
			else:
				timer.timeout
		await get_tree().create_timer(0.05).timeout
	if barriers:
		barriers.get_child(idx).disabled = true
		color_barriers.get_child(idx).hide()
		check_if_unreasonable_barriers()
		while neighbors.has(null):
			if is_inside_tree():
				await get_tree().create_timer(randf_range(0,0.2)).timeout
				check_if_unreasonable_barriers()
			else:
				has_neigbors = true
				break

func check_if_unreasonable_barriers() -> void:
	if barriers:
		
		
		if neighbors[0]: #up
			
			if neighbors[3]: 
				if neighbors[0].complete == true and neighbors[3].complete == false:
					if neighbors[3].barriers.get_child(0).disabled == true:
						
						neighbors[3].barriers.get_child(2).disabled = true
						neighbors[3].color_barriers.get_child(2).hide()
						barriers.get_child(3).disabled = true
						color_barriers.get_child(3).hide()
						
			if neighbors[2]: 
				if neighbors[0].complete == true and neighbors[2].complete == false:
					if neighbors[2].barriers.get_child(0).disabled == true:
						
						neighbors[2].barriers.get_child(3).disabled = true
						neighbors[2].color_barriers.get_child(3).hide()
						barriers.get_child(2).disabled = true
						color_barriers.get_child(2).hide()
						
						
		if neighbors[1]: #down
			
			if neighbors[3]: 
				if neighbors[1].complete == true and neighbors[3].complete == false:
					if neighbors[3].barriers.get_child(1).disabled == true:
						
						neighbors[3].barriers.get_child(2).disabled = true
						neighbors[3].color_barriers.get_child(2).hide()
						barriers.get_child(3).disabled = true
						color_barriers.get_child(3).hide()
						
			if neighbors[2]: 
				if neighbors[1].complete == true and neighbors[2].complete == false:
					if neighbors[2].barriers.get_child(1).disabled == true:
						
						neighbors[2].barriers.get_child(3).disabled = true
						neighbors[2].color_barriers.get_child(3).hide()
						barriers.get_child(2).disabled = true
						color_barriers.get_child(2).hide()
						
						
		if neighbors[2]: #left
			
			if neighbors[0]:
				if neighbors[2].complete == true and neighbors[0].complete == false:
					if neighbors[0].barriers.get_child(2).disabled == true:
						
						neighbors[0].barriers.get_child(1).disabled = true
						neighbors[0].color_barriers.get_child(1).hide()
						barriers.get_child(0).disabled = true
						color_barriers.get_child(0).hide()
						
			if neighbors[1]:
				if neighbors[2].complete == true and neighbors[1].complete == false:
					if neighbors[1].barriers.get_child(2).disabled == true:
						
						neighbors[1].barriers.get_child(0).disabled = true
						neighbors[1].color_barriers.get_child(0).hide()
						barriers.get_child(1).disabled = true
						color_barriers.get_child(1).hide()
			
			
		if neighbors[3]: #right
			
			if neighbors[0]:
				if neighbors[3].complete == true and neighbors[0].complete == false:
					if neighbors[0].barriers.get_child(3).disabled == true:
						neighbors[0].barriers.get_child(1).disabled = true
						neighbors[0].color_barriers.get_child(1).hide()
						barriers.get_child(0).disabled = true
						color_barriers.get_child(0).hide()
						
			if neighbors[1]:
				if neighbors[3].complete == true and neighbors[1].complete == false:
					if neighbors[1].barriers.get_child(3).disabled == true:
						
						neighbors[1].barriers.get_child(0).disabled = true
						neighbors[1].color_barriers.get_child(0).hide()
						barriers.get_child(1).disabled = true
						color_barriers.get_child(1).hide()
			
			
func _on_up_entered(area: Area2D) -> void:
	area.get_parent().finished.connect(neighbor_finished.bind(0))
	neighbors[0] = area.get_parent()
	finished.connect(neighbors[0].neighbor_finished.bind(1))
	if up:
		up.queue_free()
	if complete:
		area.get_parent().neighbor_finished(0)
	has_neigbors = not neighbors.has(null)


func _on_down_entered(area: Area2D) -> void:
	area.get_parent().finished.connect(neighbor_finished.bind(1))
	neighbors[1] = area.get_parent()
	finished.connect(neighbors[1].neighbor_finished.bind(0))
	if down:
		down.queue_free()
	if complete:
		area.get_parent().neighbor_finished(1)
	has_neigbors = not neighbors.has(null)
	
func _on_left_entered(area: Area2D) -> void:
	area.get_parent().finished.connect(neighbor_finished.bind(2))
	neighbors[2] = area.get_parent()
	finished.connect(neighbors[2].neighbor_finished.bind(3))
	if left:
		left.queue_free()
	if complete:
		area.get_parent().neighbor_finished(2)
	has_neigbors = not neighbors.has(null)
	
func _on_right_entered(area: Area2D) -> void:
	area.get_parent().finished.connect(neighbor_finished.bind(3))
	neighbors[3] = area.get_parent()
	finished.connect(neighbors[3].neighbor_finished.bind(2))
	if right:
		right.queue_free()
	if complete:
		area.get_parent().neighbor_finished(3)
	has_neigbors = not neighbors.has(null)
		
func _on_object_removed_detect_area_exited(area: Area2D) -> void:
	object_list.erase(area.get_parent())
	text_data.text = "[center]" + str(len(object_list))
	if len(object_list) <= 0:
		text_data.hide()
		if complete == false:
			game.new_chunk_unlocked(floor(global_position / 256))
		emit_signal("finished")
		complete = true
		if barriers:
			color_barriers.queue_free()
			barriers.queue_free()

func update_neighbors_from_dict() -> void:
	if not has_neigbors:
		if Global.chunks.has(chunk_pos + Vector2i(0,-1)): # up
			neighbors[0] = Global.chunks[chunk_pos + Vector2i(0,-1)]
		if Global.chunks.has(chunk_pos + Vector2i(0,1)): # down
			neighbors[1] = Global.chunks[chunk_pos + Vector2i(0,1)]
		if Global.chunks.has(chunk_pos + Vector2i(-1,0)): # left
			neighbors[2] = Global.chunks[chunk_pos + Vector2i(-1,0)]
		if Global.chunks.has(chunk_pos + Vector2i(1,0)): # right
			neighbors[3] = Global.chunks[chunk_pos + Vector2i(1,0)]
	else:
		Global.new_chunk_generated.disconnect(update_neighbors_from_dict)
		
func _exit_tree() -> void:
	queue_free()
