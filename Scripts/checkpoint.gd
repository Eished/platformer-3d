extends Area3D

class_name Checkpoint

@export var is_final_checkpoint: bool = false

var is_activated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if not is_activated and body is CharacterBody3D:
		$AnimationPlayer.play("active")
		is_activated = true
		GameManager.instance.saved_checkpoints.append(self)
		
		if is_final_checkpoint:
			GameManager.instance.win_game()
