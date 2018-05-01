extends Node

const category = 'fucking'
const code = 'lotus'
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
	if takers.size() != 1 || givers.size() != 1:
		valid = false
#	elif givers.size() + takers.size() == 2 && (!givers[0].penis in [takers[0].vagina, takers[0].anus] ):
#		valid = false
	for i in givers:
		if i.person.penis == 'none' && i.strapon == null:
			valid = false
#		elif i.penis != null && givers.size() > 1:
#			valid = false
	for i in takers:
		if i.person.vagina == 'none':
			valid = false
#		elif i.vagina != null && takers.size() > 1:
#			valid = false
	
	return valid

func getname(state = null):
	return "Lotus"

func getongoingname(givers, takers):
	return "[name1] fuck[s/1] [name2] in the lotus position."

func givereffect(member):
	var result
	var takertech
	var increase
	for i in takers:
		takertech = i.person.sexexp.vaginatech
	var effects = {lust = 100, sens = 100*(member.person.senspenis+takertech/2), lewd = 1}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lust >= 200):
		result = 'good'
		increase = 1.25
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
		increase = 1
	else:
		result = 'bad'
		increase = 0.75
	if member.person.penis == 'none':
		effects.sens /= 1.2
		effects.lust /= 1.2
	member.person.sexexp.penis += 1
	member.tempsexexp.penis += 1
	member.person.sexexp.penistech += 0.01*increase
	return [result, effects]

func takereffect(member):
	var result
	var givertech
	var increase
	for i in givers:
		givertech = i.person.sexexp.penistech
	var effects = {lust = 100, sens = 100*(member.person.sensvagina+givertech/2), lewd = 1}
	if (member.consent == true || member.person.traits.find("Likes it rough") >= 0) && member.lust >= 200 && member.lube >= 3:
		result = 'good'
		increase = 1.25
	elif (member.consent == true || member.person.traits.find("Likes it rough") >= 0):
		result = 'average'
		increase = 1
	else:
		result = 'bad'
		increase = 0.75
	if member.lube < 3:
		effects.pain = 3
	member.person.sexexp.vagina += 1
	member.tempsexexp.vagina += 1
	member.person.sensvagina += 0.01*increase
	return [result, effects]

#orientation of givers/takers
const rotation1 = Quat(0.0,0.0,0.0,0.0)
const rotation2 = Quat(0.0,0.0,0.0,0.0)

const initiate = ['start_1_lotus','start_2_sexv']

const ongoing = ['main_1_sexv','main_2_sexv','main_3_sex']

const reaction = ['react_1_sex','react_2_sex','react_3_sexv']

const linkset = "sex"

const act_lines = {

start_2_sexv = {
	
	shift = {
	conditions = {
		orifice = ["shift"],
	},
	lines = [
		", {^enjoying:relishing in} the closeness of [partners2] [body2]. ",
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

react_3_sexv = {
	
	default = {
	conditions = {
	},
	lines = [
		" as [his3] [body3] entwine.",
	]},
	
},

}