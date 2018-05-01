extends Node

var person
var showmode = 'default'

#func getslavedescription(tempperson, mode = 'default'):
#	showmode = mode
#	person = tempperson
#	var text = basics() + features() + genitals() + mods() + tattoo() + piercing()
#	text = person.dictionary(text)
#	if text.find('[furcolor]'):
#		text = text.replace('[furcolor]', getdescription('furcolor'))
#	
#	
#	return text
#------------------------------------------------	
func getslavedescription(tempperson, mode = 'default'):
	showmode = mode
	person = tempperson
	var text = ''
	text = basetab()
	text = person.dictionary(text)
	if text.find('[furcolor]'):
		text = text.replace('[furcolor]', getdescription('furcolor'))
	
	return text
	
func getslavedescriptionex(tempperson, mode = 'default'):
	showmode = mode
	person = tempperson
	var text = ''
	if showmode == 'bstats':
		text = thissession()
	return text
#------------------------------------------------

#-----------------Base-Tab-------------------	
func basetab():
	var text = ''
	var temptext = ''
	if globals.state.descriptsettings.general == true:
		text += "General description"
		text += " / "
		text += "[url=general][color=#d1b970]Switch to body information[/color][/url] "
		temptext = basics() + features() + genitals() + mods() + tattoo() + piercing()
	elif globals.state.descriptsettings.general == false:
		text += "Body information"
		text += " / "
		text += "[url=general][color=#d1b970]Switch to general description[/color][/url]  "
		temptext = bstates()
	text += temptext
	return text	
#------------------------------------------------	

func basics():
	var text = ''
#-----------------Basic------------------------
#	if showmode == 'default':
	text += "\n"
	text += "\n"
	if showmode != 'compact':
		text += "[url=basic][color=#d1b970]Basics:[/color][/url] "
#----------------------------------------------
	if globals.state.descriptsettings.basic == true || showmode != 'default':
		text += entry() + race() + getdescription('bodyshape') + getdescription('age') + getbeauty()
	else:
		text += "[color=yellow]$name, [url=race]" + person.race + "[/url], " + person.age.capitalize() +'[/color]. '
	return text
	
#-----------------bstates----------------------	
func bstates():
	var text = '\n'
	#if showmode == 'default':
	text = "\n" + text
	if globals.state.descriptsettings.bodystates == true || showmode != 'default':
		text += experiences()
	else:
		text += "Omitted. "
	return text
#----------------------------------------------

