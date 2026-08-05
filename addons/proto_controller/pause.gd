extends Node
@onready var actions_layer: CanvasLayer = $"../ActionsLayer"

var shop_instance: Node = null

func _input(event: InputEvent) -> void :
	if event.is_action_pressed("p") and !Global.on_victory_watch_video and !Global.is_on_mochila and Global.player_node.can_move:
		print("se ejecuta?")

		if !Global.on_shop:
			create_shop()
		else:
			close_shop()

		Global.on_shop = !Global.on_shop

func create_shop() -> void :
	if shop_instance != null:
		return
	get_tree().paused = true
	if Global.player_node:
		Global.player_node.release_mouse()

	shop_instance = Global.shop_scene.instantiate()
	add_child(shop_instance)

func close_shop() -> void :
	if shop_instance:
		shop_instance.queue_free()
		shop_instance = null
		get_tree().paused = false
		if Global.player_node:
			Global.player_node.capture_mouse()
			Global.player_node.can_move = true
