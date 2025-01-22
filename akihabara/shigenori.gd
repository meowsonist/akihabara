extends CharacterBody3D


var SPD = 5.0
const RAWSPD = 5.0
const JUMP_VELOCITY = 3.5
const SENS = 0.001
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var collider = $CollisionShape3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENS)
		camera.rotate_x(-event.relative.y * SENS)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	
	SPD = clamp(SPD, 5, 10)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		print(SPD)
	
	if not is_on_floor() and not Input.is_action_pressed("Up"):
		SPD -= 0.5

	if is_on_floor(): #gravity thing
		velocity += get_gravity() * delta
		SPD -= 0.2
	
	
	if not is_on_floor() and Input.is_action_pressed("Up"): #air control thing
		SPD += 0.01
	
	if Input.is_action_pressed("Focus"):
		SPD = RAWSPD - 1
		head.position.y = 0.25
		collider.shape.height = 1.5
	else:
		head.position.y = 0.5
		collider.shape.height = 2

	# Handle jump.
	if is_on_floor() and Input.is_action_pressed("Jump"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	
	var final_input_dirX = input_dir.x/1.5
	
	if is_on_floor(): #gravity thing
		final_input_dirX = input_dir.x * 1.5
	
	var direction: Vector3 = (head.transform.basis * Vector3(final_input_dirX, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPD
		velocity.z = direction.z * SPD
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