#-----------------Experience----------------------
func experiences():
	var text = ''
	text += '[url=mouth][color=#d1b970][Mouth][/color][/url] '
	if globals.state.descriptsettings.mouth == true:
	# need to add kissing times ???
		var linetechoral = ''
		var linetechoraltemp = ''
		if person.sexexp.oral > 0:
			text += "\n"+"$he used $his mouth "+str(floor(person.sexexp.oral))+" times"
			linetechoraltemp = 'and '
			if person.sexexp.swallow > 0:# should spit if not enough experience but should swallow 1/4 of total original ammount
				text += " and swallowed "+str(floor(person.sexexp.swallowamount))+" ml of cum"
				var temptext = ''
				if person.sexexp.swallow >= 50 && person.sexexp.swallowamount >= 500:
					#text += "Loves swalowing cum so much $he cant live without it"#K
					temptext += "$his body aches from the taste of cum"#TW
				elif person.sexexp.swallow >= 40 && person.sexexp.swallowamount >= 400:
			#		text += "Loves the tase of cum and starts to become adicted to it"
					temptext += "$he can drink cum without any difficulty"#TW
				elif person.sexexp.swallow >= 20 && person.sexexp.swallowamount >= 200:
					temptext += "$he is not against swallowing the cum"
				elif person.sexexp.swallow >= 10 && person.sexexp.swallowamount >= 100:
					temptext += "$he cannot swallow all the cum just yet"
				if temptext != '':
					text += "\n" + temptext
		else:
			text += "$he never used $his mouth for anything sexual"
		if person.sexexp.oraltech >= 2:
			linetechoral += "could make anyone cum using $his mouth or tongue"
		elif person.sexexp.oraltech >= 1.5:
			linetechoral += "skilled enough to make others orgasms rapidly"
		elif person.sexexp.oraltech >= 1.25:
			linetechoral += "intermediary mouth sill expertise"
		elif person.sexexp.oraltech >= 1:
			linetechoral += "basic mouth skill knowledge"
		if linetechoral != '':
			text += "\n" + linetechoraltemp + linetechoral
	else:
		text += "Omitted. "
	text += "\n"
	text += "\n"
	text += '[url=breasts][color=#d1b970][Breasts][/color][/url] '
	if globals.state.descriptsettings.breasts == true:
		var linesensebreast = ''
		var linesensebreasttemp = ''
		if person.sexexp.breast > 0:
			text += "\n"+"$his breasts where used "+str(floor(person.sexexp.breast))+" times"
			linesensebreasttemp = 'and '
			if person.sexexp.milked > 0:
				text += "\n"
				text += "and where milked "+str(floor(person.sexexp.milked))+" times"
				if person.sexexp.milkedamount > 0:
					text += " for "+str(floor(person.sexexp.milkedamount))+" ml of milk"
					var temptext = ''
					if person.sexexp.milkedamount >= 500:
						temptext += "$his got turned into a milk cow producing large amounts of milk"
					elif person.sexexp.milkedamount >= 400:
						temptext += "$he can produce a decent amount of milk"
					elif person.sexexp.milkedamount >= 200:
						temptext += "$he starts to get used to have her milk extracted"
					elif person.sexexp.milkedamount >= 100:
						temptext += "$he is not used to have her milk extracted"
					if temptext != '':
						text += "\n" + temptext
		if person.sensbreast >= 1.5:
			linesensebreast += "are so sensitive they could orgasm from a light touch to $her erected nipples"
		elif person.sensbreast >= 1.25:
			linesensebreast += "now sensitive enough to make $his nipples constantly erected"
		elif person.sensbreast >= 1:
			linesensebreast += "have a normal sensitivity"
		elif person.sensbreast >= -1:
			linesensebreast += "are somehow insensitive"
		if linesensebreast != '':
			text += "\n" + linesensebreasttemp + linesensebreast
	else:
		text += "Omitted. "
	text += "\n"
	text += "\n"
	text += '[url=fingers][color=#d1b970][Fingers][/color][/url] '
	if globals.state.descriptsettings.fingers == true:
		var linetechfingers = ''
		var linetechfingerstemp = ''
		if person.sexexp.fingers > 0:
			text += "\n"+"used $his fingers "+str(floor(person.sexexp.fingers))+" times"
			linetechfingerstemp = 'and '
			if person.sexexp.fingersamount > 0:
				text += " and made other orgasms "+str(floor(person.sexexp.fingersamount))+" times"
		if person.sexexp.fingerstech >= 2:
			linetechfingers += "became lethal weapons"
		elif person.sexexp.fingerstech >= 1.5:
			linetechfingers += "dextrous enough to make others orgasms rapidly"
		elif person.sexexp.fingerstech >= 1.25:
			linetechfingers += "of avrage dexterity"
		elif person.sexexp.fingerstech >= 1:
			linetechfingers += "of common dexterity"
		if linetechfingers != '':
			text += "\n" + linetechfingerstemp + linetechfingers
	else:
		text += "Omitted. "
	if person.sex != 'male':
		text += "\n"
		text += "\n"
		text += '[url=vagina][color=#d1b970][Vagina][/color][/url] '
		if globals.state.descriptsettings.vagina == true:
			var linetight = ''
			var linesense = ''
			var linetechvagina = ''
			if person.sexexp.vagina > 0:
				text += "\n"+"$his vagina was used "+str(floor(person.sexexp.vagina))+" times"
				if person.sexexp.vagina >= 15:
				#	linetight += "$his gaping vagina can acomodate anything"
					linetight += "$his vagina is now perfectly developed\n"
					linetight += "and ompletely changed its form and shape to squirm and wriggle around your penis"
				elif person.sexexp.vagina >= 10:
					linetight += "$his vagina is now nicely developed\n"
					linetight += "due to all the attention, it became a fine hole"
				elif person.sexexp.vagina >= 5:
					linetight += "$his tight vagina starts to losen a bit"
				else:
					linetight += "$his vagina is shut tight"
				if person.sexexp.creampie > 0:
					text += " and stuffed with "+str(floor(person.sexexp.creampieamount))+" ml of cum"
					var temptext = ''
					if person.sexexp.creampie > 50 && person.sexexp.creampieamount > 500:
						temptext += "and feels euphoric from creampies."#TW
					elif person.sexexp.creampie > 40 && person.sexexp.creampieamount > 400:
						temptext += "and it throbs and aches from creampies."#TW
					elif person.sexexp.creampie > 1 && person.sexexp.creampieamount > 30:
						temptext += "and is starting to get used to the feeling of semen inside"
					elif person.sexexp.creampie > 0 && person.sexexp.creampieamount > 0:
						temptext += "and feels discomfort as it is not used having semen inside"
					if temptext != '':
						text += "\n" + temptext
			else:
				text += "$he never used $his vagina for anything sexual"
				linetight += "$his vagina is shut tight"
			text += "\n" + linetight
			if person.sensvagina >= 1.5:
				linesense += "and is so sensitive it constantly drools and aches to be filled"
			elif person.sensvagina >= 1.25:
				linesense += "and is very sensitive and could orgasm from a light touch"
			elif person.sensvagina >= 1:
				linesense += "and has a normal sensitivity"
			elif person.sensvagina >= -1:
				linesense += "and is somehow insensitive"
			text += "\n" + linesense
			if person.sexexp.vaginatech >= 2:
				linetechvagina += "could make anyone cum using $his lewd vagina"
			elif person.sexexp.vaginatech >= 1.5:
				linetechvagina += "is skilled enough to make others orgasms rapidly"
			elif person.sexexp.vaginatech >= 1.25:
				linetechvagina += "has intermediary vaginal sill expertise"
			elif person.sexexp.vaginatech >= 1:
				linetechvagina += "has basic vaginal skill knowledge"
			if linetechvagina != '':
				text += "\n" + linetechvagina
		else:
			text += "Omitted. "
		if person.sexexp.crevix > 0:
			text += "\n"
			text += "\n"
			text += '[url=crevix][color=#d1b970][Crevix][/color][/url] '
			if globals.state.descriptsettings.crevix == true:
				var linesensecrevix = ''
				var linetightcrevix = ''
				var linetechcrevix = ''
				text += "\n"+"$his crevix was inserted "+str(floor(person.sexexp.crevix))+" times"
				if person.sexexp.crevix >= 15:
				#	linetight += "$his gaping vagina can acomodate anything"
					linetightcrevix += "$his crevix is now perfectly developed\n"
					linetightcrevix += "and ompletely changed its form and shape to squirm and wriggle around your penis"
				elif person.sexexp.crevix >= 10:
					linetightcrevix += "$his crevix is now nicely developed\n"
					linetightcrevix += "due to all the attention, it became a fine impregnation hole"
				elif person.sexexp.crevix >= 5:
					linetightcrevix += "$his tight crevix starts to losen a bit"
				else:
					linetightcrevix += "$his crevix is very tight"
				if person.sexexp.crevixpie > 0:
					text += " and stuffed with "+str(floor(person.sexexp.crevixamount))+" ml of cum"
					var temptext = ''
					if person.sexexp.crevixpie > 50 && person.sexexp.crevixamount > 500:
						temptext += "and feels euphoric from been inserted and creampied."#TW
					elif person.sexexp.crevixpie > 40 && person.sexexp.crevixamount > 400:
						temptext += "and is now flexible enough to throbs and aches from creampies."#TW
					elif person.sexexp.crevixpie > 1 && person.sexexp.crevixamount > 30:
						temptext += "and is starting to relax a bit getting used to the feeling of semen inside"
					elif person.sexexp.crevixpie > 0 && person.sexexp.crevixamount > 0:
						temptext += "and hurts as its not used to be inserted and filled"
					if temptext != '':
						text += "\n" + temptext
				text += "\n" + linetightcrevix
				if person.senscrevix >= 1.5:
					linesensecrevix += "and is so sensitive it constantly drools and aches to be filled"
				elif person.senscrevix >= 1.25:
					linesensecrevix += "and is very sensitive and could orgasm from a light touch"
				elif person.senscrevix >= 1:
					linesensecrevix += "and has a normal sensitivity"
				elif person.senscrevix >= -1:
					linesensecrevix += "and is somehow insensitive"
				text += "\n" + linesensecrevix
				if person.sexexp.crevixtech >= 2:
					linetechcrevix += "could make anyone cum using $his lewd crevix"
				elif person.sexexp.crevixtech >= 1.5:
					linetechcrevix += "is skilled enough to make others orgasms rapidly"
				elif person.sexexp.crevixtech >= 1.25:
					linetechcrevix += "has intermediary crevix sill expertise"
				elif person.sexexp.crevixtech >= 1:
					linetechcrevix += "has basic crevix skill knowledge"
				if linetechcrevix != '':
					text += "\n" + linetechcrevix
			else:
				text += "Omitted. "
		text += "\n"
		text += "\n"
		text += '[url=clitoris][color=#d1b970][Clitoris][/color][/url] '
		if globals.state.descriptsettings.clitoris == true:
			var linesenseclit = ''
			var linesenseclittemp = ''
			if person.sexexp.clit > 0:
				text += "\n"+"$his clit was used "+str(floor(person.sexexp.clit))+" times"
				linesenseclittemp = 'and '
				if person.sexexp.clitamount > 0:
					text += " and relased "+str(floor(person.sexexp.clitamount))+" ml of nectar"
			if person.sensclit >= 1.5:
				linesenseclit += "is so sensitive it could orgasm from a light touch to $her erected clit"
			elif person.sensclit >= 1.25:
				linesenseclit += "now sensitive enough to make $his clitoris constantly erected"
			elif person.sensclit >= 1:
				linesenseclit += "has a normal sensitivity"
			elif person.sensclit >= -1:
				linesenseclit += "is somehow insensitive"
			if linesenseclit != '':
				text += "\n" + linesenseclittemp + linesenseclit
		else:
			text += "Omitted. "
	if person.sex != 'female':
		text += "\n"
		text += "\n"
		text += '[url=penis][color=#d1b970][Penis][/color][/url] '
		if globals.state.descriptsettings.penis == true:
			var linesensepenis = ''
			var linesensepenistemp = ''
			var linetechpenis = ''
			if person.sexexp.penis > 0:
				text += "\n"+"$his penis was used "+str(floor(person.sexexp.penis))+" times"
				linesensepenistemp = 'and '
				if person.sexexp.penisamount > 0:
					text += " and relased "+str(floor(person.sexexp.penisamount))+" ml of cum"
			else:
				text += "$he never used $his penis for anything sexual"
			if person.senspenis >= 1.5:
				linesensepenis += "is so sensitive it is constantly erected and could orgasm from a light touch"
			elif person.senspenis >= 1.25:
				linesensepenis += "is very sensitive and could orgasm from a light touch"
			elif person.senspenis >= 1:
				linesensepenis += "has a normal sensitivity"
			elif person.senspenis >= -1:
				linesensepenis += "is somehow insensitive"
			text += "\n" + linesensepenistemp + linesensepenis
			if person.sexexp.penistech >= 2:
				linetechpenis += "could make anyone cum using $his horny penis"
			elif person.sexexp.penistech >= 1.5:
				linetechpenis += "is skilled enough to make others orgasms rapidly"
			elif person.sexexp.penistech >= 1.25:
				linetechpenis += "has intermediary penis sill expertise"
			elif person.sexexp.penistech >= 1:
				linetechpenis += "has basic penis skill knowledge"
			if linetechpenis != '':
				text += "\n" + linetechpenis
		else:
			text += "Omitted. "
	if person.tail != 'none':
		text += "\n"
		text += "\n"
		text += '[url=tail][color=#d1b970][Tail][/color][/url] '
		if globals.state.descriptsettings.tail == true:
			var linesensetail = ''
			var linexptail = ''
			var linesensetailtemp = ''
			if person.sexexp.tail > 0:
				text += "\n"+"used $his tail "+str(floor(person.sexexp.tail))+" times"
				linesensetailtemp = 'and '
				if person.sexexp.tailamount > 0:
					text += " and made other orgasms "+str(floor(person.sexexp.tailamount))+" times"
			if person.sexexp.tailtech >= 2:
				linexptail += "became a third hand"
			elif person.sexexp.tailtech >= 1.5:
				linexptail += "dextrous enough to make others orgasms rapidly"
			elif person.sexexp.tailtech >= 1.25:
				linexptail += "of avrage dexterity"
			elif person.sexexp.tailtech >= 1:
				linexptail += "of common dexterity"
			if person.senstail >= 1.5:
				linesensetail += "is so sensitive it is constantly erected and could orgasm from a light touch"
			elif person.senstail >= 1.25:
				linesensetail += "is very sensitive and could orgasm from a light touch"
			elif person.senstail >= 1:
				linesensetail += "has a normal sensitivity"
			elif person.senstail >= -1:
				linesensetail += "is somehow insensitive"
			if linesensetail != '':
				text += "\n" + linesensetailtemp + linesensetail
			if linexptail != '':
				text += "\n" + linesensetailtemp + linexptail
		else:
			text += "Omitted. "
	text += "\n"
	text += "\n"
	text += '[url=anus][color=#d1b970][Anus][/color][/url] '
	if globals.state.descriptsettings.anus == true:
		var linetightanal = ''
		var linesenseanal = ''
		var linetechanus = ''
		if person.sexexp.anal > 0:
			text += "\n"+"$his anus was used "+str(floor(person.sexexp.anal))+" times"
			if person.sexexp.anal >= 15:
			#	linetightanal += "$his gaping anus can acomodate anything"
				linetightanal += "$his anus is now perfectly developed\n"
				linetightanal += "and ompletely changed its form and shape to squirm and wriggle around your penis"
			elif person.sexexp.anal >= 10:
				linetightanal += "$his anus is now nicely developed\n"
				linetightanal += "due to all the attention, it became a fine hole"
			elif person.sexexp.anal >= 5:
				linetightanal += "$his tight anus starts to losen a bit"
			else:
				linetightanal += "$his anus is shut tight"
			if person.sexexp.analcreampie > 0:
				text += " and stuffed with "+str(floor(person.sexexp.analcreampieamount))+" ml of cum"
				var temptext = ''
				if person.sexexp.analcreampie > 50 && person.sexexp.analcreampieamount > 500:
					temptext += "feels euphoric from creampies."#TW
				elif person.sexexp.analcreampie > 40 && person.sexexp.analcreampieamount > 400:
					temptext += "it throbs and aches from creampies."#TW
				elif person.sexexp.analcreampie > 1 && person.sexexp.analcreampieamount > 30:
					temptext += "starting to get used to the feeling of something inside"
				elif person.sexexp.analcreampie > 0 && person.sexexp.analcreampieamount > 0:
					temptext += "feels discomfort as it is not used having something inside"
				if temptext != '':
					text += "\n" + temptext
		else:
			text += "$he never used $his anus for anything sexual"
			linetightanal += "$his anus is shut tight"
		text += "\n" + linetightanal
		if person.sensanal >= 1.5:
			linesenseanal += "and is so sensitive it constantly aches to be filled"
		elif person.sensanal >= 1.25:
			linesenseanal += "and is very sensitive and could orgasm from a light touch"
		elif person.sensanal >= 1:
			linesenseanal += "and has a normal sensitivity"
		elif person.sensanal >= -1:
			linesenseanal += "and is somehow insensitive"
		text += "\n" + linesenseanal
		if person.sexexp.analtech >= 2:
			linetechanus += "could make anyone cum using $his horny anal"
		elif person.sexexp.analtech >= 1.5:
			linetechanus += "is skilled enough to make others orgasms rapidly"
		elif person.sexexp.analtech >= 1.25:
			linetechanus += "has intermediary anal sill expertise"
		elif person.sexexp.analtech >= 1:
			linetechanus += "has basic anal skill knowledge"
		if linetechanus != '':
			text += "\n" + linetechanus
	else:
		text += "Omitted. "
	text += "\n"
	text += "\n"
	text += '[url=tail][color=#d1b970][Feets][/color][/url] '
	if globals.state.descriptsettings.feets == true:
		var linexpfeets = ''
		var linesensefeetstemp = ''
		if person.sexexp.feets > 0:
			text += "\n"+"used $his feets "+str(floor(person.sexexp.feets))+" times"
			linesensefeetstemp = 'and '
			if person.sexexp.feetsamount > 0:
				text += " and made other orgasms "+str(floor(person.sexexp.feetsamount))+" times"
		if person.sexexp.feetstech >= 2:
			linexpfeets += "became a third hand"
		elif person.sexexp.feetstech >= 1.5:
			linexpfeets += "dextrous enough to make others orgasms rapidly"
		elif person.sexexp.feetstech >= 1.25:
			linexpfeets += "of avrage dexterity"
		elif person.sexexp.feetstech >= 1:
			linexpfeets += "of common dexterity"
		if linexpfeets != '':
			text += "\n" + linesensefeetstemp + linexpfeets
	else:
		text += "Omitted. "
	if showmode == 'default':
		text += "\n"
		text += "\n"
		text += "orgasmed "+str(floor(person.sexexp.orgasms))+" times"
	#	text += " might turn pregnant on day "+str(floor(person.sexexp.impregnationcycle))
	return text
