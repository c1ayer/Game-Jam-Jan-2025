extends Node2D

var number_of_water = 300
var pressureMult = 20000
var targetDensity = .6
var smoothingRadius = 50
var densities = []
var positions = [] #predicted positions
var spacialOffsets = []
var spacialIndices = []
var debuglist = []
var predictionFactor = .01


# Called when the node enters the scene tree for the first time.
func _ready():
	var rowsize = 40
	var spacing = 25
	var water_scene = preload("res://scenes/water.tscn")
	densities.resize(number_of_water)
	positions.resize(number_of_water)
	spacialIndices.resize(number_of_water)
	spacialOffsets.resize(number_of_water)
	
	for i in number_of_water:
		#add a bunch of water particles
		var active_water = water_scene.instantiate()
		add_child(active_water)
		var x = (i % rowsize + 1) * spacing
		var y = ((i-i%rowsize)/rowsize + 1) * spacing
		active_water.position = Vector2(x,y)
		active_water.waterNumber = i
		positions[active_water.waterNumber] = active_water.position
		#if active_water.waterNumber == 120:
			#active_water.modulate =Color.GREEN
		
	UpdateSpacialIndices()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var damping = .999
	for ichild in get_child_count():
		var tmpChild = get_child(ichild)
		if(tmpChild.has_method('NearPlayer')): #should be more specific, like water.gd or has_method
			positions[tmpChild.waterNumber] = tmpChild.position + tmpChild.linear_velocity * delta * predictionFactor
			var density = CalculateDensity(tmpChild.position)
			densities[tmpChild.waterNumber] = density
			#if tmpChild.waterNumber == 120:
				#tmpChild.modulate = Color.GREEN
			#else:
				#tmpChild.modulate = Color.WHITE
			#for j in debuglist.size():
				#if tmpChild.waterNumber == debuglist[j]:
					#tmpChild.modulate = Color.RED
	for ichild in get_child_count():
		var tmpChild = get_child(ichild)
		if(tmpChild.has_method('NearPlayer')): #should be more specific, like water.gd or has_method
			var pressureForce = CalcPressureForce(tmpChild.position,tmpChild.waterNumber)
			var pressureAcc = -pressureForce/densities[tmpChild.waterNumber]
			tmpChild.linear_velocity = tmpChild.linear_velocity*damping
			tmpChild.linear_velocity += pressureAcc * delta
			#print(pressureAcc, ' ', tmpChild.linear_velocity, ' ', delta)
	UpdateSpacialIndices()
	#print(spacialIndices,spacialOffsets)
	#print(densities,positions)

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
	for i in 9: #neighboring cells
		var hash = NeighborhoodLookup(samplePos,i)
		var key = hash % number_of_water
		var tmpIndex = spacialOffsets[key]
		while tmpIndex < number_of_water:
			var indexData = spacialIndices[tmpIndex]
			tmpIndex = tmpIndex + 1
			if indexData.x != key:
				break
			#if indexData.z != hash:
			#	continue
			var neighborWaterNumber = indexData.y
			var neighborPos = positions[neighborWaterNumber]
			var distance = (neighborPos - samplePos).length()
			if(distance < smoothingRadius and distance > 0):
				density += DensityKernel(smoothingRadius,distance)
	return(density)
	
func CalcPressureForce(samplePos,tmpWaterNumber):
	var pressureForce = Vector2(0,0)
	var myPressure = (densities[tmpWaterNumber] - targetDensity)* pressureMult #pressure at particle
	if tmpWaterNumber == 120:
		debuglist.clear()
	
	for i in 9: #neighboring cells
		var hash = NeighborhoodLookup(samplePos,i)
		var key = hash % number_of_water
		var tmpIndex = spacialOffsets[key]
		while tmpIndex < number_of_water:
			var indexData = spacialIndices[tmpIndex]
			tmpIndex = tmpIndex + 1
			if indexData.x != key:
				break
			#if indexData.z != hash:
			#	continue
			var neighborWaterNumber = indexData.y
			if neighborWaterNumber == tmpWaterNumber:
				continue
			var neighborPos = positions[neighborWaterNumber]
			var distance = (neighborPos - samplePos).length()
			if(distance < smoothingRadius and distance > 0):
				#if tmpWaterNumber == 120:
					#debuglist.append(neighborWaterNumber)
				var direction = (neighborPos - samplePos).normalized() #direction of particle
				var slope = DensityDerivativeKernel(smoothingRadius,distance) # slope of density deriv (pressure slope)
				var pressure = (densities[neighborWaterNumber] - targetDensity)* pressureMult #pressure at particle
				var sharedPressure = (pressure + myPressure)/2
				pressureForce += - sharedPressure * direction * slope / densities[neighborWaterNumber]
	return pressureForce
	
	
func NeighborhoodLookup(position, neighbor):
	var hashk1 = 15823
	var hashk2 = 9737333
	var offsets = [Vector2(-1,1),Vector2(0,1),Vector2(1,1),Vector2(-1,0),Vector2(0,0),Vector2(1,0),Vector2(-1,-1),Vector2(0,-1),Vector2(1,-1)]
	var base_cell = floor(position/smoothingRadius) #get integer ID
	#for i in 9: #neighboring cells
	var cell = base_cell + offsets[neighbor]
	var a = cell.x * hashk1
	var b = cell.y * hashk2
	var hash: int = a + b
	#var key = hash % number_of_water
	return (hash)
	
		
func UpdateSpacialIndices():
	for ichild in get_child_count():
		var tmpChild = get_child(ichild)
		if(tmpChild.has_method('NearPlayer')): #should be more specific, like water.gd or has_method
			var hash = NeighborhoodLookup(tmpChild.position,4)
			var key = hash % number_of_water
			spacialIndices[tmpChild.waterNumber] = Vector3(key,tmpChild.waterNumber,hash)
			spacialOffsets[tmpChild.waterNumber] = number_of_water
			
	spacialIndices.sort() #sort by key
	#print(spacialIndices) 
	
	for i in spacialIndices.size():
		var key = spacialIndices[i].x
		if i > 0:
			var keyPrev = spacialIndices[i-1].x
			if key != keyPrev:
				spacialOffsets[key] = i
				
	#print(spacialOffsets)
#ToDo:
# Optimise so I can run more particles
# Add viscosity 
# figure out perfect constants: pressure mult, smoothing radius, gravity, target density, size of water, # of water
