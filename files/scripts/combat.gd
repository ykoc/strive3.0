
extends Node


var nocaptures = false
var area
var currentenemies
var playergroup = []
var enemygroup = []
var enemygear
var chosencharacter
var selectedcombatant
var selectmode = null
var cursortexture = Texture
var deads = []
var trapper = false
var trappername

class fighter:
	var name
	var person
	var pasthealth = 0
	var health setget health_set
	var healthmax
	var speed
	var speedbase
	var power
	var powerbase
	var magic
	var magicbase
	var energy = 0 setget energy_set
	var energymax = 0
	var armor
	var armorbase
	var protection
	var abilities
	var activeabilities
	var cooldowns
	var state
	var effects
	var action
	var target
	var party
	var button
	var icon
	var passives = []
	var ai
	var aimemory = ''
	var geareffects = []
	
	func health_set(value):
		var damage = value - pasthealth
#		if damage != 0:
#			globals.main.get_node('combat').animatetext(damage, button)
		health = value
		pasthealth = health
	
	func energy_set(value):
		energy = clamp(round(value),0,energymax)
	
	func sendbuff():
		var temptarget
		if (action.target == 'enemy' && self.party == 'ally') || (self.party == 'enemy' && action.target in ['ally','self']):
			temptarget = globals.main.get_node('combat').enemygroup[target]
		else:
			temptarget = globals.main.get_node('combat').playergroup[target]
		temptarget.getbuff(makebuff(action.effect, [temptarget], [self]))
	
	
	func getbuff(buff):
		var buffexists = false
		if effects.has(buff.code):
			buffexists = true
		if buffexists == true:
			effects[buff.code].duration = buff.duration
		else:
			effects[buff.code] = buff
			for i in buff.stats:
				self[i] = self[i] + buff.stats[i]
	
	func removebuff(buffcode):
		if effects.has(buffcode):
			if buffcode == 'stun':
				state = 'normal'
			for i in effects[buffcode].stats:
				self[i] = self[i] - effects[buffcode].stats[i]
			effects.erase(buffcode)
	
	func makebuff(code, targets, casters = null):
		var effect = str2var(var2str(globals.abilities.effects[code]))
		var buff = {duration = effect.duration, name = effect.name, code = effect.code, type = effect.type, stats = {}, icon = effect.icon}
		for i in effect.stats:
			var temp = i[1].split(',')
			temp = Array(temp)
			for ii in range(0, temp.size()):
				if temp[ii].find('caster') >= 0:
					var temp2 = temp[ii].split('.')
					temp[ii] = casters[0][temp2[1]]
				elif temp[ii].find('target') >= 0:
					var temp2 = temp[ii].split('.')
					temp[ii] = targets[0][temp2[1]]
			var temp2 = ''
			for i in temp:
				temp2 += str(i)
			buff.stats[i[0]] = globals.evaluate(temp2)
		return buff

func animatetext(text, node):
	var newnode = $floattext.duplicate()
	add_child(newnode)
	newnode.animatetext(text, node)


