
extends Node

var person
var main

func _init():
	globals.spelldict = spelllist

func spellsynchronize():
	for i in globals.state.spelllist:
		if i.learned == true:
			globals.spelldict[i].learned = true
			print('spellsynchroned')

var spelllist = {
mindread = {
	code = 'mindread',
	name = 'Mind Reading',
	description = 'Enhances your mind to be more cunning towards others. Allows to get accurate information about other characters. ',
	effect = 'mindreadeffect',
	manacost = 3,
	req = 0,
	price = 100,
	personal = true,
	combat = true,
	learned = false,
	type = 'control',
	flavor = "Reading other person's thoughts hardly worth the effort: way too often they are just chaotic streams changing one after another. Netherless, you can grasp some understanding how others think by devoting your time to them. ",
	},
sedation = {
	code = 'sedation',
	name = 'Sedation',
	description = "Eases target's stress and improves low obedience.",
	effect = 'sedationeffect',
	manacost = 10,
	req = 0,
	price = 200,
	personal = true,
	combat = true,
	learned = false,
	type = 'control',
	flavor = "Ability to calm down another person is invaluable in many situations. ",
	},
heal = {
	code = 'heal',
	name = 'Heal',
	description = 'Heals physical wounds. ',
	effect = 'healeffect',
	manacost = 10,
	req = 0,
	price = 200,
	personal = true,
	combat = true,
	learned = false,
	type = 'defensive',
	flavor = "Regeneration is a part of every living being.",
	},
dream = {
	code = 'dream',
	name = 'Dream',
	description = 'Puts target into deep, restful sleep. ',
	effect = 'dreameffect',
	manacost = 20,
	req = 0,
	price = 350,
	personal = true,
	combat = false,
	learned = false,
	type = 'control',
	},
entrancement = {
	code = 'entrancement',
	name = 'Entrancement',
	description = 'Makes target more susceptible to suggestions and easier to acquire various kinks.',
	effect = 'entrancementeffect',
	manacost = 15,
	req = 10,
	price = 400,
	personal = true,
	combat = false,
	learned = false,
	type = 'control',
	},
fear = {
	code = 'fear',
	name = 'Fear',
	description = 'Invokes subconscious feel of terror onto the targer. Can be effective punishment. ',
	effect = 'feareffect',
	manacost = 10,
	req = 0,
	price = 250,
	personal = true,
	combat = false,
	learned = false,
	type = 'control',
	},
domination = {
	code = 'domination',
	name = 'Domination',
	description = 'Attempts to overwhelm  the target′s mind and instill unwavering obedience. May cause irreversible mental trauma. ',
	effect = 'dominationeffect',
	manacost = 40,
	req = 10,
	price = 500,
	personal = true,
	combat = false,
	learned = false,
	type = 'control',
	},
mutate = {
	code = 'mutate',
	name = 'Mutation',
	description = 'Enforces mutation onto targe. Results may vary drastically. ',
	effect = 'mutateeffect',
	manacost = 15,
	req = 2,
	price = 400,
	personal = true,
	combat = false,
	learned = false,
	type = 'utility',
	},
barrier = {
	code = 'barrier',
	name = 'Barrier',
	description = "Creates a magical barrier around target, raising it's armor. ",
	effect = '',
	manacost = 12,
	req = 1,
	price = 200,
	personal = false,
	combat = true,
	learned = false,
	type = 'defensive',
	},
shackle = {
	code = 'shackle',
	name = 'Shackle',
	description = "Ties single target to ground making escape impossible. ",
	effect = '',
	manacost = 10,
	req = 1,
	price = 200,
	personal = false,
	combat = true,
	learned = false,
	type = 'utility',
	},
acidspit = {
	code = 'acidspit',
	name = 'Acid Spit',
	description = "Turns your saliva into highly potent corrosive substance for a short time. \nDeals spell damage to single target enemy and recudes it's armor. ",
	effect = '',
	manacost = 5,
	req = 2,
	price = 400,
	personal = false,
	combat = true,
	learned = false,
	type = 'offensive',
	},
mindblast = {
	code = 'mindblast',
	name = 'Mind Blast',
	description = "Simple mind attack which can be utilized in combat. While not terribly effective on its own, can eventually break the enemy. \nDeals spell damage to single target enemy. ",
	effect = '',
	manacost = 3,
	req = 1,
	price = 100,
	personal = false,
	combat = true,
	learned = false,
	type = 'offensive',
	},
invigorate = {
	code = 'invigorate',
	name = 'Invigorate',
	description = "Restores caster's and target's energy by using mana and target body's potential. Builds up target's stress. Can be used in wild. ",
	effect = 'invigorateeffect',
	manacost = 5,
	req = 2,
	price = 300,
	personal = true,
	combat = false,
	learned = false,
	type = 'utility',
	},
summontentacle = {
	code = 'summontentacle',
	name = 'Summon Tentacle',
	description = 'Summons naughty tentacles from the otherworld for a short time.',
	effect = 'tentacleeffect',
	manacost = 35,
	req = 10,
	price = 650,
	personal = true,
	combat = false,
	learned = false,
	type = 'utility',
	},
guidance = {
	code = 'guidance',
	name = 'Guidance',
	description = "An utility spell which helps to find shortest and safest paths among the wilds. \nEffect grows with Magic Affinity. \n[color=yellow]Effect reduced in enclosed spaces[/color] ",
	effect = 'guidanceeffect',
	manacost = 8,
	req = 2,
	price = 250,
	personal = false,
	combat = false,
	learned = false,
	type = 'utility',
	},
}

