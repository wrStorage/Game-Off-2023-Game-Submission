extends AudioStreamPlayer

const menu_scroll: AudioStreamWAV = preload("res://assets/sfx/menu scroll.wav")
const death_sfx: AudioStreamWAV = preload("res://assets/sfx/death.wav")
const idol_sfx: AudioStreamWAV = preload("res://assets/sfx/idol.wav")

func play_menu_scroll_sfx() -> void:
	stream = menu_scroll
	play()

func play_death_sfx() -> void:
	stream = death_sfx
	play()

func play_idol_sfx() -> void:
	stream = idol_sfx
	play()