func start_battle(nosound = false):
	get_parent().animationfade(0.4)
	yield(get_parent(),'animfinished')
	get_node("autowin").visible = get_parent().get_node("new slave button").visible
	var slave
	var combatant
	trapper = false
	get_node("autoattack").set_pressed(globals.rules.autoattack)
	globals.main.get_node("outside").hide()
	globals.main.get_node("ResourcePanel").hide()
	if nosound == false:
		globals.main.music_set('combat')
	deads = []
	playergroup.clear()
	enemygroup.clear()
	selectedcombatant = null
	show()
	$TextureRect2/combatlog.set_bbcode('')
	var array = globals.state.playergroup
	slave = globals.player
	combatant = fighter.new()
	combatant.person = slave
	combatant.name = slave.name_short()
	combatant.pasthealth = slave.health
	combatant.health = slave.health
	combatant.healthmax = slave.stats.health_max
	combatant.speed = 10 + slave.sagi*3
	if slave.preg.duration > variables.pregduration/3:
		combatant.speed = round(combatant.speed - combatant.speed*0.25)
		combatant.getbuff(combatant.makebuff('pregnancy', combatant))
	combatant.power = 3 + slave.sstr*2
	combatant.icon = slave.imageportait
	if slave.race == 'Seraph':
		combatant.speed += 4
	elif slave.race.find('Wolf') >= 0:
		combatant.power += 2 
	combatant.magic = slave.smaf
	combatant.energymax = slave.stats.energy_max
	combatant.energy = slave.stats.energy_cur
	combatant.armor = slave.stats.armor_cur
	combatant.protection = 0
	combatant.abilities = {}
	combatant.activeabilities = []
	combatant.cooldowns = {}
	combatant.state = 'normal'
	combatant.effects = {}
	combatant.action = null
	combatant.target = null
	combatant.party = 'ally'
	updateabilities(combatant)
	for i in slave.gear.values():
		if i != null:
			var tempitem = globals.state.unstackables[i]
			for k in tempitem.effects:
				if k.type == 'incombat' && has_method(k.effect):
					call(k.effect, combatant, k.effectvalue)
				if k.type in ['incombatphyattack', 'incombatturn']:
					combatant.geareffects.append(k)
	
	playergroup.append(combatant)
	for i in globals.state.playergroup: # Take combatants from player group
		slave = globals.state.findslave(i)
		if slave.spec == 'trapper':
			trapper = true
			trappername = slave.name_short()
		combatant = fighter.new()
		combatant.person = slave
		combatant.name = slave.dictionary('$name')
		combatant.pasthealth = slave.health
		combatant.health = slave.health
		combatant.healthmax = slave.stats.health_max
		combatant.speed = 6 + slave.sagi*3
		combatant.power = 3 + slave.sstr*2
		combatant.icon = slave.imageportait
		if slave.race == 'Seraph':
			combatant.speed += 4
		elif slave.race.find('Wolf') >= 0:
			combatant.power += 2 
		if slave.spec == 'assassin':
			combatant.speed += 5
		combatant.magic = slave.smaf
		combatant.energymax = slave.stats.energy_max
		combatant.energy = slave.stats.energy_cur
		combatant.armor = slave.stats.armor_cur
		combatant.protection = 0
		combatant.state = 'normal'
		combatant.abilities = {}
		combatant.activeabilities = []
		combatant.cooldowns = {}
		combatant.effects = {}
		combatant.action = null
		combatant.target = null
		combatant.party = 'ally'
		if slave.preg.duration > variables.pregduration/3:
			combatant.speed = round(combatant.speed - combatant.speed*0.25)
			combatant.getbuff(combatant.makebuff('pregnancy', combatant))
		updateabilities(combatant)
		for i in slave.gear.values():
			if i != null:
				var tempitem = globals.state.unstackables[i]
				for k in tempitem.effects:
					if k.type == 'incombat':
						call(k.effect, combatant, k.effectvalue)
					if k.type in ['incombatphyattack', 'incombatturn']:
						combatant.geareffects.append(k)
		if slave.lust >= 80:
			combatant.getbuff(combatant.makebuff('luststrong', combatant))
			combatant.removebuff('lustweak')
		elif slave.lust >= 50:
			combatant.getbuff(combatant.makebuff('lustweak', combatant))
			combatant.removebuff('luststrong')
		else:
			combatant.removebuff('luststrong')
			combatant.removebuff('lustweak')
		playergroup.append(combatant)
	
	#build enemy group
	for i in currentenemies:
		combatant = fighter.new()
		if i.icon != null:
			combatant.icon = i.icon
		if nocaptures == false && i.capture != null:
			combatant.person = i.capture
			if i.capture.sex in ['female','futa'] && i.has('iconalt'):
				combatant.icon = i.iconalt
		else:
			combatant.person = null
		combatant.ai = 'attack'
		if combatant.person == null:
			combatant.name = i.name
			combatant.pasthealth = i.stats.health
			combatant.healthmax = i.stats.health
			combatant.speed = i.stats.speed
			combatant.power = i.stats.power
			combatant.magic = i.stats.magic
			combatant.energymax = i.stats.energy
			combatant.energy = i.stats.energy
			combatant.armor = i.stats.armor
			combatant.protection = 0
			combatant.state = 'normal'
			combatant.abilities = []
			combatant.cooldowns = {}
			combatant.effects = {}
			combatant.action = null
			combatant.target = null
			combatant.party = 'enemy'
			combatant.button = null
			combatant.health = combatant.healthmax
			for ii in i.stats.abilities:
				combatant.abilities.append(globals.abilities.abilitydict[ii])
		else:
			slave = combatant.person
			if slave.spec == 'trapper':
				trapper = true
				trappername = slave.name_short()
			combatant.person = slave
			combatant.name = i.name
			combatant.pasthealth = slave.health
			combatant.health = slave.health
			combatant.healthmax = slave.stats.health_max
			combatant.speed = 6 + slave.sagi*3
			combatant.power = 3 + slave.sstr*2
			if slave.race == 'Seraph':
				combatant.speed += 4
			elif slave.race.find('Wolf') >= 0:
				combatant.power += 2 
			if slave.spec == 'assassin':
				combatant.speed += 5
			combatant.magic = slave.smaf
			combatant.energy = slave.stats.energy_cur
			combatant.energymax = slave.stats.energy_max
			combatant.armor = slave.stats.armor_cur
			combatant.protection = 0
			combatant.state = 'normal'
			combatant.abilities = []
			combatant.activeabilities = []
			combatant.cooldowns = {}
			combatant.effects = {}
			combatant.action = null
			combatant.target = null
			combatant.party = 'ally'
			if get_parent().get_node("explorationnode").deeperregion:
				combatant.power = ceil(combatant.power * 1.25)
				combatant.healthmax = ceil(combatant.healthmax * 1.5)
				combatant.speed = ceil(combatant.speed + 5)
			for i in slave.abilityactive:
				combatant.activeabilities.append(globals.abilities.abilitydict[i])
			for i in slave.ability:
				combatant.abilities.append(globals.abilities.abilitydict[i])
			for i in slave.gear.values():
				if i != null:
					var tempitem = enemygear[i]
					for k in tempitem.effects:
						if k.type == 'incombat':
							call(k.effect, combatant, k.effectvalue)
						if k.type in ['incombatphyattack', 'incombatturn']:
							combatant.geareffects.append(k)
			combatant.health = combatant.healthmax
		enemygroup.append(combatant)
	set_process(true)
	set_process_input(true)
	nocaptures = false
	updatepanels()
	
	if globals.state.tutorial.combat == false:
		globals.main.get_node("tutorialnode").combat()

func updateabilities(combatant):
	combatant.activeabilities.clear()
	combatant.abilities.clear()
	for i in combatant.person.abilityactive:
		combatant.activeabilities.append(globals.abilities.abilitydict[i])
	for i in combatant.person.ability:
		combatant.abilities[i] = globals.abilities.abilitydict[i]
	choosecharacter(combatant)


func damage(combatant, value):
	combatant.power += value

func armor(combatant, value):
	combatant.armor += value

func speed(combatant, value):
	combatant.speed += value

func passive(combatant, value):
	combatant.passives.append(value)

func protection(combatant, value):
	combatant.protection += value

func lust(combatant, value):
	combatant.person.lust += 2