func mindreadeffect():
	var spell = globals.spelldict.mindread
	var text = ''
	globals.resources.mana -= spell.manacost
	text = "You peer into $name's soul. $He is of " + person.origins + " origins. \nObedience: " + str(round(person.obed)) + ', Stress: '+ str(round(person.stress)) + ', Loyalty: ' + str(round(person.loyal)) + ', Lust: '+ str(round(person.lust)) + ', Courage: ' + str(round(person.cour)) + ', Confidence: ' + str(round(person.conf)) + ', Wit: '+ str(round(person.wit)) + ', Charm: ' + str(round(person.charm)) + ", Toxicity: " + str(floor(person.toxicity)) + ", Lewdness: " + str(floor(person.lewdness)) 
	text += "\nStrength: " + str(person.sstr) + ", Agility: " + str(person.sagi) + ", Magic Affinity: " + str(person.smaf) + ", Endurance: " + str(person.send)
	text += "\nBase Beauty: " + str(person.beautybase) + ', Temporal Beauty: ' + str(person.beautytemp)
	if person.effects.has('captured') == true:
		text = text + "\n$name doesn't accept $his new life in your domain. Strength : " + str(person.effects.captured.duration)
	if person.praise > 0:
		text = text + '\n$name is still upbeat from you praising $him.'
	if person.punish.expect == true:
		text = text + '\n$name still strongly fears your punishment.'
	if person.traits.size() >= 0:
		text += '\n$name has corresponding traits:'
		for i in person.traits:
			text += ' ' + i
		text += '.'
#------------------------------------------------------------------
	#if person.sexexp.bloodlossdetected == true:
	text += "\nImpregnation risk at: Day "+ str(person.sexexp.cycleday)
	if person.sexexp.impregnationday == 1:
		text += " [color=red]Danger Day !![/color]"
#------------------------------------------------------------------
	if person.preg.duration > 0:
		text += "\nPregnancy: " + str(person.preg.duration)
	if person.lastsexday != 0:
		text += "\n$name had sex last time " + str(globals.resources.day - person.lastsexday) + " day(s) ago"
	text = person.dictionary(text)
	main.dialogue(true, self, text)

func sedationeffect():
	var spell = globals.spelldict.sedation
	globals.resources.mana -= spell.manacost
	if person.effects.has('sedated'):
		main.popup(person.dictionary("You cast Sedation spell on the $name but it appears $he is already under its effect. "))
		return
	person.add_effect(globals.effectdict.sedated)
	person.stress -= rand_range(20,30) + globals.player.smaf*6
	if person.obed < 40:
		person.obed += rand_range(20,30)
	main.popup(person.dictionary('You cast Sedation spell on the $name and $he relaxes a bit.'))
	main.rebuild_slave_list()

func healeffect():
	var text = ''
	var spell = globals.spelldict.heal
	globals.resources.mana -= spell.manacost
	if person.health < person.stats.health_max:
		person.health += rand_range(20,30) + globals.player.smaf*5
		if globals.player != person:
			text = "After you finish casting the spell, $name's wounds close up. "
			if person.loyal < 20:
				person.loyal += rand_range(2,4)
				person.obed += rand_range(10,15)
				text += '$He looks somewhat surprised at your kind treatment and grows bit closer to you. '
		else:
			text = "After you finish casting the healing spell, your wounds close up. "
	else:
		text = "It does not seems like $name was injured in first place. "
	main.popup(person.dictionary(text))
	main.rebuild_slave_list()

func dreameffect():
	var text = ''
	var spell = globals.spelldict.dream
	globals.resources.mana -= spell.manacost
	person.away.duration = 1
	person.energy = person.stats.energy_max
	person.stress -= rand_range(25,50)
	text = 'You cast sleep on $name, putting $him into deep rest until the next day. '
	main.popup(person.dictionary(text))
	main._on_mansion_pressed()


