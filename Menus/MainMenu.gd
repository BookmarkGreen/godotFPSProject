extends Control

@onready var level_scene = preload("res://Levels/Level.tscn") as PackedScene



func _on_start_game_button_pressed():
	get_tree().change_scene_to_packed(level_scene)


func _on_options_button_pressed():
	print("Game Options")


func _on_exit_game_button_pressed():
	get_tree().quit()
