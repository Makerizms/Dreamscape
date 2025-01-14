extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8
@export var SENSITIVITY = 0.03

var gravity = 26

@onready var head = $Head
@onready var camera = $Head/Camera3D

@onready var rayCast = $Head/Camera3D/RayCast3D

var blockIndex : int = 0

func _ready():
	if SENSITIVITY == 0:
		SENSITIVITY = 0.03
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		if velocity.y < -9.8:
			velocity.y = -9.8

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	# This is the voxel place and break system
	if Input.is_action_just_pressed("LeftClick"):
		if rayCast.is_colliding():
			#print_debug("Method: ", rayCast.get_collider().has_method("destroy_block"))
			#print_debug("Collider: ", rayCast.get_collider())
			#print_debug("Collision Point: ", rayCast.get_collision_point())
			#print_debug("Collision Normal: ", rayCast.get_collision_normal())
			if rayCast.get_collider().has_method("destroy_block") :
				rayCast.get_collider().destroy_block(rayCast.get_collision_point() - rayCast.get_collision_normal())
	if Input.is_action_just_pressed("RightClick"):
		if rayCast.is_colliding():
			#print_debug("Method: ", rayCast.get_collider().has_method("destroy_block"))
			#print_debug("Collider: ", rayCast.get_collider())
			#print_debug("Collision Point: ", rayCast.get_collision_point())
			#print_debug("Collision Normal: ", rayCast.get_collision_normal())
			if rayCast.get_collider().has_method("create_block") :
				rayCast.get_collider().create_block(rayCast.get_collision_point() - rayCast.get_collision_normal(), blockIndex)
	if Input.is_action_just_pressed("MiddleClick"):
		if rayCast.is_colliding():
			print_debug("Index ", rayCast.get_index())
			blockIndex = rayCast.get_index()

	move_and_slide()
