extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sort_area_body_exited(body: Node2D) -> void:
	body.z_index = 0


func _on_sort_area_body_entered(body: Node2D) -> void:
	body.z_index = -10
