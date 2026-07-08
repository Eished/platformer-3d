extends Node3D
class_name GameManager

static var instance: GameManager

@export var collected_items: Dictionary[String, int] = {
	'DIAMOND': 0,
	'COIN': 0,
	'CHERRY': 0,
}

@export var item_labels: Dictionary[String, Label]
@export var win_label_title: Label
@export var restart_btn: Button
@export var menu_btn: Button
@export var win_bg_layer: ColorRect

var saved_checkpoints: Array[Checkpoint] = []
var is_game_over: bool = false
var is_paused: bool = false

var start_time: int = 0
var elapsed_time: float = 0
var start_paused_time: float = 0
var paused_time: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if instance == null:
		instance = self
	else:
		queue_free()
		
	win_label_title.visible = false
	restart_btn.visible = false
	menu_btn.visible = false
	win_bg_layer.visible = false
	
	start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_death_zone_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func respawn_player(body: Node3D) -> void:
	if body is CharacterBody3D:
		if len(saved_checkpoints) == 0:
			Player.instance.position = Player.instance.spawn_position
		else:
			var closest_checkpoint = saved_checkpoints[len(saved_checkpoints) - 1]
			# 节省算力的比较距离；可改用最后一个检查点，可加偏移量 Vector3(0, 3, 0)
			# var closest_distance = closest_checkpoint.position.distance_squared_to(Player.instance.position)
			Player.instance.position = closest_checkpoint.position

func collect_item(item_type):
	collected_items[item_type] += 1
	item_labels[item_type].text = str(collected_items[item_type])
	
func win_game():
	stop_timer()
	win_bg_layer.visible = true
	win_label_title.visible = true
	is_game_over = true
	restart_btn.visible = true
	menu_btn.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file('res://Scenes/MainMenu.tscn')
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed and not is_game_over:
			if not is_paused:
				#process_mode = Node.PROCESS_MODE_DISABLED
				#set_process(PROCESS_MODE_PAUSABLE)
				win_bg_layer.visible = true
				is_paused = true
				restart_btn.visible = true
				menu_btn.visible = true
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				pause_timer()
			else:
				win_bg_layer.visible = false
				is_paused = false
				restart_btn.visible = false
				menu_btn.visible = false
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				resume_timer()
		

func start_timer():
	start_time = Time.get_ticks_msec()
	elapsed_time = 0

func pause_timer():
	start_paused_time = Time.get_ticks_msec()

func resume_timer():
	paused_time += Time.get_ticks_msec() - start_paused_time

func stop_timer():
	elapsed_time = (
		Time.get_ticks_msec() - start_time - paused_time
	) / 1000.0

func get_time():
	if not is_game_over:
		return (
			Time.get_ticks_msec() - start_time - paused_time
		) / 1000.0
	return elapsed_time
