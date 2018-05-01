extends Node

var location = 'mansion'
var gender = ''
var skintype = ''
var curScolor
var	curCcolor
var Shue = 0
var Ssat = 0
var Sval = 1
var Chue = 0
var Csat = 0
var Cval = 1
var tempV = 1
var tempS = 0
var tempH = 0
var curmember

var shades = {
arachna = {male = load("res://files/buttons/inventory/shades/Arachna_M.png"), female = load("res://files/buttons/inventory/shades/Arachna_F.png")},
bunny = {male = load("res://files/buttons/inventory/shades/Beastkin-Bunny_M.png"), female = load("res://files/buttons/inventory/shades/Beastkin-Bunny_F.png")},
cat = {male = load("res://files/buttons/inventory/shades/Beastkin-Cat_M.png"), female = load("res://files/buttons/inventory/shades/Beastkin-Cat_F.png")},
fox = {male = load("res://files/buttons/inventory/shades/Beastkin-Fox_M.png"), female = load("res://files/buttons/inventory/shades/Beastkin-Fox_F.png")},
tanuki = {male = load("res://files/buttons/inventory/shades/Beastkin-Tanuki_M.png"), female = load("res://files/buttons/inventory/shades/Beastkin-Tanuki_F.png")},
wolf = {male = load("res://files/buttons/inventory/shades/Beastkin-Wolf_M.png"), female = load("res://files/buttons/inventory/shades/Beastkin-Wolf_F.png")},
centaur = {male = load("res://files/buttons/inventory/shades/Centaur_M.png"), female = load("res://files/buttons/inventory/shades/Centaur_F.png")},
demon = {male = load("res://files/buttons/inventory/shades/Demon_M.png"), female = load("res://files/buttons/inventory/shades/Demon_F.png")},
dragonkin = {male = load("res://files/buttons/inventory/shades/Dragonkin_M.png"), female = load("res://files/buttons/inventory/shades/Dragonkin_F.png")},
dryad = {male = load("res://files/buttons/inventory/shades/Dryad_M.png"), female = load("res://files/buttons/inventory/shades/Dryad_F.png")},
elf = {male = load("res://files/buttons/inventory/shades/Elf_M.png"), female = load("res://files/buttons/inventory/shades/Elf_F.png")},
fairy = {male = load("res://files/buttons/inventory/shades/Fairy_M.png"), female = load("res://files/buttons/inventory/shades/Fairy_F.png")},
gnome = {male = load("res://files/buttons/inventory/shades/Gnome_M.png"), female = load("res://files/buttons/inventory/shades/Gnome_F.png")},
goblin = {male = load("res://files/buttons/inventory/shades/Goblin_M.png"), female = load("res://files/buttons/inventory/shades/Goblin_F.png")},
harpy = {male = load("res://files/buttons/inventory/shades/Harpy_M.png"), female = load("res://files/buttons/inventory/shades/Harpy_F.png")},
human = {male = load("res://files/buttons/inventory/shades/Human_M.png"), female = load("res://files/buttons/inventory/shades/Human_F.png")},
lamia = {male = load("res://files/buttons/inventory/shades/Lamia_M.png"), female = load("res://files/buttons/inventory/shades/Lamia_F.png")},
nereid = {male = load("res://files/buttons/inventory/shades/Nereid_M.png"), female = load("res://files/buttons/inventory/shades/Nereid_F.png")},
scylla = {male = load("res://files/buttons/inventory/shades/Scylla_M.png"), female = load("res://files/buttons/inventory/shades/Scylla_F.png")},
seraph = {male = load("res://files/buttons/inventory/shades/Seraph_M.png"), female = load("res://files/buttons/inventory/shades/Seraph_F.png")},
slime = {male = load("res://files/buttons/inventory/shades/Slime_M.png"), female = load("res://files/buttons/inventory/shades/Slime_F.png")},
taurus = {male = load("res://files/buttons/inventory/shades/Taurus_M.png"), female = load("res://files/buttons/inventory/shades/Taurus_F.png")},
orc = {male = load("res://files/buttons/inventory/shades/Orc_-M.png"), female = load("res://files/buttons/inventory/shades/Orc_F.png")},

}

var Ccolordict = {
"orange" : [0.04, -1.9, 1.4],
}
var Scolordict = {
"green" : [0.3, -3, 0.1],
"green1" : [0.24, -3, 0.28],
"pale blue" : [0.598, -1.078, 0.521],
"purple" : [0.658, -1.673, 0.484],
"blue" : [0.603, -1.598, 0.484],
"pale" : [0, 0, 1.487],
"fair" : [0, 0, 1],
"olive" : [0.112, -0.59, 0.892],
"tan" : [0.1, -0.595, 0.483],
"brown" : [0.063, -1, 0.26],
"dark" : [0.1, -0.483, 0.037],
}