#------------------------------------------------

func features():
	var text = '\n'
	if showmode == 'default':
		text += '[url=appearance][color=#d1b970]Appearance:[/color][/url] '
	if globals.state.descriptsettings.appearance == true || showmode != 'default':
		text = "\n" + text
		text += getdescription('hairlength') + getdescription('hairstyle') + getdescription("eyecolor") + getdescription("eyeshape") + getdescription('horns') + getdescription('ears') + getdescription('skin') + getdescription("skincov") + getdescription("wings") + getdescription("tail") + getdescription("height")
	else:
		text += "Omitted. "
	return text

func genitals():
	var text = '\n'
	if showmode == 'default':
		text += '[url=genitals][color=#d1b970]Privates:[/color][/url] '
	if globals.state.descriptsettings.genitals == true || showmode != 'default':
		text = "\n" + text + getdescription("titssize") + gettitsextra() + getdescription("asssize") + lowergenitals()
		if person.preg.duration > 24:
			text += "\n\nThe unborn child forces $his belly to protrude massively; $he is going to give birth soon."
		elif person.preg.duration > 16:
			text += "\n\n$His advanced pregnancy is clearly evident by the moderate bulge in $his belly."
		elif person.preg.duration > 8:
			text += "\n\nThe unborn fetus causes $his belly to bulge slightly."
		if person.preg.has_womb == false && person.sex != 'male':
			text += "\n\n[color=yellow]$name is sterile and won't be able to get pregnant.[/color]"
	else:
		text += "Omitted. "
	
	return text

