extends Label

@export var flavor_text: Array[String] = []

func _ready() -> void:
	EventBus.connect("player_died", generate_flavor_text)

func generate_flavor_text() -> void:
	text = flavor_text[randi_range(0, flavor_text.size() - 1)]