func _process(delta):
	var button
	for i in playergroup:
		button = get_node("grouppanel/groupline").get_child(playergroup.find(i)+1)
		if i.action == null && i.state != 'chasing':
			i.target = null
		else:
			button.texture_normal = load("res://files/buttons/combat/8.1.png")
		button.get_node('action').visible = !i.target == null
		if button.get_node('action').visible:
			button.get_node('action').set_texture(i.action.iconnorm)
			button.get_node('target').visible = true
			if i.action.target == 'enemy':
				button.get_node('target').set_texture(enemygroup[i.target].icon)
			elif i.action.target == 'ally' && playergroup[i.target].icon != null:
				button.get_node('target').set_texture(globals.loadimage(playergroup[i.target].icon))
			elif i.action.target == 'self' && i.icon != null:
				button.get_node('target').set_texture(load((i.icon)))
			else:
				button.get_node('target').set_texture(null)
	if selectedcombatant != null:
		get_node("grouppanel/groupline").get_child(playergroup.find(selectedcombatant)+1)
	else:
		for i in get_node("grouppanel/groupline").get_children():
			i.set_pressed(false)
	if get_node("warning").modulate.a != 0:
		get_node("warning").modulate.a = (get_node("warning").modulate.a-delta/2.5)
	if selectmode != null:
		get_node("confirm").set_disabled(true)
		Input.set_custom_mouse_cursor(load("res://files/buttons/kursor_act.png"))
		get_node("selectedskill").show()
		get_node("selectedskill").set_bbcode("[center]Select Target: "+ selectmode.capitalize() + "[/center]\n[center][color=yellow]Active ability: "+ selectedcombatant.action.name+  "[/color][/center]")
	else:
		get_node("selectedskill").hide()
		Input.set_custom_mouse_cursor(load("res://files/buttons/kursor.png"))
		get_node("confirm").set_disabled(false)
	if selectedcombatant == null:
		get_node("abilitites").set_disabled(true)
		var counter = 0
		playergroup.invert()
		for i in playergroup:
			if i.target == null && i.state in ['normal']:
				choosecharacter(i)
			else:
				counter += 1
		if counter >= playergroup.size():
			deselecteverything()
		playergroup.invert()
	else:
		get_node("grouppanel/groupline").get_child(playergroup.find(selectedcombatant)+1).set_pressed(true)
		get_node("abilitites").set_disabled(false)
	#get_node("combatlog").set_bbcode(text)

func _input(event):
	if event.is_echo() == true || event.is_pressed() == false || get_node("abilitites/Panel").visible == true || self.is_visible_in_tree() == false:
		return
	if get_node("win").visible == true && event.is_action_pressed("F") == true:
		_on_winconfirm_pressed()
		return
	elif get_node("win").visible == true:
		return
	if event is InputEventKey:
		var dict = {49 : 1, 50 : 2, 51 : 3, 52 : 4,53 : 5,54 : 6,55 : 7,56 : 8, 16777351 :1, 16777352 : 2, 16777353 : 3, 16777354 : 4, 16777355 : 5, 16777356: 6, 16777357: 7, 16777358: 8}
		if event.scancode in dict && selectedcombatant != null:
			var key = dict[event.scancode]
			if event.is_action_pressed(str(key)) == true && get_node("grouppanel/skilline").get_children().size() >= key+1 && self.visible == true && get_node("escapewarn").visible == false:
				activateskill(get_node("grouppanel/skilline").get_child(key).get_meta('skill'), selectedcombatant)
			elif event.is_action_pressed(str(key)) == true && get_node("escapewarn").visible == true && get_node("escapewarn/escapeoption").get_item_count() >= key:
				get_node("escapewarn/escapeoption").select(key-1)
			elif get_node("escapewarn").visible == true:
				return
	if event.is_action_pressed("RMB") == true && selectmode != null:
		selectmode = null
		selectedcombatant.action = null
		updatepanels()
		for i in get_node("grouppanel/skilline").get_children():
			i.set_pressed(false)
	if event.is_action_pressed("F") == true && selectmode == null && get_node("escapewarn").visible != true && $confirm.disabled == false:
		_on_confirm_pressed()
	elif event.is_action_pressed("F") == true && get_node("escapewarn").visible == true:
		_on_escapeconfirm_pressed()
	if event.is_action_pressed('f1') == true  && get_node("grouppanel/groupline").get_children().size() > 1:
		choosecharacter(get_node("grouppanel/groupline").get_child(1).get_meta('char'))
		get_node("grouppanel/groupline").get_child(1).set_pressed(true)
	elif event.is_action_pressed('f2') == true && get_node("grouppanel/groupline").get_children().size() > 2:
		choosecharacter(get_node("grouppanel/groupline").get_child(2).get_meta('char'))
		get_node("grouppanel/groupline").get_child(2).set_pressed(true)
	elif event.is_action_pressed('f3') == true && get_node("grouppanel/groupline").get_children().size() > 3:
		choosecharacter(get_node("grouppanel/groupline").get_child(3).get_meta('char'))
		get_node("grouppanel/groupline").get_child(3).set_pressed(true)
	elif event.is_action_pressed('f4') == true && get_node("grouppanel/groupline").get_children().size() > 4:
		choosecharacter(get_node("grouppanel/groupline").get_child(4).get_meta('char'))
		get_node("grouppanel/groupline").get_child(4).set_pressed(true)

func updatepanels():
	var newbutton
	clearpanels()
	$resources/mana/Label.text = str(globals.resources.mana)
	for combatant in playergroup:
		var slave = combatant.person
		var temp = ''
		if combatant.energy > 0 && combatant.passives.has('exhausted'):
			combatant.removebuff('exhaust')
			combatant.passives.erase("exhaust")
		elif combatant.energy <= 0:
			combatant.getbuff(combatant.makebuff('exhaust', combatant))
			passive(combatant, 'exhaust')
		newbutton = get_node("grouppanel/groupline/character").duplicate()
		if slave.imageportait != null:
			newbutton.get_node("portait").set_texture(globals.loadimage(slave.imageportait))
		newbutton.visible = true
		get_node("grouppanel/groupline").add_child(newbutton)
		newbutton.get_node("name").set_text(combatant.name)
		newbutton.get_node("hp").value = (combatant.health/combatant.healthmax)*100
		newbutton.get_node("hp/Label").text = str(ceil(combatant.health)) + "/" + str(combatant.healthmax)
		newbutton.get_node("en").value = (float(combatant.energy)/combatant.energymax)*100
		newbutton.get_node("en/Label").text = str(ceil(combatant.energy)) + "/" + str(combatant.energymax)
		if combatant.person != globals.player:
			newbutton.get_node("stress").visible = true
			newbutton.get_node("stress").value = (float(combatant.person.stress)/combatant.person.stats.stress_max)*100
			newbutton.get_node("stress/Label").text = str(ceil(combatant.person.stress))
		newbutton.set_meta("char", combatant)
		for i in combatant.effects.values():
			var newnode = $grouppanel/groupline/character/buffscontainer/TextureRect.duplicate()
			newbutton.get_node("buffscontainer").add_child(newnode)
			newnode.visible = true
			newnode.texture = i.icon
			newnode.connect("mouse_entered", self, 'bufftooltip', [i])
			newnode.connect("mouse_exited", self, 'bufftooltiphide')
		newbutton.connect("pressed",self,'choosecharacter',[combatant])
		newbutton.get_node("info").connect("pressed",self,'showinfochar',[combatant])
		combatant.button = newbutton
	for combatant in enemygroup:
		if combatant.state in ['normal']:
			var slave = combatant.person
			newbutton = get_node("enemypanel/enemyline/character").duplicate()
			if combatant.icon != null:
				newbutton.get_node("portrait").set_texture(combatant.icon)
			newbutton.show()
			get_node("enemypanel/enemyline").add_child(newbutton)
			for i in combatant.effects.values():
				var newnode = $grouppanel/groupline/character/buffscontainer/TextureRect.duplicate()
				newbutton.get_node("buffscontainer").add_child(newnode)
				newnode.visible = true
				newnode.texture = i.icon
				newnode.connect("mouse_entered", self, 'bufftooltip', [i])
				newnode.connect("mouse_exited", self, 'bufftooltiphide')
			newbutton.set_meta("char", combatant)
			newbutton.get_node("name").set_text(combatant.name)
			newbutton.get_node("hp").set_value((combatant.health/combatant.healthmax)*100)
			newbutton.get_node("hp/Label").set_text(str(ceil(combatant.health)) +'/'+ str(ceil(combatant.healthmax)))
			if playergroup[0].effects.has('mindreadeffect') == false:
				newbutton.get_node("hp/Label").hide()
			newbutton.connect("pressed",self,'chooseenemy',[combatant])
			newbutton.connect("mouse_entered", self, 'enemytooltip', [combatant])
			newbutton.connect("mouse_exited", self, 'enemytooltiphide')
			combatant.button = newbutton
	$enemypanel/enemyline.move_child($enemypanel/enemyline/character, $enemypanel/enemyline.get_children().size())

