extends Label


func _process(delta):
	if not GameManager.instance.is_paused:
		var t = GameManager.instance.get_time()
		text = format_time(t)



func format_time(t):
	var minutes = int(t / 60)
	var seconds = int(t) % 60
	var ms = int(t * 100) % 100

	return "%02d:%02d.%02d" % [
		minutes,
		seconds,
		ms
	]
