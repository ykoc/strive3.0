extends Node

const category = 'fucking'
const code = 'doubledildo'
var givers
var takers
const canlast = true
const giverpart = 'vagina'
const takerpart = 'vagina'
const virginloss = true
const giverconsent = 'advanced'
const takerconsent = 'advanced'

func getname(state = null):
	return "Double Dildo"

func getongoingname(givers, takers):
	return "[name1] and [name2] fuck each other with a double-ended dildo."

func getongoingdescription(givers, takers):
	return "[name1] and [name2] {^shake:grind:pump} [their] hips together, as the dildo trusts in and out of [their] [pussy3]."

func requirements():
	var valid = true
	if takers.size() != 1 || givers.size() != 1:
		valid = false
	else:
		for i in givers:
			if i.person.vagina == 'none' :
				valid = false
		for i in takers:
			if i.person.vagina == 'none' :
				valid = false
#			elif i.vagina != null:
#				valid = false
	return valid

func givereffect(member):
	var result
	var takertech
	var increase
	for i in takers:
		takertech = i.person.sexexp.vaginatech
	var effects = {lust = 80, sens = 110*(member.person.sensvagina+takertech/2), lewd = 4}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lust >= 400):
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
	member.person.sexexp.vaginatech += 0.01*increase
	return [result, effects]

func takereffect(member):
	var result
	var givertech
	var increase
	for i in givers:
		givertech = i.person.sexexp.vaginatech
	var effects = {lust = 80, sens = 110*(member.person.sensvagina+givertech/2), lewd = 4}
	member.lube()
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lust >= 400):
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
	member.person.sexexp.vaginatech += 0.01*increase
	return [result, effects]

func initiate():
	var text = ''
	text += "[name1] insert[s/1] a double dildo into [his1] and [names2] pussies, {^grinding:pumping:gyrating} [his1] hips against [partner2]."

	return text

func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[names2] [pussy2] {^trembles:twitches}, {^responding:reacting} to {^the stimulation:[names1] efforts:the dildo inside [him2]} even in [his2] unconcious state."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[names2] [pussy2] {^presents:gives} some resistance to {^the intrusion:[names1] efforts:the dildo inside [him2]}{^, still somewhat unprepared:, not yet fully prepared:}."
	elif member.sens < 300:
		text = "[names2] [pussy2] {^begins:starts} to {^respond:react} to the {^sensation:feeling} of {^the intrusion:[names1] dildo:the dildo inside [him2]}."
	elif member.sens < 600:
		text = "[names2] [pussy2] {^trembles:quivers} in {^response:reaction} to the {^sensation:feeling} of {^[names1] dildo:the dildo inside [him2]}, [his2] arousal {^made clear:apparent:clearly showing}."
	else:
		text = "[names2] [pussy2] {^violently trembles:clenches:quivers} {^with every movement of [names1] hips:in response to [names1] efforts}{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm:}."
	return text