extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
@onready var shader_material := material as ShaderMaterial

var rock_scene = preload("res://scenes/objects/rocks/stone.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)
	
func on_hurt(hit_damge: int) -> void:
	damage_component.apply_damage(hit_damge)
	shader_material.set_shader_parameter("shake_intensity", 0.3)
	await get_tree().create_timer(0.5).timeout
	shader_material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damage_reached() -> void:
	call_deferred("add_stone_scene")
	queue_free()

func add_stone_scene() -> void:
	var rock_intance = rock_scene.instantiate() as Node2D
	rock_intance.global_position = global_position
	get_parent().add_child(rock_intance)
