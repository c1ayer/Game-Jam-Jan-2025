extends Node2D

var number_of_water = 200
var pressureMult = 100000
var targetDensity = .2
var smoothingRadius = 100
var densities = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var rowsize = 20
	var spacing = 50
	var water_scene = preload("res://water.tscn")
	densities.resize(number_of_water)
	
	for i in number_of_water:
		#add a bunch of water particles
		var active_water = water_scene.instantiate()
		add_child(active_water)
		var x = (i % rowsize + 1) * spacing
		var y = ((i-i%rowsize)/rowsize + 1) * spacing
		active_water.position = Vector2(x,y)
		active_water.waterNumber = i
		
	#CalculateDensity(Vector2(500,200))
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for ichild in get_child_count():
		if(get_child(ichild).is_class("RigidBody2D")): #should be more specific, like water.gd or has_method
			var density = CalculateDensity(get_child(ichild).position)
			densities[get_child(ichild).waterNumber] = density
	for ichild in get_child_count():
		if(get_child(ichild).is_class("RigidBody2D")): #should be more specific, like water.gd or has_method
			var pressureForce = CalcPressureForce(get_child(ichild).position,get_child(ichild).waterNumber)
			var pressureAcc = -pressureForce/densities[get_child(ichild).waterNumber]
			get_child(ichild).linear_velocity += pressureAcc * delta

func DensityKernel(radius,distance):
	var volume = PI * radius**4 /6
	var tmp = max(0,radius -distance)
	return tmp**2 / volume*1000
	
func DensityDerivativeKernel(radius,distance):
	var volume = PI * radius**4 /12
	var tmp = max(0,radius -distance)
	return -tmp / volume*1000

func CalculateDensity(samplePos):
	var density = 0
	var mass = 1
	
	#loop over particle positions
	for ichild in get_child_count():
		if(get_child(ichild).is_class("RigidBody2D")): #should be more specific, like water.gd or has_method
			var distance = (get_child(ichild).position - samplePos).length()
			if(distance < smoothingRadius):
				density += DensityKernel(smoothingRadius,distance)
	return(density)
	
func CalcPressureForce(samplePos,tmpWaterNumber):
	var pressureForce = Vector2(0,0)
	var myPressure = (densities[tmpWaterNumber] - targetDensity)* pressureMult #pressure at particle
	
	for ichild in get_child_count():
		if(get_child(ichild).is_class("RigidBody2D")): #should be more specific, like water.gd or has_method
			var distance = (get_child(ichild).position - samplePos).length()
			if(distance < smoothingRadius and distance > 0):
				var direction = (get_child(ichild).position - samplePos).normalized() #direction of particle
				var slope = DensityDerivativeKernel(smoothingRadius,distance) # slope of density deriv (pressure slope)
				var pressure = (densities[get_child(ichild).waterNumber] - targetDensity)* pressureMult #pressure at particle
				var sharedPressure = (pressure + myPressure)/2
				pressureForce += - sharedPressure * direction * slope / densities[get_child(ichild).waterNumber]
	return pressureForce
	
#ToDo:
# Optimise so I can run more particles
# Add viscosity 
# figure out perfect constants: pressure mult, smoothing radius, gravity, target density, size of water, # of water
