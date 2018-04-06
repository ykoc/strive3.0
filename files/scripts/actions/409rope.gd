extends Node

const category = 'SM'
const code = 'rope'
var givers
var takers
const canlast = false
const giverpart = ''
const takerpart = 'acc4'#body extra to change some getname into restrained getname
const virginloss = false
const giverconsent = 'basic'
const takerconsent = 'any'

func getname(state = null):
	return "Rope"

func getongoingname(givers, takers):
	return "[name1] bind[s/1] [names2] body with a rope."

func getongoingdescription(givers, takers):
	return ""
	
func requirements():
	var valid = true
#	for i in takers:
#		if i.acc4 != null:
#			valid = false
	if takers.size() < 1 || givers.size() < 1:
		valid = false
	elif givers.size() > 2:
		valid = false
	return valid

func givereffect(member):
	var result
	var effects = {lust = 0}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lewd >= 10):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	return [result, effects]

func takereffect(member):
	var result
	var effects = {lust = 0}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lewd >= 10):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	if member.person.sex == 'male':
		effects.sens /= 1.3
	return [result, effects]

func initiate():
	var text = ''
	var temparray = []
	temparray += ["[name1] {^place:stick}[s/1] a rope around [names2] body to enable restricted type of actions."]
#	temparray += ["[name1] latch[es/1] onto [names2] nipples"]
	text += temparray[randi()%temparray.size()]
	temparray.clear()
	return text

func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[name2] lie[s/2] unconscious, with her body still tied down."
	#elif member.consent == false:
		#TBD
# probably fear used here as in fear to be abuse and been unable to move to avoid the abose
#	elif member.sens < 100:
#		text = "[name2] {^show:give}[s/2] little {^response:reaction} to [his2] nipples being {^stimulated:teased:sucked on:suckled}."
#	elif member.sens < 400:
#		text = "[name2] {^begin:start}[s/2] to {^respond:react} as [his2] nipples are {^stimulated:teased:sucked on:suckled}."
#	elif member.sens < 800:
#		text = "[name2] {^moans[s/2]:crie[s/2] out} in {^pleasure:arousal:extacy} as [his2] nipples are {^stimulated:teased:sucked on:suckled}."
#	else:
#		text = "[names2] body {^trembles:quivers} {^at the slightest movement of [names1] tongue[/s1]:in response to [names1] suckling}{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm:}."
	return text
