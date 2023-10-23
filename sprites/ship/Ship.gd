extends CharacterBody2D
class_name Ship

var body_type: String = 'ship'

enum SHIP_STYLE {
	BLACK, RED, GREEN, YELLOW, BLUE, WHITE
}

var styles = {
	SHIP_STYLE.BLACK: {'full': Vector2i(408, 115), 'damaged_1': Vector2i(0, 307), 'damaged_2': Vector2i(272, 345)},
	SHIP_STYLE.RED: {'full': Vector2i(204, 115), 'damaged_1': Vector2i(0, 77), 'damaged_2': Vector2i(272, 230)},
	SHIP_STYLE.GREEN: {'full': Vector2i(68, 192), 'damaged_1': Vector2i(340, 345), 'damaged_2': Vector2i(272, 115)},
	SHIP_STYLE.YELLOW: {'full': Vector2i(68, 307), 'damaged_1': Vector2i(340, 115), 'damaged_2': Vector2i(204, 345)},
	SHIP_STYLE.BLUE: {'full': Vector2i(68, 77), 'damaged_1': Vector2i(340, 230), 'damaged_2': Vector2i(272, 0)},
	SHIP_STYLE.WHITE: {'full': Vector2i(408, 0), 'damaged_1': Vector2i(0, 192), 'damaged_2': Vector2i(340, 0)},
}

@export var debug: bool = false
@export var controlled: bool = false
@export var speed: int = 500
@export var damage: int = 5
@export var max_health: int = 100
@export var style: SHIP_STYLE = SHIP_STYLE.RED
@export var rotation_precision: int = 108
@onready var _follow: PathFollow2D = $Path2D/PathFollow2D
@onready var health: int = self.max_health
var style_mod: String = 'full'

@onready var agent = $NavigationAgent2D as NavigationAgent2D
@onready var bullet_scene: PackedScene = preload("res://sprites/ship/Bullet.tscn")
@onready var smoke_scene: PackedScene = preload("res://sprites/ship/Smoke.tscn")
@onready var crew_scene: PackedScene = preload("res://sprites/ship/Crew.tscn")
@onready var trash_scene: PackedScene = preload("res://sprites/ship/Trash.tscn")
@onready var dead_ship_scene: PackedScene = preload("res://sprites/ship/DeadShip.tscn")
@onready var boat_scene: PackedScene = preload("res://sprites/ship/Boat.tscn")

var path_done = true
var pause_follow = false
var is_targeting = false
var target: Ship
var target_velocity: Vector2
var is_charged = false

var visible_enemies = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_style()
	_follow.position = position
	rotation = randf_range(-PI, PI)
	if not controlled:
		$FollowArea2D.body_entered.connect(_start_follow)
		$FollowArea2D.body_exited.connect(_end_follow)
		$AttackRangeArea2D.body_entered.connect(_start_target)
		$AttackRangeArea2D.body_exited.connect(_continue_follow)
		$AttackArea2D.body_entered.connect(_start_attack)
		$AttackArea2D.body_exited.connect(_start_target)
		$AttackTimer.timeout.connect(_update_attack)
		$FollowTimer.timeout.connect(_update_follow)
	else:
		$AttackTimer.timeout.connect(_update_attack)
	
	agent.velocity_computed.connect(on_velocity_computed)
	agent.target_reached.connect(on_target_reached)

func set_style(mod: String = 'full'):
	var rect = Rect2(styles[style][mod], $Sprite2D.region_rect.size)
	$Sprite2D.region_rect = rect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controlled:
		var _direction = rotation
		var _up_pressed = Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")
		is_targeting = true
		if Input.is_action_pressed("ui_right"):
			_direction += PI/rotation_precision * (0.55 if _up_pressed else 1)
		elif Input.is_action_pressed("ui_left"):
			_direction -= PI/rotation_precision * (0.55 if _up_pressed else 1)
		elif _up_pressed:
			pass
		else:
			is_targeting = false
		if is_targeting:
			_direction += PI/2
			target_velocity = Vector2(cos(_direction), sin(_direction))

