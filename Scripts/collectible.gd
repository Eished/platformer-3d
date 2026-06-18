extends Area3D

enum CollectibleType {DIAMOND, COIN, CHERRY}
@export var type: CollectibleType

@export var diamond_model: PackedScene
@export var coin_model: PackedScene
@export var cherry_model: PackedScene

@export var rotation_speed: float = 0.5
@export var floating_speed: float = 0.005
@export var floating_magnitude: float = 0.05
var original_y: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_y = position.y
	
	type = randi_range(0, 2)
	var model: PackedScene
	match type:
		CollectibleType.DIAMOND:
			model = diamond_model
		CollectibleType.COIN:
			model = coin_model
		CollectibleType.CHERRY:
			model = cherry_model
		_:
			printerr('Invalid type!')
	
	var node = model.instantiate()
	add_child(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation.y += rotation_speed * delta
	position.y = original_y + sin(Time.get_ticks_msec() * floating_speed) * floating_magnitude


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		queue_free()
		GameManager.instance.collect_item(CollectibleType.find_key(type))
