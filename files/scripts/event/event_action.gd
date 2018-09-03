###Ku-Ku-Ku-Kurapanda!!!
###EventAction - One action within an Event

#Resources
const ReqCheck = preload("res://files/scripts/event/event_requirement_check.gd")

###Member Variables
var event
var actionType = 'dialogue' #Types - 'dialogue', 'scene', 'decision'
var text = ''
var image = ''
var sprites = []
var nodes = []

	
###Public Functions
#'Node' accessors
func add_node(node): #node = {eventState = eventStateVal, meta = {requirements = {}, result = {}}}
	nodes.append(node)

func get_node():	
	var decisionNode
	var defaultNodes = []
	var availableNodes = []
	
	#Fill in defaultNodes & availableNodes
	for inode in nodes:		
		if inode.meta.requirements.empty():
			defaultNodes.append(inode)
			continue
					
		var checkResult = ReqCheck.check_requirements(inode.meta.requirements)
		if checkResult.meetsReqs:
			availableNodes.append(inode)
	
	#Select decisionNode
	if availableNodes.empty():
		var diceRoll = randi() % defaultNodes.size()
		decisionNode = defaultNodes[diceRoll]
	else:
		var diceRoll = randi() % availableNodes.size()
		decisionNode = availableNodes[diceRoll]
		
	return decisionNode
	
#'Button' accessors
func add_button(buttonName, newEventState, buttonMeta = {requirements = {}, result = {}}):
	nodes.append({name = buttonName, eventState = newEventState, meta = buttonMeta})
		
func get_buttons():
	var checkResult
	var finalButtons = []		
	
	for ibutton in nodes:
		var result = ibutton.meta.result
		checkResult = ReqCheck.check_requirements(ibutton.meta.requirements)
		
		if checkResult.meetsReqs: #No missing reqs			
			finalButtons.append({name = ibutton.name, text = ibutton.name, function = '_process_event', args = [ibutton.eventState, event, result]})  #ToFix - name, text are redundant, because outside.buildbuttons() and mansion.dialogue() are inconsistent
		else:
			finalButtons.append({name = ibutton.name, text = ibutton.name, function = '_process_event', args = [ibutton.eventState, event, result], disabled = true, tooltip = checkResult.meta.tooltip})				
		
	return finalButtons
	
#Utiliy Functions	
func clear():
	event = null
	actionType = 'decision' #default type
	text = ''
	image = ''
	sprites.clear()
	nodes.clear()
	
#File system functions
func to_dict():
	var actionDict = {'actionType' : actionType, 'text' : text, 'image' : image, 'sprites': sprites, 'nodes' : nodes}
	return actionDict
	
func from_dict(actionDict):
	clear()		
	actionType = actionDict.actionType
	text = actionDict.text
	image = actionDict.image
	sprites = actionDict.sprites
	nodes = actionDict.nodes