
extends Node

var period = 'base'
var phase = ''
var currentenemies
var enemygear = {}
var playergroup = []
var enemygroup = []
var selectedcharacter
var targetskill
var nocaptures = false
var area
var trapper = false
var trappername
var turns = 0

var combatlog = '' setget combatlog_set, combatlog_get

func combatlog_set(value):
	$TextureRect2/combatlog.bbcode_text = value
	$TextureRect2/combatlog.scroll_to_line($TextureRect2/combatlog.get_line_count()-1)

func combatlog_get():
	return $TextureRect2/combatlog.bbcode_text

var debug = true


var enemypaneltextures = {
	normal = load("res://files/buttons/combat/6.png"),
	target = load("res://files/buttons/combat/7.png"),
}
var playerpaneltextures = {
	normal = load("res://files/buttons/combat/8.png"),
	target = load("res://files/buttons/combat/9.png"),
	disabled = load("res://files/buttons/combat/8.1.png"),
}


func _ready():
	$grouppanel/skilline/skill.set_meta('skill', {})
#	if debug == true:
#		var scene = load("res://files/scripts/exploration.gd")
#		globals.main = self
#		$TextureRect.set_script(scene)
#		globals.player = globals.newslave('randomany', 'random', 'random')
#		var x = 2
#		while x > 0:
#			var newslave = globals.newslave('randomany', 'random', 'random')
#			x -= 1
#			globals.slaves = newslave
#			globals.state.playergroup.append(newslave.id)
#		for i in globals.slaves + [globals.player]:
#			var newcombatant = combatant.new()
#			var newbutton = $grouppanel/groupline/character.duplicate()
#			$grouppanel/groupline.add_child(newbutton)
#			newcombatant.node = newbutton
#			newcombatant.scene = self
#			newcombatant.createfromslave(i)
#			newcombatant.energy = 0
#			newcombatant.person.lust = 100
#			newbutton.connect('pressed', newcombatant, 'selectcombatant')
#			newbutton.connect('mouse_entered', newcombatant, 'combatanttooltip')
#			newbutton.connect("mouse_exited", globals, 'hidetooltip')
#			playergroup.append(newcombatant)
#			newbutton.set_meta('combatant', newcombatant)
#			newcombatant.draw()
#
#		$TextureRect.buildenemies("banditseasy")
#		currentenemies = $TextureRect.enemygroup
#		for i in currentenemies.units:
#			var newcombatant = combatant.new()
#			var newbutton = $enemypanel/enemyline/character.duplicate()
#			$enemypanel/enemyline.add_child(newbutton)
#			newcombatant.node = newbutton
#			newbutton.set_meta('combatant', newcombatant)
#			newcombatant.scene = self
#			newbutton.connect('pressed', newcombatant, 'selectcombatant')
#			if nocaptures == false && i.capture != null:
#				newcombatant.createfromslave(i.capture, i)
#			else:
#				newcombatant.createfromdata(i)
#			newcombatant.name = i.name
#			enemygroup.append(newcombatant)
#			newcombatant.draw()

func combatanttooltip():
	pass


func _process(delta):
	$resources/mana/Label.text = str(globals.resources.mana)
	$resources/turns/Label.text = str(turns)
	#Reset panel textures
	for i in $enemypanel/enemyline.get_children():
		if i.visible:
			if period == 'skilltarget' && targetskill.targetgroup == 'enemy':
				i.set_normal_texture(enemypaneltextures.target)
			else:
				i.set_normal_texture(enemypaneltextures.normal)
	for i in $grouppanel/groupline.get_children():
		if i.visible:
			if period == 'skilltarget' && targetskill.targetgroup == 'ally':
				i.set_normal_texture(playerpaneltextures.target)
			elif i.get_meta('combatant').actionpoints <= 0:
				i.set_normal_texture(playerpaneltextures.disabled)
			else:
				i.set_normal_texture(playerpaneltextures.normal)
			if period == 'base' && selectedcharacter == null && i.get_meta('combatant').actionpoints > 0:
				i.emit_signal('pressed')
	
	#Set cursor and skill pressed
	if period == 'skilltarget':
		Input.set_custom_mouse_cursor(load("res://files/buttons/kursor_act.png"))
		for i in $grouppanel/skilline.get_children():
			i.pressed = i.get_meta("skill") == targetskill
	else:
		Input.set_custom_mouse_cursor(load("res://files/buttons/kursor.png"))
		for i in $grouppanel/skilline.get_children():
			i.pressed = false
		