func bufftooltip(buff):
	var text = '[center][color=yellow]' + buff.name + "[/color][/center]"
	if str(buff.stats).replace('(','').replace(')','') != '':
		text += "\n" + str(buff.stats).replace('(','').replace(')','')
	if buff.duration >= 1:
		text += '\nDuration: ' + str(buff.duration)+ ' turns'
	globals.showtooltip(text)

func showinfochar(combatant):
	get_parent().get_node('outside').opencharacter(combatant.person, true, combatant)

func bufftooltiphide():
	globals.hidetooltip()

func clearpanels():
	for i in get_node("enemypanel/enemyline").get_children() + $grouppanel/groupline.get_children():
		if i.get_name() != 'character':
			i.hide()
			i.queue_free()

func choosecharacter(combatant):
	var newbutton
	if combatant.state == 'chasing' || (combatant.state == 'stunned' && selectmode == null):
		get_node("warning").set_text(combatant.name + " can't act this turn: " + combatant.state.capitalize() + '. ')
		get_node("warning").modulate.a = 1
		get_node("grouppanel/groupline").get_child(playergroup.find(combatant)+1).set_pressed(false)
		return
	if selectmode == null:
		selectedcombatant = combatant
		for i in get_node("grouppanel/groupline/").get_children():
			if i.has_meta('char'):
				if i.get_meta('char') == combatant:
					i.set_pressed(true)
				else:
					i.set_pressed(false)
		for i in get_node("grouppanel/skilline").get_children():
			if i != get_node("grouppanel/skilline/skill"):
				i.hide()
				i.free()
		$grouppanel/skilline.rect_size = $grouppanel/skilline.rect_min_size
		for i in combatant.activeabilities:
			newbutton = get_node("grouppanel/skilline/skill").duplicate()
			get_node("grouppanel/skilline").add_child(newbutton)
			newbutton.set_disabled(combatant.cooldowns.has(i.code))
			newbutton.show()
			
			newbutton.get_node("number").set_text(str(get_node("grouppanel/skilline").get_children().size()-1))
			newbutton.set_meta("skill", i)
			newbutton.connect("mouse_entered",self,'showskilltooltip',[i])
			newbutton.connect("mouse_exited",self,'hideskilltooltip')
			if i.has('iconnorm'):
				newbutton.set_normal_texture(i.iconnorm)
				newbutton.set_pressed_texture(i.iconpressed)
				newbutton.set_disabled_texture(i.icondisabled)
			newbutton.connect("pressed",self,'activateskill',[i,combatant])
			if combatant.action != null:
				if combatant.action.name == i.name:
					newbutton.set_pressed(true)
			if newbutton.is_disabled():
				newbutton.get_node("number").set('custom_colors/font_color', Color(1,0,0,1))
			elif newbutton.is_pressed():
				newbutton.get_node("number").set('custom_colors/font_color', Color(0,1,1,1))
			newbutton.set_meta('skill', i)
	elif selectmode == 'ally':
		for i in get_node("grouppanel/groupline/").get_children():
			if i.has_meta('char'):
				if i.get_meta('char') == selectedcombatant:
					i.set_pressed(true)
				else:
					i.set_pressed(false)
		selectmode = null
		selectedcombatant.target = playergroup.find(combatant)
		selectedcombatant = null

	elif selectmode == 'enemy':
		get_node("warning").set_text("Can't target ally")
		get_node("warning").modulate.a = 1
		get_node("grouppanel/groupline").get_child(playergroup.find(combatant)+1).set_pressed(false)

