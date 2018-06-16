extends Node

var enemygroup = {enemygear = {}, units = {}}

#func enemyencounter():
#	var enc
#	var encmoveto
#	var scoutawareness = -1
#	var patrol = 'none'
#	var text = ''
#	var enemyawareness
#	enemygroup.clear()
#	inencounter = true
#	outside.clearbuttons()
#	scoutawareness = calculateawareness()
#	if currentzone.encounters.size() > 0:
#		for i in currentzone.encounters:
#			enc = i[0]
#			var condition = i[1]
#			var chance = i[2]
#			if globals.evaluate(condition) == true && rand_range(0,100) < chance:
#				encmoveto = enc
#				break
#	if encmoveto != null:
#		call(enc)
#		return
#	else:
#		for i in currentzone.tags:
#			if i in ['wimborn','frostford','gorn','amberguard'] && globals.state.reputation[i] <= -10 && max(10, min(abs(globals.state.reputation[i])/1.2,30)) - scoutawareness/2 > rand_range(0,100):
#				if globals.state.reputation[i] <= -25 && rand_range(0,10) > 3:
#					buildenemies(i+'guardsmany')
#					patrol = 'patrolbig'
#					break
#				elif globals.state.reputation[i] <= -10:
#					buildenemies(i+'guards')
#					patrol = 'patrolsmall'
#					break
#		if enemygroup.empty() == true:
#			buildenemies()
#		var counter = 0
#		for i in enemygroup.units:
#			if i.capture == true:
#				var race = ''
#				var sex = ''
#				var age = ''
#				var origins = ''
#				var rand = 0
#				if i.capturerace.find('area') >= 0:
#					race = globals.weightedrandom(currentzone.races)
#				elif i.capturerace.find('any') >= 0:
#					race = globals.allracesarray[rand_range(0,globals.allracesarray.size())]
#				elif i.capturerace.find('bandits') >= 0:
#					if rand_range(0,10) <= 7:
#						race = 'Human'
#					else:
#						race = globals.banditraces[rand_range(0,globals.banditraces.size())]
#				else:
#					rand = rand_range(0,100)
#					for ii in i.capturerace:
#						if rand < ii[1]:
#							race = ii[0]
#							break
#				race = globals.checkfurryrace(race)
#				if i.capturesex.find('any') >= 0:
#					sex = 'random'
#				else:
#					rand = rand_range(0,100)
#					for ii in i.capturesex:
#						if rand < ii[1]:
#							sex = ii[0]
#							break
#				age = globals.weightedrandom(i.captureagepool)
#				origins = globals.weightedrandom(i.captureoriginspool)
#				if deeperregion == true && globals.originsarray.find(origins) < 4 && rand_range(0,1) > 0.3:
#					origins = globals.originsarray[globals.originsarray.find(origins)+1]
#				var slavetemp = globals.newslave(race, age, sex, origins)
#				enemylevelup(slavetemp, currentzone.levelrange)
#				slavetemp.health = slavetemp.stats.health_max
#				enemygroup.units[counter].capture = slavetemp
#				var gear = {}
#				for k in ['armor','weapon','costume','underwear','accessory']:
#					if !combatdata.enemyequips[i.gear].has(k):
#						continue
#					gear[k] = globals.weightedrandom(combatdata.enemyequips[i.gear][k])
#					if gear[k] == 'nothing':
#						continue
#					var enchant = false
#					var item
#					if gear[k].find("+") >= 0:
#						enchant = true
#						gear[k] = gear[k].replace("+","")
#					item = globals.items.createunstackable(gear[k])
#					if enchant:
#						globals.items.enchantrand(item)
#					enemygear[item.id] = item
#					globals.items.equipitem(item.id, slavetemp, true)
#
#			counter += 1
#		if enemygroup.captured != null:
#			var group = enemygroup.captured
#			enemygroup.captured = []
#			for i in group:
#				var person = capturespool[i]
#				var race = ''
#				var sex = ''
#				var age = ''
#				var origins = ''
#				var rand = 0
#				if person.race.find('area') >= 0:
#					race = globals.weightedrandom(currentzone.races)
#				elif person.race.find('any') >= 0:
#					race = globals.allracesarray[rand_range(0,globals.allracesarray.size())]
#				elif person.race.find('bandits') >= 0:
#					race = globals.banditraces[rand_range(0,globals.banditraces.size())]
#				else:
#					rand = rand_range(0,100)
#					for i in person.race:
#						if rand < i[1]:
#							race = i[0]
#							break
#				if person.sex.find('any') >= 0:
#					sex = 'random'
#				else:
#					rand = rand_range(0,100)
#					for i in person.sex:
#						if rand < i[1]:
#							sex = i[0]
#							break
#				rand = rand_range(0,100)
#				race = globals.checkfurryrace(race)
#				age = globals.weightedrandom(person.agepool)
#				origins = globals.weightedrandom(person.originspool)
#				if deeperregion == true && globals.originsarray.find(origins) < 4 && rand_range(0,1) > 0.3:
#					origins = globals.originsarray[globals.originsarray.find(origins)+1]
#				person = globals.newslave(race, age, sex, origins)
#				enemygroup.captured.append(person)
#	enemyawareness = enemygroup.awareness
#	if deeperregion == true:
#		enemyawareness *= 1.25
#	if patrol != 'none':
#		text = encounterdictionary(enemygroup.description) + "Your bad reputation around here will certainly lead to a difficult fight..."
#		encounterbuttons(patrol)
#	elif scoutawareness < enemygroup.awareness:
#		ambush = true
#		text = encounterdictionary(enemygroup.descriptionambush)
#		if enemygroup.special == null:
#			encounterbuttons()
#		else:
#			call(enemygroup.specialambush)
#			return
#	else:
#		ambush = false
#		text = encounterdictionary(enemygroup.description)
#		if enemygroup.special == null:
#			encounterbuttons()
#		else:
#			call(enemygroup.special)
#			return
#	mansion.maintext = text
#	enemyinfo()
#
#func enemyinfo():
#	var text = ''
#	if enemygroup.units.size() <= 3:
#		text = "Number: " + str(enemygroup.units.size())
#	else:
#		text += "Estimate number: " + str(max(round(enemygroup.units.size() + rand_range(-2,2)),1))
#	if enemygroup.units[0].capture != null:
#		text += "\nEstimated level: " + str(enemygroup.units[0].capture.level)
#	else:
#		text += "\nEstimated level: " + str(max(1,enemygroup.units[0].level + round(rand_range(-1,1))))
#	text += '\nGroup: ' + enemygroup.units[0].faction
#	if enemygroup.captured != null && enemygroup.captured.size() >= 1:
#		text += "\n\nHave other persons involved. "
#	outside.get_node("textpanelexplore/enemyportrait").set_texture(enemygroup.units[0].icon)
#	outside.get_node("textpanelexplore/enemyinfo").set_bbcode(text)
#
#func enemyinfoclear():
#	outside.get_node("textpanelexplore/enemyportrait").set_texture(null)
#	outside.get_node("textpanelexplore/enemyinfo").set_bbcode('')
#
#func enemylevelup(person, levelarray):
#	var level = levelarray[randi()%levelarray.size()]
#	var statdict = ['sstr','sagi','smaf','send']
#	person.skillpoints = 0
#	person.level = 1
#	var skillpoints = 2+(level-1)*variables.skillpointsperlevel
#	while person.level < level:
#		person.level += 1
#		var points = variables.skillpointsperlevel
#		while points > 0 && statdict.size() > 0:
#			var tempstat = statdict[randi()%statdict.size()]
#			if person[tempstat] >= person.stats[globals.maxstatdict[tempstat]]:
#				statdict.erase(tempstat)
#				continue
#			person[tempstat] += 1
#			points -= 1
#
#func buildenemies(enemyname = null):
#	if enemyname == null:
#		var rand = max(rand_range(0,100)-scout.sagi*3,0)
#		enemygroup = str2var(var2str(enemygrouppools[globals.weightedrandom(currentzone.enemies)]))
#	else:
#		enemygroup = str2var(var2str(enemygrouppools[enemyname]))
#	var tempunits = str2var(var2str(enemygroup.units))
#	var unitcounter = {}
#	enemygroup.units = []
#	var addnumbers
#	for i in tempunits:
#		addnumbers = false
#		var count = round(rand_range(i[1], i[2]))
#		if deeperregion:
#			count = round(count * rand_range(1.2,1.6))
#		if count >= 2:
#			addnumbers = true
#		while count >= 1:
#			var newunit = str2var(var2str(enemypool[i[0]]))
#			if unitcounter.has(newunit.name) == false:
#				unitcounter[newunit.name] = 1
#			else:
#				unitcounter[newunit.name] += 1
#			if addnumbers:
#				newunit.name = newunit.name + " " + str(unitcounter[newunit.name])
#			enemygroup.units.append(newunit)
#			count -= 1



