extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_mouse_entered():
	$AnimationPlayer.play("to_being_hovered")

func _on_Area2D_mouse_exited():
	$AnimationPlayer.play("away_from_hovered")