func activateskill(skill, combatant):
	if skill.code == 'escape' && area.tags.find("noreturn") >= 0:
		get_node("warning").set_text("Can't escape in this location")
		get_node("warning").modulate.a = 1
		return
	if selectmode != null:
		selectmode = null
	combatant.target = null
	globals.hidetooltip()
	if combatant.energy < skill.costenergy:
		get_node("warning").set_text("Not enough energy")
		get_node("warning").modulate.a = 1
		deselecteverything()
		return
	if skill.costmana > 0:
		var cost = skill.costmana
		if globals.state.spec == 'Mage':
			cost = round(cost/2)
		if globals.resources.mana < cost:
			get_node("warning").set_text("Not enough mana")
			get_node("warning").modulate.a = 1
			deselecteverything()
			return
	if combatant.cooldowns.has(skill.code):
		get_node("warning").set_text("Skill is on cooldown")
		get_node("warning").modulate.a = 1
		deselecteverything()
		return
	combatant.action = skill
	for i in get_node("grouppanel/skilline").get_children():
			if i.has_meta('skill'):
				if i.get_meta('skill') != skill:
					i.set_pressed(false)
				else:
					i.set_pressed(true)
	if skill.target == 'enemy':
		selectedcombatant = combatant
		selectmode = 'enemy'
		var counter = 0
		var tempenemy
		for i in enemygroup:
			if i.state in ['escaped','captured','defeated']:
				counter+= 1
			else:
				tempenemy = i
		if enemygroup.size() - counter <= 1:
			selectmode = 'enemy'
			chooseenemy(tempenemy)
	elif skill.target == 'self':
		selectmode = null
		combatant.target = playergroup.find(combatant)
		selectedcombatant = null
	elif skill.target == 'ally':
		selectedcombatant = combatant
		selectmode = 'ally'


func chooseenemy(enemy):
	if selectmode == 'enemy':
		selectmode = null
		selectedcombatant.target = enemygroup.find(enemy)
		selectedcombatant = null
	elif selectmode == 'ally':
		get_node("warning").set_text("Can't target enemy")
		get_node("warning").modulate.a = 1

func actionexecute(actor, target, skill):
	var text = ''
	var damage
	var group
	var hit = 'hit'
	var targetparty 
	var targethealthinit = target.health
	if skill.cooldown > 0:
		actor.cooldowns[skill.code] = skill.cooldown
	if playergroup.find(actor) >= 0:
		text = actor.person.dictionary(skill.usetext) 
		group = 'player'
		if skill.costmana > 0:
			var cost = skill.costmana
			if globals.state.spec == 'Mage':
				cost = round(cost/2)
			globals.resources.mana -= cost
	else:
		group = 'enemy'
		text = skill.usetext 
	if skill.target == 'enemy':
		if group == 'enemy':#Checking for blockers
			targetparty = playergroup
			for i in playergroup:
				if i.target == playergroup.find(target) && i.action.code == 'protect' && i != target:
					text = '$name tries to attack ' + target.name + ', but ' + i.name + ' moves in and takes the hit. '
					if target.action.code == 'protect':
						target.target = playergroup.find(target)
					text += actionexecute(actor, i, skill)
					return text
		else:
			targetparty = enemygroup
			for i in enemygroup:
				if i.target == enemygroup.find(target) && i.action.code == 'protect':
					text = '$name tries to attack ' + target.name + ', but ' + i.name + ' moves in and takes the hit. '
					if target.action.code == 'protect':
						target.target = enemygroup.find(target)
					text += actionexecute(actor, i, skill)
					return text
		#checking hit chance
		if skill.attributes.find('damage') >= 0:
			if skill.can_miss == true && target.action != null && target.action.code != 'protect':
				hit = hitchance(actor, target)
			else:
				hit = 'hit'
			
			if skill.type == 'physical':
				var power = float((actor.power * 2.5)*skill.power)
				var protection = float(float(100-target.protection)/100)
				var armor = target.armor
				if skill.attributes.has('physpen'):
					protection = 1
					armor = 0
				for i in actor.geareffects:
					if i.type == 'incombatphyattack':
						if i.effect == 'protpenetration':
							protection = 1
						if i.effect == 'fullpenetration':
							armor = 0
							protection = 1
				damage = power * protection - armor
				if target.action.code == 'protect':
					if target.person.spec == 'bodyguard':
						damage = damage - damage*0.7
					else:
						damage = damage - damage*0.35
			elif skill.type == 'spell':
				damage = max(1,(actor.magic * 2.5)) * skill.power
				if skill.code == 'mindblast':
					damage += target.healthmax/5
				if globals.state.spec == 'Mage' && group == 'player':
					damage *= 1.2
			if target.person != null and target.person.traits.has("Sturdy"):
				damage = damage*0.85
			actor.energy = max(actor.energy - skill.costenergy,0)
			if actor.person != null && actor.person.spec == 'assassin':
				damage += 5
			if hit == 'precise':
				damage = damage*1.3
				text = text + "$name's swift attack lands precisely at desirable spot. " 
			if damage < 0: damage = 0
			if actor.passives.has("exhaust"): damage = damage*0.66
			if hit != 'miss' && hit != 'glance':
				var power = powercompare(actor.power, target.power)
				var enddamage = 0
				if power == 'overpower':
					enddamage = damage*1.3
					text = text + "$name's force overpowers " + target.name + ' and deals great damage.(' + str(round(enddamage*1.3)) + ")" 
				elif power == 'normal' || hit == 'precise':
					enddamage = damage
					text = text + "$name damages " + target.name + '.(' + str(round(enddamage)) + ")" 
				else:
					enddamage = damage/1.75
					text = text + "$name's attack struggles to ovecome " + target.name + "'s defence and falls in efficiency.(" + str(round(damage/1.75)) + ")" 
				target.health -= enddamage
				
			elif hit == 'glance':
				target.health -= damage/2
				text = text + "$name's attack lacks in speed and only partly damages " + target.name + ".(" + str(round(damage/2)) + ")" 
			elif hit == 'miss':
				text = text + "$name's attack misses " + target.name + '. '
			if target.action.code != 'protect':
				target.energy -= (targethealthinit - target.health)/5
			else:
				target.energy -= (targethealthinit - target.health)/2.5
			if skill.attributes.has('allparty'):
				text += "\nStrong attack affects everyone in opposing party."
				for i in targetparty:
					if i != target:
						i.health -= damage
			if target.energy < 0:
				target.energy = 0
			if skill.attributes.has('lifesteal'):
				actor.health = min(actor.health + (targethealthinit - target.health)/4,actor.healthmax)
				text += actor.name + ' recovered some health back.' 
	elif skill.target == 'self':
		if skill.code == 'escape' && globals.main.get_node("explorationnode").launchonwin == null:
			actor.state = 'stopfight'
			actor.energy = max(actor.energy - skill.costenergy,0)
		elif skill.code == 'escape' && globals.main.get_node("explorationnode").launchonwin != null:
			globals.main.popup("You can't escape from this fight")
	elif skill.target == 'ally':
		if group == 'enemy':#Checking for blockers
			targetparty = enemygroup
		else:
			targetparty = playergroup
	if skill.effect != null && (skill.type == 'spell' || hit in ['precise','hit'] || skill.target in ['ally','self']):
		actor.sendbuff()
	if skill.code == 'heal':
		globals.abilities.restorehealth(actor,target)
	elif skill.code == "masshealcouncil":
		for i in targetparty:
				if i != actor:
					globals.abilities.restorehealth(actor,i)
	target.health = ceil(target.health)
	if target.health < 0:
		target.health = 0
		if actor.person != null && actor.person != globals.player:
			actor.person.stress -= rand_range(5,10)
			text += "\n$name has defeated " + target.name + ". "
	text = combatantdictionary(actor, text)
	return text







