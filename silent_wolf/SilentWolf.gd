extends Node

onready var Scores = HTTPRequest.new()

var config = {
	"apiKey": "FmKF4gtm0Z2RbUAEU62kZ2OZoYLj4PNXa5YRIBb0",
	"gameId": "1",
	"gameVersion": "0.1.0"
}

func _ready():
	Scores.set_script(preload("res://addons/silent_wolf/Scores/Scores.gd"))
	add_child(Scores)