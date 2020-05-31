extends KinematicBody

var target: Vector3
var player: RigidBody

func _ready():
	player = get_tree().current_scene.get_node("player")
	self.target = player.global_transform.origin
	
func pos():
	return self.global_transform.origin

func _process(delta):
	var vec = target - self.pos()
	if self.move_and_collide(vec,true,true,true) != null:
		print (self.move_and_collide(vec,true,true,true).collider.name)
		if !self.move_and_collide(vec,true,true,true).collider.name.match("wall*"):
			var dist = Vector3(999,0,999).length()
			for node in get_tree().current_scene.get_children():
				if node.name.match("door*"):
					var length = node.global_transform.origin - self.pos()
					length = length.length()
					print (length," ",dist)
					if length < dist:
						dist = length
						#target = node.global_transform.origin
	else: self.target = player.global_transform.origin
	#self.look_at(target,Vector3(1,0,0))
	vec = target - self.pos()
	self.move_and_slide(Vector3(vec.x,0,vec.z))