func lowergenitals():
	var text = ''
	if person.vagina == 'normal':
		if person.vagvirgin == true && person.vagina != 'none':
			text = '$He has a tight, [color=yellow]virgin pussy[/color] below $his waist. '
		else:
			text = '$He has a [color=yellow]normal pussy[/color] below $his waist. '
	if person.penis != 'none':
		var temp = person.penistype + '_' + person.penis
		if penisdescription.has(temp):
			text += penisdescription[temp]
	if person.balls != 'none':
		text += getdescription('balls')
	return text

func piercing():
	var text = ""
	if person.piercing.earlobes == 'earrings':
		text += '$His ears are decorated with a pair of [color=aqua]fancy earrings[/color]. '
	elif person.piercing.earlobes == 'stud':
		text += '$His ears have a pair of [color=aqua]small studs[/color] in them. '
	if person.piercing.eyebrow == 'stud':
		text += '$His eyebrow is decorated with a [color=aqua]small stud[/color]. '
	if person.piercing.nose == 'ring':
		text += '$His nose bears a [color=aqua]large nose ring[/color] in it. '
	elif person.piercing.nose == 'stud':
		text += '$His nose has a [color=aqua]small stud[/color] in it. '
	if person.piercing.lips == 'ring':
		text += '$His lip is pierced with a [color=aqua]small ring[/color]. '
	elif person.piercing.lips == 'stud':
		text += '$His lip has a [color=aqua]small stud[/color] in it. '
	if person.piercing.tongue == 'stud':
		text += '$His tongue has a shiny [color=aqua]stud[/color], which can be seen when $he talks. '
	if person.piercing.nipples == 'stud':
		text += '$His nipples are pierced and decorated with [color=aqua]a pair of small studs[/color]. '
	elif person.piercing.nipples == 'ring':
		text += '$His nipples are pierced and [color=aqua]pair of rings[/color] can be seen in them. '
	elif person.piercing.nipples == 'chain':
		text += 'Her nipples are pierced and a [color=aqua]small degrading chain[/color] connects them. '
	if person.piercing.clit == 'ring':
		text += '$His clit is pierced with a [color=aqua]ring[/color]. '
	elif person.piercing.clit == 'stud':
		text += '$His clit has a [color=aqua]small stud[/color] in it. '
	if person.piercing.labia == 'ring':
		text += '$His labia is pierced and decorated with [color=aqua]a pair of rings[/color]. '
	elif person.piercing.labia == 'stud':
		text += '$His labia is pierced and decorated with a [color=aqua]small stud[/color]. '
	if person.piercing.penis == 'ring':
		text += '$His cock has a considerable [color=aqua]ring[/color] on the tip. '
	elif person.piercing.penis == 'stud':
		text += '$His cock has a [color=aqua]stud[/color] in it. '
	
	if text != '':
		if globals.state.descriptsettings.piercing == true || showmode != 'default':
			text = "\n\n[url=piercing][color=#d1b970]Piercing:[/color][/url] " + text
		else:
			text = "\n[url=piercing][color=#d1b970]Piercing:[/color][/url] Omitted."
	return text

