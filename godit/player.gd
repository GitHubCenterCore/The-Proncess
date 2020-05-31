extends RigidBody

var paused = false
var vlct = Vector3(0,0,0)

func move():
	var form = self.transform.basis.z
	var formx = self.transform.basis.x
	form.y = 0
	vlct = Vector3.ZERO
	if Input.is_action_pressed("ui_w"):
		vlct += form
	if Input.is_action_pressed("ui_s"):
		vlct -= form
	if Input.is_action_pressed("ui_d"):
		vlct += formx
	if Input.is_action_pressed("ui_a"):
		vlct -= formx
	vlct = vlct.normalized()
	vlct *= 10
	print(vlct)
	self.linear_velocity = vlct

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		paused = !paused
	if event is InputEventMouseMotion:
		if !paused:
			var w = event.relative.x / (1 * 100)
			var h = event.relative.y / (1 * 100)
			var mx = self.rotation.x - w
			#print(mx)
			#if mx > 89
			$Camera.rotate_object_local(Vector3(1,0,0),-h)
			self.rotate_y(-w)
			self.rotation.x = clamp(self.rotation.x, -89, 89)
			#self.rotation.y = clamp(self.rotation.y, -89, 89)

func _integrate_forces(state):
	state.linear_velocity = vlct

func _ready():
	if paused == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	if paused: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	move()
	
