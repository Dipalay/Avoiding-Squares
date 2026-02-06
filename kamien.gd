extends Area2D
var speed = 200.0
func _ready():
	speed = randf_range(150, 350)
func _process(delta):
	position.y += speed*delta
	if position.y>get_viewport_rect().size.y+100:
		queue_free()
func zwieksz_predkosc(dodatek):
	speed+=dodatek
