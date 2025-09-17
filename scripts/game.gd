extends Node2D

@onready var new_chunk_sfx: AudioStreamPlayer = $NewChunk
@onready var new_chunk_subtext: RichTextLabel = $GUI/Control/NewChunkText/NewChunkSubtext
@onready var new_chunk_anim: AnimationPlayer = $GUI/Control/NewChunkText/Anim

# Called when the node enters the scene tree for the first time.
func new_chunk_unlocked(pos : Vector2) -> void:
	new_chunk_sfx.play()
	new_chunk_subtext.text = "[center][X: " + str(int(pos.x)) + ", Y: " + str(int(-pos.y)) + "]"
	new_chunk_anim.play("scroll")
