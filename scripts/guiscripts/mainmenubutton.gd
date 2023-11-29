extends Button

func _on_pressed() -> void:
	GameManager.load_main_menu()
	get_tree().paused = false
