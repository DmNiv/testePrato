extends StaticBody2D

func interacted(player: CharacterBody2D):
	player.carrying(self)
	
func carried():
	$Sprite2D/AnimationPlayer.play("carrying")
	
func throw(direction):
	$Sprite2D/AnimationPlayer.play("dropping")
