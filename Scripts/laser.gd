extends Area3D

class_name LaserProjectile

var damage = 20

@export var speed: int = 20
var direction: Vector3 = Vector3.FORWARD
@onready var timer = $Utilities/Timer


func _ready():
	direction = Vector3.FORWARD
	timer.start(10)

func _process(delta):
	position += global_basis * Vector3.FORWARD * speed * delta


func _on_body_entered(body):
	if body.has_method("hit"): #or <if "hit" in body:>
		body.hit()
	queue_free()


func _on_hit_box_body_entered(body):
	if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()


func _on_timer_timeout() -> void:
	queue_free()
