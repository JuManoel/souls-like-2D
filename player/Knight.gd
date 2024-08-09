extends CharacterBody2D


const SPEED = 300.0 #It can be changed
var this_delta = 0
@export
var is_doging = false
var is_running = false
var is_moving = false
var last_direcion = Vector2(0,0)
var is_ataking = false

var vida_max = 300
var stamina_max = 100
var energia_max = 50



var regen_estamina = 30
var consumo_min = 20

var flip_h = false
var flip_v = false

var arma = null
var armaRotate = 0
#Explaining the components of my Knight
#CollisionWalls: its propose is only to collide with the wall of the game
#Do not change it. It must be the bigest player's collisionshape
#CollisionDamage: To recive damage from enemys. it can be desable if the knight
#start to rols (like in dark souls)
#Equipament: healing potion, weapons, usable itens, will be ther.
#I must do a input map for it
#Sprite2D: for now is a sprite, but I will change for a AnimationSprite Later
#LightPlayer: Maybe the map will be dark, so the light will help us to see
#Camera: is just de Camera
	
func _ready():
	$Estatus/Vida.set_max(vida_max)
	$Estatus/Stamina.set_max(stamina_max)
	$Estatus/Mana.set_max(energia_max)
	
	$Estatus/Vida.value = vida_max
	$Estatus/Stamina.value = stamina_max
	$Estatus/Mana.value = energia_max
	
	arma = $Equipament/weapon.get_child(0)
	armaRotate = arma.positionRotate


func _physics_process(delta):
	this_delta = delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	getInput()
	move_and_slide()
	if(!is_doging and  !is_running and !arma.is_ataking):
		$Estatus/Stamina.value += regen_estamina*delta



func getInput():
	var directionX = Input.get_axis("esquerda", "direita")
	var directionY = Input.get_axis("cima","baixo")
	is_running = Input.is_action_pressed("correr")
	var atk = Input.is_action_just_pressed("atacar")
	var douge = Input.is_action_just_pressed("rolar")
	var defeder = Input.is_action_pressed("defeder")
	if(!is_moving): 
		is_running = false
	move(directionX,directionY)
	accion(atk,douge)
	move_weapon()
	protect(defeder)
	
func move(directionX,directionY):
	if(arma.is_ataking):
		velocity = Vector2(0,0)
		return
	if(!is_doging ):
		if directionX:
			velocity.x = directionX * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if directionY:
			velocity.y = directionY * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		if directionX and directionY:
			velocity*=(sqrt(2)/2)
		
		if(directionX!=0 or directionY!=0):
			last_direcion = velocity
			is_moving = true
			if(is_running and $Estatus/Stamina.value>0):
				velocity*=2
				$Estatus/Stamina.value -= 15*this_delta
				return
			return
		is_moving = false
		return
	velocity = last_direcion

func accion(atk,douge):
	if(!arma.is_ataking):
		if(douge):
			if($Estatus/Stamina.value > consumo_min):
				$Estatus/Stamina.value -= 20
				$AnimationPlayer.play("douge")
				
		if(atk and !douge):
			if(arma != null):
				if( $Estatus/Stamina.value >= consumo_min):
					$Estatus/Stamina.value -= 30
					arma.atacar()

		
func move_weapon():
	if(!arma.is_ataking):
		if(last_direcion.x>0):
			$Equipament/weapon.rotation = 0
			$Equipament/weapon.position = Vector2(armaRotate,0)
		elif(last_direcion.x<0):
			$Equipament/weapon.rotation = PI
			$Equipament/weapon.position = Vector2(-armaRotate,0)
		if(last_direcion.x == 0):
			if(last_direcion.y<0):
				$Equipament/weapon.rotation = 3*PI/2
				$Equipament/weapon.position = Vector2(0,-armaRotate)
			elif(last_direcion.y>0):
				$Equipament/weapon.rotation = PI/2
				$Equipament/weapon.position = Vector2(0,armaRotate)
func protect(defede):
	if(!arma.is_ataking and !is_doging and defede):
		arma.defender()
		return
	arma.isNotDef()
