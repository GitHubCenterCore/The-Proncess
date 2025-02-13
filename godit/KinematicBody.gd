extends KinematicBody

export var Sensitivity_X = 0.01
export var Sensitivity_Y = 0.01
export var Invert_Y_Axis = false
export var Exit_On_Escape = true
export var Maximum_Y_Look = 45
export var Accelaration = 5
export var Maximum_Walk_Speed = 20
export var Jump_Speed = 0

var paused = false

const GRAVITY = 0.9
var velocity = Vector3(0,0,0)
var forward_velocity = 0
var Walk_Speed = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	forward_velocity = Walk_Speed
	set_process(true)

func _process(delta):
	if Exit_On_Escape:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()
	
func _physics_process(delta):
	velocity.y -= GRAVITY
	
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		Walk_Speed += Accelaration
		if Walk_Speed > Maximum_Walk_Speed:
			Walk_Speed = Maximum_Walk_Speed
		velocity.x = -global_transform.basis.z.x * Walk_Speed
		velocity.z = -global_transform.basis.z.z * Walk_Speed
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		Walk_Speed += Accelaration
		if Walk_Speed > Maximum_Walk_Speed:
			Walk_Speed = Maximum_Walk_Speed
		velocity.x = global_transform.basis.z.x * Walk_Speed
		velocity.z = global_transform.basis.z.z * Walk_Speed
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		Walk_Speed += Accelaration
		if Walk_Speed > Maximum_Walk_Speed:
			Walk_Speed = Maximum_Walk_Speed
		velocity.x = -global_transform.basis.x.x * Walk_Speed
		velocity.z = -global_transform.basis.x.z * Walk_Speed
		
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		Walk_Speed += Accelaration
		if Walk_Speed > Maximum_Walk_Speed:
			Walk_Speed = Maximum_Walk_Speed
		velocity.x = global_transform.basis.x.x * Walk_Speed
		velocity.z = global_transform.basis.x.z * Walk_Speed
		
	if not(Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_RIGHT)):
		velocity.x = 0
		velocity.z = 0
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = Jump_Speed
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			$clik.play()
			$Control/ColorRect.color.v = 0.2
			var cl = $Camera/RayCast.get_collider()
			if $Camera/RayCast.is_colliding():
				if cl.name.match("proncess*"):
					cl.get_node("laugh").play()
				if cl.name.match("light*"):
					cl.set("visible", !cl.get("visible"))
				if cl.name.match("door*"):
					print("opened door")
					self.global_transform.origin = cl.global_transform.origin + self.transform.basis.z * -3
					$door.play()
		
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed == false:
			$Control/ColorRect.color.v = 1
	if Input.is_key_pressed(KEY_ESCAPE):
		paused = !paused
		if paused: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		if !paused:
			rotate_y(-Sensitivity_X * event.relative.x)