#,'weaponclaymore','clothpet','clothkimono','underwearlacy','weaponaynerisrapier'
func _ready():
#	pass
#	for i in $personbodyparts.get_children():
#		var partsname = i.get_name()
#		get_node("personbodyparts/"+str(partsname)+"/partframe/VBoxContainer/fillcover/fillcoverbar").value = 0#person.sexexp.oralammount
#		if partsname == "breasts":
#			get_node("personbodyparts/"+str(partsname)+"/partframe/VBoxContainer/milkprod/milkprodbar").value = 0#
#		get_node("personbodyparts/"+str(partsname)+"/partframe/VBoxContainer/sense/sensebar/sensecenter/sensevalue").rect_position = Vector2(0, 0)#Vector2(personsense, 0)
#		get_node("personbodyparts/"+str(partsname)+"/partframe/VBoxContainer/technique/techiquebar/techniquecenter/techniquevalue").rect_position = Vector2(0, 0)#Vector2(150, 0)
	for i in ["mouth","throat","breasts","hands","vagina","clit","penis","crevix","anus","feets","tail"]:
		get_node("personbodyparts/"+i+"/hover"+i).connect("mouse_entered",self,"partentered",[i])
		get_node("personbodyparts/"+i+"/hover"+i).connect("mouse_exited",self,"partexited",[i])
	_on_Button2_pressed()


#	var i = 3
#	if globals.player.name == '':
#		globals.player = globals.newslave(globals.allracesarray[rand_range(0,globals.allracesarray.size())], 'random', 'random')
#		while i > 0:
#			i -= 1
#			var person = globals.newslave(globals.allracesarray[rand_range(0,globals.allracesarray.size())], 'random', 'random')
#			globals.slaves = person
	
	
#	for i in globals.itemdict.values():
#		i.unlocked = true
#		if !i.type in ['gear','dummy']:
#			i.amount += 10
#	for i in ['armorchain','armorchain','armorchain','armorchain','armorchain']:
#		var tmpitem = globals.items.createunstackable(i)
#		globals.items.enchantrand(tmpitem)
#		globals.state.unstackables[str(tmpitem.id)] = tmpitem
	
	
	
#	for i in ['costume','weapon','armor','accessory','underwear']:
#		get_node("gearpanel/" + i).connect("pressed", self, 'gearinfo', [i])
#		get_node("gearpanel/" + i + "/unequip").connect("pressed", self, 'unequip', [i])
	
#	for i in get_tree().get_nodes_in_group("invcategory"):
#		i.connect("pressed",self,'selectcategory',[i])
	
#	open()


func slavebodyinfo(member):
	curmember = member
#	var text = ''
#	text += "Health: " + str(person.health) + "/" + str(person.stats.health_max) + '\nEnergy: ' + str(person.energy) + '/' + str(person.stats.energy_max) + '\n'
	var sex
	var race
	sex = member.person.sex.replace('futanari','female')
	race = member.person.race.replace("Beastkin ",'').replace("Halfkin ", '').to_lower()
	if race in ['dark elf', 'drow']:
		race = 'elf'
	get_node("gearpanel/charframe").set_texture(shades[race][sex])
	get_node("gearpanel/Label").text = member.person.name_long()
	gender = member.person.sex
	skintype = member.person.race
	print(curmember.person.tail, " ", curmember.person.race)
	var coverarray = []
	if Ccolordict.has(curmember.person.furcolor):
		coverarray = Ccolordict[curmember.person.furcolor]
	elif Ccolordict.has(curmember.person.scalescolor):
		coverarray = Ccolordict[curmember.person.scalescolor]
	elif Ccolordict.has(curmember.person.featherscolor):
		coverarray = Ccolordict[curmember.person.featherscolor]
	else:
		coverarray = [0,0,1]
	Chue = coverarray[0]
	Csat = coverarray[1]
	Cval = coverarray[2]
	
	var skinarray = []
	if Scolordict.has(curmember.person.skin):
		skinarray = Scolordict[curmember.person.skin]
	else:
		skinarray = [0,0,1]
	Shue = skinarray[0]
	Ssat = skinarray[1]
	Sval = skinarray[2]

