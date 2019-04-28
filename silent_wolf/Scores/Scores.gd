extends HTTPRequest

#signal scores_received(scores)

var scores = null

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("request_completed", self, "_on_Scores_request_completed")

func get_high_scores():
	var apiKeyHeader = "x-api-key: " + SilentWolf.config.apiKey
	var headers = [apiKeyHeader]
	print("get_high_scores headers: " + str(headers))
	var gameId = SilentWolf.config.gameId
	var gameVersion = SilentWolf.config.gameVersion
	var requestUrl = "https://api.silentwolf.com/get_high_scores/" + str(gameId) + ";" + str(gameVersion)
	request(requestUrl, headers)
	
func persist_score(player_name, score):
	var gameId = SilentWolf.config.gameId
	var gameVersion = SilentWolf.config.gameVersion
	var apiKey = SilentWolf.config.apiKey
	var payload = { "player_name" : player_name, "game_id": gameId, "game_version": gameVersion, "score": score }
	var query = JSON.print(payload)
	var headers = ["Content-Type: application/json", "x-api-key: " + apiKey]
	print("persist_score headers: " + str(headers))
	var use_ssl = true
	request("https://api.silentwolf.com/post_new_high_score", headers, use_ssl, HTTPClient.METHOD_POST, query)
	
# callback for responses to both get high scores and post score requests 
# (logic depends on response_type field in json response)
func _on_Scores_request_completed( result, response_code, headers, body ):
	print("Scores request_completed")
	var json = JSON.parse(body.get_string_from_utf8())
	print("json: " + str(json))
	var response = json.result
	var response_type = response.response_type
	print("response_type: " + response_type)
	if response_type == "get_scores":
		scores = response.top_ten
		print("scores: " + str(scores))
		#emit_signal("scores_received", scores)
	elif response_type == "post_new_score":
		print("SilentWolf post score success: " + str(response_code))
	else:
		print("Unrecognised response type: " + response_type)