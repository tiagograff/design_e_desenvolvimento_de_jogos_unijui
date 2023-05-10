extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
@export var direction = 1.0
var estado="ativo"
var timer_inativo=2.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):	
	if estado=="inativo":
		position.y+=delta*300.0
		rotation_degrees+=delta*360
		timer_inativo=timer_inativo-delta
		if timer_inativo<=0:
			queue_free()
		
	if estado=="ativo":
		if $ray_dir.is_colliding():
			direction=-1
		if $ray_esq.is_colliding():
			direction=1	
			
		if $ray_chao_dir.is_colliding()==false and $ray_chao_esq.is_colliding()==true:
			direction=-1
		if $ray_chao_dir.is_colliding()==true and $ray_chao_esq.is_colliding()==false:
			direction=1		
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta


		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		
func sofre_dano():
	estado="inativo"
	$CollisionShape2D.disabled=true
	$anim.play("desmaio")


func _on_hitbox_body_entered(body):
	if body.is_in_group("fireball"):
		sofre_dano()
		body.queue_free()
