extends Node2D

const chunk_size : int = 256
const CHUNK = preload("res://scenes/chunk.tscn")
@onready var first_chunk: Node2D = $Chunk

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index : int = 0
	for i : VisibleOnScreenNotifier2D in first_chunk.get_child(0).get_children():
		i.screen_entered.connect(generate_chunk.bind(first_chunk.global_position, index, i, false))
		index += 1


func generate_chunk(pos : Vector2, direction : int, from : VisibleOnScreenNotifier2D, wait : bool) -> void:
	if wait:
		await get_tree().create_timer(randf_range(0.03, 0.07)).timeout
	if from:
		var from_chunk : Node2D = from.get_parent().get_parent()
		from.queue_free()
		var chunk : Node2D = CHUNK.instantiate()
		var to_delete : Array[Node2D] = []
		var borders : Node2D = chunk.get_child(0)
		add_child(chunk)
		chunk.global_position = pos
		from_chunk.neighbors[direction] = chunk
		match direction:
			0:
				chunk.global_position.y -= chunk_size
				to_delete.append(borders.get_child(1))
			1:
				chunk.global_position.y += chunk_size
				to_delete.append(borders.get_child(0))
			2:
				chunk.global_position.x -= chunk_size
				to_delete.append(borders.get_child(3))
			3:
				chunk.global_position.x += chunk_size
				to_delete.append(borders.get_child(2))
		print("New chunk at x: " + str(chunk.global_position.x) + ", y: " + str(chunk.global_position.y))
		var index : int = 0
		for i : VisibleOnScreenNotifier2D in chunk.get_child(0).get_children():
			i.screen_entered.connect(generate_chunk.bind(chunk.global_position, index, i, true))
			index += 1
		for i in to_delete:
			i.queue_free()
		chunk.generate_objects()
