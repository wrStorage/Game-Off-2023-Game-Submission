extends CanvasLayer

@onready var return_button = $ReturnButton

func _ready() -> void:
	EventBus.connect("credits_clicked", show)
	hide()

func _on_cancel_button_pressed() -> void:
	hide()

func _on_cancel_button_focus_exited() -> void:
	hide()

func _on_visibility_changed() -> void:
	if visible:
		return_button.grab_focus()
	else:
		EventBus.clicked_off_credits.emit()