func deselecteverything():
	for i in get_node("grouppanel/skilline").get_children():
		if i != get_node("grouppanel/skilline/skill"):
			i.hide()
			i.queue_free()
	for i in get_node("grouppanel/groupline").get_children():
		i.set_pressed(false)
	selectedcombatant = null

func combatantdictionary(combatant, text):
	if playergroup.find(combatant) >= 0:
		if playergroup.find(combatant) == 0:
			text = text.replace('$name', 'You')
			text = text.replace(' goes ', ' go ')
			text = text.replace(' does ', ' do ')
			text = text.replace("'s ", "r ")
		else:
			text = text.replace('$name', combatant.name)
		if combatant.action.target == 'enemy':
			text = text.replace("$targetname", enemygroup[combatant.target].name)
		elif combatant == playergroup[combatant.target]:
			text = text.replace("$targetname", 'self')
		else:
			text = text.replace("$targetname", playergroup[combatant.target].name)
	else:
		text = text.replace('$name', combatant.name)
		if combatant.action.target == 'enemy':
			text = text.replace("$targetname", playergroup[combatant.target].name)
		elif combatant == enemygroup[combatant.target]:
			text = text.replace("$targetname", 'self')
		else:
			text = text.replace("$targetname", enemygroup[combatant.target].name)
	return text

func hitchance(attacker, target):
	var hit = ''
	var attackspeed = attacker.speed
	var targetspeed = target.speed
	if attacker.person != null && attacker.person.traits.has("Nimble"):
		attackspeed *= 1.25
	if attacker.action.has('accuracy'):
		attackspeed = attackspeed*attacker.action.accuracy
	if playergroup.find(target) >= 0:
		if target.person.race.findn("cat") >= 0:
			targetspeed += 4
	var hitchance = attackspeed - targetspeed
	if hitchance > 10 && rand_range(0,100) < (hitchance-5) * 5:
		hit = 'precise'
	elif hitchance >= -5 && rand_range(0,100) < (hitchance+8) * 9:
		hit = 'hit'
	elif (hitchance >= -10 && rand_range(0,100) > 75):
		hit = 'glance'
	else:
		if rand_range(0,100) <= 5:
			hit = 'glance'
		else:
			hit = 'miss'
	return hit

func powercompare(attackpower, targetpower):
	var power = ''
	if attackpower >= targetpower*2:
		power = 'overpower'
	elif attackpower >= targetpower*0.7:
		power = 'normal'
	else:
		power = 'halved'
	return power

func showskilltooltip(skill):
	var text = ''
	text += '[center]' + skill.name + '[/center]\n\n' + skill.description 
	if skill.costenergy > 0:
		text += "\n[color=yellow]Energy: " + str(skill.costenergy) + "[/color]"
	if skill.costmana > 0:
		var cost = skill.costmana
		if globals.state.spec == 'Mage':
			cost = round(cost/2)
		text += "\n[color=aqua]Mana: " + str(cost) + "[/color]"
	text += '\nBasic cooldown: ' + str(skill.cooldown)
	if selectedcombatant.cooldowns.has(skill.code):
		text += '\n\nCooldown: ' + str(selectedcombatant.cooldowns[skill.code])
	globals.showtooltip(text)

func hideskilltooltip():
	globals.hidetooltip()

func enemytooltip(enemy):
	var text = ''
	text += '[center]' + enemy.name + '[/center]\n'
	if enemy.person != null:
		text += enemy.person.race + ' ' + enemy.person.age + ' ' + enemy.person.sex + '.\n'
	if playergroup[0].effects.has('mindreadeffect') || globals.developmode == true:
		text += "Power: " + str(enemy.power) + " Speed: " + str(enemy.speed) + " Protection: " + str(enemy.protection) + " Armor: " + str(enemy.armor)
		if enemy.person != null:
			text += "\nGrade: " + enemy.person.origins
#	if enemy.person != null:
#		text += enemygear[enemy.person.gear.armor].name + "\n" + enemygear[enemy.person.gear.weapon].name
	globals.showtooltip(text)

func enemytooltiphide():
	globals.hidetooltip()