#	if furcolordict.has(curmember.person.furcolor):
#		coverarray = furcolordict[curmember.person.furcolor]
#	elif scalescolordict.has(curmember.person.scalescolor):
#		coverarray = scalescolordict[curmember.person.scalescolor]
#	elif feathercolordict.has(curmember.person.featherscolor):
#		coverarray = feathercolordict[curmember.person.featherscolor]
#	else:
#		coverarray = [0,0,1]
#	Chue = coverarray[0]
#	Csat = coverarray[1]
#	Cval = coverarray[2]

	
	if gender != 'female':
		partentered('penis')
		partexited('penis')
	else:
		partentered('vagina')
		partexited('vagina')
	partentered('mouth')
	partexited('mouth')
	
	if member.person.tail == 'none':
		get_node('personbodyparts/tail').visible = false
		get_node('personbodyparts/mouth').rect_position = Vector2(150, 44)
		get_node('personbodyparts/throat').rect_position = Vector2(262, 44)
		get_node('personbodyparts/hands').rect_position = Vector2(130, 218+25)
		get_node('personbodyparts/anus').rect_position = Vector2(166, 392+50)
	else:
		get_node('personbodyparts/tail').visible = true
		get_node('personbodyparts/mouth').rect_position = Vector2(150, 44)
		get_node('personbodyparts/throat').rect_position = Vector2(262, 44)
		get_node('personbodyparts/hands').rect_position = Vector2(130, 218)
		get_node('personbodyparts/anus').rect_position = Vector2(166, 392)
		
	if member.person.tail == 'tentacles':
		get_node('personbodyparts/tail/Label').text = "Tentacle"
	else:
		get_node('personbodyparts/tail/Label').text = "Tail"
		
	if member.person.legs in ['snake','spider','horse','tentacles']:
		get_node('personbodyparts/feets').visible = false
	else:
		get_node('personbodyparts/feets').visible = true
		
		
	var button
	button = get_node("personinfo")
	var text = member.person.name_long() + " [color=yellow]" + member.person.race + "[/color]"
	if member.person == globals.player:
		text += " [color=aqua]Master[/color]"
	else:
		text += " " + member.person.origins.capitalize()
	button.get_node("name").set_bbcode(text)
	if member.person.imageportait != null:
		button.get_node("portrait").set_texture(globals.loadimage(member.person.imageportait))
	
	var personsense = []
	var persontech = []
	var cuminammount = []
	var cumonammount = []
	var sensetext = ["Frigid", "Normal sensitivity", "Sensitive", "Very sensitive", "Extremely sensitive"]
	var techtext = ["Unskilled", "Common knowledge", "Skilled", "very skilled", "Mastered"]
	var cumintext = ["Clean","Some cum inside","Stuffed with cum","Overflowing with cum","Leaking cum"]
	var cumontext = ["Clean","Some cum over","More cum over","Cum covered","Driping with cum"]
	var squirtrelasedtext = ["Not cummed yet","Cummed a bit","Cummed some","Cummed some more","Cummed a lot"]
	var cumrelasedtext = ["Not squirted yet","Squirted a bit","Squirted some","Squirted some more","Squirted a lot"]
	var cuminbuildindex = 0
	var cumonbuildindex = 0
	var sensebuildindex = 0
	var techbuildindex = 0
	
	var cumonindex = 0
	
	for i in [member.person.sensbreast, member.person.sensvagina, member.person.sensclit, member.person.senspenis, member.person.senscrevix, member.person.sensanal, member.person.senstail]:
		var sensereveal
		var unlock = [member.person.sexexp.breast, member.person.sexexp.vagina, member.person.sexexp.clit, member.person.sexexp.penis, member.person.sexexp.crevix, member.person.sexexp.anal, member.person.sexexp.tail]
		var parts = ["breasts","vagina","clit","penis","crevix","anus","tail"]
		if unlock[sensebuildindex] != 0:
			sensereveal = true
		else:
			sensereveal = false
	#	if i >= 2:#special
#			personsense.append(150)
		if i >= 1.85:
			personsense.append([parts[sensebuildindex], 127.5, sensereveal])
		elif i >= 1:
			personsense.append([parts[sensebuildindex], 150*(i-1), sensereveal])
		elif i > 0.5:
			personsense.append([parts[sensebuildindex], (35*i-35)*2, sensereveal])
		elif i <= 0.5:
			personsense.append([parts[sensebuildindex], -35, sensereveal])
#		else:
#			personsense.append(150*(i-1))
		sensebuildindex += 1
	
	for i in [member.person.sexexp.oraltech, member.person.sexexp.fingerstech, member.person.sexexp.vaginatech, member.person.sexexp.penistech, member.person.sexexp.analtech, member.person.sexexp.tailtech, member.person.sexexp.feetstech]:
		var techreveal
		var unlock = [member.person.sexexp.oral, member.person.sexexp.fingers, member.person.sexexp.vagina, member.person.sexexp.penis, member.person.sexexp.anal, member.person.sexexp.tail, member.person.sexexp.feets]
		var parts = ["mouth","hands","vagina","penis","anus","tail","feets"]
		if unlock[techbuildindex] != 0:
			techreveal = true
		else:
			techreveal = false
#		if i >= 2:#special
#			persontech.append(150)
		if i >= 1.85:
			persontech.append([parts[techbuildindex], 127.5, techreveal])
		elif i >= 1:
			persontech.append([parts[techbuildindex], 150*(i-1), techreveal])
		elif i > 0.5:
			persontech.append([parts[techbuildindex], (35*i-35)*2, techreveal])
		elif i <= 0.5:
			persontech.append([parts[techbuildindex], -35, techreveal])
