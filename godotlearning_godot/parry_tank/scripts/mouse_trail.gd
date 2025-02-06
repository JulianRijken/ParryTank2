class_name MouseTrail extends Line2D

class Point:
	var position: Vector2
	var distance: float
	var time: float

	func _init(_position, _distance = 0.0, _time = 0.0):
		position = _position
		distance = _distance
		time = _time
 
var queue: Array[Point]
var distance: float
var lastPosition: Vector2

@export var _placeInterval: float = 30
@export var _removeTime: float = 0.2

func _ready() -> void:
	width * (get_viewport_rect().size.y / 1080)

func _process(_delta):
	var pos = get_global_mouse_position()
	var distanceMoved = Vector2(pos - lastPosition).length()
	distance += distanceMoved
	lastPosition = pos
	
	
	# Add points
	while distance > _placeInterval:
		queue.push_front(Point.new(pos))
		distance -= _placeInterval
	
	# Increment time
	for point in queue:
		point.time += _delta
	
	# Remove points
	while not queue.is_empty() and queue.back().time > _removeTime:
		queue.pop_back() 
		
	# Update points from line
	clear_points()
	add_point(pos) # Always one extra at the target
	for point in queue:
		add_point(point.position)