func _input(event):
	if event.is_echo() == true || event.is_pressed() == false || get_node("abilitites/Panel").visible == true || self.is_visible_in_tree() == false:
		return
	#Cancel skill by rightclick
	if event.is_action_pressed("RMB") && period == 'skilltarget':
		period = 'base'
		selectedcharacter.selectcombatant()
	#Select ability by 1-8 nums
	if str(event.as_text()) in str(range(1,9)):
		if self.visible == true && get_node("escapewarn").visible == false && $win.visible == false && $grouppanel/skilline.get_children().size() > int(event.as_text()):
			get_node("grouppanel/skilline").get_child(int(event.as_text())).emit_signal('pressed')
	#select characters
	if event.as_text() in ['F1','F2','F3','F4'] && $win.visible == false && get_node("grouppanel/groupline").get_children().size() > int(event.as_text().replace("F","")):
		$grouppanel/groupline.get_child(int(event.as_text().replace("F",""))).emit_signal('pressed')
	#End turn
	if event.is_action_pressed("F") == true && period == 'base' && get_node("escapewarn").visible != true && $confirm.disabled == false:
		_on_confirm_pressed()



class combatant:
	var person
	var group
	var state = 'normal'
	var panel
	var name
	var hp setget health_set, health_get
	var hpmax
	var energy
	var energymax
	var stress = 0
	var stressmax = 0
	var lust
	var lustmax
	var passives = []
	var attack = 0
	var magic = 0
	var armor = 0
	var protection = 0
	var speed = 0
	var portrait
	var target
	var geareffects = []
	var abilities
	var activeabilities
	var node
	var scene
	var cooldowns = []
	var actionpoints = 1
	var effects = {}
	
	var ai = ''
	var aimemory = ''
	
	func createfromslave(person, data = null):
		name = person.name_short()
		self.person = person
		if person == globals.player || (globals.slaves.has(person) && globals.state.playergroup.has(person.id)):
			group = 'player'
			portrait = person.imageportait
		else:
			group = 'enemy'
			portrait = data.icon
		abilities = person.ability
		activeabilities = person.abilityactive
		#Filling values
		
		hp = person.health
		hpmax = person.stats.health_max
		energy = person.energy
		energymax = person.stats.energy_max
		stress = person.stress
		stressmax = person.stats.stress_max
		lust = person.lust
		lustmax = person.stats.lust_max
		
		attack = 3 + person.sstr * variables.damageperstr
		magic = person.smaf
		armor = person.stats.armor_cur
		speed = variables.speedbase + (person.sagi * variables.speedperagi)
		
		
		if person.race == 'Seraph':
			speed += 4
		elif person.race.find('Wolf') >= 0:
			attack += 2 
		if person.spec == 'assassin':
			speed += 5
		
		if person.preg.duration > variables.pregduration/3:
			speed = round(speed - speed*0.25)
			scene.getbuff(scene.makebuff('pregnancy', self, self), self)
		#Gear
		
		
		for i in person.gear.values():
			var tempitem
			if i != null:
				if group == 'player':
					tempitem = globals.state.unstackables[i]
				else:
					tempitem = globals.combatencounterdata.enemygear[i]
				for k in tempitem.effects:
					if k.type == 'incombat' && has_method(k.effect):
						globals.abilities.call(k.effect, self, k.effectvalue)
					if k.type in ['incombatphyattack', 'incombatturn']:
						self.geareffects.append(k)
	
	func selectcombatant():
		if actionpoints <= 0:
			node.pressed = false
			return
		if scene.period == 'base':
			if group == 'enemy':
				return
			scene.selectedcharacter = self
			for i in scene.playergroup:
				i.node.pressed = i == scene.selectedcharacter
			buildabilities()
		elif scene.period == 'skilltarget':
			if scene.targetskill.targetgroup == 'enemy' && scene.selectedcharacter.group == self.group:
				scene.floattext(node,'Wrong Target')
				return
			elif scene.targetskill.targetgroup == 'ally' && scene.selectedcharacter.group != self.group:
				scene.floattext(node,'Wrong Target')
				return
			scene.period = 'skilluse'
			scene.useskills(scene.targetskill, scene.selectedcharacter, self)
	
	func combatanttooltip():
		if actionpoints <= 0:
			node.hint_tooltip = 'No action points left'
		else:
			node.hint_tooltip = ''
	
	func buildabilities():
		for i in scene.get_node("grouppanel/skilline").get_children():
			if i.name != 'skill':
				i.hide()
				i.free()
		for i in activeabilities:
			var skill = globals.abilities.abilitydict[i]
			var newbutton = scene.get_node("grouppanel/skilline/skill").duplicate()
			scene.get_node("grouppanel/skilline").add_child(newbutton)
			newbutton.set_disabled(cooldowns.has(skill.code))
			newbutton.show()
			
			newbutton.get_node("number").set_text(str(scene.get_node("grouppanel/skilline").get_children().size()-1))
			newbutton.set_meta("skill", skill)
			newbutton.connect("mouse_entered",scene,'showskilltooltip',[skill])
			newbutton.connect("mouse_exited",scene,'hideskilltooltip')
			newbutton.connect("pressed",scene,'pressskill', [skill])
			if skill.has('iconnorm'):
				newbutton.set_normal_texture(skill.iconnorm)
				newbutton.set_pressed_texture(skill.iconpressed)
				newbutton.set_disabled_texture(skill.icondisabled)
