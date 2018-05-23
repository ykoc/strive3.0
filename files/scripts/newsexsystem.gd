extends Node

var parser = load("res://files/scripts/sexdescriptions.gd").new()

var participants = []
var givers = []
var takers = []
var turns = 0
var actions = []
var ongoingactions = []
var location
var selectmode = 'normal'

var takercategories = ['cunnilingus','rimjob','handjob','titjob','tailjob','blowjob']
var analcategories = ['assfingering','rimjob','missionaryanal','doggyanal','lotusanal','revlotusanal','doubledildoass','inerttaila','analvibrator','enemaplug','insertinturnsass']
var punishcategories = globals.punishcategories
var penetratecategories = ['missionary','missionaryanal','doggy','doggyanal','lotus','lotusanal','revlotus','revlotusanal','doubledildo','doubledildoass','inserttailv','inserttaila','tribadism','frottage']

var filter = ['nosehook','relaxinginsense','facesit','afacesit','grovel','enemaplug']


var statsicons = {
lub1 = load("res://files/buttons/sexicons/lub1.png"),
lub2 = load("res://files/buttons/sexicons/lub2.png"),
lub3 = load("res://files/buttons/sexicons/lub3.png"),
lub4 = load("res://files/buttons/sexicons/lub4.png"),
lub5 = load("res://files/buttons/sexicons/lub5.png"),
lust1 = load("res://files/buttons/sexicons/lust1.png"),
lust2 = load("res://files/buttons/sexicons/lust2.png"),
lust3 = load("res://files/buttons/sexicons/lust3.png"),
lust4 = load("res://files/buttons/sexicons/lust4.png"),
lust5 = load("res://files/buttons/sexicons/lust5.png"),
sens1 = load("res://files/buttons/sexicons/sens1.png"),
sens2 = load("res://files/buttons/sexicons/sens2.png"),
sens3 = load("res://files/buttons/sexicons/sens3.png"),
sens4 = load("res://files/buttons/sexicons/sens4.png"),
sens5 = load("res://files/buttons/sexicons/sens5.png"),
stress1 = load("res://files/buttons/icons/stress/2.png"),
stress2 = load("res://files/buttons/icons/stress/1.png"),
stress3 = load("res://files/buttons/icons/stress/3.png")
}


var selectedcategory = 'caress'
var categories = {caress = [], fucking = [], tools = [], SM = [], humiliation = [], other = []}


class member:
	var name
	var person
	var mood
	var submission
	var loyalty
	var lust = 0 setget lust_set
	var sens = 0 setget sens_set
	var lube = 0
	var pain = 0
	var role
	var sex
	var orgasms = 0
	var lastaction
	
	var svagina = 0
	var smouth = 0
	var sclit = 0
	var sbreast = 0
	var spenis = 0
	var sanus = 0
	var lewd
	
	var energy = 100
	
	var knowledge
	
	var giving = []
	var taking = []
	
	var vagina
	var penis
	var clit
	var breast
	var feet
	var acc1
	var acc2
	var acc3
	var acc4
	var acc5
	var acc6
	var mouth
	var anus
	var tail
	var strapon
	var posh1
	var mode = 'normal'
	var consent = true
	
	var actionshad = {addtraits = [], removetraits = [], samesex = 0, samesexorgasms = 0, oppositesex = 0, oppositesexorgasms = 0, punishments = 0, group = 0}
	
	func lust_set(value):
		lust = min(value, 1000)
	
	func sens_set(value):
		sens = min(value, 1000)
	
	func lube():
		if person.vagina != 'none':
			lube = lube + (sens/200)
			lube = min(5+lewd/20,lube)
	
	func actioneffect(acceptance, values, scenedict):
		var lewdinput = 0
		var lustinput = 0
		var sensinput = 0
		var paininput = 0
		if values.has("lewd"):
			lewdinput = values.lewd
		if values.has("lust"):
			lustinput = values.lust
		if values.has('sens'):
			sensinput = values.sens
		if values.has('pain'):
			paininput = values.pain
		
		if scenedict.scene.code in globals.punishcategories:
			if scenedict.givers.has(self):
				person.asser += rand_range(1,2)
			else:
				person.asser -= rand_range(1,2)
		
		if acceptance == 'good':
			sensinput *= rand_range(1.1,1.4)
			lustinput *= 2
		elif acceptance == 'average':
			sensinput *= 1.1
			lustinput *= 1
		else:
			sensinput *= 0.6
			lustinput *= 0.3
			if values.has('pain') == false:
				person.stress += rand_range(5,10)
		
		if values.has('tags'):
			if values.tags.has('punish'):
				if (person.obed < 90 || mode == 'forced') && (!person.traits.has('Masochist') && !person.traits.has('Likes it rough')):
					if values.has('obed') == false:
						values.obed = 0
					if values.has("stress") == false:
						values.stress = rand_range(3,5)
					person.obed += values.obed
					person.stress += values.stress
					if person.effects.has("captured") && randf() >= values.obed/2:
						person.effects.captured.duration -= 1
					self.lust += lustinput/4
					self.sens += sensinput/4
				else:
					self.lewd += lewdinput
					self.lust += lustinput
					self.sens += sensinput
					if person.asser < 35 && randf() < 0.1:
						actionshad.addtraits.append('Likes it rough')
					if !person.traits.has('Masochist'):
						if values.has('stress') == false:
							values.stress = rand_range(2,6)
						person.stress += values.stress
			if values.tags.has('pervert') && (acceptance == 'good' || person.traits.has('Pervert')):
				self.lust += lustinput
				self.sens += sensinput
				if lust >= 750 && randf() < 0.2:
					actionshad.addtraits.append("Pervert")
				else:
					person.stress += rand_range(2,4)
			elif values.tags.has('pervert'):
				self.lust += lustinput/1.75
				self.sens += sensinput/1.75
			if values.tags.has('group'):
				actionshad.group += 1
				self.lewd += lewdinput
				self.lust += lustinput
				self.sens += sensinput
		else:
			self.lewd += lewdinput
			self.lust += lustinput
			self.sens += sensinput
	

func _ready():
	for i in globals.dir_contents('res://files/scripts/actions'):
		if i.find('.remap') >= 0:
			continue
		var newaction = load(i).new()
		categories[newaction.category].append(newaction)
	for i in get_node("Panel/HBoxContainer").get_children():
		i.connect("pressed",self,'changecategory',[i.get_name()])
	
	filter = globals.state.actionblacklist
	
	var i = 5
	if globals.player.name == '':
		globals.itemdict.supply.amount = 10
		while i > 0:
			i -= 1
			var person = globals.newslave(globals.allracesarray[rand_range(0,globals.allracesarray.size())], 'random', 'random')
			var newmember = member.new()
			person.obed = 90
			person.lewdness = 70
			newmember.loyalty = person.loyal
			newmember.submission = person.obed
			newmember.person = person
			newmember.sex = person.sex
			newmember.name = person.name_short()
			newmember.svagina = person.sensvagina
			newmember.smouth = person.sensmouth
			newmember.spenis = person.senspenis
			newmember.sanus = person.sensanal
			newmember.lewd = person.lewdness
			participants.append(newmember)
		turns = variables.timeforinteraction
		changecategory('caress')
		clearstate()
		rebuildparticipantslist()