#		else:
#			persontech.append(150*(i-1))
		techbuildindex += 1

	for i in [member.tempsexexp.swallowamount, member.tempsexexp.swallowamount, member.tempsexexp.creampieamount, member.tempsexexp.crevixamount, member.tempsexexp.analcreampieamount]:
		var cuminreveal
		var unlock = [member.person.sexexp.oral, member.person.sexexp.throat, member.person.sexexp.vagina, member.person.sexexp.crevix, member.person.sexexp.anal]
		var parts = ["mouth","throat","vagina","crevix","anus"]
		if unlock[cuminbuildindex] >= 15:
			cuminreveal = 'flexible'
		elif unlock[cuminbuildindex] >= 10:
			cuminreveal = 'relaxed'
		elif unlock[cuminbuildindex] >= 1:
			cuminreveal = 'tight'
		else:
			cuminreveal = 'unknown'
		cuminammount.append([parts[cuminbuildindex], i, cuminreveal])
		cuminbuildindex += 1
		
	for i in [member.tempsexexp.breastamount, member.tempsexexp.fingersamount, member.tempsexexp.feetsamount, member.tempsexexp.tailamount]:
		cumonammount.append(i)

	#for i in $personbodyparts.get_children():
	#	var partsname = i.get_name()
	#	get_node("personbodyparts/"+partsname+"/hover").connect("mouse_entered",self,"partentered",[partsname])
	#	get_node("personbodyparts/"+partsname+"/hover").connect("mouse_entered",self,"partexited",[partsname])
	#	if partsname == "breasts":
	#		get_node("personbodyparts/"+partsname+"/partframe/VBoxContainer/milkprod/milkprodbar").value = member.tempsexexp.milkedamount
	#	if partsname == "clit":
	#		get_node("personbodyparts/"+partsname+"/partframe/VBoxContainer/milkprod/milkprodbar").value = member.tempsexexp.clitamount
	if member.person.sex != 'female':
		if member.person.sex == 'male':
			get_node('personbodyparts/penis').visible = true
			get_node('personbodyparts/clit').visible = false
			get_node('personbodyparts/vagina').visible = false
			get_node('personbodyparts/crevix').visible = false
		else:
			get_node('personbodyparts/penis').visible = true
			get_node('personbodyparts/clit').visible = true
			get_node('personbodyparts/vagina').visible = true
			get_node('personbodyparts/crevix').visible = true
			get_node('personbodyparts/clit/Label').text = 'Vagina'
	else:
		get_node('personbodyparts/penis').visible = false
		get_node('personbodyparts/clit').visible = true
		get_node('personbodyparts/vagina').visible = true
		get_node('personbodyparts/crevix').visible = true
		get_node('personbodyparts/clit/Label').text = 'Clitoris'
		
	

		
	for i in ["mouth","throat","breasts","hands","vagina","clit","penis","crevix","anus","feets","tail"]:
#		get_node("personbodyparts/"+i+"/hover"+i).connect("mouse_entered",self,"partentered",[i])
#		get_node("personbodyparts/"+i+"/hover"+i).connect("mouse_exited",self,"partexited",[i])
		if i == "breasts":
			get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar").value = member.tempsexexp.milkedamount
		if i == "clit":
			get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar").value = member.tempsexexp.clitamount
			if member.tempsexexp.clitamount >= 100:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = squirtrelasedtext[4]
			elif member.tempsexexp.clitamount >= 66:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = squirtrelasedtext[3]
			elif member.tempsexexp.clitamount >= 33:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = squirtrelasedtext[2]
			elif member.tempsexexp.clitamount > 0:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = squirtrelasedtext[1]
			elif member.tempsexexp.clitamount == 0:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = squirtrelasedtext[0]
		if i == "penis":
			get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar").value = member.tempsexexp.penisamount
			if member.tempsexexp.penisamount >= 100:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = cumrelasedtext[4]
			elif member.tempsexexp.penisamount >= 66:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = cumrelasedtext[3]
			elif member.tempsexexp.penisamount >= 33:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = cumrelasedtext[2]
			elif member.tempsexexp.penisamount > 0:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = cumrelasedtext[1]
			elif member.tempsexexp.penisamount == 0:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/milkprod/milkprodbar/milkprodtext").text = cumrelasedtext[0]
		
#	for i in ["mouth","throat","vagina","crevix","anus"]:
	for i in cuminammount:
		var partname = i[0]
		var value = i[1]
		var known = i[2]
		var new_color1 = Color()
		new_color1.v = Sval #value
		new_color1.s = Ssat #saturation
		new_color1.h = Shue #hue
		if known != 'unknown':
			get_node("personbodyparts/"+partname+"/partframe/loseness").text = known.capitalize()#+" "+partname
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/Label").visible = false
			if partname in ['vagina', 'anus', 'crevix']:# untill i make the other images then i remove (also missing the rave for color change)
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/under").set("texture", load("res://files/buttons/inventory/progbarempty"+partname+".png"))
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/over").set("texture", load("res://files/buttons/inventory/progbarframe"+partname+known+"v1.png"))
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/under").set_modulate(new_color1)
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/over").set_modulate(new_color1)
			elif partname == 'mouth':
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/over").set("texture", load("res://files/buttons/inventory/progbarframethroat.png"))
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/under").set("texture", load("res://files/buttons/inventory/progbaremptyin.png"))
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/under").set_modulate(new_color1)
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/over").set_modulate(new_color1)
			else:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/under").set("texture", load("res://files/buttons/inventory/progbaremptyin.png"))
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/over").set("texture", load("res://files/buttons/inventory/progbarframe.png"))
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/under").set_modulate(new_color1)
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/over").set_modulate(new_color1)
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/over2").set("texture", load("res://files/buttons/inventory/progbarframe.png"))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar").set("texture_progress", load("res://files/buttons/inventory/progbarwhitecum.png"))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar").value = value
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar").hint_tooltip = partname+" Filled with "+str(value)+" ml of cum"
		else:
			get_node("personbodyparts/"+partname+"/partframe/loseness").text = known.capitalize()
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/Label").visible = true
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/Label").set("custom_colors/font_color", Color(0.45,0.45,0.45))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/under").set("texture", load("res://files/buttons/inventory/progbarempty.png"))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/over").set("texture", load("res://files/buttons/inventory/progbarframe.png"))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar").set("texture_progress", null)
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar").hint_tooltip = "Never explored this "+partname+".. perform a action using this boduypart to reveal its value"
		if get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/Label").visible == false:
			if value >= 100:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumintext[4]
			elif value >= 66:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumintext[3]
			elif value >= 33:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumintext[2]
			elif value > 0:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumintext[1]
			elif value == 0:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumintext[0]
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").set("custom_colors/font_color", Color(1,1,1))
		else:
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = 'Cum inside'
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").set("custom_colors/font_color", Color(0.45,0.45,0.45))
		
	for i in ["breasts","hands","feets","tail"]:
