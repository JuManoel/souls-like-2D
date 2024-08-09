extends Area2D

var dano = 10
@export
var is_ataking = false

var danoReducion = 50
var estaminaConsume = 20

var positionRotate = 72

var startTime = false
var isdef = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print($Timer.time_left)
	pass

func atacar():
	$Animations.play("atacar")

func _on_body_entered(body):
	$Animations.play("RESET")
	body.dano(dano)

func defender():
	if(!startTime or !isdef):
		$Timer.start()
		startTime = true
	$EspadaDef.visible = true
	$ColisionDef.disabled = false
	isdef = true

func isNotDef():
	isdef = false
	$EspadaDef.visible = false
	$ColisionDef.disabled = true