#			if action != null:
#				if action.name == skill.name:
#					newbutton.set_pressed(true)
			if newbutton.is_disabled():
				newbutton.get_node("number").set('custom_colors/font_color', Color(1,0,0,1))
			elif newbutton.is_pressed():
				newbutton.get_node("number").set('custom_colors/font_color', Color(0,1,1,1))
	
	func dodge():
		scene.floattext(node, 'Miss!', '#ffff00')
	
	func createfromdata(data):
		name = data.name
		portrait = data.icon
		if person == globals.player || (globals.slaves.has(person) && globals.state.playergroup.has(person.id)):
			group = 'player'
		else:
			group = 'enemy'
		abilities = data.stats.abilities
		#Filling values
		
		hp = data.stats.health
		hpmax = data.stats.health
		energy = data.stats.energy
		
		attack = data.stats.power
		armor = data.stats.armor
		speed = data.stats.speed
		magic = data.stats.magic
		
		#Gear
	
	func draw():
		if state == 'defeated':
			if group == 'player':
				scene.playergroup.erase(self)
			else:
				scene.enemygroup.erase(self)
			node.hide()
			node.queue_free()
			return
		node.visible = true
		node.get_node("portrait").texture = portrait
		node.get_node("name").text = name
		node.get_node("hp").value = (hp/hpmax)*100
		node.get_node("hp/Label").text = str(ceil(hp)) + "/" + str(hpmax)
		if node.has_node("en"):
			node.get_node("en").value = float(energy)/energymax*100
			node.get_node("en/Label").text = str(ceil(energy)) + "/" + str(energymax)
		if node.has_node('stress') && person != globals.player:
			node.get_node('stress').visible = true
			node.get_node('stress/Label').text = str(stress)
			node.get_node('stress').value = float(stress)/stressmax*100
		for i in node.get_node("buffscontainer").get_children():
			if i.name != 'TextureRect':
				i.hide()
				i.free()
		
		if energy > 0 && passives.has('exhausted'):
			scene.removebuff('exhaust', self)
			passives.erase("exhaust")
		elif energy <= 0:
			scene.getbuff(scene.makebuff('exhaust', self, self), self)
			scene.passive(self, 'exhaust')
		if person != null:
			if person.lust >= 80:
				scene.getbuff(scene.makebuff('luststrong', self, self), self)
				scene.removebuff('lustweak', self)
			elif person.lust >= 50:
				scene.getbuff(scene.makebuff('lustweak', self, self), self)
				scene.removebuff('luststrong', self)
			else:
				scene.removebuff('luststrong',self)
				scene.removebuff('lustweak',self)
		
		for i in effects.values():
			var newnode = node.get_node("buffscontainer/TextureRect").duplicate()
			node.get_node("buffscontainer").add_child(newnode)
			newnode.visible = true
			newnode.texture = i.icon
			newnode.connect("mouse_entered", scene, 'bufftooltip', [i])
			newnode.connect("mouse_exited", globals, 'hidetooltip')
		#button.get_node("")
	
	func health_set(value):
		var effect = ''
		var color = 'white'
		var difference = ceil(value - hp)
		if difference > 0:
			effect = 'increase'
			color = '#00ff5e'
		elif difference < 0:
			effect = 'decrease'
			color = '#f05337'
		hp = clamp(0, ceil(value), hpmax)
		
		scene.floattext(node, str(difference), color)
		draw()
		if hp <= 0:
			defeat()
	
	func defeat():
		state = 'defeated'
		scene.combatlog += scene.combatantdictionary(self, self, "\n[color=aqua][name1] has been defeated.[/color]")
		scene.endcombatcheck()
	
	func health_get(value):
		return hp