func _input(event):
	if !event is InputEventKey || is_visible_in_tree() == false:
		return
	var dict = {49 : 1, 50 : 2, 51 : 3, 52 : 4,53 : 5,54 : 6,55 : 7,56 : 8, 16777351 :1, 16777352 : 2, 16777353 : 3, 16777354 : 4, 16777355 : 5, 16777356: 6, 16777357: 7, 16777358: 8}
	if event.scancode in dict:
		var key = dict[event.scancode]
		if event.is_action_pressed(str(key)) == true && participants.size() >= key:
			if !givers.has(participants[key-1]) && !takers.has(participants[key-1]):
				$Panel/ScrollContainer/VBoxContainer.get_child(key).get_node('give').emit_signal("pressed")
			else:
				$Panel/ScrollContainer/VBoxContainer.get_child(key).get_node('take').emit_signal("pressed")
	if event.is_action_pressed("F") && $Panel/passbutton.disabled == false:
		_on_passbutton_pressed()


func startsequence(actors, mode = null, secondactors = []):
	participants.clear()
	get_node("Control").hide()
	for person in actors:
		var newmember = member.new()
		for i in actors + secondactors:
			if person != i:
				if person.sexexp.watchers.has(i.id):
					person.sexexp.watchers[i.id] += 1
				else:
					person.sexexp.watchers[i.id] = 1
		person.lastinteractionday = globals.resources.day
		newmember.loyalty = person.loyal
		newmember.submission = person.obed
		newmember.person = person
		newmember.sex = person.sex
		newmember.lust = person.lust*10
		newmember.sens = newmember.lust/2
		newmember.name = person.name_short()
		newmember.svagina = person.sensvagina
		newmember.smouth = person.sensmouth
		newmember.spenis = person.senspenis
		newmember.sanus = person.sensanal
		newmember.lewd = person.lewdness
		participants.append(newmember)
	
	if mode == 'abuse':
		for person in secondactors:
			var newmember = member.new()
			for i in actors + secondactors:
				if person != i:
					if person.sexexp.watchers.has(i.id):
						person.sexexp.watchers[i.id] += 1
					else:
						person.sexexp.watchers[i.id] = 1
			person.lastinteractionday = globals.resources.day
			newmember.loyalty = person.loyal
			newmember.submission = person.obed
			newmember.person = person
			newmember.sex = person.sex
			newmember.lust = person.lust*10
			newmember.sens = newmember.lust/2
			newmember.name = person.name_short()
			newmember.svagina = person.sensvagina
			newmember.smouth = person.sensmouth
			newmember.spenis = person.senspenis
			newmember.sanus = person.sensanal
			newmember.lewd = person.lewdness
			newmember.mode = 'forced'
			newmember.consent = false
			participants.append(newmember)
	get_node("Panel/sceneeffects").set_bbcode("You bring selected participants into your bedroom. ")
	for i in participants:
		i.person.attention = 0
	turns = variables.timeforinteraction
	changecategory('caress')
	clearstate()
	rebuildparticipantslist()
	

func clearstate():
	givers.clear()
	takers.clear()
	if givers.size() >= 1:
		givers.append(participants[0])

func changecategory(name):
	selectedcategory = name
	for i in get_node("Panel/HBoxContainer").get_children():
		if i.get_name() != name: i.set_pressed(false) 
		else: i.set_pressed(true)
	rebuildparticipantslist()

func rebuildparticipantslist():
	var newnode
	var effects
	if selectmode == 'ai':
		clearstate()
	for i in get_node("Panel/ScrollContainer/VBoxContainer").get_children() + get_node("Panel/GridContainer/GridContainer").get_children():
		if !i.get_name() in ['Panel', 'Button']:
			i.visible = false
			i.queue_free()
	for i in participants:
		newnode = get_node("Panel/ScrollContainer/VBoxContainer/Panel").duplicate()
		newnode.visible = true
		get_node("Panel/ScrollContainer/VBoxContainer").add_child(newnode)
		newnode.get_node("name").set_text(i.person.dictionary('$name'))
		newnode.get_node("name").connect("pressed",self,"slavedescription",[i])
		if givers.find(i) >= 0:
			newnode.get_node("give").set_pressed(true)
		elif takers.find(i) >= 0:
			newnode.get_node("take").set_pressed(true)
		newnode.set_meta("person", i)
		newnode.get_node("sex").set_texture(globals.sexicon[i.person.sex])
		newnode.get_node("sex").set_tooltip(i.person.sex)
		newnode.get_node("lust").set_texture(statsicons['lust' + str(max(1,ceil(i.lust/200)))])
		newnode.get_node("sens").set_texture(statsicons['sens' + str(max(1,ceil(i.sens/200)))])
		newnode.get_node("lube").set_texture(statsicons['lub' + str(clamp(ceil(i.lube/2), 1, 5))])
		newnode.get_node("stress").set_texture(statsicons['stress'+str(clamp(round(i.person.stress/33)+1,1,3))])
		newnode.get_node("stress").set_tooltip("Stress: " + str(floor(i.person.stress))+"%")
		newnode.get_node("give").connect("pressed",self,'switchsides',[newnode, 'give'])
		newnode.get_node("take").connect("pressed",self,'switchsides',[newnode, 'take'])
		newnode.get_node("portrait").texture = globals.loadimage(i.person.imageportait)
		newnode.get_node("portrait").connect("mouse_entered",self,'showbody',[i])
		newnode.get_node("portrait").connect("mouse_exited",self,'hidebody')
		if ai.has(i):
			newnode.get_node('name').set('custom_colors/font_color', Color(1,0.2,0.8))
			newnode.get_node('name').hint_tooltip = 'Leads'
		
		if i.person == globals.player:
			newnode.get_node("mood").hide()
			continue
		
		if i.person.obed < 90:
			newnode.get_node("mood").set("custom_colors/font_color", Color(1,i.person.obed/100,i.person.obed/100))
			newnode.get_node("mood").set_text("Rebellious")
		
		if i.mode == 'forced':
			newnode.get_node("mood").set("custom_colors/font_color", Color(1,i.person.obed/100,i.person.obed/100))
			newnode.get_node("mood").set_text("Forced")
		elif i.lust > 200:
			newnode.get_node("mood").set("custom_colors/font_color", Color(1,0.2,0.8))
			newnode.get_node("mood").set_text("Horny")
		else:
			newnode.get_node("mood").set_text("Neutral")
		
	var text = ''
	
	#check for double dildo scenes between participants
	var doubledildo = doubledildocheck()
	
	for i in categories[selectedcategory]:
		i.givers = givers
		i.takers = takers
		var result = checkaction(i, doubledildo)
		if result[0] == 'false':
			continue
		newnode = get_node("Panel/GridContainer/GridContainer/Button").duplicate()
		get_node("Panel/GridContainer/GridContainer").add_child(newnode)
		newnode.visible = true
		newnode.set_text(i.getname())
		if result[0] == 'disabled':
			newnode.disabled = true
			newnode.hint_tooltip = result[1]
		newnode.connect("pressed",self,'startscene',[i])
		if i.canlast == true && newnode.disabled == false:
			newnode.get_node("continue").visible = true
			newnode.get_node("continue").connect("pressed",self,'startscenecontinue',[i])
		for j in ongoingactions:
			if j.scene.code == i.code && j.givers == i.givers && j.takers == i.takers:
				newnode.get_node("continue").pressed = true
	if selectedcategory == 'caress' && givers.size() >= 1 && givers[0].person != globals.player && selectmode != 'ai':
		newnode = get_node("Panel/GridContainer/GridContainer/Button").duplicate()
		get_node("Panel/GridContainer/GridContainer").add_child(newnode)
		newnode.visible = true
		if givers.size() < 2:
			newnode.set_text(givers[0].person.dictionary("Let $name Lead"))
		else:
			newnode.set_text("Let Selected Lead")
		newnode.connect("pressed",self,'activateai')
	elif selectmode == 'ai':
		newnode = get_node("Panel/GridContainer/GridContainer/Button").duplicate()
		get_node("Panel/GridContainer/GridContainer").add_child(newnode)
		newnode.visible = true
		newnode.set_text("Stop")
		newnode.connect("pressed",self,'activateai')
	$Panel/GridContainer/GridContainer.move_child($Panel/GridContainer/GridContainer/Button, $Panel/GridContainer/GridContainer.get_child_count()-1)
	for i in givers:
		text += '[color=yellow]' + i.name + '[/color], '
	if givers.size() == 0:
		text += '[...] '
	text += 'will do it ... to '
	for i in takers:
		text += '[color=aqua]' + i.name + '[/color], '
	if takers.size() == 0:
		text += "[...]"
	else:
		text = text.substr(0, text.length() -2)+ '. '
	text += "\n\n"
	for i in ongoingactions:
		text += decoder(i.scene.getongoingname(i.givers,i.takers), i.givers, i.takers) + ' [url='+str(ongoingactions.find(i))+'][Interrupt][/url]\n'
	
	if givers.size() == 0 && selectmode != 'ai':
		get_node("Panel/passbutton").set_disabled(true)
	else:
		get_node("Panel/passbutton").set_disabled(false)
	
	if selectmode == 'ai':
		$Panel/passbutton.set_text("Observe")
	else:
		$Panel/passbutton.set_text("Pass")
	
	get_node("TextureFrame/Label").set_text(str(turns))
	
	get_node("Panel/sceneeffects1").set_bbcode(text)
	
	globals.state.actionblacklist = filter
	
	if turns == 0:
		endencounter()