func tattoo():
	var text = ''
	var sametattoo = true
	for i in person.tattoo.values():
		if person.tattoo.face != i || person.tattoo.face == 'none':
			sametattoo = false
			break
	if sametattoo == true:
		text += "$name's entire body is tattoed with [color=yellow]" + tattoooptions[person.tattoo.face].name + '[/color] pattern, featuring complex ' + tattoooptions[person.tattoo.face].descript + '. '
	else:
		if person.tattoo.face != 'none' && person.tattooshow.face == true:
			text += tattoosdescript.face.start + '[color=yellow]' + tattoooptions[person.tattoo.face].name + '[/color]' + tattoosdescript.face.end + tattoooptions[person.tattoo.face].descript + '. '
		if person.tattoo.chest != 'none' && person.tattooshow.chest == true:
			text += tattoosdescript.chest.start + '[color=yellow]' + tattoooptions[person.tattoo.chest].name + '[/color]' + tattoosdescript.chest.end + tattoooptions[person.tattoo.chest].descript + '. '
		if person.tattoo.arms != 'none' && person.tattooshow.arms == true:
			text += tattoosdescript.arms.start + '[color=yellow]' + tattoooptions[person.tattoo.arms].name + '[/color]' + tattoosdescript.arms.end + tattoooptions[person.tattoo.arms].descript + '. '
		if person.tattoo.waist != 'none' && person.tattooshow.waist == true:
			text += tattoosdescript.waist.start + '[color=yellow]' + tattoooptions[person.tattoo.waist].name + '[/color]' + tattoosdescript.waist.end + tattoooptions[person.tattoo.waist].descript + '. '
		if person.tattoo.legs != 'none' && person.tattooshow.legs == true:
			text += tattoosdescript.legs.start + '[color=yellow]' + tattoooptions[person.tattoo.legs].name + '[/color]' + tattoosdescript.legs.end + tattoooptions[person.tattoo.legs].descript + '. '
		if person.tattoo.ass != 'none' && person.tattooshow.ass == true:
			text += tattoosdescript.ass.start + '[color=yellow]' + tattoooptions[person.tattoo.ass].name + '[/color]' + tattoosdescript.ass.end + tattoooptions[person.tattoo.ass].descript + '. '
	if text != '':
		if globals.state.descriptsettings.tattoo == true || showmode != 'default': 
			text = "\n\n[url=tattoo][color=#d1b970]Tattoos:[/color][/url] " + text
		else:
			text = "\n[url=tattoo][color=#d1b970]Tattoos:[/color][/url] Omitted."
	return text

func mods():
	var text = ''
	
	if person.mods.has('hollownipples') == true:
		text += '[color=#B05DB0]$His breasts has been modified and are flexible and sensitive enough for penetration. [/color]'
	if person.mods.has('augmentfur'):
		text += "[color=#B05DB0]$His fur is magically augmented and provides extra resistance against harmful effects.[/color]\n"
	if person.mods.has('augmenttongue'):
		text += "[color=#B05DB0]$His tongue is unusually long which allows better performance during oral sex [/color]\n"
	if person.mods.has('augmentscales'):
		text += "[color=#B05DB0]$His scales are thicker than normal and provide extra protection against impacts.[/color]\n"
	if person.mods.has('augmenthearing'):
		text += "[color=#B05DB0]$His hearing is magically augmented and more sensitive to the surroundings.[/color]\n"
	if person.mods.has('augmentstr'):
		text += "[color=#B05DB0]$His muscles has been magically improved and can perform greater feats with proper training.[/color]\n"
	if person.mods.has('augmentagi'):
		text += "[color=#B05DB0]$His reflexes and flexibility has been magically improved and $his physic potential way higher than usual.[/color]\n"
	
	if text != '':
		text = "\n[url=mods]Mods: [/url]" + text
	return text


func race():
	var text = "$He is "
	if person.race[0] in ['E','A','O','U']:
		text += 'an '
	else:
		text += 'a '
	text += "[color=yellow][url=race]" + person.race + '[/url][/color]: '
	return text

func entry():
	var text = ''
	if globals.slaves.find(person) >= 0 || globals.player == person || person.fromguild == true:
		if person.sleep == 'jail':
			text = 'Behind the iron bars you see '
		elif globals.player == person:
			text = 'In the mirror you see '
		else:
			text = 'You see '
		if person.nickname == '':
			text = text + person.name + ' ' + person.surname + '. '
		else:
			text = text + person.name + ' "'+person.nickname+'" ' + person.surname + '. '
	else:
		
		text = 'Tied and bound [color=yellow]$sex[/color] looking at you with fear and hatred. '
	text = text.replace(" .", ".")
	return text

func getdescription(value):
	var text
	if descriptions.has(value) && descriptions[value].has(person[value]):
		text = descriptions[value][person[value]]
		text = text.split('|',true)
		text = text[rand_range(0,text.size())]
	elif descriptions.has(value) && descriptions[value].has('default'):
		text = descriptions[value].default
	else:
		text = "[color=red]Error at getting description for " + value + ": " + person[value] + '[/color]. '
	return text

