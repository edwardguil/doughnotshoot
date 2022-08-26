extends Node

var queue = []

func AddPlayer(player_id):
	queue.append(player_id)
	print("Added Player")

func RemoveFromQueue(player_id):
	queue.remove(queue.find(player_id))

func IsInQueue(player_id) -> bool:
	if queue.find(player_id) == -1:
		return false
	else: 
		return true