var ai = []

func activateai():
	for i in givers:
		if i.submission < 90 || i.consent == false:
			$Control/Panel/RichTextLabel.bbcode_text = i.person.dictionary('$name refuses to participate. ')
			return
	ai.clear()
	if selectmode != 'ai':
		selectmode = 'ai'
		for i in givers:
			if i.person != globals.player:
				ai.append(i)
	else:
		selectmode = 'normal'
	rebuildparticipantslist()


func doubledildocheck():
	var doubledildo = false
	var givercheck = false
	var takercheck = false
	
	for scene in ongoingactions:
		if scene.scene.code in ['doubledildo','doubledildoass','tribadism','frottage']:
			for i in givers:
				if scene.givers.has(i) || scene.takers.has(i):
					givercheck = true
			for i in takers:
				if scene.givers.has(i) || scene.takers.has(i):
					takercheck = true
		if givercheck && takercheck:
			doubledildo = true
			break
		else:
			givercheck = false
			takercheck = false
	return doubledildo

func checkaction(action, doubledildo):
	action.givers = givers
	action.takers = takers
	var disabled = false
	var hint_tooltip = ''
	if action.requirements() == false || filter.has(action.code):
		return ['false']
	elif doubledildo == true && action.category in ['caress','fucking'] && !action.code in ['doubledildo','doubledildoass','tribadism','frottage']:
		return ['false']
	for k in givers:
		if k.person == globals.player:
			continue
		if action.giverconsent != 'any' && ((k.mode == 'forced' || k.person.obed < 80) && !k.person.traits.has('Masochist') && !k.person.traits.has('Likes it rough') ):
			disabled = true
			hint_tooltip = k.person.dictionary("$name refuses to perform this action (low obedience)")
			continue
		elif action.giverconsent == 'advanced' && k.lewd < 50:
			disabled = true
			hint_tooltip = k.person.dictionary("$name refuses to perform this action (low lewdness)")
			continue
	for k in takers:
		if k.person == globals.player:
			continue
		if action.takerconsent != 'any' && ((k.mode == 'forced' || k.person.obed < 80) && !k.person.traits.has('Masochist') && !k.person.traits.has('Likes it rough')  ):
			disabled = true
			hint_tooltip = k.person.dictionary("$name refuses to perform this action (low obedience)")
			continue
		elif action.takerconsent == 'advanced' && k.lewd < 50:
			disabled = true
			hint_tooltip = k.person.dictionary("$name refuses to perform this action (low lewdness)")
			continue
	if disabled == true:
		return ['disabled',hint_tooltip]
	else:
		return ['allowed']


func slavedescription(member):
	get_parent().popup(member.person.descriptionsmall())

var nakedspritesdict = {
	Cali = {cons = 'calinakedhappy', rape = 'calinakedsad', clothcons = 'calineutral', clothrape = 'calisad'},
	Tisha = {cons = 'tishanakedhappy', rape = 'tishanakedneutral', clothcons = 'tishahappy', clothrape = 'tishaneutral'},
	Emily = {cons = 'emilynakedhappy', rape = 'emilynakedneutral', clothcons = 'emily2happy', clothrape = 'emily2worried'},
	Chloe = {cons = 'chloenakedhappy', rape = 'chloenakedneutral', clothcons = 'chloehappy2', clothrape = 'chloeneutral2'},
	Maple = {cons = 'fairynaked', rape = 'fairynaked', clothcons = 'fairy', clothrape = 'fairy'},
	Yris = {cons = 'yrisnormalnaked', rape = 'yrisshocknaked', clothcons = 'yrisnormal', clothrape = 'yrisshock'},
	Ayneris = {cons = 'aynerisneutralnaked', rape = 'aynerisangrynaked', clothcons = 'aynerisneutral', clothrape = 'aynerisangry'},
	Zoe = {cons = "zoehappynaked", rape = 'zoesadnaked', clothcons = 'zoehappy', clothrape = 'zoesad'},
	Melissa = {cons = "melissanakedfriendly", rape = 'melissanakedneutral', clothcons = 'melissafriendly', clothrape = 'melissaneutral'},
	}

func showbody(i):
	if globals.loadimage(i.person.imagefull) != null:
		$Panel/bodyimage.visible = true
		$Panel/bodyimage.texture = globals.loadimage(i.person.imagefull)
	elif nakedspritesdict.has(i.person.unique):
		if i.mode == 'forced':
			$Panel/bodyimage.texture = globals.spritedict[nakedspritesdict[i.person.unique].rape]
			$Panel/bodyimage.visible = true
		else:
			$Panel/bodyimage.texture = globals.spritedict[nakedspritesdict[i.person.unique].cons]
			$Panel/bodyimage.visible = true

