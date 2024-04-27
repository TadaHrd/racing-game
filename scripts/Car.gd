extends VehicleBody

onready var BL = $back_left
onready var BR = $back_right
onready var FL = $front_left
onready var FR = $front_right
onready var cam = $Cam_Pivot
onready var cam_arm = $Cam_Pivot/Camera_arm
onready var car = $"."
onready var engineSound = $EngineSoundPlayer
onready var nametag = $NameTag

export var          max_rpm = 1500
export var       back_speed = 0.75
export var           torque = 200
export var brake_multiplier = 3
export var        max_steer = 0.3 #0-1
export var     brake_amount = 4
export var       cam_smooth = 0.1

var rpm = 0
var is_lock_rpm = false
var locked_rpm = 0
var mouse_mode = 0
var back = 0
var forw = 0
var right_left = 0

func _ready():
	engineSound.playing = true

func _input(_event):
	if Input.is_action_pressed("lock_rpm"):
		_on_Lock_button_down()

func _physics_process(_delta):
	if Input.is_action_just_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	rpm = (BL.get_rpm() + BR.get_rpm()) / 2
	
	back = max(Input.get_action_strength("back"), $Controls/Back.pressed as int)
	forw = max(Input.get_action_strength("forward"), $Controls/Forw.pressed as int)
	var brake = Input.get_action_strength("brake") * brake_amount;
	print(Input.is_action_just_pressed("brake"))
	
	
	if back == 1 && forw == 1:
		brake = brake_amount
	
	right_left = max(
		Input.get_action_strength("left"), $Controls/Left.pressed as int
	) - max(
		Input.get_action_strength("right"), $Controls/Right.pressed as int
	)
	
	player_name()
	control_car(get_speed_for_car(), get_speed_for_car(), brake, right_left)
	control_camera()
	sound()
	dont_fall()

func get_speed_for_car() -> float:
	var speed
	
	if rpm > 0:
		speed = forw - back * brake_multiplier
	else:
		speed = forw * brake_multiplier - back * back_speed
	
	if abs(rpm) >= max_rpm:
		speed = 0
	
	return speed * torque

# warning-ignore:shadowed_variable
func control_car(R, L, brake_amount, steer_axis,
				 front_wheels: bool = true, back_wheels: bool = true):
	if !is_lock_rpm:
		if back_wheels:
			BL.engine_force = L 
			BR.engine_force = R
		if front_wheels:
			FL.engine_force = L
			FR.engine_force = R
	else:
		if brake_amount:
			is_lock_rpm = false
		
		if locked_rpm > 0:
			if back_wheels:
				BL.engine_force = (rpm < locked_rpm) as int * torque
				BR.engine_force = (rpm < locked_rpm) as int * torque
			if front_wheels:
				FL.engine_force = (rpm < locked_rpm) as int * torque
				FR.engine_force = (rpm < locked_rpm) as int * torque
		elif locked_rpm < 0:
			if back_wheels:
				BL.engine_force = (rpm > locked_rpm) as int * -torque * back_speed
				BR.engine_force = (rpm > locked_rpm) as int * -torque * back_speed
			if front_wheels:
				FL.engine_force = (rpm > locked_rpm) as int * -torque * back_speed
				FR.engine_force = (rpm > locked_rpm) as int * -torque * back_speed
	
	steering = lerp(steering, steer_axis * max_steer, 0.2)
	
	brake = brake_amount

func sound():
	var sound_strength = max(
		max(abs(forw - back), 0.50),
		is_lock_rpm as float
	) * abs(rpm) / 80
	
	engineSound.set_max_db(sound_strength)
	engineSound.pitch_scale = sound_strength / 10

func control_camera():
	if rpm <= -10:
		cam.rotation.y = lerp(cam.rotation.y, PI, cam_smooth)
	else:
		cam.rotation.y = lerp(cam.rotation.y, 0, cam_smooth)
	
	var look = Input.get_axis("look_left", "look_right") * PI / 2
	if $Controls/LookLeft.pressed || $Controls/LookRight.pressed:
		look = $Controls/LookRight.pressed as float - $Controls/LookLeft.pressed as float
	
	cam.rotation.y = lerp(cam.rotation.y, cam.rotation.y + look * PI / 2, cam_smooth)

func dont_fall():
	if transform.origin.y <= -1:
		transform.origin = Vector3.UP
	if abs(rotation_degrees.x) >= 160 || abs(rotation_degrees.z) >= 160:
		rotation_degrees.x = 0
		rotation_degrees.z = 0
		
		angular_velocity.x = 0
		angular_velocity.z = 0
		
		transform.origin.y = 1

func player_name():
	nametag.text = car.name

func _on_Lock_button_down():
	is_lock_rpm = !is_lock_rpm
	locked_rpm = rpm
