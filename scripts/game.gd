extends Node2D

@onready var new_chunk_sfx: AudioStreamPlayer = $NewChunk
@onready var new_chunk_subtext: RichTextLabel = $GUI/Control/NewChunkText/NewChunkSubtext
@onready var new_chunk_anim: AnimationPlayer = $GUI/Control/NewChunkText/Anim
@onready var hi: AudioStreamPlayer = $"../Hi"

var unlocked_chunks : PackedVector2Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	hi.play()
func new_chunk_unlocked(pos : Vector2) -> void:
	if not unlocked_chunks.has(pos):
		Global.money += 100 * Global.chunk_money_mult
		unlocked_chunks.append(pos)
		new_chunk_sfx.play()
		new_chunk_subtext.text = "[center][X: " + str(int(pos.x)) + ", Y: " + str(int(-pos.y)) + "]"
		new_chunk_anim.play("scroll")