func getbeauty():
	var calculate 
	var text = ''
	var appeal = person.beauty
	var tempappeal = person.beautytemp
	
	if appeal <= 15:
		calculate = 'ugly'
	elif appeal <= 30:
		calculate = 'boring'
	elif appeal <= 50:
		calculate = 'normal'
	elif appeal <= 70:
		calculate = 'cute'
	elif appeal <= 85:
		calculate = 'pretty'
	else:
		calculate = 'beautiful'
	
	text = descriptions['beauty'][calculate]
	text += "(" 
	if tempappeal != 0:
		text += '[color=aqua]'+str(floor(appeal))+'[/color]'
	else:
		text += str(floor(appeal)) 
	text += ")"
	return text

func gettitsextra():
	var text
	if person.titsextra >= 1:
		if person.titsextradeveloped == false:
			text = 'Below $his chest you can spot [color=yellow]' + str(person.titsextra) + ' additional '+ globals.fastif(person.titsextra == 1, 'pair', 'pairs') +'[/color] of [color=yellow]rudimentary nipples[/color]. '
		else:
			text = 'Below $his chest $he possesses [color=yellow]' + str(person.titsextra) + globals.fastif(person.titsextra == 1, ' row', ' rows')+ '[/color] of slightly smaller [color=yellow]ripe tits[/color]. '
	else:
		text = ''
	return text

static func getstatus(person):
	var text
	var name = person.name_short()
	
	if person.obed <= 20:
		text = '[color=#ff4949]$name barely pays any attention to you, as if demonstrating $his independence. [/color]'
	elif person.obed <= 40:
		text = '[color=#FFA500]$name prefers to avoid looking at you and reacts poorly to your commands. [/color]'
	elif person.obed <= 60:
		text = "[color=yellow]$name shows some respect to you, but it is clear that $he forces $himself to do it. [/color]"
	elif person.obed <= 80:
		text = '[color=#adff2f]$name is pretty considerate and tries to appeal to you, showing that your opinion is important to $him. [/color]' 
	else:
		text = '[color=green]$name grasps your every word and gives you all of the attention that $he can muster. [/color]'
	
	text = text + '\n\n'
	
	if person.stress <= 20:
		text = text + '[color=green]Overall $name acts content and lively[/color]. ' 
	elif person.stress <= 40:
		text = text + '[color=#adff2f]$name looks slightly down and tired.[/color] '
	elif person.stress <= 60:
		text = text + '[color=yellow]$name looks somewhat depressed.[/color] '
	elif person.stress <= 80:
		text = text + '[color=#FFA500]$name looks really stressed.[/color] '
	else:
		text = text + '[color=#ff4949]$name looks terrible, almost on the verge of breaking.[/color] '
	
	text = text + '\n\n'
	
	if person.loyal <= 20:
		text = text + '[color=#ff4949]$name does not show any signs of attachment to you. [/color]' 
	elif person.loyal <= 40:
		text = text + "[color=#FFA500]$name's attitude gives away some affection $he holds for you. [/color]"
	elif person.loyal <= 60:
		text = text + '[color=yellow]$name shows considerable loyalty to you as $his master.[/color] '
	elif person.loyal <= 80:
		text = text + '[color=#adff2f]$name shows a strong bond and deep feelings that $he has towards you.[/color] '
	else:
		text = text + "[color=green]To $name, nothing is more important than you and your will.[/color] "
	
	
	if person.effects.has('captured') == true:
		text = text + '\n\n[color=#ff4949]Due to recent events $name is very rebellous towards you.[/color]'
	text = person.dictionary(text)
	
	return text

func getBabyDescription(person):
	var text = '$He has ' + person.haircolor + ' hair and ' + person.eyecolor + ' eyes. $His skin is ' + person.skin + '. '
	var dict = {}
	dict = {
	none = '',
	plants = "It is covered in some leaves and green plant matter. ",
	scales = "It is covered in a few scales. ",
	feathers = "It has bird feathers in some places. ",
	full_body_fur = "It shows the beginnings of fur. ",
	}
	text = text + dict[person.skincov]
	if person.tail != 'none':
		text = text + '$He appears to have small tail, inherited from one of the parents. '
	if person.horns != 'none':
		text = text + '$He has pair of tiny horns on $his head. '
	dict = {
	human = 'normal',
	short_furry = 'short and furry',
	long_pointy_furry = 'long an furry',
	pointy = 'pointy',
	long_round_furry = 'of a bunny',
	long_droopy_furry = 'of a bunny',
	feathery = "feathery",
	fins = 'fin-like',
	}
	text = text + '$His ears are ' + dict[person.ears] + '. '
	
	text = person.dictionary(text)
	return text





var penisdescription = {
	human_small = 'Below $his waist dangles a [color=yellow]tiny humanish dick[/color], small enough that it could be called cute. ',
	human_average ='$He has an [color=yellow]ordinary humanish penis[/color] below $his waist, more than enough to make most men proud. ',
	human_big = 'A [color=yellow]huge humanish cock[/color] swings heavily from $his groin, big enough to give even the most veteran whore pause. ',
	canine_small = 'A slender, pointed [color=yellow]canine dick[/color] hangs below $his waist, so small that its knot is barely noticeable. ',
	canine_average = '$He has a knobby, red, [color=yellow]canine cock[/color] of respectable size below $his waist, which wouldn’t look out of place on on a large dog. ', 
	canine_big = 'Growing from $his crotch is a [color=yellow]massive canine dick[/color], red-skinned and sporting a thick knot near the base. ',
	feline_small = 'A [color=yellow]tiny feline penis[/color] dangles below $his waist, so small you can barely see the barbs. ',
	feline_average = '$He has a barbed [color=yellow]cat dick[/color] growing from $his crotch, big enough to rival an average human. ',
	feline_big = 'There is a frighteningly [color=yellow]large feline cock[/color] hanging between $his thighs, its sizable barbs making it somewhat intimidating. ', 
	equine_small = 'Below $his waist hangs a [color=yellow]smallish equine cock[/color], which is still respectable compared to the average man. ',
	equine_average= 'There is a [color=yellow]sizable equine cock[/color] growing from $his nethers, which, while small on a horse, is still thicker and heavier than the average human tool. ',
	equine_big = 'A [color=yellow]massive equine cock[/color] hangs heavily below $his waist, it’s mottled texture not quite matching the rest of $his skin. ',
}