#		get_node("personbodyparts/hands/partframe/VBoxContainer/fillcover/under").set("texture_under", load("res://files/buttons/inventory/progbaremptyout.png"))
#		get_node("personbodyparts/hands/partframe/VBoxContainer/fillcover/under2").set("texture_under", load("res://files/buttons/inventory/fur.png"))
		if i in ['hands','feets','tail']:
			if curmember.person.furcolor != 'none':
				if i != 'tail':
					if curmember.person.race in ['Beastkin Cat','Beastkin Fox','Beastkin Wolf','Beastkin Bunny','Beastkin Tanuki']:
						get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").set("texture", load("res://files/buttons/inventory/skincoverfurcut.png"))
				else:
					get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").set("texture", load("res://files/buttons/inventory/skincoverfur.png"))
			elif curmember.person.scales != 'none':
				var scaletype = curmember.person.scales
				if i != 'tail':
					get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").set("texture", load("res://files/buttons/inventory/skincover"+scaletype+"cut.png"))
				else:
					get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").set("texture", load("res://files/buttons/inventory/skincover"+scaletype+".png"))
			elif curmember.person.featherscolor != 'none':
				if i != 'tail':
					get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").set("texture", load("res://files/buttons/inventory/skincoverfeathercut.png"))
				else:
					get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").set("texture", load("res://files/buttons/inventory/skincoverfeather.png"))
			else:
				get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").set("texture", null)
			if i != 'tail':
				if get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").texture != null:
					get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under3").set("texture", load("res://files/buttons/inventory/cut.png"))
				else:
					get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under3").set("texture", null)
		var new_color = Color()
		var new_color1 = Color()
		new_color.v = Cval #value
		new_color.s = Csat #saturation
		new_color.h = Chue #hue
		get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").set_modulate(new_color)
		new_color1.v = Sval #value
		new_color1.s = Ssat #saturation
		new_color1.h = Shue #hue
		get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under").set_modulate(new_color1)
		get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/under2").set("self_modulate", Color(1,1,1,0.98))
		get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/fillcoverbar").value = cumonammount[cumonindex]
		get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/fillcoverbar").hint_tooltip = i+" Covered with "+str(cumonammount[cumonindex])+" ml of cum"+str(cumonindex)
		if cumonammount[cumonindex] >= 100:
			get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumontext[4]
		elif cumonammount[cumonindex] >= 66:
			get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumontext[3]
		elif cumonammount[cumonindex] >= 33:
			get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumontext[2]
		elif cumonammount[cumonindex] > 0:
			get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumontext[1]
		elif cumonammount[cumonindex] == 0:
			get_node("personbodyparts/"+i+"/partframe/VBoxContainer/fillcover/fillcoverbar/fillcovertext").text = cumontext[0]
		cumonindex += 1
	
		
	#for i in ["breasts","vagina","clit","penis","crevix","anus","tail"]:
	for i in personsense:
		var partname = i[0]
		var value = i[1]
		var known = i[2]
		if known == true:
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensecenter/sensevalue").visible = known
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/Label").visible = false
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar").set("texture_progress", load("res://files/buttons/inventory/progbarslider.png"))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensecenter/sensevalue").rect_position = Vector2(value, 0)
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar").hint_tooltip = partname+" value of "+str(value)+" sense"
		else:
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensecenter/sensevalue").visible = known
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/Label").visible = true
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar").set("texture_under", load("res://files/buttons/inventory/progbarempty.png"))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/Label").set("custom_colors/font_color", Color(0.45,0.45,0.45))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar").set("texture_progress", null)
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar").hint_tooltip = partname+" sense value is unknown.. perform a action using this boduypart to reveal its value"
		if get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/Label").visible == false:
			if value >= 150:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").text = sensetext[4]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").set("custom_colors/font_color", Color(0.17,0.65,0.13))
			elif value >= 100:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").text = sensetext[3]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").set("custom_colors/font_color", Color(0.36,0.73,0.25))
			elif value >= 50:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").text = sensetext[2]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").set("custom_colors/font_color", Color(0.67,0.86,0.62))
			elif value >= 0:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").text = sensetext[1]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").set("custom_colors/font_color", Color(1,1,1))
			elif value < 0:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").text = sensetext[0]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").set("custom_colors/font_color", Color(0.8,0.11,0.11))
		else:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").text = 'Sensitivity'
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/sense/sensebar/sensetext").set("custom_colors/font_color", Color(0.45,0.45,0.45))
		
		
#	for i in ["mouth","hands","vagina","penis","anus","tail","feets"]:
	for i in persontech:
		var partname = i[0]
		var value = i[1]
		var known = i[2]
		if known == true:
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquecenter/techniquevalue").visible = known
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/Label").visible = false
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar").set("texture_progress", load("res://files/buttons/inventory/progbarslider.png"))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquecenter/techniquevalue").rect_position = Vector2(value, 0)
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar").hint_tooltip = partname+" value of "+str(value)+" technique"
		else:
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquecenter/techniquevalue").visible = known
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/Label").visible = true
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar").set("texture_under", load("res://files/buttons/inventory/progbarempty.png"))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/Label").set("custom_colors/font_color", Color(0.45,0.45,0.45))
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar").set("texture_progress", null)
			get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar").hint_tooltip = partname+" technique value is unknown.. perform a action using this boduypart to reveal its value"
		if get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/Label").visible == false:
			if value >= 150:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").text = techtext[4]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").set("custom_colors/font_color", Color(0.17,0.65,0.13))
			elif value >= 100:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").text = techtext[3]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").set("custom_colors/font_color", Color(0.36,0.73,0.25))
			elif value >= 50:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").text = techtext[2]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").set("custom_colors/font_color", Color(0.67,0.86,0.62))
			elif value >= 0:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").text = techtext[1]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").set("custom_colors/font_color", Color(1,1,1))
			elif value < 0:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").text = techtext[0]
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").set("custom_colors/font_color", Color(0.8,0.11,0.11))
		else:
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").text = 'Techninque'
				get_node("personbodyparts/"+partname+"/partframe/VBoxContainer/technique/techiquebar/techniquetext").set("custom_colors/font_color", Color(0.45,0.45,0.45))


	#get_node("Label").text = str(member.person.sexexp.tailamount)
	#get_node("Label2").text = str(member.tempsexexp.tailamount)+str(cumonammount)
	#button.get_node("hpbar").set_value(float((person.stats.health_cur)/float(person.stats.health_max))*100)
	#button.get_node("enbar").set_value(float((person.stats.energy_cur)/float(person.stats.energy_max))*100)
	
	
	#for k in ['sstr','sagi','smaf','send']:
	#	button.get_node(k).set_text(str(i[k])+ "/" +str(min(i.stats[globals.maxstatdict[k]], i.originvalue[i.origins])))
	#button.connect("pressed",self,'selectslave',[button])
	#button.set_meta('person', i)
	
