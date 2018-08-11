extends KinematicBody2D

var _car_location = Vector2()
# var _car_heading = -90 * (PI/180)
var _car_heading = -PI/2
var _car_speed = 0
var _steer_angle = 0
var _wheel_base = 50
var _front_wheel = Vector2()
var _back_wheel = Vector2()

func _ready():
	_car_location = self.position
	_front_wheel = _car_location + _wheel_base/2 * Vector2(cos(_car_heading), sin(_car_heading))
	_back_wheel = _car_location - _wheel_base/2 * Vector2(cos(_car_heading), sin(_car_heading))
	print("car location " , _car_location)
	print("node position " , self.position)
	


func _input(event):
	if(Input.is_action_pressed("ui_left")):
		if(_steer_angle >= -35 * (PI/180)):
			_steer_angle -= 0.1
			print("wheel_angle: ", _steer_angle)

	if(Input.is_action_pressed("ui_right")):
		if(_steer_angle <= 35 * (PI/180)):
			_steer_angle += 0.1
			print("wheel_angle: ", _steer_angle)

	if(Input.is_action_pressed("ui_down")):
		_car_speed -= 2
		print("car_speed: " , _car_speed)

	if(Input.is_action_pressed("ui_up")):
		_car_speed += 2
		print("car_speed: " , _car_speed)
	
	

func _process(delta):
	_front_wheel += _car_speed * delta * Vector2(cos(_car_heading + _steer_angle), sin(_car_heading + _steer_angle))
	_back_wheel += _car_speed * delta * Vector2(cos(_car_heading), sin(_car_heading))
	_car_location = (_front_wheel + _back_wheel) / 2
	_car_heading = atan2(_front_wheel.y - _back_wheel.y, _front_wheel.x - _back_wheel.x)
	
	_front_wheel = _car_location + _wheel_base/2 * Vector2(cos(_car_heading), sin(_car_heading))
	_back_wheel = _car_location - _wheel_base/2 * Vector2(cos(_car_heading), sin(_car_heading))
	self.position = _car_location
	self.rotation = _car_heading

	pass