func invigorateeffect():
	var text = ''
	var spell = globals.spelldict.invigorate
	globals.resources.mana -= spell.manacost
	person.energy += person.stats.energy_max/2
	person.stress += rand_range(25,35)-globals.player.smaf*4
	globals.player.energy += 50
	main.popup(person.dictionary("You cast Invigorate on $name. Your and $his energy is partly restored. $His stress has increased. "))

func entrancementeffect():
	var text = ''
	var spell = globals.spelldict.entrancement
	var exists = false
	globals.resources.mana -= spell.manacost
	if person.effects.has('entranced') == false:
		text = "Light gradually fades from $name's eyes, and $his gaze becomes downcast. $He seems ready to accept whatever you tell $him. "
		person.add_effect(globals.effectdict.entranced)
	else:
		text = "It seems, $name is already entranced. "
	main.popup(person.dictionary(text))

func feareffect():
	var text = "You grab hold of $name's shoulders and hold $his gaze. At first, $he’s calm, but the longer you stare into $his eyes, the more $he trembles in fear. Soon, panic takes over $his stare. "
	var spell = globals.spelldict.fear
	globals.resources.mana -= spell.manacost
	if person.cour > 30 && rand_range(1,100) < 20:
		person.cour -= rand_range(5,10)
	if person.obed < 85 && person.punish.expect == false:
		person.obed += rand_range(25,50)
		text = text + "$name's looks changed considerably as your punishment made its point for $him."
		person.punish.expect = true
		if person.race == 'Human':
			person.punish.strength = 10
		else:
			person.punish.strength = 5
		person.stress += rand_range(15,20)
		person.loyal += -5
	elif person.obed < 85 && person.punish.expect == true:
		person.obed += rand_range(35,70)
		text = text + "$name quickly excused $himself and begged for your forgiveness, realizing rightfulnes of your actions. "
		if person.race == 'Human':
			person.punish.strength = 10
		else:
			person.punish.strength = 5
		person.stress += rand_range(10,15)
	elif person.obed >= 85:
		text = text + '$name reacts disturbingly to your punishment, as $he does not seems to believe $he offended you rightly.'
		person.stress += 45
		person.cour -= rand_range(5,10)
	if person.effects.has('captured') == true:
		text += "\n[color=green]$name becomes less rebellious towards you.[/color]"
		person.effects.captured.duration -= 1+globals.player.smaf
	main.popup(person.dictionary(text))
	main.rebuild_slave_list()

func dominationeffect():
	var text = ''
	var spell = globals.spelldict.domination
	globals.resources.mana -= spell.manacost
	if rand_range(0,100) < 20 && globals.player.smaf < 5:
		text = "Your spell badly damages $name's mind as $he twiches and yells under its' effect."
		person.cour -= rand_range(1,25)
		person.conf -= rand_range(1,25)
		person.wit -= rand_range(1,25)
		person.charm -= rand_range(1,25)
	else:
		if person.wit + person.conf > rand_range(100,175):
			text = '$name managed to resist influence of your spell. $His disposition towards you worsened. '
			person.loyal += -rand_range(15,25)
			person.obed += -rand_range(25,50)
		else:
			text = 'Your spell greatly affected $name and $he became way more submissive towards you.  '
			person.loyal += rand_range(25,50)
			person.obed += 100
			if person.effects.has('captured') == true:
				text += "\n[color=green]$name becomes less rebellious towards you.[/color]"
				person.effects.captured.duration -= 3+(1*globals.player.smaf)
	main.popup(person.dictionary(text))
	main.rebuild_slave_list()

func guidanceeffect():
	var spell = globals.spelldict.guidance
	globals.resources.mana -= spell.manacost
	var text = 'You cast guidance and move forward through the area avoiding any unnecessary encounters. '
	
	if main.exploration.currentzone.tags.has("noreturn"):
		main.exploration.progress += round((2 + globals.player.smaf*.15)/2)
	else:
		main.exploration.progress += round(2 + globals.player.smaf*1.5)
	main.exploration.zoneenter(main.exploration.currentzone.code)
	main.popup(text)

func tentacleeffect():
	main.popup('This spell is WIP, Sorry.')

func sortspells(first, second):
	if first.name >= second.name:
		return false
	else:
		return true

func mutateeffect():
	globals.resources.mana -= spelllist.mutate.manacost
	mutate(2)
	get_parent().rebuild_slave_list()