func open(place = 'mansion'):
	self.visible = true

func _on_bodyinfoclose_pressed():
	self.visible = false

func partsdescription(part):
	var posx = 569
	if part == 'clit':
		get_node('personbodyparts/description/Label').text = 'Clitoris'
	else:
		get_node('personbodyparts/description/Label').text = part.capitalize()
	if part in ['vagina','penis','clit','crevix','breasts','feets']:
		posx = 196
	get_node('personbodyparts/description').rect_position = Vector2(posx, 148)

func partentered(part):
	get_node('personbodyparts/description').visible = true
	if part == 'mouth':
		get_node('personbodyparts/throat/partframe').visible = false
		get_node('personbodyparts/throat/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/mouth/Label').set("custom_colors/font_color", Color(1,1,1))
	if part == 'throat':
		get_node('personbodyparts/throat/partframe').visible = true
		get_node('personbodyparts/throat/Label').set("custom_colors/font_color", Color(1,1,1))
		get_node('personbodyparts/mouth/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
	if part == 'vagina':
		get_node('personbodyparts/penis/partframe').visible = false
		get_node('personbodyparts/clit/partframe').visible = false
		get_node('personbodyparts/crevix/partframe').visible = false
		get_node('personbodyparts/vagina/Label').set("custom_colors/font_color", Color(1,1,1))
		get_node('personbodyparts/clit/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/penis/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/crevix/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
	if part == 'clit':
		if gender == 'futanari':
			get_node('personbodyparts/penis/partframe').visible = false
			get_node('personbodyparts/clit/partframe').visible = false
			get_node('personbodyparts/crevix/partframe').visible = false
		else:
			get_node('personbodyparts/clit/partframe').visible = true
			get_node('personbodyparts/crevix/partframe').visible = false
		get_node('personbodyparts/vagina/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/clit/Label').set("custom_colors/font_color", Color(1,1,1))
		get_node('personbodyparts/penis/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/crevix/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
	if part == 'crevix':
		get_node('personbodyparts/crevix/partframe').visible = true
		get_node('personbodyparts/description').visible = true
		get_node('personbodyparts/vagina/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/clit/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/penis/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/crevix/Label').set("custom_colors/font_color", Color(1,1,1))
	if part == 'penis':
		get_node('personbodyparts/penis/partframe').visible = true
		get_node('personbodyparts/clit/partframe').visible = false
		get_node('personbodyparts/crevix/partframe').visible = false
		get_node('personbodyparts/vagina/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/clit/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
		get_node('personbodyparts/penis/Label').set("custom_colors/font_color", Color(1,1,1))
		get_node('personbodyparts/crevix/Label').set("custom_colors/font_color", Color(0.45,0.45,0.45))
	if gender == 'futanari':
		if part == 'clit':
			part = 'vagina'
		else:
			part = part
		partsdescription(part)
	else:
		partsdescription(part)

func partexited(part):
	get_node('personbodyparts/description').visible = false

var tempswitch ='cover'
var index = 0
var colarray = []
var valuesarray = []
var split = []

func _on_nextcol_pressed():
	if index < colarray.size()-1:
		index += 1
	else:
		index = 0
	displaycolorhsv()

func _on_prevcol_pressed():
	if index == 0:
		index = colarray.size()-1
	else:
		index -= 1
	displaycolorhsv()

func displaycolorhsv():
	if tempswitch == 'cover':
		colarray = Ccolordict.keys()
		valuesarray = Ccolordict.values()
		curCcolor = colarray[index]
	else:
		colarray = Scolordict.keys()
		valuesarray = Scolordict.values()
		curScolor = colarray[index]
	split = valuesarray[index]
	get_node("Colorchange/LineEdit").text = '"'+str(colarray[index])+'" : ['+str(split[0])+','+str(split[1])+','+str(split[2])+'],'
	tempV = split[2]
	tempS = split[1]
	tempH = split[0]
	get_node("Colorchange/Hue/HHSlider").value = tempH
	get_node("Colorchange/Hue/Hvalue").text = str(tempH)
	get_node("Colorchange/Saturation/SHSlider").value = tempS
	get_node("Colorchange/Saturation/Svalue").text = str(tempS)
	get_node("Colorchange/Value/VHSlider").value = tempV
	get_node("Colorchange/Value/Vvalue").text = str(tempV)
	var new_color = Color()
	new_color.v = tempV #value
	new_color.s = tempS #saturation
	new_color.h = tempH #hue
	get_node("Colorchange/TextureRect").set_modulate(new_color)

func _on_update_pressed():
	tempH = float(get_node("Colorchange/Hue/Hvalue").text)
	tempS = float(get_node("Colorchange/Saturation/Svalue").text)
	tempV = float(get_node("Colorchange/Value/Vvalue").text)
	var merge = [tempH, tempS, tempV]
	if tempswitch == 'cover':
		colarray = Ccolordict.keys()
		Ccolordict[colarray[index]] = merge
	else:
		colarray = Scolordict.keys()
		Scolordict[colarray[index]] = merge
	displaycolorhsv()
	
func _on_add_pressed():
	get_node("Colorchange/colorname").visible = true
	
func _on_addcolor_pressed():
	var color = get_node("Colorchange/colorname/LineEdit").text
	tempH = float(get_node("Colorchange/Hue/Hvalue").text)
	tempS = float(get_node("Colorchange/Saturation/Svalue").text)
	tempV = float(get_node("Colorchange/Value/Vvalue").text)
	var merge = [tempH, tempS, tempV]
	if tempswitch == 'cover':
		colarray = Ccolordict.keys()
		Ccolordict[color] = merge
	else:
		colarray = Scolordict.keys()
		Scolordict[color] = merge
	get_node("Colorchange/colorname").visible = false
	get_node("Colorchange/colorname/LineEdit").text = ''
	displaycolorhsv()
	
func _on_closecname_pressed():
	get_node("Colorchange/colorname").visible = false
	
func _on_LineEdit_text_changed(new_text):
	if tempswitch == 'cover':
		if Ccolordict.has(new_text) == true:
			get_node("Colorchange/colorname/Label").text = "Color exist already"
			get_node("Colorchange/colorname/Label").set("custom_colors/font_color", Color(1,0,0))
			get_node("Colorchange/colorname/addcolor").disabled = true
		else:
			get_node("Colorchange/colorname/Label").text = "Enter the new color name"
			get_node("Colorchange/colorname/Label").set("custom_colors/font_color", Color(1,1,1))
			get_node("Colorchange/colorname/addcolor").disabled = false
	else:
		if Scolordict.has(new_text) == true:
			get_node("Colorchange/colorname/Label").text = "Color exist already"
			get_node("Colorchange/colorname/Label").set("custom_colors/font_color", Color(1,0,0))
			get_node("Colorchange/colorname/addcolor").disabled = true
		else:
			get_node("Colorchange/colorname/Label").text = "Enter the new color name"
			get_node("Colorchange/colorname/Label").set("custom_colors/font_color", Color(1,1,1))
			get_node("Colorchange/colorname/addcolor").disabled = false
	
func _on_Button_pressed():
	if tempswitch == 'cover':
		if curmember.person.furcolor != 'none':
			curmember.person.furcolor = curCcolor
		elif curmember.person.scalescolor != 'none':
			curmember.person.scalescolor = curCcolor
		elif curmember.person.featherscolor != 'none':
			curmember.person.featherscolor = curCcolor
	else:
		if curmember.person.skin != 'none':
			curmember.person.skin = curScolor
	slavebodyinfo(curmember)

func _on_Button2_pressed():
	if tempswitch == 'cover':
		tempswitch = 'skin'
		get_node("Colorchange/TextureRect").set("texture", load("res://files/buttons/inventory/progbaremptyout.png"))
	else:
		tempswitch = 'cover'
		if curmember.person.furcolor != 'none':
			get_node("Colorchange/TextureRect").set("texture", load("res://files/buttons/inventory/skincoverfur.png"))
		elif curmember.person.scalescolor != 'none':
			var saletype = curmember.person.scales
			get_node("Colorchange/TextureRect").set("texture", load("res://files/buttons/inventory/skincover"+saletype+".png"))
		elif curmember.person.featherscolor != 'none':
			get_node("Colorchange/TextureRect").set("texture", load("res://files/buttons/inventory/skincoverfeathers.png"))
	index = 0
	colarray = []
	valuesarray = []
	_on_nextcol_pressed()
	_on_load_pressed()
#	var thiscolor = Color()
#	thiscolor.h  = get_node("TextureRect").modulate.h


func _on_Hvalue_text_changed(new_text):
	tempH = float(new_text)
	var new_color = Color()
	new_color.v = tempV #value
	new_color.s = tempS #saturation
	new_color.h = tempH #hue
	get_node("Colorchange/Hue/HHSlider").value = tempH
	get_node("Colorchange/TextureRect").set_modulate(new_color)
	
func _on_HHSlider_value_changed(value):
	tempH = value
	var new_color = Color()
	new_color.v = tempV #value
	new_color.s = tempS #saturation
	new_color.h = tempH #hue
	get_node("Colorchange/Hue/Hvalue").text = str(tempH)
	get_node("Colorchange/TextureRect").set_modulate(new_color)

func _on_Svalue_text_changed(new_text):
	tempS = float(new_text)
	var new_color = Color()
	new_color.v = tempV #value
	new_color.s = tempS #saturation
	new_color.h = tempH #hue
	get_node("Colorchange/Saturation/SHSlider").value = tempS
	get_node("Colorchange/TextureRect").set_modulate(new_color)
	
func _on_SHSlider_value_changed(value):
	tempS = value
	var new_color = Color()
	new_color.v = tempV #value
	new_color.s = tempS #saturation
	new_color.h = tempH #hue
	get_node("Colorchange/Saturation/Svalue").text = str(tempS)
	get_node("Colorchange/TextureRect").set_modulate(new_color)
	
func _on_Vvalue_text_changed(new_text):
	tempV = float(new_text)
	var new_color = Color()
	new_color.v = tempV #value
	new_color.s = tempS #saturation
	new_color.h = tempH #hue
	get_node("Colorchange/Value/VHSlider").value = tempV
	get_node("Colorchange/TextureRect").set_modulate(new_color)
	
func _on_VHSlider_value_changed(value):
	tempV = value
	var new_color = Color()
	new_color.v = tempV #value
	new_color.s = tempS #saturation
	new_color.h = tempH #hue
	get_node("Colorchange/Value/Vvalue").text = str(tempV)
	get_node("Colorchange/TextureRect").set_modulate(new_color)
	
func _on_Hplus_pressed():
	tempH += 0.01
	Htextset()

func _on_Hminus_pressed():
	tempH -= 0.01
	Htextset()
	
func Htextset():
	get_node("Colorchange/Hue/Hvalue").text = str(tempH)
	
func _on_Splus_pressed():
	tempS += 0.01
	Stextset()

func _on_Sminus_pressed():
	tempS -= 0.01
	Stextset()
	
func Stextset():
	get_node("Colorchange/Saturation/Svalue").text = str(tempS)
	
func _on_Vplus_pressed():
	tempV += 0.01
	Vtextset()

func _on_Vminus_pressed():
	tempV -= 0.01
	Vtextset()
	
func Vtextset():
	get_node("Colorchange/Value/Vvalue").text = str(tempV)

func _on_TextureButton_pressed():
	get_node("Colorchange").visible = true

func _on_CCclose_pressed():
	get_node("Colorchange").visible = false
	

func _on_save_pressed():
	var settings = File.new()
	if tempswitch == 'cover':
		settings.open("user://covercolor.ini", File.WRITE)
		settings.store_line(var2str(Ccolordict))
		settings.close()
	else:
		settings.open("user://skincolor.ini", File.WRITE)
		settings.store_line(var2str(Scolordict))
		settings.close()
		
func _on_load_pressed():
	var settings = File.new()
	if tempswitch == 'cover':
		if settings.file_exists("user://covercolor.ini") == true:
			settings.open("user://covercolor.ini", File.READ)
			var temp = str2var(settings.get_as_text())
			for i in temp:
				if !Ccolordict.has(i):
					Ccolordict[i] = []
			for i in Ccolordict:
				if temp.has(i):
					Ccolordict[i] = temp[i]
			settings.close()
	else:
		if settings.file_exists("user://skincolor.ini") == true:
			settings.open("user://skincolor.ini", File.READ)
			var temp = str2var(settings.get_as_text())
			for i in temp:
				if !Scolordict.has(i):
					Scolordict[i] = []
			for i in Scolordict:
				if temp.has(i):
					Scolordict[i] = temp[i]
			settings.close()