func checkforresults():
	if playergroup[0].state == 'defeated':
		lose()
		return
	var counter = 0
	var text = ''
	for i in playergroup:
		if i.state == 'defated':
			text += '\n[color=#ff4949]' + i.name + ' has fallen. [/color]'
			playergroup.remove(playergroup.find(i))
	for i in enemygroup:
		if i.state == 'defeated':
			counter += 1
	if counter >= enemygroup.size():
		win()

func lose():
	globals.main.animationfade(1)
	$confirm.disabled = true
	yield(globals.main, 'animfinished')
	globals.main.get_node("gameover").show()
	globals.main.get_node("gameover/Panel/text").set_bbcode("[center]You have died. \nGame over.[/center]")

func win():
	get_node("win").show()
	globals.main.music_set('stop')
	globals.main.sound('win')


func start_battle(nosound = false):
	get_parent().animationfade(0.4)
	yield(get_parent(),'animfinished')
	get_node("autowin").visible = get_parent().get_node("new slave button").visible
	var slave
	var combatant
	trapper = false
	globals.main.get_node("outside").hide()
	globals.main.get_node("ResourcePanel").hide()
	turns = 1
	
	playergroup.clear()
	enemygroup.clear()
	for i in $enemypanel/enemyline.get_children() + $grouppanel/groupline.get_children():
		if i.get_name() != 'character':
			i.hide()
			i.free()
			#i.queue_free()
	
	if nosound == false:
		globals.main.music_set('combat')
	self.visible = true
	combatlog = ''
	var slavearray = []
	for i in globals.state.playergroup:
		slavearray.append(globals.state.findslave(i))
	for i in [globals.player] + slavearray:
		var newcombatant = self.combatant.new()
		var newbutton = $grouppanel/groupline/character.duplicate()
		$grouppanel/groupline.add_child(newbutton)
		newcombatant.node = newbutton
		newcombatant.scene = self
		newcombatant.createfromslave(i)
		newbutton.connect('pressed', newcombatant, 'selectcombatant')
		newbutton.connect('mouse_entered', newcombatant, 'combatanttooltip')
		newbutton.connect("mouse_exited", globals, 'hidetooltip')
		newbutton.get_node("info").connect("pressed",self,'showinfochar',[combatant])
		playergroup.append(newcombatant)
		newbutton.set_meta('combatant', newcombatant)
		newcombatant.draw()
	
	#$TextureRect.buildenemies("banditseasy")
	#currentenemies = $TextureRect.enemygroup
	for i in currentenemies:
		var newcombatant = self.combatant.new()
		var newbutton = $enemypanel/enemyline/character.duplicate()
		$enemypanel/enemyline.add_child(newbutton)
		newcombatant.node = newbutton
		newbutton.set_meta('combatant', newcombatant)
		newcombatant.scene = self
		newbutton.connect('pressed', newcombatant, 'selectcombatant')
		if nocaptures == false && i.capture != null:
			newcombatant.createfromslave(i.capture, i)
		else:
			newcombatant.createfromdata(i)
		newcombatant.name = i.name
		enemygroup.append(newcombatant)
		newcombatant.draw()
	$grouppanel/skilline/skill.set_meta('skill', {})
	nocaptures = false
	
	if globals.state.tutorial.combat == false:
		globals.main.get_node("tutorialnode").combat()



