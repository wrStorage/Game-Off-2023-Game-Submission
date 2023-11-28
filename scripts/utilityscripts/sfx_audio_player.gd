extends AudioStreamPlayer

const menu_scroll: AudioStreamWAV = preload("res://assets/sfx/menu scroll.wav")
const death_sfx: AudioStreamWAV = preload("res://assets/sfx/death.wav")
const idol_sfx: AudioStreamWAV = preload("res://assets/sfx/idol.wav")
const rock_sfx: AudioStreamWAV = preload("res://assets/sfx/rock.wav")
var volume_muted: bool = false
@onready var sfx_bus: int = AudioServer.get_bus_index("SFX")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mute"):
		EventBus.mute_button_pressed.emit()

func _ready() -> void:
	EventBus.connect("mute_button_pressed", toggle_mute)
	
func play_menu_scroll_sfx() -> void:
	stream = menu_scroll
	play()

func play_death_sfx() -> void:
	stream = death_sfx
	play()

func play_idol_sfx() -> void:
	stream = idol_sfx
	play()

func play_rock_sfx() -> void:
	stream = rock_sfx
	play()
	
func toggle_mute() -> void:
	volume_muted = !volume_muted
	AudioServer.set_bus_mute(sfx_bus, volume_muted)
	
