extends Node

const category = 'fucking'
const code = 'inserttailv'
var givers
var takers
const canlast = true
const giverpart = 'tail'
const takerpart = 'vagina'
const virginloss = true
const giverconsent = 'advanced'
const takerconsent = 'any'
var type

func getname(state = null):
	for i in givers:
		if i.person.tail == 'tentacles':
			type = 'tentacle'
			return "Tentacle V Insert"
		else:
			type = 'tail'
			return "Insert Tail Pussy"

func getongoingname(givers, takers):
	return "[name1] fuck[s/1] [name2]'s pussy with [his1] "+type+"."

func getongoingdescription(givers, takers):
	var temparray = []
	temparray += ["[name1] thrust[s/1] [his1] "+type+" in and out of [names2] [pussy2]."]
	return temparray[randi()%temparray.size()]

func requirements():
	var valid = true
	if takers.size() < 1 || givers.size() < 1 || givers.size() + takers.size() > 3:
		valid = false
	else:
		for i in givers:
#			if i.tail != null || !globals.longtails.has(i.person.tail):
#				valid = false
			if !globals.longtails.has(i.person.tail):
				valid = false
		for i in takers:
#			if i.vagina != null || i.person.vagina == 'none':
#				valid = false
			if i.person.vagina == 'none':
				valid = false
	return valid

func givereffect(member):
	var result
	var increase
	var effects = {lust = 50, sens = 85*(member.person.senstail), lewd = 2, tags = ['pervert']}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lewd >= 30):
		result = 'good'
		increase = 1.25
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
		increase = 1
	else:
		result = 'bad'
		increase = 0.75
	member.person.sexexp.tail += 1
	member.tempsexexp.tail += 1
	member.person.sexexp.tailtech += 0.01*increase
	return [result, effects]

func takereffect(member):
	var result
	var givertech
	var increase
	for i in givers:
		givertech = i.person.sexexp.tailtech
	var effects = {lust = 80, sens = 110*(member.person.sensvagina+givertech/2), lewd = 2, tags = ['pervert']}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lewd >= 30):
		result = 'good'
		increase = 1.25
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
		increase = 1
	else:
		result = 'bad'
		increase = 0.75
	member.person.sexexp.vagina += 1
	member.tempsexexp.vagina += 1
	member.person.sensvagina += 0.01*increase
	return [result, effects]


func initiate():
	var temparray = []
	temparray += ["[name1] insert[s/1] [his1] thick "+type+" into [names2] [pussy2]. "]
	return temparray[randi()%temparray.size()]

func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[name2] lie[s/2] unconscious, {^trembling:twitching} {^slightly :}as [his2] [pussy2] {^respond:react}[s/#2] to {^the stimulation:[names1] "+type+"[/s1]}."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[name2] {^show:give}[s/2] little {^response:reaction} to {^the stimulation:[names1] efforts:[names1] "+type+"[/s1]}."
	elif member.sens < 400:
		text = "[name2] {^begin:start}[s/2] to {^respond:react} as [his2] [pussy2] get[s/#2] {^fucked:penetrated} by [names1] "+type+"[/s1]."
	elif member.sens < 800:
		text = "[name2] {^moans[s/2]:crie[s/2] out} in {^pleasure:arousal:extacy} as [his2] [pussy2] get[s/#2] {^fucked:penetrated} by [names1] "+type+"[/s1]."
	else:
		text = "[names2] body {^trembles:quivers} {^at the slightest movement of [names1] "+type+"[/s1] inside [his2] [pussy2]:in response to [names1] penetrating}{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm:}."
	return text