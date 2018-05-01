extends Node

const category = 'fucking'
const code = 'revlotusanal'
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
	if takers.size() != 1 || givers.size() != 1:
		valid = false
#	elif givers.size() + takers.size() == 2 && (!givers[0].penis in [takers[0].vagina, takers[0].anus] ):
#		valid = false
	for i in givers:
		if i.person.penis == 'none' && i.strapon == null:
			valid = false
#		elif i.penis != null && givers.size() > 1:
#			valid = false
#	for i in takers:
#		if i.anus != null && takers.size() > 1:
#			valid = false
	
	return valid

func getname(state = null):
	return "Lap Sitting Anal"

func getongoingname(givers, takers):
	return "[name1] fuck[s/1] [names2] ass[/es2] in the reverse lotus position."

func givereffect(member):
	var result
	var takertech
	var increase
	for i in takers:
		takertech = i.person.sexexp.analtech# how good they are as grasping/moving with their asshole
	var effects = {lust = 90, sens = 100*(member.person.senspenis+takertech/2), lewd = 3}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lust >= 200):
		result = 'good'
		increase = 1.25
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
		increase = 1
	else:
		result = 'bad'
		increase = 0.75
	if member.person.penis == 'none':	#
		effects.sens /= 1.2				#POSSIBLE RIGHT PLACEMENT
		effects.lust /= 1.2				#
	member.person.sexexp.penis += 1
	member.tempsexexp.penis += 1
	member.person.sexexp.penistech += 0.01*increase
	return [result, effects]

func takereffect(member):
	var result
	var givertech
	var increase
	for i in givers:
		givertech = i.person.sexexp.penistech# how good they are at stifening/ moving your member to weak points
	var effects = {lust = 80, sens = 110*(member.person.sensanal+givertech/2), lewd = 3}
	if (member.consent == true || member.person.traits.find("Likes it rough") >= 0) && member.lust >= 400 && member.lube >= 5:
		result = 'good'
		increase = 1.25
	elif (member.consent == true || member.person.traits.find("Likes it rough") >= 0):
		result = 'average'
		increase = 1
	else:
		result = 'bad'
		increase = 0.75
	if member.lube < 5:
		effects.pain = 3
#	if member.person.penis == 'none':
#		effects.sens /= 1.2
#		effects.lust /= 1.2
	member.person.sexexp.anal += 1
	member.tempsexexp.anal += 1
	member.person.sensanal += 0.01*increase
	return [result, effects]

#orientation of givers/takers
const rotation1 = Quat(0.0,0.0,0.0,0.0)
const rotation2 = Quat(0.0,0.0,0.0,1.0)

const initiate = ['start_1_revlotus','start_2_sexa']

const ongoing = ['main_1_sexa','main_2_sexa','main_3_sex']

const reaction = ['react_1_sex','react_2_sex','react_3_sexa']

const linkset = "sex"

const act_lines = {

start_2_sexa = {
	
	shift = {
	conditions = {
		orifice = ["shift"],
	},
	lines = [
		", {^enjoying:finding glee in} putting [partner2] in such an embarassing position. ",
	]},
	
},

main_3_sex = {
	
	locational = {
	conditions = {
	},
	lines = [
		". ",
		" from below. ",
	]},
	
},

react_3_sexa = {
	
	default = {
	conditions = {
	},
	lines = [
		" as [name1] make[s/1] a show of [him2].",
	]},
	
},

}