extends HBoxContainer

# https://coolors.co/94a0c5-7c87a7-f8e9b8-f9b799-ffede1

var color = Color("7C87A7") setget set_color

func _ready():
	self.color = color

func _on_BlueButton_pressed():
	self.color = Color("7C87A7")

func _on_YellowButton_pressed():
	self.color = Color("F8E9B8")

func _on_OrangeButton_pressed():
	self.color = Color("F9B799")

func _on_GreenButton_pressed():
	self.color = Color("B7F7BF")

func set_color(new_color):
	color = new_color
	$Label.modulate = new_color
