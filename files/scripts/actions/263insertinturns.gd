extends Node

const category = 'fucking'
const code = 'insertinturns'
var givers
var takers
const canlast = true
const giverpart = 'penis'
const takerpart = 'vagina'
const virginloss = true
const giverconsent = 'basic'
const takerconsent = 'any'

func requirements():
	var valid = true
	if takers.size() < 1 || givers.size() < 1:
		valid = false
	for i in givers:
		if i.person.penis == 'none' && i.strapon == null:
			valid = false
	for i in takers:
		if i.person.vagina == 'none':
			valid = false
	return valid

func getname(state = null):
	return "Fuck in turns"

func getongoingname(givers, takers):
	return "[name1] [fuck1] [name2] [pussy2] periodically taking turns and switching."

func getongoingdescription(givers, takers):
	var temparray = []
	temparray += ["[name1] continue {^passionately :eagerly :} [fucking1] [name2] in turns."]
	return temparray[randi()%temparray.size()]



func givereffect(member):
	var result
	var effects = {lust = 100, sens = 120, lewd = 2, tags = ['group']}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lust >= 200) && member.person.traits.has("Fickle"):
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
	var effects = {lust = 100, sens = 120, lewd = 3, tags = ['group']}
	if (member.consent == true || member.person.traits.find("Likes it rough") >= 0) && member.lust >= 400 && member.lube >= 3  && member.person.traits.has("Fickle"):
		result = 'good'
	elif (member.consent == true || member.person.traits.find("Likes it rough") >= 0):
		result = 'average'
	else:
		result = 'bad'
	if member.lube < 3:
		effects.pain = 2
	return [result, effects]

func initiate():
	var text = ''
	var temparray = []
	temparray += ["[name1] [fuck1] [name2] [pussy2] periodically taking turns and switching."]
	text += temparray[randi()%temparray.size()]
	temparray.clear()
	return text
