extends Node

const category = 'caress'
const code = 'handjob'
var givers
var takers
const canlast = true
const giverpart = ''
const takerpart = 'penis'
const virginloss = false
const giverconsent = 'basic'
const takerconsent = 'any'

func getname(state = null):
	if givers.size() + takers.size() == 2:
		return "Handjob"
	else:
		return "Smlt. Handjob"

func getongoingname(givers, takers):
	return "[name1] give[s/1] [a /1]handjob[/s1] to [name2]."

func getongoingdescription(givers, takers):
	var temparray = []
	temparray += ["[name1] {^steadily :rhythmically :carefully :}{^massage:stroke:rub:jerk}[s/1] [names2] [penis2]{^, trying to maintain eye contact:, studying [his2] reactions:}."]
	temparray += ["[name1] {^massage:work:stroke:rub}[s/1] {^up and down the length of:all along:the shaft[/s2] of} [names2] [penis2] with [his1] hands."]
	return temparray[randi()%temparray.size()]

func requirements():
	var valid = true
	if takers.size() < 1 || givers.size() < 1:
		valid = false
	else:
		for i in takers:
#			if i.penis != null || i.person.penis == 'none':
#				valid = false
			if i.person.penis == 'none':
				valid = false
	return valid

func givereffect(member):
	var result
	var increase
	var effects = {lust = 50, lewd = 1}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lust >= 150):
		result = 'good'
		increase = 1.25
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
		increase = 1
	else:
		result = 'bad'
		increase = 0.75
	member.person.sexexp.fingers += 1
	member.tempsexexp.fingers += 1
	member.person.sexexp.fingerstech += 0.01*increase
	return [result, effects]

func takereffect(member):
	var result
	var givertech
	var increase
	for i in givers:
		givertech = i.person.sexexp.fingerstech
	var effects = {lust = 75, sens = 120*(member.person.senspenis+givertech/2), lewd =1}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0):
		result = 'good'
		increase = 1.25
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
		increase = 1
	else:
		result = 'bad'
		increase = 0.75
	member.person.sexexp.penis += 1
	member.tempsexexp.penis += 1
	member.person.senspenis += 0.01*increase
	return [result, effects]


func initiate():
	var temparray = []
	temparray += ["[name1] {^grip:grab:seize}[s/1] [names2] [penis2] and {^massage:stroke:rub:jerk}[s/1] [it2] with {^inensity:intense focus:fervor:passion}."]
	temparray += ["[name1] {^tease[s/1]:brush[es/1] against} the {^tip:shaft:base}[/s2] of [names2] [penis2] with [his1] fingertips as [he1] {^service:stroke:milk:attend}[s/1] [it2] with [his1] hands."]
	return temparray[randi()%temparray.size()]

func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[name2] lie[s/2] unconscious, {^trembling:twitching} {^slightly :}as [his2] [penis2] {^respond:react}[s/#2] to {^the stimulation:[names1] touch}."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[name2] {^show:give}[s/2] little {^response:reaction} to {^the stimulation:[names1] fingers:[names1] touch}."
	elif member.sens < 400:
		text = "[name2] {^begin:start}[s/2] to {^respond:react} as [his2] [penis2] get[s/#2] {^jerked:stroked}."
	elif member.sens < 800:
		text = "[name2] {^moans[s/2]:crie[s/2] out} in {^pleasure:arousal:extacy} as [his2] [penis2] get[s/#2] {^jerked:stroked}."
	else:
		text = "[names2] body {^trembles:quivers} {^at the slightest movement of [names1] fingers against [his2] [penis2]:in response to [names1] jerking}{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm:}."
	return text