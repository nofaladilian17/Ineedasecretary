extends Node3D

@onready var player: CharacterBody3D = $".."
@onready var animation_player: AnimationPlayer = $"../player_model/AnimationPlayer"

var trying_to_convince = false