func _on_confirm_pressed():
	globals.hidetooltip()
	if selectmode != null:
		get_node("warning").set_text("Select target first.")
		get_node("warning").modulate.a = 1
		return
	$confirm.disabled = true
	var text = ''
	for combatant in playergroup:
		if combatant.action == null && combatant.state in ['normal']:
			if globals.rules.autoattack == false:
				combatant.action = globals.abilities.abilitydict['pass']
				combatant.target = playergroup.find(combatant)
			else:
				combatant.action = globals.abilities.abilitydict.attack
				for i in enemygroup:
					if i.state == 'normal':
						combatant.target = enemygroup.find(i)
						continue
		elif combatant.state == 'chasing':
			combatant.action = globals.abilities.abilitydict['pass']
			combatant.target = playergroup.find(combatant)
	for combatant in enemygroup:
		combatant.action = null
		for i in combatant.cooldowns:
			combatant.cooldowns[i] -= 1
			if combatant.cooldowns[i] <= 0:
				combatant.cooldowns.erase(i)
		var abilitydict = []
		for i in combatant.abilities:
			if combatant.ai == 'attack':
				if combatant.aimemory != 'attack':
					abilitydict = combatant.abilities[0]
					combatant.aimemory = 'attack'
					break
				if combatant.cooldowns.has(i.code):
					continue
				if i.aipatterns.has('attack'):
					abilitydict.append({value = i, weight = i.aipriority})
			
		if typeof(abilitydict) == TYPE_ARRAY:
			abilitydict = globals.weightedrandom(abilitydict)
		combatant.action = abilitydict
		if combatant.action == null:
			combatant.action = combatant.abilities[0]
		if combatant.action.target == 'enemy':
			combatant.target = floor(rand_range(0,playergroup.size())-1)
		elif combatant.action.target == 'ally':
			combatant.target = floor(rand_range(0,enemygroup.size())-1)
		if combatant.action.target == 'enemy' && combatant.state in ['normal']:
			text += actionexecute(combatant, playergroup[combatant.target], combatant.action) + '\n'
		elif combatant.action.target == 'ally' && combatant.state in ['normal']:
			text += actionexecute(combatant, enemygroup[combatant.target], combatant.action) + '\n'
	for combatant in playergroup:
		if combatant.action.target == 'enemy':
			text += actionexecute(combatant, enemygroup[combatant.target], combatant.action) + '\n'
		elif combatant.action.target == 'self':
			text += actionexecute(combatant, combatant, combatant.action) + '\n'
		elif combatant.action.target == 'ally' && combatant.action.code != 'protect':
			text += actionexecute(combatant, playergroup[combatant.target], combatant.action) + '\n'
		if combatant.passives.has('doubleattack') && randf() < 0.5 && combatant.action.code == 'attack':
			text += "[color=aqua][Double Attack][/color]" + actionexecute(combatant, enemygroup[combatant.target], combatant.action) + '\n'
		for i in combatant.cooldowns:
			combatant.cooldowns[i] -= 1
			if combatant.cooldowns[i] <= 0:
				combatant.cooldowns.erase(i)
		for i in combatant.geareffects:
			if i.type == 'incombatturn' && has_method(i.effect):
				call(i.effect, combatant, i.effectvalue)
		if combatant.state == 'chasing':
			combatant.state = 'normal'
		if combatant.person == globals.player:
			continue
		if combatant.person.lust >= 80:
			combatant.getbuff(combatant.makebuff('luststrong', combatant))
			combatant.removebuff('lustweak')
		elif combatant.person.lust >= 50:
			combatant.getbuff(combatant.makebuff('lustweak', combatant))
			combatant.removebuff('luststrong')
		else:
			combatant.removebuff('luststrong')
			combatant.removebuff('lustweak')
	get_node("combatlog").set_bbcode(text)
	resolution()

func resolution(text = ''):
	var counter = 0
	globals.hidetooltip()
	for i in playergroup:
		i.person.stress += 3
		for effect in i.effects.values():
			if effect.duration == 0:
				i.removebuff(effect.code)
			elif effect.duration > 0:
				effect.duration -= 1
	for i in enemygroup:
		if i.state in ['normal']:
			counter += 1
	for i in enemygroup:
		if i.health <= 0 && i.state in ['normal']:
			i.state = 'defeated'
			text += '\n[color=yellow]'+ i.name + ' has been defeated. [/color]'
			if i.person != null:
				var escapechance = (globals.originsarray.find(i.person.origins)+1)*15
				if rand_range(0,100) < escapechance:
					if counter > 1 && i.effects.has('shackleeffect'):
						i.state = 'captured'
						text += '\n[color=yellow]'+ i.name + ' has been defeated and subdued unable to escape. [/color]'
					elif trapper == true && rand_range(0,100) <= 50:
						i.state = 'captured'
						text += '\n[color=yellow]'+ i.name + ' has attempted to escape, but walked right into ' + trappername + "'s trap and was quickly subdued by your group. [/color]"
					elif counter == 1:
						i.state = 'captured'
						text += '\n[color=yellow]'+ i.name + ' has been defeated and surrounded by your group. [/color]'
					elif counter > 1 && !i.effects.has('shackleeffect'):
						capturesequence(i)
						return
				else:
					i.state = 'captured'
					text +=  '\n[color=yellow]'+ i.name + ' has been defeated and knocked out by your group. [/color]'
	for i in playergroup:
		if i.health <= 0:
			text += '\n[color=#ff4949]'+ i.name + ' has fallen. [/color]'
			playergroup.remove(playergroup.find(i))
			if i.person == globals.player:
				globals.main.animationfade(1)
				$confirm.disabled = true
				yield(globals.main, 'animfinished')
				globals.main.get_node("gameover").show()
				globals.main.get_node("gameover/Panel/text").set_bbcode("[center]You have died. \nGame over.[/center]")
				return
			else:
				var slave = i.person
				if globals.rules.permadeath == false:
					slave.stats.health_cur = 10
					slave.away.duration = 3
					slave.away.at = 'rest'
					slave.work = 'rest'
					globals.state.playergroup.erase(i.person.id)
				else:
					globals.state.playergroup.erase(i.person.id)
					for i in globals.state.playergroup:
						globals.state.findslave(i).stress += rand_range(15,25)
					globals.slaves.erase(slave)
		elif i.effects.has("stun"):
			i.state = 'stunned'
		else:
			i.action = null
			i.target = null
	counter = 0
	for i in enemygroup:
		if i.state in ['escaped','defeated','captured']:
			counter += 1
	if counter >= enemygroup.size():
		get_node("win").show()
		globals.main.music_set('stop')
		globals.main.sound('win')
	elif playergroup[0].state == 'stopfight':
		clearpanels()
		hide()
		set_process(false)
		for i in playergroup:
			i.person.stats.energy_cur = i.energy
			i.person.stats.health_cur = i.health
		globals.main.get_node("explorationnode").enemyleave()
		globals.main.popup('You hastly escape from the fight. ')
		globals.main.get_node("outside").show()
		globals.main.get_node("ResourcePanel").show()
		return
	else:
		for i in enemygroup:
			i.action = null
			i.target = null
	if selectedcombatant != null:
		choosecharacter(selectedcombatant)
	get_node("combatlog").set_bbcode(get_node("combatlog").get_bbcode() + text)
	updatepanels()
	$confirm.disabled = false
	deselecteverything()

