extends CharacterBody2D

var fireball_comp=preload("res://fireball.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var estado="parado"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if Input.is_action_just_pressed("tiro"):
		var fireball=fireball_comp.instantiate()
		var lado=sign($robo.scale.x)
		fireball.position=self.position+Vector2(30*lado,-30)
		fireball.linear_velocity=Vector2(lado*1000,0)
		get_node("..").add_child(fireball)
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if estado=="parado":
		if velocity.x!=0:
			estado="correndo"
			$robo/AnimationPlayer.play("correndo")
	if estado=="correndo":
		if velocity.x==0:
			estado="parado"
			$robo/AnimationPlayer.play("parado")
			
	if estado=="parado" or estado=="correndo":
		if is_on_floor()==false:
			estado="pulando"
			$robo/AnimationPlayer.play("pulando")
	if estado=="pulando":
		if is_on_floor()==true:
			estado="parado"	
			$robo/AnimationPlayer.play("parado")
			
	if velocity.x>0:
		$robo.scale.x=0.3
	if velocity.x<0:
		$robo.scale.x=-0.3
		
	if $ray_pulo.is_colliding():
		var obj=$ray_pulo.get_collider()
		if obj.is_in_group("inimigo"):
			obj.sofre_dano()
			velocity.y = JUMP_VELOCITY
			
			
		


func _on_hitbox_area_entered(area):
	if area.is_in_group("buraco"):
		get_node("../canvas_HUD/label_gameover").visible=true
		get_tree().paused=true


func _on_hitbox_body_entered(body):
	if body.is_in_group("inimigo"):
		get_node("../canvas_HUD/label_gameover").visible=true
		get_tree().paused=true		