func _physics_process(delta: float) -> void:
	if not path_done and not pause_follow and not agent.is_navigation_finished():
		var next_location = agent.get_next_path_position()
		if debug:
			print('go to ', next_location)
		var v = (next_location - global_position).normalized()
		agent.set_velocity(v * speed)
	if is_targeting:
		velocity = normalize_velocity(target_velocity) * speed * .75
		move_and_slide()
		rotation = (5 * velocity + get_real_velocity()).angle() - PI / 2

func on_velocity_computed(safe_velocity: Vector2) -> void:
	if not path_done and not pause_follow and not agent.is_navigation_finished():
		velocity = normalize_velocity(safe_velocity.normalized()) * speed
		move_and_slide()
		if velocity.length_squared() > 0:
			rotation = (5 * velocity + get_real_velocity()).angle() - PI / 2

func on_target_reached() -> void:
	path_done = true

func navigate(_target: Vector2):
	if _target.distance_squared_to(position) < 75*75:
		return
	
	if debug:
		print('move to ', _target)
	agent.set_target_position(_target)
	is_targeting = false
	path_done = false

func navigate_shot_range(_target: Vector2):
	var _target_direction = _target.direction_to(position)
	var _direction = Vector2(randi_range(-30, 30), randi_range(-30, 30)).normalized()
	navigate(_target + ((_direction + _target_direction).normalized() * 150))

func normalize_velocity(_target_velocity: Vector2):
	var _normalized = velocity.normalized()
	if absf(_normalized.angle_to(_target_velocity)) > PI / 8:
		return (3 * _normalized + _target_velocity).normalized()
	return _target_velocity

func _start_follow(_body):
	if is_enemy_ship(_body):
		visible_enemies[_body.get_instance_id()] = 1

func _end_follow(_body):
	if is_enemy_ship(_body):
		visible_enemies.erase(_body.get_instance_id())

func _start_target(_body):
	if is_enemy_ship(_body):
		visible_enemies[_body.get_instance_id()] = 2
		if not controlled:
			pause_follow = true
		is_targeting = true
		var _vector = position - _body.position
		var _perpendicular = Vector2(_vector.y, -_vector.x)
		var _angle = abs(rotation_degrees - _body.rotation_degrees)
		if _angle > 150 and _angle < 200:
			_perpendicular = _perpendicular - _vector / 2
		target_velocity = _perpendicular.normalized()
		if debug:
			print(target_velocity)

func _continue_follow(_body):
	if is_enemy_ship(_body):
		visible_enemies[_body.get_instance_id()] = 1

func _start_attack(_body):
	if is_enemy_ship(_body):
		visible_enemies[_body.get_instance_id()] = 3
		if is_charged:
			_update_attack()
			$AttackTimer.start()

func _update_follow():
	is_targeting = false
	if target and (not is_instance_valid(target) or not visible_enemies.has(target.get_instance_id())):
		target = null
	for _id in visible_enemies:
		if not is_instance_id_valid(_id):
			visible_enemies.erase(_id)
		elif not target or visible_enemies[target.get_instance_id()] < visible_enemies[_id]:
			target = instance_from_id(_id)
	if target:
		var _priority = visible_enemies[target.get_instance_id()]
		if not controlled and _priority == 1:
			pause_follow = false
			if debug:
				print('come closer to ', target.position)
			navigate_shot_range(target.position)
		if _priority == 2 and (not controlled or path_done):
			#pause_follow = true
			if debug:
				print('start target to ', target.position)
			_stop_navigation()
			_start_target(target)
		if _priority == 3:
			if debug:
				print('shooting')
			_stop_navigation()
	elif not controlled:
		if debug:
			print('stop')
		_stop_navigation()

func _stop_navigation():
	agent.set_target_position(position)
	velocity = Vector2.ZERO
	path_done = true