func capturesequence(enemy):
	enemy.button.get_node('name').set_text(enemy.button.get_node('name').get_text() + ' - Escaping!')
	get_node("escapewarn").show()
	get_node("escapewarn/escapedescript").set_bbcode(combatantdictionary(enemy, "$name tries to escape. Send someone to stop them? (costs 30 energy and will be unable to act for 1 turn)"))
	get_node("escapewarn/escapeoption").clear()
	get_node("escapewarn/escapeoption").set_meta('slave',enemy)
	get_node("escapewarn/escapeoption").add_item("Let them escape")
	var counter = 1
	for i in playergroup:
		if i.person != globals.player:
			get_node("escapewarn/escapeoption").add_item(i.name)
			get_node("escapewarn/escapeoption").set_item_disabled(counter, true)
			if i.state in ['normal'] && i.energy >= 30 && i.person != globals.player:
				get_node("escapewarn/escapeoption").set_item_disabled(counter, false)
			counter += 1

func victory():
	var deads = []
	
	get_parent().animationfade(0.4)
	yield(get_parent(),'animfinished')
	get_node("win").hide()
	for i in range(0, enemygroup.size()):
		if enemygroup[i].state == 'escaped':
			currentenemies[i].state = 'escaped'
		else:
			currentenemies[i].state = 'defeated'
	globals.main.get_node("explorationnode").enemygroup.units = currentenemies
	clearpanels()
	hide()
	globals.main.get_node("outside").show()
	globals.main.get_node("ResourcePanel").show()
	globals.main.get_node("explorationnode").enemydefeated()




func _on_escapeconfirm_pressed():
	var text = ''
	var captured = false
	var basechance 
	var ID = get_node("escapewarn/escapeoption").get_selected()
	var slave = get_node("escapewarn/escapeoption").get_meta('slave')
	if ID == 0:
		slave.state = 'escaped'
		text = slave.name + ' has ran away in unknown direction. '
	else:
		var chaseslave = playergroup[ID]
		chaseslave.state = 'chasing'
		basechance = chaseslave.speed
		chaseslave.action = {code = 'chasing'}
		chaseslave.energy -= 30
		if chaseslave.person.spec == 'trapper':
			basechance += 5
		if basechance > slave.speed * 2:
			captured = true
			text = '[color=aqua]'+chaseslave.name + ' swiftly caught helpless ' + slave.name + '. [/color] '
		elif (basechance - slave.speed) + rand_range(0, 10) > 8:
			captured = true
			text = '[color=aqua]'+slave.name + ' has been caught and subdued by ' + chaseslave.name + '. [/color]'
		else:
			captured = false
			text = '[color=red]'+chaseslave.name + ' failed to catch escaping ' + slave.name + '. [/color]'
		if captured == true:
			chaseslave.person.metrics.capture += 1
			slave.state = 'captured'
		else:
			slave.state = 'escaped'
	get_node("escapewarn").hide()
	resolution(text)


func _on_winconfirm_pressed():
	set_process(false)
	get_node("win").hide()
	for i in playergroup:
		i.person.metrics.win += 1
		i.person.stats.energy_cur = i.energy
		i.person.stats.health_cur = i.health
	victory()


func _on_abilitites_pressed():
	get_node("abilitites/Panel").show()
	get_node("abilitites/Panel/use").set_disabled(true)
	get_node("abilitites/Panel/abilitydescript").set_bbcode('')
	var newbutton
	for i in get_node("abilitites/Panel/inactivecontainer/VBoxContainer").get_children():
		if i != get_node("abilitites/Panel/inactivecontainer/VBoxContainer/Button"):
			i.hide()
			i.queue_free()
	for i in selectedcombatant.abilities.values():
		newbutton = get_node("abilitites/Panel/inactivecontainer/VBoxContainer/Button").duplicate()
		get_node("abilitites/Panel/inactivecontainer/VBoxContainer").add_child(newbutton)
		newbutton.show()
		newbutton.set_text(i.name)
		newbutton.set_meta('ability', i)
		if selectedcombatant.activeabilities.has(i) == true:
			newbutton.get_node("CheckBox").set_pressed(true)
		else:
			newbutton.get_node("CheckBox").set_pressed(false)
		newbutton.connect("pressed", self, "selectabilityfromlist" ,[i])
		newbutton.get_node("CheckBox").connect("pressed", self, "toggleabilityfromlist", [i, newbutton.get_node("CheckBox")])

func selectabilityfromlist(ability):
	var text = "[center]" + ability.name + "[/center]\n" + ability.description +  '\nTarget: ' + ability.target +  '\nCooldown - ' + str(ability.cooldown)
	get_node("abilitites/Panel/abilitydescript").set_bbcode(text)
	for i in get_node("abilitites/Panel/inactivecontainer/VBoxContainer").get_children():
		if i.has_meta('ability'):
			if i.get_meta('ability') == ability:
				i.set_pressed(true)
			else:
				i.set_pressed(false)
	var tempabil = selectedcombatant.abilities[ability.code]
	get_node("abilitites/Panel/abilitydescript").set_meta('ability', tempabil)
	var cost = tempabil.costmana
	if globals.state.spec == 'Magi':
		cost = round(cost/2)
	if selectedcombatant.energy < tempabil.costenergy || selectedcombatant.cooldowns.has(tempabil.code) || globals.resources.mana < cost :
		get_node("abilitites/Panel/use").set_disabled(true)
	else:
		get_node("abilitites/Panel/use").set_disabled(false)





func toggleabilityfromlist(ability, checkbox):
	if checkbox.is_pressed() == true && selectedcombatant.activeabilities.has(ability) == false:
		selectedcombatant.person.abilityactive.append(ability.code)
	else:
		selectedcombatant.person.abilityactive.erase(ability.code)
	updateabilities(selectedcombatant)
	_on_abilitites_pressed()


func _on_close_pressed():
	get_node("abilitites/Panel").hide()
	deselecteverything()
	updatepanels()


func _on_use_pressed():
	var skill = get_node("abilitites/Panel/abilitydescript").get_meta('ability')
	get_node("abilitites/Panel").hide()
	activateskill(skill, selectedcombatant)






func _on_autoattack_pressed():
	globals.rules.autoattack = get_node("autoattack").is_pressed()

func findcombatantfromslave(person):
	for i in playergroup:
		if i.person == person:
			return i
