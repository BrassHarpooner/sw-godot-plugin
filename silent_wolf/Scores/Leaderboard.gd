tool
extends Node2D

const ScoreItem = preload("ScoreItem.tscn")

var list_index = 0

func _ready():
	var scores = SilentWolf.Scores.scores
	print("Leaderboard scores: " + str(scores))
	if scores: 
		for score in scores:
			add_item(score.player_name, str(int(score.score)))

func add_item(player_name, score):
	var item = ScoreItem.instance()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score
	item.margin_top = list_index * 100
	$"Board/HighScores/ScoreItemContainer".add_child(item)

func _on_CloseButton_pressed():
	var scene_name = SilentWolf.scores_config.open_scene_on_close
	print("scene name: " + str(scene_name))
	global.reset()
	get_tree().change_scene(scene_name)