#func buildcaptureslaves():
#	for i in enemygroup.units:
#		if i.capture == true:
#			var race = ''
#			var sex = ''
#			var age = ''
#			var origins = ''
#			var rand = 0
#			if i.capturerace.find('area') >= 0:
#				race = globals.weightedrandom(currentzone.races)
#			elif i.capturerace.find('any') >= 0:
#				race = globals.allracesarray[rand_range(0,globals.allracesarray.size())]
#			elif i.capturerace.find('bandits') >= 0:
#				if rand_range(0,10) <= 7:
#					race = 'Human'
#				else:
#					race = globals.banditraces[rand_range(0,globals.banditraces.size())]
#			else:
#				rand = rand_range(0,100)
#				for ii in i.capturerace:
#					if rand < ii[1]:
#						race = ii[0]
#						break
#			race = globals.checkfurryrace(race)
#			if i.capturesex.find('any') >= 0:
#				sex = 'random'
#			else:
#				rand = rand_range(0,100)
#				for ii in i.capturesex:
#					if rand < ii[1]:
#						sex = ii[0]
#						break
#			age = globals.weightedrandom(i.captureagepool)
#			origins = globals.weightedrandom(i.captureoriginspool)
#			if deeperregion == true && globals.originsarray.find(origins) < 4 && rand_range(0,1) > 0.3:
#				origins = globals.originsarray[globals.originsarray.find(origins)+1]
#			var slavetemp = globals.newslave(race, age, sex, origins)
#			enemylevelup(slavetemp, currentzone.levelrange)
#			slavetemp.health = slavetemp.stats.health_max
#			enemygroup.units[counter].capture = slavetemp
#			var gear = {}
#			for k in ['armor','weapon','costume','underwear','accessory']:
#				if !combatdata.enemyequips[i.gear].has(k):
#					continue
#				gear[k] = globals.weightedrandom(combatdata.enemyequips[i.gear][k])
#				if gear[k] == 'nothing':
#					continue
#				var enchant = false
#				var item
#				if gear[k].find("+") >= 0:
#					enchant = true
#					gear[k] = gear[k].replace("+","")
#				item = globals.items.createunstackable(gear[k])
#				if enchant:
#					globals.items.enchantrand(item)
#				enemygear[item.id] = item
#				globals.items.equipitem(item.id, slavetemp, true)