func showinfochar(combatant):
	get_parent().get_node('outside').opencharacter(combatant.person, true, combatant)




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
	if selectedcharacter.cooldowns.has(skill.code):
		text += '\n\nCooldown: ' + str(selectedcharacter.cooldowns[skill.code])
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

func bufftooltip(buff):
	var text = '[center][color=yellow]' + buff.name + "[/color][/center]"
	if buff.description != null:
		text += '\n'+buff.description
	if str(buff.stats).replace('(','').replace(')','') != '':
		text += "\n" + str(buff.stats).replace('(','').replace(')','')
	if buff.duration >= 1:
		text += '\nDuration: ' + str(buff.duration)+ ' turns'
	globals.showtooltip(text)

func physdamage(caster, target, skill):
	var damage = 0
	var power = (caster.attack * skill.power)
	var protection = float(float(100-target.protection)/100)
	var armor = target.armor
	if skill.attributes.has('physpen'):
		protection = 1
		armor = 0
	for i in caster.geareffects:
		if i.type == 'incombatphyattack':
			if i.effect == 'protpenetration':
				protection = 1
			if i.effect == 'fullpenetration':
				armor = 0
				protection = 1
	if caster.passives.has('exhaust'):
		power = power * 0.66
	
	damage = power * protection - armor
	if target.person != null && target.person.traits.has("Sturdy"):
		damage = damage*0.85
	damage = max(damage, 1)
	return damage

func spelldamage(caster, target, skill):
	var damage = 0
	damage = max(1,(caster.magic * 2.5)) * skill.power
	if skill.code == 'mindblast':
		damage += target.healthmax/5
	if globals.state.spec == 'Mage' && caster.group == 'player':
		damage *= 1.2
	if target.person != null && target.person.traits.has("Sturdy"):
		damage = damage*0.85
	return damage

func calculatehit(caster,target,skill):
	var hitchance = 80
	if caster.speed >= target.speed:
		hitchance += (caster.speed - target.speed)*2.5
	else:
		hitchance -= (target.speed - caster.speed)*4
	if caster.person != null && caster.person.traits.has("Nimble"):
		hitchance *= 1.25
	if skill.has('accuracy'):
		hitchance = hitchance*skill.accuracy
	if target.person != null && target.person.race.findn("cat") >= 0:
		hitchance = hitchance*0.9
	if rand_range(0,100) > hitchance:
		return 'miss'
	else:
		return 'hit'

func floattext(node, value, color = 'white'):
	var newnode = $floattext.duplicate()
	node.add_child(newnode)
	newnode.visible = true
	newnode.text = str(value)
	if color != 'white':
		newnode.set('custom_colors/font_color', Color(color))
	newnode.get_node("AnimationPlayer").play("flyout")
	yield(newnode.get_node('AnimationPlayer'), 'animation_finished')
	newnode.queue_free()

func pressskill(skill):
	if skill.target in ['one']:
		period = 'skilltarget'
		targetskill = skill
	else:
		period = 'skilluse'
		useskills(skill, selectedcharacter, selectedcharacter)
	
