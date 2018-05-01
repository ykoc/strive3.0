extends Node

const category = 'fucking'
const code = 'crevix'
var givers
var takers
var participants
const canlast = true
const giverpart = 'penis'
const takerpart = 'crevix'
const virginloss = false
const giverconsent = 'basic'
const takerconsent = 'any'

func requirements():
	var valid = true
	if takers.size() != 1 || givers.size() != 1:
		valid = false
#	elif givers.size() + takers.size() == 2 && (!givers[0].penis in [takers[0].vagina, takers[0].anus] ):
#		valid = false
	for i in givers:
		if i.person.penis == 'none' && i.strapon == null:
			valid = false
		elif i.person.penis != 'big':
#		elif i.penis != null && givers.size() > 1:
			valid = false
	for i in takers:
		if i.person.vagina == 'none':
			valid = false
		elif i.vagina != null || i.crevix != null:
			valid = true
		else:
			valid = false
#		elif i.vagina != null && takers.size() == 1:
#			valid = false
	
	return valid

func getname(state = null):
	for i in givers:
		if i.sens >= 900:#as tryout but need to annd a check in dangerous days
			return "insemination"
		else:
			return "Crevix tease"

func getongoingname(givers, takers):
	return "[name1] fuck[s/1] [name2] womb."
	
func getongoingdescription(givers, takers):
	return "[name2] {^shake} [his2] waist as the vibrator stimulates [his2] pussy."
#	return ""

func givereffect(member):
	var result
	var effects = {lust = 100, sens = 100, lewd = 1}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lewd >= 30):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	if member.person.penis == 'none':
		effects.sens /= 1.2
		effects.lust /= 1.2
	member.person.sexexp.penis += 1
	return [result, effects]

func takereffect(member):
	var result
	var effects = {lust = 100*(member.person.sensclit+member.person.sexexp.fingerstech-1), sens = 100*(member.person.sensclit+member.person.sexexp.fingerstech-1), lewd = 1}
	if (member.consent == true || member.person.traits.find("Likes it rough") >= 0) && member.lewd >= 30 && member.lube >= 3:
		result = 'good'
	elif (member.consent == true || member.person.traits.find("Likes it rough") >= 0):
		result = 'average'
	else:
		result = 'bad'
	if member.lube < 3:
		effects.pain = 3
	member.person.sexexp.crevix += 1
	member.person.sexexp.vagina += 1
	return [result, effects]

func initiate():
	var text = ''
	var temparray = []
	temparray += ["[name1] {^push:place:shove:stick}[s/1] [his1] [penis1] into [names2] {^crevix:womb:uterus}"]
#	temparray += ["[name1] latch[es/1] onto [names2] nipples"]
	text += temparray[randi()%temparray.size()]
	temparray.clear()
	temparray += [", {^stimulating:teasing} it."]
#	temparray += [", {^lightly:gently} {^nibbling at:stimulating} them with [his1] teeth."]
#	temparray += [", {^greedily slurping at them:nursing} like [a /1]bab[y/ies1]."]
	text += temparray[randi()%temparray.size()]
	return text

func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[name2] lie[s/2] unconscious, {^trembling:twitching} {^slightly :}as [his2] {^crevix:womb:uterus} still {^respond:react} to {^the stimulation:teasing} of [name1] {^pounding:hammering}."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[name2] {^show:give}[s/2] little {^response:reaction} to [his2] {^crevix:womb:uterus} being {^stimulated:teased:used}."
	elif member.sens < 400:
		text = "[name2] {^begin:start}[s/2] to {^respond:react} at the {^stimulation:tease:use} of [his2] {^crevix:womb:uterus}."
	elif member.sens < 800:
		text = "[name2] {^moans[s/2]:crie[s/2] out} in {^pleasure:arousal:extacy} at [his2] {^crevix:womb:uterus} been {^stimulated:teased:used}."
	else:
		text = "[names2] body {^trembles:quivers} {^at the slightest movement of [name1]:in response to the movement}{^as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm}."
	return text