func hidebody():
	$Panel/bodyimage.visible = false


func switchsides(panel, side):
	var person = panel.get_meta('person')
	givers.erase(person)
	takers.erase(person)
	if person.role == side:
		person.role = 'none'
	else:
		person.role = side
	if person.role == 'give':
		givers.append(person)
	elif person.role == 'take':
		takers.append(person)
	rebuildparticipantslist()

func startscene(scenescript, cont = false, pretext = ''):
	var textdict = {mainevent = pretext, repeats = '', orgasms = ''}
	var pain = 0
	var effects
	scenescript.givers = givers
	scenescript.takers = takers
	
	
	for i in givers + takers:
		if isencountersamesex(givers,takers,i) == true:
			i.actionshad.samesex += 1
		else:
			i.actionshad.oppositesex += 1
		if i.person.sexexp.actions.has(scenescript.code):
			i.person.sexexp.actions[scenescript.code] += 1
		else:
			i.person.sexexp.actions[scenescript.code] = 1
		for k in givers + takers:
			if k != i:
				if i.person.sexexp.partners.has(k.person.id):
					i.person.sexexp.partners[k.person.id] += 1
				else:
					i.person.sexexp.partners[k.person.id] = 1
	
	for i in participants:
		if !givers.has(i) && !takers.has(i):
			if i.person.sexexp.seenactions.has(scenescript.code):
				i.person.sexexp.seenactions[scenescript.code] += 1
			else:
				i.person.sexexp.seenactions[scenescript.code] = 1
	
	
	
	#temporary support for scenes converted to centralized output and those not
	#should be unified in the future
	var centralized = false
	if scenescript.has_method('initiate'):
		textdict.mainevent += decoder(scenescript.initiate(), givers, takers)
	else:
		centralized = true
		textdict.mainevent += output(scenescript, scenescript.initiate, givers, takers) + output(scenescript, scenescript.ongoing, givers, takers)
		
	turns -= 1
	
	if centralized == false:
		if scenescript.has_method('reaction'):
			for i in takers:
				textdict.mainevent += '\n' + decoder(scenescript.reaction(i), givers, [i])
	elif scenescript.reaction != null:
			for i in takers:
				textdict.mainevent += '\n' + output(scenescript, scenescript.reaction, givers, [i])
	
	#remove virginity if relevant
	if scenescript.virginloss == true:
		for i in givers:
			if scenescript.giverpart == 'vagina':
				i.person.vagvirgin = false
			elif scenescript.giverpart == 'anus':
				i.person.assvirgin = false
		for i in takers:
			if scenescript.takerpart == 'vagina':
				i.person.vagvirgin = false
			elif scenescript.takerpart == 'anus':
				i.person.assvirgin = false
	
	
	
	var dict = {scene = scenescript, takers = [] + takers, givers = [] + givers}
	
	for i in givers:
		if scenescript.giverpart != '':
			#print(i.name + " " + str(i[scenescript.giverpart]) + str(scenescript.giverpart))
			if i[scenescript.giverpart] != null:
				stopongoingaction(i[scenescript.giverpart])
			i[scenescript.giverpart] = dict
	
	for i in takers:
		if scenescript.takerpart != '':
			if i[scenescript.takerpart] != null:
				stopongoingaction(i[scenescript.takerpart])
			i[scenescript.takerpart] = dict
	
	if scenescript.get('takerpart2'):
		givers[1][scenescript.giverpart] = dict
		for i in takers:
			if i[scenescript.takerpart2] != null:
				stopongoingaction(i[scenescript.takerpart2])
			i[scenescript.takerpart2] = dict
	
	for i in givers: 
		if scenescript.has_method('givereffect'):
			effects = scenescript.givereffect(i)
			i.actioneffect(effects[0], effects[1], dict)
		i.lube()
		
	for i in takers:
		if scenescript.has_method('takereffect'):
			effects = scenescript.takereffect(i)
			i.actioneffect(effects[0], effects[1], dict)
		i.lube()
	
	#if scenescript.has(
	
	
	if scenescript.code in ['strapon', 'rope']:
		cont = true
	#to make action switch on that hole even if they comes from another body part
	if scenescript.code in ['doubledildo','doubledildoass','tribadism']:
		for i in ongoingactions:
			if i.scene.category == 'fucking' && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					stopongoingaction(i)
	if scenescript.code in ['cunnilingus','rimjob','facesit','afacesit','massagefoot','lickfeet']:
		for i in ongoingactions:
			if i.scene.category == 'fucking' && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					if i.scene.code != 'strapon':
						stopongoingaction(i)
	if scenescript.category == 'fucking':
		for i in ongoingactions:
			if i.scene.code in ['cunnilingus','rimjob','facesit','afacesit','massagefoot','lickfeet'] && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					stopongoingaction(i)
	if scenescript.code == 'grovel':
		for i in ongoingactions:
			if i.scene.code in ['facesit','afacesit'] && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					stopongoingaction(i)
	if scenescript.code in ['facesit','afacesit']:
		for i in ongoingactions:
			if i.scene.code == 'grovel' && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					stopongoingaction(i)
	
	
	
	var sceneexists = false
	var temptext = ''
	for i in ongoingactions:
		temptext = ''
		if i.givers == givers && i.takers == takers && i.scene == scenescript:
			sceneexists = true
		elif i.scene.has_method('getongoingdescription'):
			temptext = decoder(i.scene.getongoingdescription(i.givers, i.takers), i.givers, i.takers)
		else:
			temptext = output(i.scene, i.scene.ongoing, i.givers, i.takers)
		if temptext != '':
			textdict.repeats += '\n' + temptext
	textdict.repeats = textdict.repeats.replace("[color=yellow]", '').replace('[color=aqua]', '').replace('[/color]','')
	
	
	for i in ongoingactions:
		for k in i.givers + i.takers:
			k.person.sexexp.actions[i.scene.code] += 1
			for j in i.givers + i.takers:
				if j != k:
					if k.person.sexexp.partners.has(j.person.id):
						k.person.sexexp.partners[j.person.id] += 1
					else:
						k.person.sexexp.partners[j.person.id] = 1
		for k in participants:
			if !i.givers.has(k) && !i.takers.has(k):
				if k.person.sexexp.seenactions.has(i.scene.code):
					k.person.sexexp.seenactions[i.scene.code] += 1
				else:
					k.person.sexexp.seenactions[i.scene.code] = 1
		if i.scene.has_method("givereffect"):
			for member in i.givers:
				effects = i.scene.givereffect(member)
				member.actioneffect(effects[0], effects[1], i)
		if i.scene.has_method("takereffect"):
			for member in i.takers:
				effects = i.scene.takereffect(member)
				member.actioneffect(effects[0], effects[1], i)
	
	
	for i in participants:
		if i in givers+takers:
			i.lastaction = dict
			if i.sens >= 1000:
				if i.person.sexexp.orgasms.has(i.lastaction.scene.code):
					i.person.sexexp.orgasms[i.lastaction.scene.code] += 1
				else:
					i.person.sexexp.orgasms[i.lastaction.scene.code] = 1
				for k in i.lastaction.givers + i.lastaction.takers:
					if i != k:
						if i.person.sexexp.orgasmpartners.has(k.person.id):
							i.person.sexexp.orgasmpartners[k.person.id] += 1
						else:
							i.person.sexexp.orgasmpartners[k.person.id] = 1
				textdict.orgasms += '\n' + orgasm(i)
		if not i.lastaction in ongoingactions:
			i.lastaction = null
		
	
	if cont == true && sceneexists == false: 
		ongoingactions.append(dict)
	else:
		for i in givers:
			if scenescript.giverpart != '':
				i[scenescript.giverpart] = null
		for i in takers:
			if scenescript.takerpart != '':
				i[scenescript.takerpart] = null
	
	
	get_node("Panel/sceneeffects").set_bbcode(textdict.mainevent + "\n" + textdict.repeats + "\n" + textdict.orgasms)
	rebuildparticipantslist()
	