func _update_attack():
	is_charged = true
	if $AttackArea2D.has_overlapping_bodies():
		var bodies = $AttackArea2D.get_overlapping_bodies()
		for _body in bodies:
			if is_enemy_ship(_body):
				is_charged = false
				var _bullet = bullet_scene.instantiate() as Node2D
				var _smoke = smoke_scene.instantiate() as Node2D
				var _start_position = position + Vector2(0, randi_range(-40, 40)).rotated(rotation)
				_bullet.position = _start_position
				_smoke.position = _start_position
				var _target = _body.position + Vector2(0, randi_range(-40, 40)).rotated(_body.rotation)
				_smoke.rotation = _smoke.position.angle_to_point(_target)
				_smoke.z_index = 200
				var _duration = _bullet.set_target(_target)
				get_parent().add_child(_bullet)
				get_parent().add_child(_smoke)
				get_tree().create_timer(_duration).timeout.connect(func():
					if is_instance_valid(_body) and _target.distance_squared_to(_body.position) < 600:
						var _attack_direction = (_target - _start_position).normalized()
						if _body.get_damage(damage, _target, _attack_direction):
							target = null
							pause_follow = false
							_stop_navigation()
				)
				get_tree().create_timer(1.5).timeout.connect(func():
					if is_instance_valid(_smoke):
						_smoke.queue_free()
				)
				return

func get_damage(_damage: int, _target: Vector2, _direction: Vector2):
	health = max(health - _damage, 0)
	var _new_style = _get_style_mod()
	if style_mod != _new_style:
		set_style(_new_style)
	
	if randi_range(1, 10) > 7:
		var _crew = crew_scene.instantiate() as Node2D
		_crew.position = _target
		var _fall_direction = _direction
		get_parent().add_child(_crew)
		var _fall_target = _target + _fall_direction * randf_range(50, 80)
		_fall_target = _fall_target + Vector2(randi_range(-40, 40), 0).rotated(rotation)
		_crew.set_target(_fall_target)
	
	if randi_range(1, 10) > 4:
		var _trash = trash_scene.instantiate() as Node2D
		_trash.position = _target
		var _fall_direction = _direction
		get_parent().add_child(_trash)
		var _fall_target = _target + _fall_direction * randf_range(30, 60)
		_fall_target = _fall_target + Vector2(randi_range(-40, 40), 0).rotated(rotation)
		_trash.set_target(_fall_target)
	
	if debug:
		print(health)
	if health == 0:
		if debug:
			print('death')
		$FollowTimer.stop()
		$AttackTimer.stop()
		_stop_navigation()
		var _dead = dead_ship_scene.instantiate() as Node2D
		_dead.position = position
		_dead.rotation = rotation
		_dead.style = style
		get_parent().add_child(_dead)
		var _boat = boat_scene.instantiate() as Node2D
		_boat.position = position + Vector2(randi_range(-10, 10), randi_range(-10, 10))
		_boat.rotation = rotation + randf_range(-PI/2, PI/2)
		_boat.direction = Vector2(cos(_boat.rotation+PI/2), sin(_boat.rotation+PI/2))
		get_parent().add_child(_boat)
		queue_free()
	return health == 0

func heal(_heal: int):
	health = min(health + _heal, max_health)
	var _new_style = _get_style_mod()
	if style_mod != _new_style:
		set_style(_new_style)

func _get_style_mod():
	var percent_health = health * 100 / max_health
	if percent_health < 30:
		return 'damaged_2'
	if percent_health < 75:
		return 'damaged_1'
	return 'full'

func see_enemies() -> bool:
	for _body in $FollowArea2D.get_overlapping_bodies():
		if is_enemy_ship(_body):
			return true
	return false

func is_ship(_body) -> bool:
	return _body.is_class("CharacterBody2D") and _body.body_type == 'ship'

func is_enemy_ship(_body) -> bool:
	return is_ship(_body) and _body.style != style
