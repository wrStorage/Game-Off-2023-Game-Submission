extends AudioStreamPlayer

const menu_scroll: AudioStreamWAV = preload("res://assets/sfx/menu_scroll.wav")
const death_sfx: AudioStreamWAV = preload("res://assets/sfx/death.wav")
const idol_sfx: AudioStreamWAV = preload("res://assets/sfx/idol.wav")
const rock_sfx: AudioStreamWAV = preload("res://assets/sfx/rock.wav")
const rumble_sfx: AudioStreamWAV = preload("res://assets/sfx/rumble_screen_v1.wav")
const idol_db: int = -9
const death_db: int = -6
const menu_scroll_db: int = -10
const default_db: int = 0
var volume_muted: bool = false
@onready var sfx_bus: int = AudioServer.get_bus_index("SFX")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mute"):
		EventBus.mute_button_pressed.emit()

func _ready() -> void:
	EventBus.connect("mute_button_pressed", toggle_mute)
	
func play_menu_scroll_sfx() -> void:
	stream = menu_scroll
	volume_db = menu_scroll_db
	play()

func play_death_sfx() -> void:
	stream = death_sfx
	volume_db = death_db
	play()

func play_idol_sfx() -> void:
	stream = idol_sfx
	volume_db = idol_db
	play()

func play_rock_sfx() -> void:
	stream = rock_sfx
	play()
	
func toggle_mute() -> void:
	volume_muted = !volume_muted
	AudioServer.set_bus_mute(sfx_bus, volume_muted)

func _on_finished() -> void:
	volume_db = default_db
