extends Node

var scene = "res://scenes/ui/menu.tscn"
@onready var warning_layer: CanvasLayer = $WarningLayer
@onready var esp: Button = $ColorRect / esp
@onready var eng: Button = $ColorRect / eng


@onready var video_opening: VideoStreamPlayer = $VideoOpening

var on_opening = false

@onready var warmup_node = $Warmup3D

var warmup_scenes = [
	preload("res://VFX_Level_UP_effects/VFX/Scenes/VFX_LV_Up_style_b.tscn"), 



]








func warmup_all():
	for scene in warmup_scenes:
		await warmup_scene(scene)

func warmup_scene(scene):
	if scene == null:
		push_error("Escena null en warmup")
		return

	var instance = scene.instantiate()
	warmup_node.add_child(instance)

	instance.visible = false


	await get_tree().process_frame
	await get_tree().process_frame

	instance.queue_free()

func _on_btn_en_mouse_entered() -> void :
	$ButtonSound.play()


func _on_btn_en_mouse_exited() -> void :
	$ButtonSound.play()


func _on_btn_esp_mouse_entered() -> void :
	$ButtonSound.play()


func _on_btn_esp_mouse_exited() -> void :
	$ButtonSound.play()


func _on_btn_en_pressed() -> void :
	$ButtonSound.play()
	TranslationServer.set_locale("en")
	TranslationManager.set_language("en")


	$btn_en.visible = false
	$btn_esp.visible = false
	show_opening()


func _on_btn_esp_pressed() -> void :
	$ButtonSound.play()
	TranslationServer.set_locale("es")
	TranslationManager.set_language("es")


	$btn_en.visible = false
	$btn_esp.visible = false
	show_opening()


func _on_btn_ru_pressed() -> void :
	$ButtonSound.play()
	TranslationServer.set_locale("ru")
	TranslationManager.set_language("ru")


	$btn_en.visible = false
	$btn_esp.visible = false
	show_opening()


func _on_btn_china_pressed() -> void :
	$ButtonSound.play()
	TranslationServer.set_locale("zh_CN")
	TranslationManager.set_language("zh_CN")


	$btn_en.visible = false
	$btn_esp.visible = false
	show_opening()


func _on_btn_brasil_pressed() -> void :
	$ButtonSound.play()
	TranslationServer.set_locale("pt_BR")
	TranslationManager.set_language("pt_BR")


	$btn_en.visible = false
	$btn_esp.visible = false
	show_opening()


func _on_btn_japon_pressed() -> void :
	$ButtonSound.play()
	TranslationServer.set_locale("ja")
	TranslationManager.set_language("ja")


	$btn_en.visible = false
	$btn_esp.visible = false
	show_opening()


func _on_btn_koreano_pressed() -> void :
	$ButtonSound.play()
	TranslationServer.set_locale("ko")
	TranslationManager.set_language("ko")


	$btn_en.visible = false
	$btn_esp.visible = false
	show_opening()

func show_opening():
	SceneManager.load_scene("res://scenes/ui/menu.tscn")
