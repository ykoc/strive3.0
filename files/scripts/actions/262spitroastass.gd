extends Node

const category = 'fucking'
const code = 'spitroastass'
var givers
var takers
const canlast = true
const giverpart = 'penis'
const takerpart = 'anus'
const takerpart2 = 'mouth'
const virginloss = true
const giverconsent = 'basic'
const takerconsent = 'any'

func requirements():
	var valid = true
	if takers.size() != 1 || givers.size() != 2:
		valid = false
	for i in givers:
		if i.person.penis == 'none' && i.strapon == null:
			valid = false
	
	return valid

func getname(state = null):
	return "Spit-roast Anal"

func getongoingname(givers, takers):
	return "[name1] spit-roast[s/1] [name2]'s [anus2] and mouth."

func getongoingdescription(givers, takers):
	var temparray = []
	temparray += ["[name1] continue {^passionately :eagerly :}spit-roasting [name2]."]
	return temparray[randi()%temparray.size()]



func givereffect(member):
	var result
	var effects = {lust = 100, sens = 120, lewd = 2, tags = ['group']}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lust >= 300) && member.person.traits.has("Fickle"):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	if member.person.penis == 'none':
		effects.sens /= 1.2
		effects.lust /= 1.2
	return [result, effects]

func takereffect(member):
	var result
	var effects = {lust = 100, sens = 120, lewd = 2, tags = ['group']}
	if (member.consent == true || member.person.traits.find("Likes it rough") >= 0) && member.lust >= 400 && member.lube >= 5 && member.person.traits.has("Fickle"):
		result = 'good'
	elif (member.consent == true || member.person.traits.find("Likes it rough") >= 0):
		result = 'average'
	else:
		result = 'bad'
	if member.lube < 5:
		effects.pain = 4
	return [result, effects]

func initiate():
	var text = ''
	var temparray = []
	temparray += ["[name1] {^passionately :eagerly :}[fuck1] [names2]'s [anus2] and mouth. "]
	text += temparray[randi()%temparray.size()]
	temparray.clear()
	return text
