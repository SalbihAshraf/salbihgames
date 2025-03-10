extends AnimatedSprite2D
var m_Pos_prev : = Vector2(0,0)
var m_Pos_curr: = Vector2(0,0)
var parent: CharacterBody2D

func _ready():
	parent = get_parent()
	m_Pos_prev = parent.get_global_position()
	m_Pos_curr = parent.get_global_position()
	set_global_position(parent.get_global_position())


func _process(_delta):
	var f = Engine.get_physics_interpolation_fraction()
	set_global_position(m_Pos_prev.lerp(m_Pos_curr, f))


func _physics_process(_delta):
	m_Pos_prev = m_Pos_curr
	m_Pos_curr = parent.get_global_position()
