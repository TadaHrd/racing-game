extends Control

onready var back = $Back
onready var forw = $Forw
onready var left = $Left
onready var right = $Right
onready var lock = $Lock
onready var lookLeft = $LookLeft
onready var lookRight = $LookRight
onready var toggleControls = $"../ToggleControls"


func _ready():
	self.visible = false

func _process(_delta):
	var wsize = OS.get_window_size()
	
	left.rect_scale = Vector2(wsize.x / 1024, wsize.x / 1024)
	right.rect_scale = Vector2(wsize.x / 1024, wsize.x / 1024)
	back.rect_scale = Vector2(wsize.x / 1024, wsize.x / 1024)
	forw.rect_scale = Vector2(wsize.x / 1024, wsize.x / 1024)
	lock.rect_scale = Vector2(wsize.x / 1024, wsize.x / 1024)
	lookLeft.rect_scale = Vector2(wsize.x / 1024, wsize.x / 1024)
	lookRight.rect_scale = Vector2(wsize.x / 1024, wsize.x / 1024)
	toggleControls.rect_scale = Vector2(wsize.x / 1024, wsize.x / 1024)
	
	left.rect_position = Vector2(wsize.x / 1024 * 50, wsize.y / 600 * 450)
	right.rect_position = Vector2(wsize.x / 1024 * 200, wsize.y / 600 * 450)
	forw.rect_position = Vector2(wsize.x / 1024 * 850, wsize.y / 600 * 450)
	back.rect_position = Vector2(wsize.x / 1024 * 650, wsize.y / 600 * 450)
	lock.rect_position = Vector2(wsize.x / 1024 * 900, wsize.y / 600 * 350)
	lookLeft.rect_position = Vector2(wsize.x / 1024 * 60, wsize.y / 600 * 360)
	lookRight.rect_position = Vector2(wsize.x / 1024 * 210, wsize.y / 600 * 360)
	toggleControls.rect_position = Vector2(wsize.x / 1024 * 900, wsize.y / 600 * 30)


func _on_ToggleControls_button_up():
	self.visible = !self.visible
