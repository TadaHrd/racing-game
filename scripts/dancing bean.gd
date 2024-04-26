extends MeshInstance


func _physics_process(delta):
	self.rotation.x += delta / 2
	self.rotation.y += delta
	self.rotation.z += delta * 2