#Effects: pleasure, excitement, pain, deviancy, obedience 

func startscenecontinue(scenescript):
	startscene(scenescript, true)


var sexdict = load("res://files/scripts/newsexdictionary.gd").new()

#centralized output processing
#category currently assumed to be 'fucking', will expland with further conversions
func output(scenescript, valid_lines, givers, takers):
	var shared_lines = sexdict.shared_lines
	var giverpart = scenescript.giverpart
	var takerpart = scenescript.takerpart
	var act_lines = scenescript.act_lines
	var links = sexdict.linksets[scenescript.linkset]
	#internal
	var linearray = []
	var output = ''
	var virginpart = null
	var virginsource = null
	var link = null
	#checks
	var checks = {
		code = scenescript.code,
		link = null,
		orifice = 'insert',
		consent = true,
		virgin = true,
		parallel = true if scenescript.rotation1.x == scenescript.rotation2.x else false,
		facing = true if scenescript.rotation1.w == 0.0 && scenescript.rotation2.w == 0.0 else false,
		arousal = 1,
		lube = 1,
		lust = 1,
	}
	
	#link with ongoingactions
	if givers[0][giverpart] != null:
		if givers[0][giverpart].scene.code in links:
			link = givers[0][giverpart].scene
			for i in givers:
				if i[giverpart] != givers[0][giverpart]:
					link = null
					break
			for i in takers:
				if i[takerpart] != givers[0][giverpart]:
					link = null
					break
	#link with lastaction if ongoing fails
	if link == null && givers[0].lastaction != null:
		if givers[0].lastaction.scene.code in links:
			link = givers[0].lastaction.scene
			for i in givers+takers:
				if i.lastaction != givers[0].lastaction:
					link = null
					break
	#gather orifice info from link
	if link != null:
		checks.link = link.code
		if scenescript.virginloss == true && link.virginloss == true:
			if checks.code == link.code:
				checks.orifice = 'same'
			elif 'vagina' in [scenescript.giverpart] + [scenescript.takerpart] && 'vagina' in [link.giverpart] + [link.takerpart]:
				checks.orifice = 'shift'
			elif 'anus' in [scenescript.giverpart] + [scenescript.takerpart] && 'anus' in [link.giverpart] + [link.takerpart]:
				checks.orifice = 'shift'
			else:
				checks.orifice = 'swap'
	#virginity assignments
	if giverpart == 'penis':
		if takerpart == 'vagina':
			virginpart = 'vagvirgin'
			virginsource = takers
		elif takerpart == 'anus':
			virginpart = 'assvirgin'
			virginsource = takers
	elif takerpart == 'penis':
		if giverpart == 'vagina':
			virginpart = 'vagvirgin'
			virginsource = givers
		elif giverpart == 'anus':
			virginpart = 'assvirgin'
			virginsource = givers
	#assign virginity check
	for i in virginsource:
		if i.person[virginpart] == false:
			checks.virgin = false
	#assign consent
	for i in takers:
		if i.mode == 'forced':
			checks.consent = false
	#based on screen values, subject to adjustment
	if takers.size() == 1:
		checks.arousal = int(clamp(ceil(takers[0].sens/200), 1, 5))
		checks.lube = int(clamp(ceil(takers[0].lube/2), 1, 5))
		checks.lust = int(clamp(ceil(takers[0].lust/200), 1, 5))
	
	#build the output
	var drop = false
	for i in valid_lines:
		linearray = []
		if i in act_lines:
			for j in act_lines[i]:
				drop = false
				for k in act_lines[i][j].conditions:
					if checks.has(k) && !act_lines[i][j].conditions[k].has(checks[k]):
						drop = true
						break
				if drop == false:
					linearray += act_lines[i][j].lines
		if i in shared_lines:
			for j in shared_lines[i]:
				drop = false
				for k in shared_lines[i][j].conditions:
					if checks.has(k) && !shared_lines[i][j].conditions[k].has(checks[k]):
						drop = true
						break
				if drop == false:
					linearray += shared_lines[i][j].lines
		if linearray.size() > 0:
			output += linearray[randi()%linearray.size()]
	
	return decoder(output, givers, takers)