var tattoosdescript = { #this goes like : start + tattoo theme + end + tattoo description: I.e On $his face you see a notable nature themed tattoo, depicting flowers and vines
	face = {start = "On $his cheek you see a notable ", end = " themed tattoo, depicting"},
	chest = {start = "$His chest is decorated with a ", end = " tattoo, portraying"},
	waist = {start = "On lower part of $his back, you spot a ", end = " tattooed image of"},
	arms = {start = "$His arm has a skillfully created ", end = " image of"},
	legs = {start = "$His ankle holds a piece of ", end = " art, representing"},
	ass = {start = "$His butt has a large ", end = " themed image showing "},
	}
	
var tattoooptions = {
	none = {name = 'none', descript = "", applydescript = "Select a theme for future tattoo"},
	nature = {name = 'nature', descript = " flowers and vines", function = "naturetattoo", applydescript = "Nature thematic tattoo will increase $name's beauty. "},
	tribal = {name = 'tribal',descript = " totemic markings and symbols", function = "tribaltattoo", applydescript = "Tribal thematic tattoo will increase $name's scouting performance. "},
	degrading = {name = 'derogatory', descript = " rude words and lewd drawings", function = "degradingtattoo", applydescript = "Derogatory tattoo will promote $name's lust and enforce obedience. "},
	animalistic = {name = 'beastly', descript = " realistic beasts and insects", function = "animaltattoo", applydescript = "Animalistic tattoo will boost $name's energy regeneration. "},
	magic = {name = "energy", descript = " empowering patterns and runes", function = "manatattoo", applydescript = "Magic tattoo will increase $name's Magic Affinity. "},
	}


