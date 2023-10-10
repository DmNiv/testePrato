extends StaticBody2D

@export var ingredientes = []

func interacted(player: CharacterBody2D):
	player.carrying(self)
	
func carried():
	$Sprite2D/AnimationPlayer.play("carrying")
	
func throw(direction):
	$Sprite2D/AnimationPlayer.play("dropping")

func addIngrediente(ingrediente):
	if ingrediente not in ingredientes:
		ingredientes.append(ingrediente)
		if ingrediente == "tomate":
			$Sprite2D.frame = 1
		elif ingrediente == "mussarela":
			$Sprite2D.frame = 2
		if "tomate" in ingredientes and "mussarela" in ingredientes:
			$Sprite2D.frame = 3
