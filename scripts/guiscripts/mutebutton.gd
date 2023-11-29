extends Button

func _ready() -> void:
	EventBus.connect("mute_button_pressed", change_mute_button_text)
	change_mute_button_text()

func change_mute_button_text() -> void:
	if SfxAudioPlayer.volume_muted == true:
		text = "Unmute"
	else:
		text = "Mute"

func _on_pressed() -> void:
	EventBus.mute_button_pressed.emit()