var descriptions = { #Store descriptions for various body parts. Separate alternative with | sign to make description pick one at random
bodyshape = {
	humanoid = '$His body is quite [color=yellow]normal[/color]. ', 
	bestial = "$His body resembles a human's, except for some [color=yellow]bestial features[/color] in $his face and body structure. ",
	shortstack = '$His body is rather [color=yellow]petite[/color], about half the size of the average person. ',
	jelly = '$His body is [color=yellow]jelly-like[/color] and partly transparent. ',
	halfbird = '$His body has [color=yellow]wings for arms and avian legs[/color] making everyday tasks difficult. ',
	halfsnake = 'The lower portion of $his body consists of a long-winding [color=yellow]snake’s tail[/color]. ', 
	halffish = '$His body is [color=yellow]scaly and sleek[/color], possessing fins and webbed digits. ',
	halfspider = "The lower portion of $his body consists of a [color=yellow]spider's legs and abdomen[/color]. ",
	halfhorse = 'While $his upper body is human, $his lower body is [color=yellow]equine[/color] in nature. ',
	halfsquid = 'The lower portion of $his body consists of a [color=yellow]number of tentacular appendages[/color], similar to those of an octopus. ', 
},age = { 
	child = '$He looks like a [color=aqua]child[/color] that has barely hit puberty. ',
	teen = "$He's a young-looking [color=aqua]teen[/color]. ",
	adult = "$He's a fully-grown [color=aqua]adult[/color] $sex. ",
},beauty = {
	ugly = '$He appears rather [color=yellow]unsavory[/color] to look at. ',
	boring = '$His looks are rather [color=yellow]bland and unimpressive[/color]. ',
	normal = '$He appears to be pretty [color=yellow]average[/color] looking. ',
	cute = '$His looks are quite [color=yellow]cute[/color] and appealing. ',
	pretty = '$He looks unusually [color=yellow]pretty[/color] and attracts some attention. ',
	beautiful = '$He looks exceptionally [color=yellow]beautiful[/color], having no visible flaws and easily evoking envy. ', 
},
hairlength = {
	ear = '$His [color=aqua][haircolor][/color] hair is cut [color=aqua]short[/color]. ',
	neck = '$His [color=aqua][haircolor][/color] hair falls down to just [color=aqua]below $his neck[/color]. ',
	shoulder = '$His wavy [color=aqua][haircolor][/color] hair is [color=aqua]shoulder length[/color]. ',
	waist = '$His gorgeous [color=aqua][haircolor][/color] hair [color=aqua]sways down to $his waist[/color]. ',
	hips = '$His [color=aqua][haircolor][/color] hair cascades down, [color=aqua]covering $his hips[/color]. ',
},
hairstyle = {
	straight = 'It [color=aqua]hangs freely[/color] from $his head. ',
	ponytail = 'It is tied in a [color=aqua]high ponytail[/color]. ',
	twintails = 'It is managed in girly [color=aqua]twin-tails[/color]. ',
	braid = 'It is combed into a single [color=aqua]braid[/color]. ',
	'two braids' : 'It is combed into [color=aqua]two braids[/color]. ',
	bun = "It is tied into a neat [color=aqua]bun[/color]. ",
},
eyecolor = {
	default = '$His eyes are [color=aqua][eyecolor][/color]. ',
},
eyeshape = {
	normal = "",
	slit = "$He has [color=aqua]vertical, animalistic pupils[/color]. "
},
horns = {
	none = '',
	short = 'There is a pair of [color=aqua]tiny, pointed horns[/color] on top of $his head. ',
	'long_straight' : '$He has a pair of [color=aqua]long, bull-like horns[/color]. ',
	curved = 'There are [color=aqua]curved horns[/color] coiling around $his head. ',
	},
ears = {
	human = '',
	short_furry = '$He has a pair of fluffy, [color=aqua]medium-sized animal-like ears[/color]. ',
	long_pointy_furry = '$He has a pair of fluffy, [color=aqua]lengthy, animal-like ears[/color]. ',
	pointy = '$He has unnaturally long, [color=aqua]pointed[/color] ears. ',
	long_round_furry = '$He has a pair of [color=aqua]standing bunny ears[/color] over $his head. ',
	long_droopy_furry = '$He has a pair of [color=aqua]droppy, bunny ears[/color] on $his head. ',
	feathery = "There's a pair of clutched [color=aqua]feathery ears[/color] on sides of " + '$His head. ',
	fins = '$His ears look like a pair of [color=aqua]fins[/color]. ',
},
skin = {
	pale = '$His skin is a [color=aqua]pale[/color] white. ',
	fair = '$His skin is healthy and [color=aqua]fair[/color] color. ',
	olive = '$His skin is of an unusual [color=aqua]olive[/color] tone. ', 
	'tan' : '$His skin is a [color=aqua]tanned[/color] bronze color. ',
	brown = '$His skin is a mixed [color=aqua]brown[/color] color. ',
	dark = '$His skin is deep [color=aqua]dark[/color]. ',
	jelly = '$His skin is [color=aqua]semi-transparent and jelly-like[/color]. ', 
	blue = '$His skin is dark [color=aqua]blue[/color]. ',
	"pale blue" : '$His skin is [color=aqua]light pale blue[/color]. ',
	green = '$His skin is [color=aqua]green[/color]. ',
	red = '$His skin is bright [color=aqua]red[/color]. ',
	purple = '$His skin is [color=aqua]purple[/color]. ',
	teal = '$His skin is [color=aqua]teal[/color]. ',
},
skincov = {
	none = '',
	plants = 'Various leaves and bits of [color=aqua]plant matter[/color] naturally cover parts of $his body. ',
	scales = '$His skin is partly covered with [color=aqua]scales[/color]. ',
	feathers = '$His body is covered in [color=aqua]bird-like feathers[/color] in many places. ',
	full_body_fur = '$His body is covered in thick, soft [color=aqua]fur of [furcolor]',
},
furcolor ={ # fur color
	none = '',
	white = 'marble color[/color]. ',
	gray = 'gray color[/color]. ',
	orange_white = 'orange-white pattern[/color]. ',
	black_white = 'black-white pattern[/color]. ',
	black_gray = 'black-gray pattern[/color]. ',
	black = 'jet-black color[/color]. ',
	orange = 'common fox pattern[/color]. ',
	brown = 'light-brown tone[/color]. ',
},
#arms = {
#	scales = '$His' + globals.fastif(person['legs'] == 'scales', ' arms and legs', ' arms') + ' are covered in [color=aqua]scales[/color]. ',
#	winged = "$His arms shaped in close resemblance of [color=aqua]bird's wings[/color]. ",
#	webbed = '$His' + globals.fastif(person['legs'] == 'webbed', ' hands and feet', ' hands') + ' have [color=aqua]webbed digits[/color]. ', 
#	fur_covered = '$His' + globals.fastif(person['legs'] == 'fur_covered', ' arms and legs', ' arms') + ' are covered in [color=aqua]fur[/color]. ',
#},
wings = {
	none = '',
	feathered_black = 'On $hisback, $he has folded, [color=aqua]black, feathery wings[/color]. ',
	feathered_white = 'On $hisback, $he has folded, [color=aqua]white, feathery wings[/color]. ',
	feathered_brown = 'On $hisback, $he has folded, [color=aqua]brown, feathery wings[/color]. ',
	insect = 'On $his back rests translucent [color=aqua]fairy wings[/color]. ',
	leather_black = 'Hidden on $his back is a pair of bat-like, [color=aqua]black leather wings[/color]. ',
	leather_red = 'Hidden on $his back is a pair of bat-like, [color=aqua]red leather wings[/color]. ',
},
tail = {
	none = '',
	cat = 'Below $his waist, you spot a slim [color=aqua]cat tail[/color] covered with fur. ',
	fox = '$He has a large, fluffy [color=aqua]fox tail[/color]. ',
	wolf = "Below $his waist there's a short, fluffy, [color=aqua]wolf tail[/color]. ",
	bunny = '$He has a [color=aqua]small ball of fluff[/color] behind $his rear. ',
	racoon = '$He has a plump, fluffy [color=aqua]raccoon tail[/color]. ',
	scruffy = 'Behind $his back you notice a long tail covered in a thin layer of fur and ending in a [color=aqua]scruffy brush[/color]. ',
	demon = '$He has a long, thin, [color=aqua]demonic tail[/color] ending in a pointed tip. ',
	dragon = 'Trailing somewhat behind $his back is a [color=aqua]scaled tail[/color]. ',
	bird = '$He has a [color=aqua]feathery bird tail[/color] on $his rear. ', 
	fish = '$His rear ends in long, sleek [color=aqua]fish tail[/color]. ', 
	"snake tail" : '',
	tentacles = '',
	horse = '',
	"spider abdomen" : ''
},
height = {
	tiny = '$His stature is [color=aqua]extremely small[/color], barely half the size of a normal person. ',
	petite = '$His stature is quite [color=aqua]petite[/color]. ',
	short = '$His height is quite [color=aqua]short[/color]. ',
	average = '$He is of pretty normal, [color=aqua]average[/color] height. ',
	tall = '$He is quite [color=aqua]tall[/color] compared to an average person. ',
	towering = '$He is unusually tall, [color=aqua]towering[/color] over others. ',
},
titssize = {
	flat = '$His chest is barely visible and nearly [color=yellow]flat[/color]. ',
	small = '$He has [color=yellow]small[/color], round boobs. ',
	average= '$His nice, [color=yellow]perky[/color] breasts are firm and inviting. ',
	big = '$His [color=yellow]big[/color] tits are pleasantly soft, but still have a nice spring to them. ',
	huge = '$His [color=yellow]giant[/color] tits are mind-blowingly big. ',
	masculine = '$His chest is of definitive [color=yellow]masculine[/color] shape. ',
},
asssize = {#ass strings
	flat = '$His butt is skinny and [color=yellow]flat[/color]. ',
	small = '$He has a [color=yellow]small[/color], firm butt. ',
	average= '$He has a nice, [color=yellow]pert[/color] ass you could bounce a coin off of. ',
	big = '$He has a pleasantly [color=yellow]plump[/color], heart-shaped ass that jiggles enticingly with each step. ',
	huge = '$He has a [color=yellow]huge[/color], attention-grabbing ass. ',
	masculine = '$His ass definitively has a [color=yellow]masculine[/color] shape. ',
},
balls = {
	small = '$He has a pair of [color=yellow]tiny[/color] balls. ',
	average = '$He has an [color=yellow]average-sized[/color] ballsack. ',
	big = '$He has a [color=yellow]huge[/color] pair of balls weighing down $his scrotum. ',
},
}
