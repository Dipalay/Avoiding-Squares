extends Node2D
@onready var gracz: Area2D = $Gracz
@onready var spawner_timer: Timer = $SpawnerTimer
@onready var punkty_label: Label = $CanvasLayer/Punkty
var punkty = 0.0
var gra_aktywna = true
var kamien_scene = preload("res://Kamien.tscn")
var bazowy_czas_spawnu = 1.0
var minimalny_czas_spawnu = 0.1
var trudnosc_mnoznik = 0.05
func _ready():
	spawner_timer.timeout.connect(_spawn_kamien)
	spawner_timer.wait_time = bazowy_czas_spawnu
	spawner_timer.start()
	gracz.area_entered.connect(_on_area_entered)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
func _process(delta):
	if not gra_aktywna:
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
		return
	var mouse_pos = get_global_mouse_position()
	var ekran = get_viewport_rect().size
	gracz.global_position = Vector2(clamp(mouse_pos.x, 50, ekran.x-50), clamp(mouse_pos.y,50,ekran.y-50))
	punkty+=delta
	punkty_label.text="Czas: "+str(int(punkty))+" s"
	var nowy_wait_time = bazowy_czas_spawnu - (punkty/2)*trudnosc_mnoznik
	spawner_timer.wait_time = max(nowy_wait_time, minimalny_czas_spawnu)
func _spawn_kamien():
	if not gra_aktywna: return
	var kamien = kamien_scene.instantiate()
	if kamien.has_method("zwieksz_predkosc"):
		kamien.zwieksz_predkosc(punkty*2.0)
	add_child(kamien)
	var ekran = get_viewport_rect().size
	kamien.position = Vector2(randf_range(50, ekran.x-50),-50)
func _on_area_entered(body: Area2D) -> void:
	game_over()
func game_over():
	gra_aktywna = false
	spawner_timer.stop()
	punkty_label.text = "GAME OVER!\nCzas: %ds\nNaciśnij R aby zrestartować grę" %int(punkty)

	