func useskills(skill, caster = null, target = null, retarget = false):
	var text = ''
	var damage = 0
	var group
	var hit = 'hit'
	var targetparty 
	if caster.group != target.group && target.effects.has('protecteffect') && retarget == false:
		if target.effects.caster.state == 'normal' && target.effects.caster.hp > 0:
			combatlog += combatantdictionary(caster, target, "[name1] covers [targetname1] from attack.")
			useskills(skill, caster, target.effects.caster, true)
			return
	caster.actionpoints -= 1
	if skill.cooldown > 0:
		caster.cooldowns[skill.code] = skill.cooldown
	if playergroup.has(caster):
		if skill.costmana > 0:
			var cost = skill.costmana
			if globals.state.spec == 'Mage':
				cost = round(cost/2)
			globals.resources.mana -= cost
		caster.energy -= skill.costenergy
	else:
		group = 'enemy'
		#text = skill.usetext 
	var skillcounter = 1
	while skillcounter > 0:
		skillcounter -= 1
		#target skills
		if skill.target == 'one':
			if skill.code == 'attack':
				text += '[color=lime][name1][/color] tries to attack [color=#ec636a][targetname1][/color]. '
			else:
				text += '[name1] uses [color=aqua]' + skill.name + "[/color] on [targetname1]. "
			if skill.attributes.has('damage'):
				if skill.can_miss == true:
					hit = calculatehit(caster, target, skill)
				if skill.type == 'physical' && hit != 'miss':
					damage = ceil(physdamage(caster, target, skill))
					text += '[targetname1] takes ' + str(damage) + ' damage.' 
				elif skill.type == 'spell':
					damage = ceil(spelldamage(caster, target, skill))
					text += '[targetname1] takes ' + str(damage) + ' spell damage.' 
				
				if skill.type == 'physical' && hit == 'miss':
					target.dodge()
					text += '[targetname1] [color=yellow]dodges[/color] it. '
				else:
					target.hp -= damage
		#aoe skills
		elif skill.target == 'all':
			var targetarray
			if group == 'player':
				targetarray = enemygroup
			else:
				targetarray = playergroup
			for i in targetarray:
				if skill.attributes.has('damage'):
					if skill.can_miss == true:
						hit = calculatehit(caster, target, skill)
					if skill.type == 'physical' && hit != 'miss':
						damage = physdamage(caster, target, skill)
					elif skill.type == 'spell':
						damage = spelldamage(caster, target, skill)
		
		#buffs and effects
		
		if skill.effect != null && hit == 'hit':
			sendbuff(caster, target, skill.effect)
		if skill.has('effectself') && skill.effectself != null:
			sendbuff(caster, caster, skill.effectself)
		
		if caster.passives.has('doubleattack') && randf() >= 0.5 && skill.type == 'physical':
			skillcounter += 1
			text += "[color=yellow]Double attack![/color]"
		
		
	if skill.has('castersfx'):
		pass
	
	
	
	self.combatlog += '\n' + combatantdictionary(caster, target, text)
	
	
	caster.draw()
	target.draw()
	
	period = 'base'
	deselectall()


func sendbuff(caster, target, effect):
	getbuff(makebuff(effect, target, caster), target)

func makebuff(code, target, caster):
	var effect = str2var(var2str(globals.abilities.effects[code]))
	var buff = {duration = effect.duration, name = effect.name, code = effect.code, type = effect.type, stats = {}, icon = effect.icon, description = null, caster = caster}
	if effect.has('description'):
		buff.description = effect.description
	for i in effect.stats:
		var temp = i[1].split(',')
		temp = Array(temp)
		for ii in range(0, temp.size()):
			if temp[ii].find('caster') >= 0:
				var temp2 = temp[ii].split('.')
				temp[ii] = caster[temp2[1]]
			elif temp[ii].find('target') >= 0:
				var temp2 = temp[ii].split('.')
				temp[ii] = target[temp2[1]]
		var temp2 = ''
		for i in temp:
			temp2 += str(i)
		buff.stats[i[0]] = globals.evaluate(temp2)
	return buff


func getbuff(buff, target):
	var buffexists = false
	if target.effects.has(buff.code):
		buffexists = true
	if buffexists == true:
		target.effects[buff.code].duration = buff.duration
	else:
		target.effects[buff.code] = buff
		for i in buff.stats:
			target[i] = target[i] + buff.stats[i]

func removebuff(buffcode, target):
	if target.effects.has(buffcode):
		if buffcode == 'stun':
			target.state = 'normal'
		for i in target.effects[buffcode].stats:
			target[i] = target[i] - target.effects[buffcode].stats[i]
		target.effects.erase(buffcode)


func combatantdictionary(combatant, combatant2, text):
	text = text.replace('[name1]', combatant.name)
	text = text.replace('[targetname1]', combatant2.name)
	return text


func deselectall():
	selectedcharacter = null
	for i in get_node("grouppanel/skilline").get_children():
		if i.name != 'skill':
			i.hide()
			i.free()
	for i in $grouppanel/groupline.get_children():
		i.pressed = false

