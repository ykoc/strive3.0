extends Node

const category = 'fucking'
const code = 'insertinturnsass'
var givers
var takers
const canlast = true
const giverpart = 'penis'
const takerpart = 'anus'
const virginloss = true
const giverconsent = 'basic'
const takerconsent = 'any'

func requirements():
	var valid = true
	if takers.size() < 1 || givers.size() < 1:
		valid = false
	elif takers.size() < 2 && givers.size() < 2:
		valid = false
	for i in givers:
		if i.person.penis == 'none' && i.strapon == null:
			valid = false
	return valid

func getname(state = null):
	return "Fuck ass in turns"

func getongoingname(givers, takers):
	return "[name1] [fuck1] [names2] [anus2] periodically taking turns and switching."

func getongoingdescription(givers, takers):
	var temparray = []
	temparray += ["[name1] continue {^passionately :eagerly :} [fucking1] [names2] [anus2] in turns."]
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
	var effects = {lust = 100, sens = 110, lewd = 3, tags = ['group']}
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
	temparray += ["[name1] [fuck1] [names2] [anus2] periodically taking turns and switching."]
	text += temparray[randi()%temparray.size()]
	temparray.clear()
	return text