func orgasm(member):
	member.sens = member.sens/4
	member.lust -= 300
	var scene
	var text
	var temptext = ''
	var penistext = ''
	var vaginatext = ''
	var anustext = ''
	member.orgasms += 1
	if participants.size() == 2 && member.person != globals.player:
		member.person.loyal += rand_range(1,4)
	elif member.person != globals.player:
		member.person.loyal += rand_range(1,2)
	#anus in use, find scene
	if member.anus != null:
		scene = member.anus
		#anus in giver slot
		if scene.givers.find(member) >= 0:
			if randf() < 0.4:
				anustext = "[name1] feel[s/1] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him1] and [his1]"
			else:
				anustext = "[names1]"
			if scene.scene.takerpart == 'penis':
				anustext += " [anus1] {^squeezes:writhes around:clamps down on} [names2] [penis2] as [he1] reach[es/1] {^climax:orgasm}."
			else:
				anustext += " [anus1] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he1] reach[es/1] {^climax:orgasm}."
			anustext = decoder(anustext, [member], scene.takers)
		#anus is in taker slot
		elif scene.takers.find(member) >= 0:
			if randf() < 0.4:
				anustext = "[name2] feel[s/2] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him2] and [his2]"
			else:
				anustext = "[names2]"
			if scene.scene.giverpart == 'penis':
				anustext += " [anus2] {^squeezes:writhes around:clamps down on} [names1] [penis1] as [he2] reach[es/2] {^climax:orgasm}."
			else:
				anustext += " [anus2] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he2] reach[es/2] {^climax:orgasm}."
			anustext = decoder(anustext, scene.givers, [member])
		#no default conditon
	#vagina present
	if member.person.vagina != 'none':
		member.lube()
		#vagina in use, find scene
		if member.vagina != null:
			scene = member.vagina
			#vagina in giver slot
			if scene.givers.find(member) >= 0:
				if randf() < 0.4:
					vaginatext = "[name1] feel[s/1] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him1] and [his1]"
				else:
					vaginatext = "[names1]"
				if scene.scene.takerpart == 'penis':
					vaginatext += " [pussy1] {^squeezes:writhes around:clamps down on} [names2] [penis2] as [he1] reach[es/1] {^climax:orgasm}."
				else:
					vaginatext += " [pussy1] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he1] reach[es/1] {^climax:orgasm}."
				vaginatext = decoder(vaginatext, [member], scene.takers)
			#vagina is in taker slot
			elif scene.takers.find(member) >= 0:
				if randf() < 0.4:
					vaginatext = "[name2] feel[s/2] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him2] and [his2]"
				else:
					vaginatext = "[names2]"
				if scene.scene.giverpart == 'penis':
					vaginatext += " [pussy2] {^squeezes:writhes around:clamps down on} [names1] [penis1] as [he2] reach[es/2] {^climax:orgasm}."
				else:
					vaginatext += " [pussy2] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he2] reach[es/2] {^climax:orgasm}."
				vaginatext = decoder(vaginatext, scene.givers, [member])
			#no default conditon
	#penis present
	if member.person.penis != 'none':
		#penis in use, find scene
		if member.penis != null:
			scene = member.penis
			#penis in giver slot
			if scene.givers.find(member) >= 0:
				if randf() < 0.4:
					penistext = "[name1] feel[s/1] {^a wave of:an intense} {^pleasure:euphoria} {^run through:course through:building in} [his1] [penis1] and [his1]"
				else:
					penistext = "[name1] {^thrust:jerk}[s/1] [his1] hips forward and a {^thick :hot :}{^jet:load:batch} of"
				if scene.scene.takerpart == '':
					penistext += " {^semen:seed:cum} {^pours onto:shoots onto:falls to} the {^ground:floor} as [he1] ejaculate[s/1]."
				elif ['anus','vagina','mouth'].has(scene.scene.takerpart):
					if scene.scene.get('takerpart2') && scene.scene.givers[1] == member:
						temptext = scene.scene.takerpart2.replace('anus', '[anus2]').replace('vagina','[pussy2]')
					else:
						temptext = scene.scene.takerpart.replace('anus', '[anus2]').replace('vagina','[pussy2]')
						if scene.scene.takerpart == 'vagina':
							for i in scene.takers:
								globals.impregnation(i.person, member.person)
					penistext += " {^semen:seed:cum} {^pours:shoots:pumps:sprays} into [names2] " + temptext + " as [he1] ejaculate[s/1]."
					
				penistext = decoder(penistext, [member], scene.takers)
			#penis in taker slot
			elif scene.takers.find(member) >= 0:
				if randf() < 0.4:
					penistext = "[name2] feel[s/2] {^a wave of:an intense} {^pleasure:euphoria} {^run through:course through:building in} [his2] [penis2] and [his2]"
				else:
					penistext = "[name2] {^thrust:jerk}[s/2] [his2] hips forward and a {^thick :hot :}{^jet:load:batch} of"
				if scene.scene.code in ['handjob','titjob']:
					penistext += " {^sticky:white:hot} {^semen:seed:cum} {^sprays onto:shoots all over:covers} [names1] face[/s1] as [he2] ejaculate[s/2]."
				elif scene.scene.code == 'tailjob':
					penistext += " {^sticky:white:hot} {^semen:seed:cum} {^sprays onto:shoots all over:covers} [names1] tail[/s1] as [he2] ejaculate[s/2]."
				elif scene.scene.giverpart == '':
					penistext += " {^semen:seed:cum} {^pours onto:shoots onto:falls to} the {^ground:floor} as [he2] ejaculate[s/2]."
				elif ['anus','vagina','mouth'].has(scene.scene.giverpart):
					temptext = scene.scene.giverpart.replace('anus', '[anus1]').replace('vagina','[pussy1]')
					penistext += " {^semen:seed:cum} {^pours:shoots:pumps:sprays} into [names1] " + temptext + " as [he2] ejaculate[s/2]."
					if scene.scene.giverpart == 'vagina':
						for i in scene.givers:
							globals.impregnation(i.person, member.person)
				penistext = decoder(penistext, scene.givers, [member])
		#orgasm without penis, secondary ejaculation
		else:
			if randf() < 0.4:
				penistext = "[name2] {^twist:quiver:writhe}[s/2] in {^pleasure:euphoria:extacy} as"
			else:
				penistext = "[name2] {^can't hold back any longer:reach[es/2] [his2] limit} and"
			penistext += " {^a jet of :a rope of :}{^semen:cum} {^fires:squirts:shoots} from {^the tip of :}[his2] {^neglected :throbbing ::}[penis2]."
			penistext = decoder(penistext, null, [member])
	if vaginatext != '' || anustext != '' || penistext != '':
		text = vaginatext + " " + anustext + " " + penistext
	#final default condition
	else:
		if randf() < 0.4:
			temptext = "[name2] feel[s/2] a {^sudden :intense ::}{^jolt of electricity:heat:wave of pleasure} and [his2]"
		else:
			temptext = "[names2]"
		temptext += " {^entire :whole :}body {^twists:quivers:writhes} in {^pleasure:euphoria:extacy} as [he2] reach[es/2] {^climax:orgasm}."
		text = decoder(temptext, null, [member])
	
	
	if member.lastaction.scene.code in punishcategories && member.lastaction.takers.has(member):
		if randf() >= 0.85 || member.person.effects.has("entranced"):
			member.actionshad.addtraits.append("Masochist")
#	if member.lastaction.scene.code in punishcategories && member.lastaction.givers.has(member) && member.person.asser >= 60:
#		if randf() >= 0.85 || member.person.effects.has("entranced"):
#			member.actionshad.addtraits.append("Dominant")
	if member.lastaction.scene.code in analcategories && (member.lastaction.takers.has(member) || member.lastaction.scene.code == 'doubledildoass'):
		if randf() >= 0.85 || member.person.effects.has('entranced'):
			member.actionshad.addtraits.append("Enjoys Anal")
	if isencountersamesex(member.lastaction.givers, member.lastaction.takers, member) == true:
		member.actionshad.samesexorgasms += 1
	else:
		member.actionshad.oppositesexorgasms += 1
	
	
	return "[color=#ff5df8]" + text + "[/color]"

func isencountersamesex(givers, takers, actor = null):
	var actorpos = ''
	var samesex = false
	if givers.size() == 0 || takers.size() == 0:
		return false
	var giverssex = givers[0].sex
	var takerssex = takers[0].sex
	if givers.has(actor):
		actorpos = 'giver'
	elif takers.has(actor):
		actorpos = 'taker'
	
	if (actorpos == 'giver' && ((actor.sex == 'male' && takerssex == 'male') || (actor.sex in ['female','futa'] && takerssex in ['female','futa']))) || (actorpos == 'taker' && ((actor.sex == 'male' && giverssex == 'male') || (actor.sex in ['female','futa'] && giverssex in ['female','futa']))) :
		samesex = true
	return samesex