func enemyturn():
	var target
	for combatant in enemygroup:
		if combatant.state != 'normal':
			continue
		for i in combatant.cooldowns:
			combatant.cooldowns[i] -= 1
			if combatant.cooldowns[i] <= 0:
				combatant.cooldowns.erase(i)
		var skill = []
		for k in combatant.abilities:
			var i = globals.abilities.abilitydict[k]
			if combatant.ai == 'attack':
				if combatant.aimemory != 'attack':
					skill = combatant.abilities[0]
					combatant.aimemory = 'attack'
					break
				if combatant.cooldowns.has(i.code):
					continue
				if i.aipatterns.has('attack'):
					skill.append({value = i, weight = i.aipriority})
		
		
		if playergroup.size() == 0:
			lose()
			return
		
		if typeof(skill) == TYPE_ARRAY:
			skill = globals.weightedrandom(skill)
		if skill == null:
			skill = globals.abilities.abilitydict[combatant.abilities[0]]
		if skill.targetgroup == 'enemy':
			target = playergroup[randi()%playergroup.size()]
		else:
			target = playergroup[randi()%enemygroup.size()]
		if combatant.state in ['normal']:
			useskills(skill, combatant, target)
	
	
	for i in playergroup + enemygroup:
		i.stress += 3
		i.actionpoints = 1
		for effect in i.effects.values():
			if effect.duration == 0:
				i.removebuff(effect.code)
			elif effect.duration > 0:
				effect.duration -= 1
	
	
	
	endcombatcheck()
	
	
	turns += 1
	self.combatlog += "\n[center]Turn " + str(turns) + "[/center]"

func endcombatcheck():
	var counter = 0
	for i in enemygroup:
		if i.state in ['escaped','defeated','captured']:
			counter += 1
	if counter >= enemygroup.size():
		get_node("win").show()
		globals.main.music_set('stop')
		globals.main.sound('win')
		return
	
	if playergroup[0].state == 'stopfight':
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


func endturn():
	for i in playergroup:
		pass

func _on_confirm_pressed():
	enemyturn()
	endturn()


func damage(combatant, value):
	combatant.attack += value

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

		#yield(get_tree().create_timer(1), 'timeout')
#			#checking hit chance
#					if target.action.code == 'protect':
#						if target.person.spec == 'bodyguard':
#							damage = damage - damage*0.7
#						else:
#							damage = damage - damage*0.35
#				
#				
#				if skill.attributes.has('allparty'):
#					text += "\nStrong attack affects everyone in opposing party."
#					for i in targetparty:
#						if i != target:
#							i.health -= damage
#				if target.energy < 0:
#					target.energy = 0
#				if skill.attributes.has('lifesteal'):
#					actor.health = min(actor.health + (targethealthinit - target.health)/4,actor.healthmax)
#					text += actor.name + ' recovered some health back.' 
#		elif skill.target == 'self':
#			if skill.code == 'escape' && globals.main.get_node("explorationnode").launchonwin == null:
#				actor.state = 'stopfight'
#				actor.energy = max(actor.energy - skill.costenergy,0)
#			elif skill.code == 'escape' && globals.main.get_node("explorationnode").launchonwin != null:
#				globals.main.popup("You can't escape from this fight")
#		elif skill.target == 'ally':
#			if group == 'enemy':#Checking for blockers
#				targetparty = enemygroup
#			else:
#				targetparty = playergroup
#		if skill.effect != null && (skill.type == 'spell' || hit in ['precise','hit'] || skill.target in ['ally','self']):
#			actor.sendbuff()
#		if skill.code == 'heal':
#			globals.abilities.restorehealth(actor,target)
#		elif skill.code == "masshealcouncil":
#			for i in targetparty:
#					if i != actor:
#						globals.abilities.restorehealth(actor,i)
#		target.health = ceil(target.health)
#		if target.health < 0:
#			target.health = 0
#			if actor.person != null && actor.person != globals.player:
#				actor.person.stress -= rand_range(5,10)
#				text += "\n$name has defeated " + target.name + ". "
#		text = combatantdictionary(actor, text)
#		return text
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
	hide()
	globals.main.get_node("outside").show()
	globals.main.get_node("ResourcePanel").show()
	globals.main.get_node("explorationnode").enemydefeated()


func _on_winconfirm_pressed():
	set_process(false)
	get_node("win").hide()
	for i in playergroup:
		i.person.metrics.win += 1
		i.person.stats.energy_cur = i.energy
		i.person.stats.health_cur = i.hp
		i.person.stress = i.stress
	victory()