extends Node

@onready var head = $Head
@onready var body_ref = $BodyRef
@onready var body_nodes = $BodyNodes
@export var stride = 50
@export var initial_size = 2
var direction = Vector2.ZERO
var previous_position = Vector2.ZERO
var should_update_body = false
var dead = false

func _ready():
	for n in range(initial_size):
		increase_size()

const CLOCK = 0.5
var timer = 0
func _physics_process(delta):
	if direction == Vector2.ZERO:
		return
	
	if should_update_body:
		move_body()
		should_update_body = false
	timer += delta
	if timer >= CLOCK:
		timer = 0
		move_head()
		should_update_body = true

func _input(event):
	if dead:
		return

	if event.is_action_pressed("ui_up") && direction != Vector2.DOWN:
		direction = Vector2.UP
	if event.is_action_pressed("ui_down") && direction != Vector2.UP:
		direction = Vector2.DOWN
	if event.is_action_pressed("ui_left") && direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	if event.is_action_pressed("ui_right") && direction != Vector2.LEFT:
		direction = Vector2.RIGHT


func _on_eat_food(body):
	if body == head:
		increase_size()

func _on_hit_own_body(body):
	if body == head:
		direction = Vector2.ZERO
		dead = true

func move_head():
	previous_position = head.position
	head.move_and_collide(direction * stride)

func move_body():
	var child_nodes = body_nodes.get_children()
	for i in range(child_nodes.size() - 1):
		child_nodes[i].position = child_nodes[i + 1].position
	child_nodes[-1].position = previous_position

func increase_size():
	var body_node = body_ref.duplicate()
	var child_nodes = body_nodes.get_children()
	if child_nodes.size() > 0:
		body_node.position = child_nodes[-1].position
	else:
		body_node.position = Vector2.ZERO
	body_node.visible = true
	body_nodes.add_child(body_node)