func decoder(text, tempgivers, temptakers):
	return parser.decoder(text, tempgivers, temptakers)


func _on_sceneeffects1_meta_clicked( meta ):
	stopongoingaction(meta, true)

func stopongoingaction(meta, rebuild = false):
	var action
	if typeof(meta) == TYPE_STRING:
		action = ongoingactions[int(meta)]
	elif typeof(meta) == TYPE_DICTIONARY:
		action = meta
	for i in action.givers:
		if action.scene.giverpart != '':
			i[action.scene.giverpart] = null
	for i in action.takers:
		if action.scene.takerpart != '':
			i[action.scene.takerpart] = null
		if action.scene.get("takerpart2"):
			i[action.scene.takerpart2] = null
	if action.scene.code == 'strapon' && action.givers[0]['penis'] != null:
		stopongoingaction(action.givers[0]['penis'])
	ongoingactions.erase(action)
	if rebuild == true:
		rebuildparticipantslist()

func _on_passbutton_pressed():
	if selectmode == 'normal':
		startscene(categories.other[0])
	else:
		askslaveforaction(ai[rand_range(0, ai.size())])

func _on_stopbutton_pressed():
	endencounter()

func endencounter():
	var mana = 0
	var totalmana = 0
	var text = ''
	for i in participants:
		i.person.lewdness = i.lewd
		i.person.lust = i.lust/10
		i.person.lastsexday = globals.resources.day
		text += i.person.dictionary("$name: Orgasms - ") + str(i.orgasms) 
		
		for trait in i.actionshad.addtraits:
			i.person.add_trait(trait)
		
		if i.actionshad.samesex > i.actionshad.oppositesex && i.actionshad.samesexorgasms > 0:
			if !i.person.traits.has("Bisexual") && !i.person.traits.has("Homosexual") && (randf() >= 0.5 || i.person.effects.has('entranced')):
				i.person.add_trait("Bisexual")
			elif i.person.traits.has("Bisexual") && (randf() >= 0.5 || i.person.effects.has('entranced')) && max(0.2,i.actionshad.samesex)/max(0.2, i.actionshad.oppositesex) > 4 :
				i.person.trait_remove("Bisexual")
				i.person.add_trait('Homosexual')
		if i.actionshad.samesex < i.actionshad.oppositesex && i.actionshad.oppositesexorgasms > 0:
			if (i.person.traits.has("Bisexual") || i.person.traits.has("Homosexual")) && (randf() >= 0.5 || i.person.effects.has('entranced')):
				if i.person.traits.has("Bisexual") && (randf() >= 0.5 || i.person.effects.has('entranced')) && max(0.2,i.actionshad.oppositesex)/max(0.2, i.actionshad.samesex) > 4:
					i.person.trait_remove("Bisexual")
				else:
					i.person.trait_remove("Homosexual")
					i.person.add_trait("Bisexual")
		if i.actionshad.group*0.01 > randf():
			i.person.trait_remove("Monogamous")
			i.person.add_trait("Fickle")
		
		if i.orgasms >= 1:
			if i.person.stats.maf_cur*20 > rand_range(0,100) && i.person.getessence() != null:
				text += ", Ingredient gained: [color=yellow]" + globals.itemdict[i.person.getessence()].name + "[/color]"
				globals.itemdict[i.person.getessence()].amount += 1
			mana += round(i.orgasms*3 + rand_range(1,2))
		else:
			mana += round(i.sens/500)
		if i.person.race == 'Dark Elf':
			mana = round(mana*1.2)
		if i.person.spec == 'nympho':
			mana += 2
		if i.person == globals.player:
			mana /= 2
		totalmana = mformula(mana, totalmana)
		text += "\n"
	totalmana = round(totalmana)
	text += "\nEarned mana: " + str(totalmana)
	
	globals.resources.mana += totalmana 
	
	ongoingactions.clear()
	
	get_node("Control").show()
	get_node("Control/Panel/RichTextLabel").set_bbcode(text)

func mformula(gain, mana):
    return mana + gain * max(0, mana/(mana-300)+1)



var actioncategories = {
caress = {dom = 'giver'},
kiss = {dom = 'any'},
fondletits = {dom = 'giver'},
sucknipples = {dom = 'giver'},
fingering = {dom = 'giver'},
assfingering = {dom = 'giver'},
cunnilingus = {dom = 'taker'},
rimjob = {dom = 'taker'},
handjob = {dom = 'taker'},
blowjob = {dom = 'taker'},
titjob = {dom = 'taker'},
tailjob = {dom = 'taker'},
footjob = {dom = 'giver'},

missionary = {dom = 'giver'},
missionaryanal = {dom = 'giver'},
doggy = {dom = 'giver'},
doggyanal = {dom = 'giver'},
lotus = {dom = 'giver'},
lotusanal = {dom = 'giver'},
revlotus = {dom = 'giver'},
revlotusanal = {dom = 'giver'},
doubledildo = {dom = 'any'},
doubledildoass = {dom = 'any'},
inserttailv = {dom = 'giver'},
inserttaila = {dom = 'giver'},
tribadism = {dom = 'any'},
frottage = {dom = 'any'},

strapon = {dom = 'any'},

spanking = {dom = 'giver'},
whipping = {dom = 'giver'},
deepthroat = {dom = 'giver'},
nippleclap = {dom = 'giver'},
clitclap = {dom = 'giver'},
ringgag = {dom = 'giver'},
blindfold = {dom = 'giver'},
nosehook = {dom = 'giver'},
vibrator = {dom = 'giver'},
analvibrator = {dom = 'giver'},
rope = {dom = 'giver'},
milker = {dom = 'giver'},
relaxinginsense = {dom = 'giver'},
mastshow = {dom = 'giver'},
grovel = {dom = 'giver'},
facesit = {dom = 'giver'},
afacesit = {dom = 'giver'},
massagefoot = {dom = 'giver'},
lickfeet = {dom = 'giver'},
enemaplug = {dom = 'giver'}


}