func mutate(power=2, silent = false):
	var array = ['height','tits','ass','penis','balls','penistype','skin','skincov','eyecolor','eyeshape','haircolor','hairlength','ears','tail','wings','horns','beauty','lactation','nipples','lust','amnesia','pregnancy']
	var line
	var text = "Raw magic in $name's body causes $him to uncontrollably mutate. \n\n"
	var temp
	while power >= 1:
		person.stress += rand_range(5,15)
		line = array[rand_range(0,array.size())]
		if line == 'height':
			text += "$name's height has changed. "
			person.height = globals.heightarray[rand_range(0,globals.heightarray.size())]
		elif line == 'tits':
			text += "$name's chest size has changed. "
			person.titssize = globals.sizearray[rand_range(0,globals.sizearray.size())]
		elif line == 'ass':
			text += "$name's butt size has changed. "
			person.ass = globals.sizearray[rand_range(0,globals.sizearray.size())]
		elif line == 'penis':
			if (globals.rules.futa == false && person.sex != 'male'):
				power += 1
				continue
			if person.penis == 'none':
				person.penis = 'small'
				text += "$name has grown a dick. "
			else:
				text += "$name's dick size has changed. "
				person.penis = globals.genitaliaarray[rand_range(0,globals.genitaliaarray.size())]
		elif line == 'penistype':
			if person.penis == 'none':
				power += 1
			else:
				text += "$name's dick shape has changed. "
				person.penistype = globals.penistypearray[rand_range(0,globals.penistypearray.size())]
		elif line == "balls":
			if (globals.rules.futaballs == false && person.sex != 'male'):
				power += 1
				continue
			if person.balls == 'none':
				person.balls = 'small'
				text += "$name has grown a scrotum. "
			else:
				person.balls = globals.genitaliaarray[rand_range(0,globals.genitaliaarray.size())]
				text += "$name's scrotum size has changed. "
		elif line == 'skin':
			text += "$name's skin color has changed. "
			person.skin = globals.assets.getrandomskincolor()
		elif line == 'skincov':
#			if globals.rules.furry == false:
#				power += 1
#				continue
			text += "$name's skin coverage has changed. "
			person.skincov = globals.skincovarray[rand_range(0,globals.skincovarray.size())]
			person.furcolor = globals.assets.getrandomfurcolor()
		elif line == 'eyecolor':
			text += "$name's eye color has changed. "
			person.eyecolor = globals.assets.getrandomeyecolor()
		elif line == "eyeshape":
			text += "$name's pupil shape has changed. "
			if person.eyeshape == 'normal':
				person.eyeshape = 'slit'
			else:
				person.eyeshape = 'normal'
		elif line == "haircolor":
			text += "$name's hair color has changed. "
			person.haircolor = globals.assets.getrandomhaircolor()
		elif line == "hairlength":
			if globals.hairlengtharray.find(person.hairlength) < 4:
				person.hairlength = globals.hairlengtharray[globals.hairlengtharray.find(person.hairlength) + 1]
				text += "$name's hair has grown. "
			else:
				power += 1 
		elif line == "horn":
			if person.horns == 'none':
				text += "$name has grown a pair of horns. "
			else:
				text += "$name's horns have changed in shape. " 
			person.horns = globals.assets.getrandomhorns()
		elif line == "tail":
			if person.tail == 'none':
				text += "$name has grown a tail. "
			else:
				text += "$name's tail has changed in shape. " 
			person.tail = globals.alltails[rand_range(0,globals.alltails.size())]
		elif line == "wings":
			if person.wings == 'none':
				text += "$name has grown a pair of wings. "
			else:
				text += "$name's wings has changed in shape. " 
			person.wings = globals.allwings[rand_range(0, globals.allwings.size())]
		elif line == "ears":
			text += "$name's ears shape has changed. "
			person.ears = globals.allears[rand_range(0, globals.allears.size())]
		elif line == "beauty":
			text += "$name's face has drastically changed. "
			person.beautybase = round(rand_range(10, 90))
		elif line == "lactation":
			if person.lactation == false:
				text += "$name's breats started secreting milk. "
				person.lactation = true
			else:
				power += 1
		elif line == "nipples":
			text += "Additional nipples has sprouted on $name's torse. "
			person.tits.extrapairs = round(rand_range(1,4))
		elif line == "pregnancy":
			if person.preg.has_womb == true:
				text += "It seems some new life has began in $name. "
				person.preg.fertility = 100
				globals.impregnation(person)
			else:
				power += 1
		elif line == "amnesia":
			text += "$name's cognitive abilities have worsened. "
			person.wit -= rand_range(10,25)
		elif line == "lust":
			text += "$name's lust has greatly increased. "
			person.lust += rand_range(40,80)
		power -= 1
	person.toxicity = -rand_range(15,30)
	if silent == false:
		main.popup(person.dictionary(text))
	else:
		return person.dictionary(text)

