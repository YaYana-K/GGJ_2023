extends Area2D

@export var theme: TileProvider.TileTheme = TileProvider.TileTheme.NIGHT_FOREST
@export var respawn_position: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_start_level)


func _start_level(_body):
	if _body.is_class("CharacterBody2D") and _body.controlled:
		SceneSwitcher.change_scene_to_file('res://scenes/level/Level.tscn', {'theme': theme, 'respawn_position': respawn_position})