func askslaveforaction(chosen):
	#choosing target
	var targets = []
	clearstate()
	var chosensex = chosen.person.sex
	var debug = ""
	var group = false
	var target
	
	
	
	
	
	
	debug += 'Chosing targets... \n'
	
	for i in participants:
		if i != chosen:
			debug += i.name
			var value = 10
			if chosen.person.traits.has("Monogamous") && i.person != globals.player:
				value = 0
			elif chosen.person.traits.has("Fickle") || chosen.person.traits.has('Slutty'):
				value = 25
			if chosen.person.traits.has('Devoted') && i.person == globals.player:
				value += 50
			
			if chosen.person.sexexp.orgasms.has(i.person.id):
				value += chosen.person.sexexp.orgasms[i.person.id]*4
			if chosen.person.sexexp.watchers.has(i.person.id):
				value += (chosen.person.sexexp.watchers[i.person.id]-1)*2
			if chosen.person.sexexp.partners.has(i.person.id):
				value += chosen.person.sexexp.partners[i.person.id]/0.2
			if isencountersamesex([chosen], [i], chosen) && chosen.person.traits.has('Bisexual') == false && chosen.person.traits.has('Homosexual') == false:
				value = max(value/5,1)
			elif isencountersamesex([chosen], [i], chosen) == false && chosen.person.traits.has('Homosexual'):
				value = max(value/5,1)
			debug += " - " + str(value) + '\n'
			value = min(value, 120)
			if value > 0:
				targets.append([i, value])
	target = globals.weightedrandom(targets)
	debug += 'final target - ' + target.name
	
	
	
	
	
	debug += '\nChosing dom: \n'
	var dom = [['giver',40],['taker', 10]]
	
	if target.person.sex != chosen.person.sex && chosen.person.sex == 'female' && (chosen.person.asser < 75 || !chosen.person.traits.has("Dominant")):
		dom[0][1] = 0
	
	if chosen.person.asser >= 75:
		dom[1][1] = 0
	elif chosen.person.asser <= 25:
		dom[0][1] = 0
	debug += str(dom) + "\n"
	dom = globals.weightedrandom(dom)
	
	debug += 'final dom: ' + dom + '\n'
	
	var groupchosen = [chosen] 
	var grouptarget = [target]
	
	if participants.size() >= 3:
		if randf() >= 0.5 && chosen.person.traits.has("Monogamous") == false:
			group = true
	var freeparticipants = []
	
	if group == true:
		debug += "Group action attempt:\n"
		for i in participants:
			if i != chosen && i != target && randf() >= 0.5:
				freeparticipants.append(i)
		
		while freeparticipants.size() > 0:
			var targetgroup
			var newparticipant = freeparticipants[randi()%freeparticipants.size()]
			var samesex = isencountersamesex([newparticipant], [chosen], chosen)
			if chosen.person.traits.has("Bisexual"):
				targetgroup = 'any'
			elif (chosen.person.traits.has("Homosexual") && samesex) || !samesex:
				targetgroup = 'target'
			elif chosen.person.traits.has("Homosexual"):
				targetgroup = 'any'
			else:
				targetgroup = 'chosen'
			if (targetgroup == 'any' && randf() >= 0.5) || targetgroup == 'chosen':
				groupchosen.append(newparticipant)
			else: 
				grouptarget.append(newparticipant)
			
			freeparticipants.erase(newparticipant)
	
	#choosing action
	var chosenpos = ''
	var actions = []
	var chosenaction = null
	debug += 'chosing action: \n' 
	for i in categories:
		for j in categories[i]:
			clearstate()
			debug += j.code + ": "
			if j.code == 'wait':
				continue
			if j.code in takercategories:
				if dom == 'taker':
					givers += groupchosen
					takers += grouptarget
				else:
					takers += groupchosen
					givers += grouptarget
			else:
				if dom == 'taker':
					takers += groupchosen
					givers += grouptarget
				else:
					givers += groupchosen
					takers += grouptarget
			var result = checkaction(j, doubledildocheck())
			if result[0] == 'allowed':
				var value = 0
				if chosen.person.sexexp.actions.has(j.code):
					value += chosen.person.sexexp.actions[j.code]/2
				if chosen.person.sexexp.orgasms.has(j.code):
					value += chosen.person.sexexp.orgasms[j.code]*4
				if chosen.person.sexexp.seenactions.has(j.code):
					value += chosen.person.sexexp.seenactions[j.code]/10
				
				if i in ['caress','fucking']:
					value += 10
				
				if !chosen.person.traits.has("Enjoys Anal") && j.code in analcategories:
					if chosenpos == 'giver' && !takercategories.has(j.code):
						value -= 5
					elif chosenpos == 'taker' && takercategories.has(j.code):
						value -= 5
				
				
				
				if chosen.person.traits.has('Masochist') && j.code in punishcategories && chosenpos == 'taker':
					value *= 2.5
				if chosen.person.traits.has('Dominant') && j.code in punishcategories && chosenpos == 'giver':
					value *= 2.5
				if target.submission < 90  && j.code in punishcategories && chosenpos == 'giver':
					value *= 3
				if chosen.person.penis == 'none' && dom == 'giver' && j.code == 'strapon':
					value *= 10
				if chosen.person.traits.has("Pervert") && ((givers.has(chosen) && j.giverconsent == 'advanced') || (takers.has(chosen) && j.takerconsent == 'advanced')):
					value += 15
				
				if chosen.person.vagvirgin == true && j.category == 'fucking' && !j.code in analcategories:
					value -= 25
				if chosen.person.assvirgin == true && j.category == 'fucking' && j.code in analcategories:
					value -= 25
				
				if j.category == 'fucking':
					value += chosen.lust/75
					if chosen.lube < 5:
						value -= chosen.lube*2
				
				if j.code in ['tribadism','doubledildo','doubledildoass','frottage'] && (chosen.strapon != null || target.strapon != null):
					value = 0
				
				debug += str(value) + '\n'
				if value >= 0:
					actions.append([j, value])
	if actions.size() == 0:
		actions.append([categories.other[0], 1])
	chosenaction = globals.weightedrandom(actions)
	clearstate()
	if chosenaction.code in takercategories:
		if dom == 'taker':
			givers = groupchosen
			takers = grouptarget
		else:
			takers = groupchosen
			givers = grouptarget
	else:
		if dom == 'taker':
			takers = groupchosen
			givers = grouptarget
		else:
			givers = groupchosen
			takers = grouptarget
	var cont = false
	var text = '[color=green][name1] initiates ' + chosenaction.getname() + ' with [name2].[/color]\n\n'
	if chosenaction.canlast == true && randf() >= 0.2:
		cont = true
	$PopupPanel/RichTextLabel.bbcode_text = debug
	#$PopupPanel.popup()
	startscene(chosenaction, cont, decoder(text, groupchosen, grouptarget))

func _on_finishbutton_pressed():
	ai.clear()
	selectmode = 'normal'
	get_parent().animationfade()
	yield(get_parent(), 'animfinished')
	hide()
	get_parent()._on_mansion_pressed()


func _on_blacklist_pressed():
	$blacklist.visible = true
	for i in $blacklist/ScrollContainer/VBoxContainer.get_children():
		if i.get_name() != 'CheckBox':
			i.visible = false
			i.queue_free()
	for i in categories.values():
		for j in i:
			if j.code == 'wait':
				continue
			var node = $blacklist/ScrollContainer/VBoxContainer/CheckBox.duplicate()
			j.givers = [participants[0]]
			$blacklist/ScrollContainer/VBoxContainer.add_child(node)
			node.visible = true
			node.text = j.getname(1)
			node.set_pressed(!filter.has(j.code))
			node.set_meta("action", j)
			node.connect("toggled", self, 'toggleaction', [node])

func toggleaction(button, node):
	var action = node.get_meta('action')
	if filter.has(action.code):
		filter.erase(action.code)
	else:
		filter.append(action.code)
	node.set_pressed(!filter.has(action.code))

func _on_closeblacklist_pressed():
	$blacklist.visible = false
	rebuildparticipantslist()




func _on_debug_pressed():
	$PopupPanel.popup()


















