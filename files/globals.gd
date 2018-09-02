
extends Node

var effectdict = {}
var guildslaves = {wimborn = [], gorn = [], frostford = [], umbra = []}
var gameversion = '0.5.19'
var state = progress.new()
var developmode = false
var gameloaded = false

var mainscreen = 'mainmenu'

var filedir = 'res://files'
var backupdir = 'res://backup'

var resources = resource.new()
var questtext = load("res://files/scripts/questtext.gd").new()
var slavegen = load("res://files/scripts/slavegen.gd").new()
var assets = load("res://files/scripts/assets.gd").new()
var constructor = load("res://files/scripts/characters/constructor.gd").new()
var origins = load("res://files/scripts/origins.gd").new()
var description = load("res://files/scripts/characters/description.gd").new()
var dictionary = load("res://files/scripts/dictionary.gd").new()
var sexscenes = load("res://files/scripts/sexscenes.gd").new()
var glossary = load("res://files/scripts/glossary.gd").new()
var repeatables = load("res://files/scripts/repeatable_quests.gd").new()
var abilities = load("res://files/scripts/abilities.gd").new()
var effects = load("res://files/scripts/effects.gd").new()
var events = load("res://files/scripts/events.gd").new()
var items = load("res://files/scripts/items.gd").new()
var spells = load("res://files/scripts/spells.gd").new()
var spelldict = spells.spelllist
var itemdict = items.itemlist
var racefile = load("res://files/scripts/characters/races.gd").new()
var races = racefile.races
var names = racefile.names
var dailyevents = load("res://files/scripts/dailyevents.gd").new()
var jobs = load("res://files/scripts/jobs&specs.gd").new()
var mansionupgrades = load("res://files/scripts/mansionupgrades.gd").new()
var gallery = load("res://files/scripts/gallery.gd").new()
var slavedialogues = load("res://files/scripts/slavedialogues.gd").new()
var characters = gallery
var patronlist = load("res://files/scripts/patronlists.gd").new()

#QMod - Variables
var mainQuestTexts = events.mainquestTexts
var sideQuestTexts = events.sidequestTexts
var places = {
	anywhere = {region = 'any', location = 'any'},
	nowhere = {region = 'none', location = 'none'}, #For events that aren't triggered by location?
	wimborn = {region = 'wimborn', location = 'any'},
	gorn = {region = 'gorn', location = 'any'},
	frostford = {region = 'frostford', location = 'any'}
}
var main

var slaves = [] setget slaves_set
var starting_pc_races = ['Human', 'Elf', 'Dark Elf', 'Orc', 'Demon', 'Beastkin Cat', 'Beastkin Wolf', 'Beastkin Fox', 'Halfkin Cat', 'Halfkin Wolf', 'Halfkin Fox', 'Taurus']
var wimbornraces = ['Human', 'Elf', 'Dark Elf', 'Demon', 'Beastkin Cat', 'Beastkin Wolf','Beastkin Tanuki','Beastkin Bunny', 'Halfkin Cat', 'Halfkin Wolf', 'Halfkin Tanuki','Halfkin Bunny','Taurus','Fairy']
var gornraces = ['Human', 'Orc', 'Goblin', 'Gnome', 'Taurus', 'Centaur','Beastkin Cat', 'Beastkin Tanuki','Beastkin Bunny', 'Halfkin Cat','Halfkin Bunny','Harpy']
var frostfordraces = ['Human','Elf','Drow','Beastkin Cat', 'Beastkin Wolf', 'Beastkin Fox', 'Beastkin Tanuki','Beastkin Bunny', 'Halfkin Cat', 'Halfkin Wolf', 'Halfkin Fox','Halfkin Bunny', 'Nereid']
var allracesarray = ['Human', 'Elf', 'Dark Elf', 'Orc', 'Drow','Beastkin Cat', 'Beastkin Wolf', 'Beastkin Fox','Beastkin Tanuki','Beastkin Bunny', 'Halfkin Cat', 'Halfkin Wolf', 'Halfkin Fox','Halfkin Tanuki','Halfkin Bunny','Taurus', 'Demon', 'Seraph', 'Gnome','Goblin','Centaur','Lamia','Arachna','Scylla', 'Slime', 'Harpy','Dryad','Fairy','Nereid','Dragonkin']
var banditraces = ['Human', 'Elf', 'Dark Elf', 'Demon', 'Cat', 'Wolf','Bunny','Taurus','Orc','Goblin']
var monsterraces = ['Centaur','Lamia','Arachna','Scylla', 'Slime', 'Harpy','Nereid']
var specarray = ['geisha','ranger','executor','bodyguard','assassin','housekeeper','trapper','nympho','merchant','tamer']
var player = person.new()
var partner
#var clothes = load("res://files/scripts/clothes.gd").costumelist()
#var underwear = load("res://files/scripts/clothes.gd").underwearlist()

var spritedict = gallery.sprites
var musicdict = {
combat1 = load("res://files/music/battle1.ogg"),
combat2 = load("res://files/music/battle2.ogg"),
combat3 = load("res://files/music/battle3.ogg"),
mansion1 = load("res://files/music/mansion1.ogg"),
mansion2 = load("res://files/music/mansion2.ogg"),
mansion3 = load("res://files/music/mansion3.ogg"),
mansion4 = load("res://files/music/mansion4.ogg"),
wimborn = load("res://files/music/wimborn.ogg"),
gorn = load("res://files/music/gorn.ogg"),
frostford = load("res://files/music/frostford.ogg"),
explore = load("res://files/music/exploration.ogg"),
maintheme = load("res://files/music/opening.ogg"),
ending = load("res://files/music/ending.ogg"),
dungeon = load("res://files/music/dungeon.ogg"),
intimate = load("res://files/music/intimate.ogg"),
}
var sounddict = {
door = load("res://files/sounds/door.wav"),
stab = load("res://files/sounds/stab.wav"),
win = load("res://files/sounds/win.wav"),
teleport = load("res://files/sounds/teleport.wav"),
fall = load("res://files/sounds/fall.wav"),
page = load("res://files/sounds/page.wav"),
attack = load("res://files/sounds/normalattack.wav"),
}
var backgrounds = gallery.backgrounds
var scenes = gallery.scenes
var mansionupgradesdict = mansionupgrades.dict
var gradeimages = {
slave = load("res://files/buttons/mainscreen/40.png"),
poor = load("res://files/buttons/mainscreen/41.png"),
commoner = load("res://files/buttons/mainscreen/42.png"),
rich = load("res://files/buttons/mainscreen/43.png"),
noble = load("res://files/buttons/mainscreen/44.png"),
}
var specimages = {
Null = null,
geisha = load("res://files/buttons/mainscreen/33.png"),
ranger = load("res://files/buttons/mainscreen/37.png"),
executor = load("res://files/buttons/mainscreen/39.png"),
bodyguard = load("res://files/buttons/mainscreen/31.png"),
assassin = load("res://files/buttons/mainscreen/30.png"),
housekeeper = load("res://files/buttons/mainscreen/34.png"),
trapper = load("res://files/buttons/mainscreen/38.png"),
nympho = load("res://files/buttons/mainscreen/36.png"),
merchant = load("res://files/buttons/mainscreen/35.png"),
tamer = load("res://files/buttons/mainscreen/32.png"),
}

var sexicon = {
female = load("res://files/buttons/sexicons/female.png"),
male = load("res://files/buttons/sexicons/male.png"),
futanari = load("res://files/buttons/sexicons/futa.png"),
}

#var combatencounterdata = explorationscrips.enemygroup

var noimage = load("res://files/buttons/noimagesmall.png")

var punishcategories = ['spanking','whipping','nippleclap','clitclap','nosehook','mashshow','facesit','afacesit','grovel']

var playerspecs = {
Slaver = "+100% gold from selling captured slaves\n+33% gold reward from slave delivery tasks",
Hunter = "+100% gold drop from random encounters\n+20% gear drop chance\nBonus to preventing ambushes",
Alchemist = "Start with an alchemy room\nDouble potion production\nSelling potions earn 100% more gold",
Mage = "-50% mana cost of spells\nCombat spell deal 20% more damage",
}

func _init():
	if OS.get_executable_path() == 'C:\\Users\\1\\Desktop\\godot\\Godot_v3.0.4-stable_win64.exe':
		developmode = true 
	randomize()
	loadsettings()
	effectdict = effects.effectlist 
#	var tempvars = load("res://mods/variables.gd").duplicate()
#	var tempnode = Node.new()
#	tempnode.set_script(tempvars)
#	for i in variables.list:
#		if tempnode.get(i) != null:
#			variables[i] = tempnode[i]
#	tempnode.queue_free()
	
	if variables.oldemily == true:
		for i in ["emilyhappy", "emilynormal","emily2normal","emily2happy","emily2worried","emilynakedhappy","emilynakedneutral"]:
			spritedict[i] = spritedict['old'+ i]
		characters.characters.Emily.imageportait = "res://files/images/emily/oldemilyportrait.png"
	
	


func savevars():
	var file = File.new()
	var text = 'extends Node\n'
	for i in variables.list:
		text += 'var ' + i + " = " + str(variables[i]) + "\n" 
	file.open("res://mods/variables.gd", File.WRITE)
	file.store_line(text)
	file.close()

func loadsettings():
	var settings = File.new()
	var dir = Directory.new()
	for i in setfolders.values():
		if dir.dir_exists(i) == false:
			dir.make_dir(i)
	if settings.file_exists("user://settings.ini") == false:
		settings.open("user://settings.ini", File.WRITE)
		settings.store_line(var2str(rules))
		settings.close()
	settings.open("user://settings.ini", File.READ)
	var temp = str2var(settings.get_as_text())
	for i in rules:
		if temp.has(i):
			rules[i] = temp[i]
	settings.close()
	var data = {chars = charactergallery, folders = setfolders}
	
	if settings.file_exists("user://progressdata") == false:
		overwritesettings()
	
	settings.open_encrypted_with_pass("user://progressdata", File.READ, 'tehpass')
	var storedsettings = settings.get_var()
	temp = storedsettings.chars
	
	for character in charactergallery:
		if temp.has(character):
			for part in charactergallery[character]:
				if part in ['unlocked', 'nakedunlocked'] && temp[character].has(part):
					charactergallery[character][part] = temp[character][part]
				elif part == 'scenes':
					for scene in range(temp[character][part].size()):
						charactergallery[character][part][scene].unlocked = temp[character][part][scene].unlocked
	if storedsettings.has('folders') == false:
		overwritesettings()
		settings.open_encrypted_with_pass("user://progressdata", File.READ, 'tehpass')
		storedsettings = settings.get_var()
	temp = storedsettings.folders
	for i in temp:
		setfolders[i] = temp[i]
	modfolder = setfolders.mods
	if storedsettings.has('savelist') == false:
		overwritesettings()
		settings.open_encrypted_with_pass("user://progressdata", File.READ, 'tehpass')
		storedsettings = settings.get_var()
	temp = storedsettings.savelist
	for i in temp:
		savelist[i] = temp[i]
	settings.close()

var charactergallery = gallery.charactergallery setget savechars
var setfolders = {portraits = 'user://portraits/', fullbody = 'user://bodies/', mods = 'user://mods/'} setget savefolders
var savelist = {}
var modfolder = setfolders.mods


func savechars(value):
	gallery.charactergallery = value

func savefolders(value):
	overwritesettings()

func overwritesettings():
	var settings = File.new()
	settings.open("user://settings.ini", File.WRITE)
	settings.store_line(var2str(rules))
	settings.close()
	settings.open_encrypted_with_pass("user://progressdata", File.WRITE, 'tehpass')
	var data = {chars = charactergallery, folders = setfolders, savelist = savelist}
	settings.store_var(data)
	settings.close()

func clearstate():
	state = progress.new()
	slaves.clear()
	events = load("res://files/scripts/events.gd").new()
	items = load("res://files/scripts/items.gd").new()
	itemdict = items.itemlist
	spells = load("res://files/scripts/spells.gd").new()
	spelldict = spells.spelllist
	resources.reset()

func newslave(race, age, sex, origins = 'slave'):
	return constructor.newslave(race, age, sex, origins)

func slaves_set(person):
	person.originstrue = person.origins
	person.health = max(person.health, 5)
	person.ability.append("protect")
	person.abilityactive.append("protect")
	slaves.append(person)
	if get_tree().get_current_scene().find_node('CharList'):
		get_tree().get_current_scene().rebuild_slave_list()
	if get_tree().get_current_scene().find_node('ResourcePanel'):
		get_tree().get_current_scene().find_node('population').set_text(str(slavecount())) 
	if globals.get_tree().get_current_scene().has_node("infotext"):
		globals.get_tree().get_current_scene().infotext("New Character acquired: " + person.name_long(),'green')

func loadimage(path):
	var file = File.new()
	if typeof(path) == TYPE_OBJECT:
		return path
	if path == null:
		return
	if path.find('res:') >= 0:
		return load(path)
	var image = Image.new()
	if File.new().file_exists(path):
		image.load(path)
	var temptexture = ImageTexture.new()
	temptexture.create_from_image(image)
	return temptexture

func slavecount():
	var number = 0
	for i in slaves:
		if i.away.at != 'hidden':
			number += 1
	return number



var rules = {
futa = true,
futaballs = false,
furry = true,
furrynipples = true,
male_chance = 15,
futa_chance = 10,
children = false,
noadults = false,
slaverguildallraces = false,
fontsize = 14,
musicvol = 24,
soundvol = 24,
receiving = true,
fullscreen = false,
oldresize = true,
fadinganimation = true,
permadeath = false,
autoattack = true,
enddayalise = 1,
spritesindialogues = true,
instantcombatanimation = false,
randomcustomportraits = true,
}




class resource:
	var day = 1 setget day_set
	var gold = 0 setget gold_set
	var mana = 0 setget mana_set
	var energy = 0 setget energy_set
	var food = 0 setget food_set
	var upgradepoints = 0 setget upgradepoints_set
	var panel
	var array = ['day','gold','mana','energy','food']
	
	var foodcaparray = [500, 750, 1000, 1500, 2000, 3000]
	
	func update():
		for i in array:
			self[i] += 0
	
	func reset():
		day = 1
		gold = 0
		mana = 0
		energy = 0
		food = 0
	
	func gold_set(value):
		value = round(value)
		var color
		var difference = gold - value
		var text = ""
		gold = value
		if gold < 0:
			gold = 0
		if panel != null:
			panel.get_node('gold').set_text(str(gold))
		
		
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " gold"
				color = 'green'
			else:
				color = 'red'
				text = "Lost " + str(abs(difference)) +  " gold"
		
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)
	
	func day_set(value):
		day = value
		if day < 0:
			day = 0
		if panel != null:
			panel.get_node('day').set_text(str(day))
	
	func food_set(value):
		value = round(value)
		var color
		var difference = round(food - value)
		var text = ""
		food = clamp(value, 0, foodcaparray[globals.state.mansionupgrades.foodcapacity])
		if panel != null:
			panel.get_node('food').set_text(str(food))
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " food"
				color = 'green'
			else:
				text = "Lost " + str(abs(difference)) +  " food"
				color = 'red'
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)
	
	func mana_set(value):
		value = round(value)
		var color
		var difference = mana - value
		var text = ""
		mana = value
		if mana < 0:
			mana = 0
		
		if panel != null:
			panel.get_node('mana').set_text(str(mana))
		
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " mana"
			else:
				text = "Used " + str(abs(difference)) +  " mana"
		
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)
		
		
	
	func upgradepoints_set(value):
		var difference = upgradepoints - value
		var bonus = 0
		if difference < 0:
			for i in globals.slaves:
				if i.traits.has("Gifted"):
					bonus = ceil(abs(difference) * 0.2)
		var text = ""
		upgradepoints = value + bonus
		
		
		if difference < 0:
			text = "Obtained " + str(abs(difference)+bonus) +  " Mansion Upgrade Points"
		
		
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,'green')
	
	func energy_set(value):
		if panel != null:
			panel.get_node("energy").set_text(str(round(globals.player.energy)))

class progress:
	var tutorialcomplete = false
	var supporter = false
	var location = 'wimborn'
	var nopoplimit = false
	var condition = 85 setget cond_set
	var conditionmod = 1.3
	var spec = ''
	var farm = 0 
	var apiary = 0
	var branding = 0
	var slaveguildvisited = 0
	var umbrafirstvisit = true
	var itemlist = {}
	var spelllist = {}
	var mainquest = 0
	var mainquestcomplete = false
	var rank = 0
	var password = ''
	var sidequests = {startslave = 0, emily = 0, brothel = 0, cali = 0, caliparentsdead = false, chloe = 0, ayda = 0, ivran = '', yris = 0, zoe = 0, ayneris = 0, sebastianumbra = 0, maple = 0} setget quest_set
	var repeatables = {wimbornslaveguild = [], frostfordslaveguild = [], gornslaveguild = []}
	var babylist = []
	var companion = -1
	var headgirlbehavior = 'none'
	var portals = {wimborn = {'enabled' : false, 'code' : 'wimborn'}, gorn = {'enabled':false, 'code' : 'gorn'}, frostford = {'enabled':false, 'code' : 'frostford'}, amberguard = {'enabled':false, 'code':'amberguard'}, umbra = {'enabled':false, 'code':'umbra'}}
	var sebastianorder = {race = 'none', taken = false, duration = 0}
	var sebastianslave
	var sandbox = false
	var snails = 0
	var groupsex = true
	var playergroup = []
	var timedevents = {}
	var customcursor = "res://files/buttons/kursor1.png"
	var upcomingevents = []
	var reputation = {wimborn = 0, frostford = 0, gorn = 0, amberguard = 0} setget reputation_set
	var dailyeventcountdown = 0
	var dailyeventprevious = 0
	var currentversion = 5000
	var unstackables = {}
	var supplykeep = 10
	var foodbuy = 200
	var supplybuy = false
	var tutorial = {basics = false, person = false, alchemy = false, jail = false, lab = false, farm = false, outside = false, combat = false, interactions = false}
	var itemcounter = 0
	var slavecounter = 0
	var alisecloth = 'normal'
	var decisions = []
	var lorefound = []
	var relativesdata = {}
	var descriptsettings = {full = true, basic = true, appearance = true, genitals = true, piercing = true, tattoo = true, mods = true}
	var mansionupgrades = {
	farmcapacity = 0,
	farmhatchery = 0,
	farmtreatment = 0,
	foodcapacity = 0,
	foodpreservation = 0,
	jailcapacity = 1,
	jailtreatment = 0,
	jailincenses = 0,
	mansioncommunal = 4,
	mansionpersonal = 1,
	mansionbed = 0,
	mansionluxury = 0,
	mansionalchemy = 0,
	mansionlibrary = 0,
	mansionlab = 0,
	mansionkennels = 0,
	mansionnursery = 0,
	mansionparlor = 0,
	}
	var plotsceneseen = []
	var capturedgroup = []
	var ghostrep = {wimborn = 0, frostford = 0, gorn = 0, amberguard = 0}
	var backpack = {stackables = {}, unstackables = []} setget backpack_set
	var restday = 0
	var defaultmasternoun = "Master"
	var sexactions = 1
	var nonsexactions = 1
	var actionblacklist = []
	
	func quest_set(value):
		sidequests = value
		if globals.mainscreen != 'mainmenu':
			globals.main.infotext('Side Quest Advanced',"yellow")
	
	func calculateweight():
		var slave
		var tempitem
		var currentweight = 0
		var maxweight = 10 + max(globals.player.sstr*4, 0)
		var array = [globals.player]
		for i in globals.state.playergroup:
			slave = globals.state.findslave(i)
			array.append(slave)
			maxweight += max(slave.sstr*5,0) + 3
		for i in globals.state.backpack.stackables:
			if globals.itemdict[i].has('weight'):
				currentweight += globals.itemdict[i].weight * globals.state.backpack.stackables[i]
		
		for i in globals.state.unstackables.values():
			if i.has('weight') && str(i.owner) == 'backpack':
				currentweight += i.weight
		for i in array:
			for k in i.gear.values():
				if k != null && globals.state.unstackables[k].code == 'acctravelbag': maxweight += 20
		var dict = {currentweight = currentweight, maxweight = maxweight, overload = maxweight < currentweight}
		return dict
	
	func reputation_set(value):
		var text = ''
		var color
		for i in value:
			if ghostrep[i] != value[i]:
				value[i] = min(max(value[i], -50),50)
				if ghostrep[i] > value[i]:
					text += "Reputation with " + i.capitalize() + " has worsened!"
					color = 'red'
				else:
					text += "Reputation with " + i.capitalize() + " has increased!"
					color = 'green'
				ghostrep[i] = value[i]
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)

	
	func cond_set(value):
		condition += value*conditionmod
		if condition > 100:
			condition = 100
		elif condition < 0:
			condition = 0
	
	func findbaby(id):
		var rval
		for i in babylist:
			if str(i.id) == str(id):
				rval = i
		return rval
	
	func findslave(id):
		var rval
		if str(globals.player.id) == str(id):
			return globals.player
		for i in range(0, globals.slaves.size()):
			if str(globals.slaves[i].id) == str(id):
				rval = globals.slaves[i]
		return rval
	
	func backpack_set(value):
		backpack = value
		checkbackpack()
	
	func checkbackpack():
		for i in backpack.stackables:
			if backpack.stackables[i] <= 0:
				backpack.stackables.erase(i)

class person:
	var name = ''
	var surname = ''
	var nickname = ''
	var unique = null
	var id = 0
	var race = ''
	var age = ''
	var mindage = ''
	var sex = ''
	var spec = null
	var imageportait = null
	var imagefull = null
	var haircolor = ''
	var hairlength = ''
	var hairstyle = ''
	var eyecolor = ''
	var skin = ''
	var height = ''
	var titssize = ''
	var asssize = ''
	var eyeshape = 'normal'
	var eyesclera = 'normal'
	var arms = 'normal'
	var legs = 'normal'
	var bodyshape = 'humanoid'
	var skincov = 'none'
	var furcolor = 'none'
	var ears = 'human'
	var tail = 'none'
	var wings = 'none'
	var horns = 'none'
	var beauty = 0 setget ,beauty_get
	var beautybase = 0 setget beautybase_set
	var beautytemp = 0 
	
	var asser = 0
	var pubichair = 'clean'
	
	var fear = 0 setget fear_set,fear_get
	var fear_mod = 1
	
	var lewdness = 0 setget lewdness_set
	var lactation = false
	var titsextra = 0
	var titsextradeveloped = false
	var consent = false
	var vagina = 'normal'
	var vagvirgin = true
	var mouthvirgin = true
	var assvirgin = true
	var penisvirgin = true
	var penis = 'none'
	var balls = 'none'
	var penistype = 'human'
	var penisextra = 0
	var sensvagina = 0
	var sensmouth = 0
	var senspenis = 0
	var sensanal = 0
	var knowntechniques = []
	
	
	var state = 'normal'
	var preg = {fertility = 0, has_womb = true, duration = 0, baby = null}
	var rules = {'silence':false, 'pet':false, 'contraception':false, 'aphrodisiac':false, 'masturbation':false, 'nudity':false, 'betterfood':false, 'personalbath':false,'cosmetics':false,'pocketmoney':false}
	var traits = []
	var gear = {costume = null, underwear = null, armor = null, weapon = null, accessory = null}
	var genes = {}
	var effects = {}
	var brand = 'none'
	var work = 'rest'
	var sleep = ''
	var farmoutcome = false
	
	var ability = ['attack']
	var abilityactive = ['attack']
	var customdesc = ''
	var piercing = {earlobes = null, eyebrow = null, nose = null, lips = null, tongue = null, navel = null, nipples = null, clit = null, labia = null, penis = null}
	var tattoo = {chest = 'none', face = 'none', ass = 'none', arms = 'none', legs = 'none', waist = 'none'}
	var level = 1
	var xp = 0 setget xp_set, xp_get
	var realxp = 0
	var skillpoints = 2
	var levelupreqs = {} setget levelupreqs_set
	var away = {duration = 0, at = ''}
	var cattle = {is_cattle = false, work = '', used_for = 'food'}
	var mods = {}
	var tattooshow = {chest = true, face = true, ass = true, arms = true, legs = true, waist = true}
	var tags = []
	var origins = 'slave'
	var originstrue = ''
	var memory = ''
	var attention = 0
	var sexuals = {actions = {}, unlocked = false, affection = 0, kinks = {}, unlocks = [], lastaction = ''}
	var kinks = []
	var forcedsex = false
	var sexexp = {partners = {}, watchers = {}, actions = {}, seenactions = {}, orgasms = {}, orgasmpartners = {}}
	var sensation = {}
	var metrics = {ownership = 0, jail = 0, mods = 0, brothel = 0, sex = 0, partners = [], randompartners = 0, item = 0, spell = 0, orgy = 0, threesome = 0, win = 0, capture = 0, goldearn = 0, foodearn = 0, manaearn = 0, birth = 0, preg = 0, vag = 0, anal = 0, oral = 0, roughsex = 0, roughsexlike = 0, orgasm = 0}
	var fromguild = false
	var masternoun = 'Master'
	var lastinteractionday = 0
	var lastsexday = 0
	var learningpoints = 0 setget learningpoints_set
	var luxury = 0
	
	var relations = {}
	
	var stats = {
		str_max = 0,
		str_mod = 0,
		str_base = 0,
		agi_max = 0, 
		agi_mod = 0,
		agi_base = 0,
		maf_max = 0,
		maf_mod = 0,
		maf_base = 0,
		end_base = 0,
		end_mod = 0,
		end_max = 0,
		cour_max = 100,
		cour_base = 0,
		conf_max = 100,
		conf_base = 0,
		wit_max = 100,
		wit_base = 0,
		charm_max = 100,
		charm_base = 0,
		obed_cur = 0.0,
		obed_max = 100,
		obed_min = 0,
		obed_mod = 1,
		stress_cur = 0.0,
		stress_max = 120,
		stress_min = 0,
		stress_mod = 1,
		tox_cur = 0.0,
		tox_max = 100,
		tox_min = 0,
		tox_mod = 1,
		lust_cur = 0,
		lust_max = 100,
		lust_min = 0,
		lust_mod = 0,
		health_cur = 0,
		health_max = 100,
		health_base = 0,
		health_bonus = 0,
		energy_cur = 75,
		energy_max = 100,
		energy_mod = 0,
		armor_cur = 0,
		armor_max = 0,
		armor_base = 0,
		loyal_cur = 0.0,
		loyal_mod = 1,
		loyal_max = 100,
		loyal_min = 0,
	}
	var health setget health_set,health_get
	var obed setget obed_set,obed_get
	var stress setget stress_set,stress_get
	var loyal setget loyal_set,loyal_get
	var cour setget cour_set,cour_get
	var conf setget conf_set,conf_get
	var wit setget wit_set,wit_get
	var charm setget charm_set,charm_get
	var lust setget lust_set,lust_get
	var toxicity setget tox_set,tox_get
	var energy setget energy_set,energy_get
	var sstr setget str_set,str_get
	var sagi setget agi_set,agi_get
	var smaf setget maf_set,maf_get
	var send setget end_set,end_get
	
	func fear_raw(value):
		fear += value
	
	
	func get_traits():
		var array = []
		for i in traits:
			array.append(globals.origins.trait(i))
		return array
	
	func add_trait(trait, remove = false):
		trait = globals.origins.trait(trait)
		var conflictexists = false
		var text = ""
		var traitexists = false
		for i in get_traits():
			if i.name == trait.name:
				traitexists = true
			for ii in i.conflict:
				if trait.name == ii:
					conflictexists = true
		if traitexists || conflictexists:
			return
		else:
			traits.append(trait.name)
			if globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.find(self) >= 0 && away.at != 'hidden':
				text += self.dictionary("$name acquired new trait: " + trait.name)
				globals.get_tree().get_current_scene().infotext(text,'yellow')
			if trait['effect'].empty() != true:
				add_effect(trait['effect'])
	
	func trait_remove(trait):
		var text = ''
		trait = globals.origins.trait(trait)
		if traits.find(trait.name) < 0:
			return
		traits.erase(trait.name)
		if trait['effect'].empty() != true:
			add_effect(trait['effect'], true)
		text += self.dictionary("$name lost trait: " + trait.name)
		if globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.find(self) >= 0 && away.at != 'hidden':
			globals.get_tree().get_current_scene().infotext(text,'yellow')
	
	func levelupreqs_set(value):
		levelupreqs = value
	
	func lewdness_set(value):
		lewdness = clamp(round(value), 0, 120)
	
	func fear_set(value):
		var difference = value - fear
		if difference > 0:
			difference = difference - difference*self.cour/200
		
		fear += round(difference*fear_mod)
		fear = clamp(fear, 0, 100+self.wit/2)
	
	func fear_get():
		return fear
	
	func levelup():
		levelupreqs.clear()
		level += 1
		skillpoints += variables.skillpointsperlevel
		realxp = 0
		self.loyal += rand_range(5,10)
		if self != globals.player:
			globals.get_tree().get_current_scene().infotext(dictionary("$name has advanced to Level " + str(level)),'green')
		else:
			globals.get_tree().get_current_scene().infotext(dictionary("You have advanced to Level " + str(level)),'green')
	
	func xp_set(value):
		var difference = value - realxp
		realxp += max(difference/max(level,1),1)
		realxp = round(clamp(realxp, 0, 100))
		if realxp >= 100 && self == globals.player:
			levelup()
	
	
	func xp_get():
		return realxp
	
	func getessence():
		var essence
		if race in ['Demon', 'Arachna', 'Lamia']:
			essence = 'taintedessenceing'
		elif race in ['Fairy', 'Drow', 'Dragonkin']:
			essence = 'magicessenceing'
		elif race == 'Dryad':
			essence = 'natureessenceing'
		elif race in ['Harpy', 'Centaur'] || race.find('Beastkin') >= 0 || race.find('Halfkin') >= 0:
			essence = 'bestialessenceing'
		elif race in ['Slime','Nereid', "Scylla"]:
			essence = 'fluidsubstanceing'
		return essence
	
	
	func cleartraits():
		spec = null
		while !traits.empty():
			trait_remove(traits.back())
		for i in ['str_base','agi_base', 'maf_base', 'end_base']:
			stats[i] = 0
		skillpoints = 2
		level = 1
		xp = 0
	
	func add_effect(effect, remove = false):
		effect = effect.duplicate()
		if effects.has(effect.code):
			if remove == true:
				effects.erase(effect.code)
				for i in effect:
					if stats.has(i):
						stats[i] = stats[i] + -effect[i]
					elif self.get(i) != null:
						self[i] -= effect[i]
		elif remove != true:
			effects[effect.code] = effect
			for i in effect:
				if stats.has(i):
					stats[i] = stats[i] + effect[i]
				elif self.get(i) != null:
					self[i] += effect[i]
	
	
	func beauty_get():
		return beautybase + beautytemp
	
	
	func health_set(value):
		stats.health_max = max(10, ((variables.basehealth + (stats.end_base+stats.end_mod)*variables.healthperend) + floor(level/2)*5) + stats.health_bonus)
		stats.health_cur = clamp(floor(value), 0, stats.health_max) 
		if stats.health_cur <= 0:
			death()
	
	func obed_set(value):
		var difference = stats.obed_cur - value
		var string = ""
		var color
		var text = ""
		stats.obed_mod = clamp(stats.obed_mod, 0.2, 2)
		if difference > 0:
			difference = abs(difference)
			if abs(difference) < 20:
				string = "(-)"
			elif abs(difference) < 40:
				string = "(--)"
			else:
				string = "(---)"
			stats.obed_cur -= difference
			text = self.dictionary("$name's obedience has decreased " + string)
			color = 'red'
		else:
			difference = abs(difference)
			if abs(difference) < 20:
				string = "(+)"
			elif abs(difference) < 40:
				string = "(++)"
			else:
				string = "(+++)"
			text = self.dictionary("$name's obedience has grown " + string)
			color = 'green'
			stats.obed_cur += difference*stats.obed_mod
		
		stats.obed_cur = clamp(stats.obed_cur, stats.obed_min, stats.obed_max)
		if stats.obed_cur < 50 && spec == 'executor':
			stats.obed_cur = 50
	
	func loyal_set(value):
		var difference = stats.loyal_cur - value
		var string = ""
		var color
		var text = ""
		if difference > 0:
			difference = abs(difference)
			if abs(difference) < 5:
				string = "(-)"
			elif abs(difference) < 10:
				string = "(--)"
			else:
				string = "(---)"
			stats.loyal_cur -= difference
			text = self.dictionary("$name's loyalty decreased " + string)
			color = 'red'
		elif difference < 0:
			difference = abs(difference)
			if abs(difference) < 5:
				string = "(+)"
			elif abs(difference) < 10:
				string = "(++)"
			else:
				string = "(+++)"
			text = self.dictionary("$name's loyalty grown " + string)
			color = 'green'
			stats.loyal_cur += difference*stats.loyal_mod
		
		
		stats.loyal_cur = max(min(stats.loyal_cur, stats.loyal_max),stats.loyal_min)
#		if globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.find(self) >= 0 && away.at != 'hidden':
#			globals.get_tree().get_current_scene().infotext(text,color)
	
	func stress_set(value):
		
		var difference = value - stats.stress_cur 
		difference = difference*stats.stress_mod
		var endvalue = stats.stress_cur + difference
		var text = ""
		var color
		if stats.stress_cur < 99 && endvalue >= 99:
			text += "$name is about to suffer from mental breakdown... "
			color = 'red'
		if stats.stress_cur < 66 && endvalue >= 66:
			text += "$name has become considerably stressed. "
			color = 'red'
		elif (stats.stress_cur < 33 || stats.stress_cur >= 66) && (endvalue >= 33 && endvalue < 66):
			text += "$name has become mildly stressed. "
			color = 'yellow'
		elif stats.stress_cur >= 33 && endvalue < 33:
			text += "$name is no longer stressed. "
			color = 'green'
		
		stats.stress_cur = clamp(endvalue, stats.stress_min, stats.stress_max)
		if text != '' && globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.has(self) && away.at != 'hidden':
			globals.get_tree().get_current_scene().infotext(self.dictionary(text),color)
		if self == globals.player:
			stats.stress_cur = 0
	
	func mentalbreakdown():
		self.cour -= rand_range(5,self.cour/4)
		self.conf -= rand_range(5,self.conf/4)
		self.wit -= rand_range(5,self.wit/4)
		self.charm -= rand_range(5,self.charm/4)
		if self.effects.has('captured'):
			self.add_effect(globals.effectdict.captured, true)
		if sleep != 'farm':
			self.health -= rand_range(0, stats.health_max/5)
		self.stress -= 30
	
	func learningpoints_set(value):
		
		var difference = learningpoints - value
		var string = ""
		var text = ""
		var color
		if difference < 0:
			difference = abs(difference)
			string = difference
			text = self.dictionary("$name has acquired " + str(string) + " learning points. " )
			color = 'green'
		
		if globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.find(self) >= 0 && away.at != 'hidden':
			globals.get_tree().get_current_scene().infotext(text,color)
		learningpoints = value
	
	func tox_set(value):
		var difference = value - stats.tox_cur
		stats.tox_cur = clamp(stats.tox_cur + difference*stats.tox_mod, stats.tox_min, stats.tox_max)
	
	func energy_set(value):
		value = round(value)
		var difference = value - stats.energy_cur
		stats.energy_cur = clamp(stats.energy_cur + difference*(1 + stats.energy_mod/100), 0, stats.energy_max)
		if self == globals.player:
			globals.resources.energy = 0
	
	var originvalue = {'slave' : 55, 'poor' : 65, 'commoner' : 75, 'rich' : 85, 'atypical' : 85, 'noble' : 100}
	
	func cour_set(value):
		stats.cour_base = clamp(value, 0, min(stats.cour_max, originvalue[origins]))
	
	func conf_set(value):
		stats.conf_base = clamp(value, 0, min(stats.conf_max, originvalue[origins]))
	
	func wit_set(value):
		stats.wit_base = clamp(value, 0, min(stats.wit_max, originvalue[origins]))
	
	func charm_set(value):
		stats.charm_base = clamp(value, 0, min(stats.charm_max, originvalue[origins]))
	
	func lust_set(value):
		var difference = value - stats.lust_cur
		if difference > 0:
			stats.lust_cur = clamp(stats.lust_cur + difference*(1 + stats.lust_mod/100),stats.lust_min,stats.lust_max)
		else:
			stats.lust_cur = clamp(stats.lust_cur + difference,stats.lust_min,stats.lust_max)
	
	func str_set(value):
		stats.str_base = min(stats.str_base, stats.str_max)
	
	func agi_set(value):
		stats.agi_base = min(stats.agi_base, stats.agi_max)
	
	func maf_set(value):
		stats.maf_base = min(stats.maf_base, stats.maf_max)
	
	func end_set(value):
		var plushealth = false
		if stats.end_base < value:
			plushealth = true
		stats.end_base = min(stats.end_base, stats.end_max)
		if plushealth:
			self.health += variables.healthperend
		else:
			self.health = self.health
	
	
	
	func beautybase_set(value):
		value = round(value)
		beautybase = min(max(value,0),100)
	
	func loyal_get():
		return stats.loyal_cur
	
	func health_get():
		return stats.health_cur
	
	func obed_get():
		return stats.obed_cur
	
	func stress_get():
		return stats.stress_cur
	
	func cour_get():
		return floor(stats.cour_base)
	
	func conf_get():
		return floor(stats.conf_base)
	
	func wit_get():
		return floor(stats.wit_base)
	
	func charm_get():
		return floor(stats.charm_base)
	
	func lust_get():
		return stats.lust_cur
	
	
	func tox_get():
		return stats.tox_cur
	
	func energy_get():
		return stats.energy_cur
	
	func str_get():
		return stats.str_base + stats.str_mod
	
	func agi_get():
		return stats.agi_base + stats.agi_mod
	
	func maf_get():
		return stats.maf_base + stats.maf_mod
	
	func end_get():
		return stats.end_base + stats.end_mod
	
	func awareness():
		var number = 0
		number = self.sagi*3 + self.wit/10
		if mods.has('augmenthearing'):
			number += 3
		if globals.state.spec == 'Hunter':
			number += 10
		if effects.has("tribal1"):
			number += 3
		elif effects.has('tribal2'):
			number += 6
		elif effects.has('tribal3'):
			number += 9
		return number
	
	
	func health_icon():
		var health
		if float(stats.health_cur)/stats.health_max > 0.75: 
			health = load("res://files/buttons/icons/health/2.png")
		elif float(stats.health_cur)/stats.health_max > 0.4:
			health = load("res://files/buttons/icons/health/1.png")
		else:
			health = load("res://files/buttons/icons/health/3.png")
		return health
	
	func obed_icon():
		var obed
		if float(stats.obed_cur)/stats.obed_max > 0.75: 
			obed = load("res://files/buttons/icons/obedience/2.png")
		elif float(stats.obed_cur)/stats.obed_max > 0.4:
			obed = load("res://files/buttons/icons/obedience/1.png")
		else:
			obed = load("res://files/buttons/icons/obedience/3.png")
		return obed
	
	func stress_icon():
		var icon
		if stats.stress_cur >= 66: 
			icon = load("res://files/buttons/icons/stress/3.png")
		elif stats.stress_cur >= 33:
			icon = load("res://files/buttons/icons/stress/1.png")
		else:
			icon = load("res://files/buttons/icons/stress/2.png")
		return icon
	
	
	func name_long():
		var text = ''
		if nickname == '':
			text = name
		else:
			text = '"' + nickname + '" ' + name
		if surname != "":
			text += " " + surname
		
		return text
	
	func name_short():
		if nickname == '':
			return name
		else:
			return nickname
	
	func race_short():
		if race.find("Beastkin") >= 0:
			return race.replace("Beastkin ", 'B.')
		elif race.find("Halfkin") >= 0:
			return race.replace("Halfkin ", "H.")
		else:
			return race
	
	func dictionary(text):
		var string = text
		string = string.replace('$name', name_short())
		string = string.replace('$surname', surname)
		string = string.replace('$penis', globals.fastif(penis == 'none', 'strapon', '$his cock'))
		string = string.replace('$child', globals.fastif(sex == 'male', 'boy', 'girl'))
		string = string.replace('$sex', sex)
		string = string.replace('$He', globals.fastif(sex == 'male', 'He', 'She'))
		string = string.replace('$he', globals.fastif(sex == 'male', 'he', 'she'))
		string = string.replace('$His', globals.fastif(sex == 'male', 'His', 'Her'))
		string = string.replace('$his', globals.fastif(sex == 'male', 'his', 'her'))
		string = string.replace('$him', globals.fastif(sex == 'male', 'him', 'her'))
		string = string.replace('$son', globals.fastif(sex == 'male', 'son', 'daughter'))
		string = string.replace('$sibling', globals.fastif(sex == 'male', 'brother', 'sister'))
		string = string.replace('$sir', globals.fastif(sex == 'male', 'Sir', "Ma'am"))
		string = string.replace('$race', globals.decapitalize(race).replace('_', ' '))
		string = string.replace('$playername', globals.player.name_short())
		string = string.replace('$master', masternoun)
		string = string.replace('[haircolor]', haircolor)
		string = string.replace('[eyecolor]', eyecolor)
		return string
	
	func dictionaryplayer(text):
		var string = text
		string = string.replace('[Playername]', globals.player.name_short())
		string = string.replace('$name', name_short())
		string = string.replace('$penis', globals.fastif(penis == 'none', 'strapon', '$his cock'))
		string = string.replace('$child', globals.fastif(sex == 'male', 'boy', 'girl'))
		string = string.replace('$sex', sex)
		string = string.replace('$He', 'You')
		string = string.replace('$he', 'you')
		string = string.replace('$His', 'Your')
		string = string.replace('$his', 'your')
		string = string.replace('$him', 'your')
		string = string.replace('$child', globals.fastif(sex == 'male', 'son', 'daughter'))
		string = string.replace('$sibling', globals.fastif(sex == 'male', 'brother', 'sister'))
		string = string.replace('$sir', globals.fastif(sex == 'male', 'Sir', "Ma'am"))
		string = string.replace('$master', globals.fastif(sex == 'male', 'Master', "Mistress"))
		string = string.replace('[haircolor]', haircolor)
		string = string.replace('[eyecolor]', eyecolor)
		string = string.replace('$race', globals.decapitalize(race).replace('_', ' '))
		return string
	
	func dictionaryplayerplus(text):
		var string = text
		string = string.replace(' has', ' have')
		string = string.replace(' Has', ' have')
		string = string.replace('You is', 'You are')
		string = string.replace("You's", "You're")
		string = string.replace('appears', 'appear')
		return string
	
	func description():
		return globals.description.getslavedescription(self)
	
	func descriptionsmall():
		return globals.description.getslavedescription(self, 'compact')
	
	func status():
		return globals.description.getstatus(self)
	
	func countluxury():
		var templuxury = luxury
		var goldspent = 0
		var foodspent = 0
		var nosupply = false
		var value = 0
		if sleep == 'personal':
			templuxury += 10+(5*globals.state.mansionupgrades.mansionluxury)
		elif sleep == 'your':
			templuxury += 5+(5*globals.state.mansionupgrades.mansionluxury)
		if rules.betterfood == true && globals.resources.food >= 5:
			globals.resources.food -= 5
			foodspent += 5
			templuxury += 5
		if rules.personalbath == true:
			if spec != 'housekeeper':
				value = 2
			else:
				value = 1
			if globals.itemdict.supply.amount >= value:
				templuxury += 5
				globals.itemdict.supply.amount -= value
			else:
				nosupply == true
		if rules.pocketmoney == true:
			if spec != 'housekeeper':
				value = 10
			else:
				value = 5
			if globals.resources.gold >= value:
				templuxury += value
				goldspent += value
				globals.resources.gold -= value
		if rules.cosmetics == true:
			if globals.itemdict.supply.amount > 1:
				templuxury += 5
				globals.itemdict.supply.amount -= 1
			else:
				nosupply = true
		
		var luxurydict = {luxury = templuxury, goldspent = goldspent, foodspent = foodspent, nosupply = nosupply}
		return luxurydict
	
	func calculateluxury():
		var luxury = variables.luxuryreqs[origins]
		if traits.has("Ascetic"):
			luxury = luxury/2
		elif traits.has("Spoiled"):
			luxury *= 2
		return luxury
	
	
	
	func calculateprice():
		var price = 0
		var bonus = 1
		price = beautybase*variables.priceperbasebeauty + beautytemp*variables.priceperbonusbeauty
		price += (level-1)*variables.priceperlevel
		if variables.racepricemods.has(race):
			price = price*variables.racepricemods[race]
		if vagvirgin == true:
			bonus += variables.pricebonusvirgin
		if sex == 'futanari':
			bonus += variables.pricebonusfuta
		for i in get_traits():
			if i.tags.has('detrimental'):
				bonus += variables.pricebonusbadtrait

		if self.toxicity >= 60:
			bonus -= variables.pricebonustoxicity
		
		if variables.gradepricemod.has(origins):
			bonus += variables.gradepricemod[origins]
		if variables.agepricemods.has(age):
			bonus += variables.agepricemods[age]
		
		
		if traits.has('Uncivilized'):
			bonus -= variables.priceuncivilized
		
		
		price = price*bonus
		
		if price < 0:
			price = variables.priceminimum
		return round(price)
	
	func buyprice():
		return calculateprice()
	
	func sellprice(alternative = false):
		var price = calculateprice()*0.6
		
		if effects.has('captured') == true && alternative == false:
			price = price/2
		for i in globals.slaves:
			if i.traits.has("Influential"):
				price *= 1.2
		price = max(round(price), variables.priceminimumsell)
		if globals.state.spec == 'Slaver' && fromguild == false:
			price *= 2
		return price
	
	func death():
		if globals.slaves.has(self):
			globals.main.infotext(self.dictionary("$name has deceased. "),'red')
			globals.items.unequipall(self)
			globals.slaves.erase(self)
			if globals.state.relativesdata.has(id):
				globals.state.relativesdata[id].state = 'dead'
		elif globals.state.babylist.has(self):
			globals.state.babylist.erase(self)
			globals.clearrelativesdata(self.id)
		globals.state.playergroup.erase(self.id)
	
	func removefrommansion():
		globals.slaves.erase(self)
		globals.main.infotext(self.dictionary("$name $surname is no longer in your possession. "),'red')
		globals.items.unequipall(self)
		if globals.state.relativesdata.has(id):
			globals.state.relativesdata[id].state = 'left'
	
	func abortion():
		if preg.duration > 0:
			preg.duration = 0
			var baby = globals.state.findbaby(preg.baby)
			preg.baby = null
			baby.death()
	
	func checksex():
		var male = false
		var female = false
		
		if penis != 'none':
			male = true
		if vagina != 'none':
			female = true
		
		if male && female:
			return 'futanari'
		elif male:
			return 'male'
		else:
			return 'female'
	
	func fetch(dict):
		for key in dict:
			var tv = dict[key]
			if typeof(tv) == TYPE_DICTIONARY:
				globals.merge(self[key], dict[key])
			elif typeof(tv) == TYPE_INT:
				self[key] = self[key] + dict[key]
			else:
				self[key] = dict[key]
	

func addrelations(person, person2, value):
	if person == player || person2 == player:
		return
	if person.relations.has(person2.id) == false:
		person.relations[person2.id] = 0
	if person2.relations.has(person.id) == false:
		person2.relations[person.id] = 0
	if person.relations[person2.id] > 500 && value > 0 && checkifrelatives(person, person2):
		value = value/1.5
	elif person.relations[person2.id] < -500 && value < 0 && checkifrelatives(person,person2):
		value = value/1.5
	person.relations[person2.id] += value
	person.relations[person2.id] = clamp(person.relations[person2.id], -1000, 1000)
	person2.relations[person.id] = person.relations[person2.id]
	if person.relations[person2.id] < -200 && value < 0:
		person.stress += rand_range(4,8)
		person2.stress += rand_range(4,8)

func randomportrait(person):
	var portraitbase
	var imagearray = []
	
	for i in portraitbase:
		if i.has(person[i]) == false:
			continue
		imagearray.append(i)
	
	person.imageportait = imagearray[randi()*imagearray.size()]


static func count_sleepers():
	var your_bed = 0
	var personal_room = 0
	var jail = 0
	var farm = 0
	var communal = 0
	var rval = {}
	for i in globals.slaves:
		if i.away.at != 'hidden':
			if i.sleep == 'personal':
				personal_room += 1
			elif i.sleep == 'your':
				your_bed += 1
			elif i.sleep == 'jail':
				jail += 1
			elif i.sleep == 'farm':
				farm += 1
			elif i.sleep == 'communal':
				communal += 1
	rval.personal = personal_room
	rval.your_bed = your_bed
	rval.jail = jail
	rval.farm = farm
	rval.communal = communal
	return rval

func impregnation(mother, father = null, anyfather = false):
	var realfather
	if father == null:
		var gender
		realfather = -1
		if globals.rules.futa == true:
			gender = ['male','futanari']
		else:
			gender = ['male']
		if anyfather == false:
			father = globals.newslave('randomcommon', 'random', gender[rand_range(0,gender.size())])
		else:
			father = globals.newslave('randomany', 'random', gender[rand_range(0,gender.size())])
	else:
		if father.penis == 'none':
			return
#		realfather = father.id
	if mother.preg.has_womb == false || mother.preg.duration > 0 || mother == father || mother.effects.has("contraceptive"):
		return
	var rand = rand_range(0,100)
	if globals.developmode == true:
		rand = 0
	if mother.preg.fertility < rand:
		if mother.traits.has("Infertile") || father.traits.has("Infertile"):
			mother.preg.fertility += rand_range(2,5)
		else:
			mother.preg.fertility += rand_range(5,10)
		return
	var age = ''
	var babyrace = mother.race
	if globals.rules.children == true:
		age = 'child'
	else: 
		age = 'teen'
	if (mother.race.find('Beastkin') >= 0 && father.race.find('Beastkin') < 0)|| (father.race.find('Beastkin') >= 0 && mother.race.find('Beastkin') < 0):
		if father.race.find('Beastkin') >= 0 && mother.race in ['Human','Elf','Dark Elf','Drow','Demon','Seraph']:
			babyrace = father.race.replace('Beastkin', 'Halfkin')
		else:
			babyrace = mother.race.replace('Beastkin', 'Halfkin')
		
	var baby = globals.newslave(babyrace, age, 'random', mother.origins)
	baby.state = 'fetus'
	baby.surname = mother.surname
	var array = ['skin','tail','ears','wings','horns','arms','legs','bodyshape','haircolor','eyecolor','eyeshape','eyesclera']
	for i in array:
		if rand_range(0,10) > 5:
			baby[i] = father[i]
		else:
			baby[i] = mother[i]
	if baby.race.find('Halfkin')>=0 && mother.race.find('Beastkin') >= 0 && father.race.find('Beastkin') < 0:
		baby.bodyshape = 'humanoid'
	if father.beautybase > mother.beautybase:
		baby.beautybase = father.beautybase + rand_range(-2,5)
	else:
		baby.beautybase = mother.beautybase + rand_range(-2,5)
	baby.cleartraits()
	
	var traitpool = father.traits + mother.traits
	for i in traitpool:
		if rand_range(0,100) <= variables.traitinheritchance:
			baby.add_trait(i)
	
	if rand_range(0,100) <= variables.babynewtraitchance:
		baby.add_trait(globals.origins.traits('any').name)
	
	connectrelatives(mother, baby, 'mother')
	if realfather != -1:
		connectrelatives(father, baby, 'father')
	mother.preg.baby = baby.id
	mother.preg.duration = 1
	
	mother.metrics.preg += 1
	globals.state.babylist.append(baby)

var baby


func connectrelatives(person1, person2, way):
	if person1 == null || person2 == null:
		return
	if globals.state.relativesdata.has(person1.id) == false:
		createrelativesdata(person1)
	if globals.state.relativesdata.has(person2.id) == false:
		createrelativesdata(person2)
	if way in ['mother','father']:
		var entry = globals.state.relativesdata[person1.id]
		entry.children.append(person2.id)
		for i in entry.children:
			if i != person2.id:
				var entry2 = globals.state.relativesdata[i]
				connectrelatives(person2, entry2, 'sibling')
		entry = globals.state.relativesdata[person2.id]
		entry[way] = person1.id
		if typeof(person1) != TYPE_DICTIONARY && typeof(person2) != TYPE_DICTIONARY:
			addrelations(person1, person2, 200)
	elif way == 'sibling':
		var entry = globals.state.relativesdata[person1.id]
		var entry2 = globals.state.relativesdata[person2.id]
		if entry.siblings.has(entry2.id) == false: entry.siblings.append(entry2.id)
		if entry2.siblings.has(entry.id) == false: entry2.siblings.append(entry.id)
		for i in entry.siblings + entry2.siblings:
			if !globals.state.relativesdata[i].siblings.has(entry.id) && i != entry.id:
				globals.state.relativesdata[i].siblings.append(entry.id)
			if !globals.state.relativesdata[i].siblings.has(entry2.id) && i != entry2.id:
				globals.state.relativesdata[i].siblings.append(entry2.id)
			if !entry.siblings.has(i) && i != entry.id:
				entry.siblings.append(i)
			if !entry2.siblings.has(i) && i != entry2.id:
				entry2.siblings.append(i)
		
		if typeof(person1) != TYPE_DICTIONARY && typeof(person2) != TYPE_DICTIONARY:
			addrelations(person1, person2, 0)


func createrelativesdata(person):
	var newdata = {name = person.name_long(), state = person.state, id = person.id, race = person.race, sex = person.sex, mother = -1, father = -1, siblings = [], halfsiblings = [], children = []}
	globals.state.relativesdata[person.id] = newdata

func clearrelativesdata(id):
	var entry
	if globals.state.relativesdata.has(id):
		entry = globals.state.relativesdata[id]
		
		for i in ['mother','father']:
			if globals.state.relativesdata.has(entry[i]):
				var entry2 = globals.state.relativesdata[entry[i]]
				entry2.children.erase(id)
		for i in entry.siblings:
			if globals.state.relativesdata.has(i):
				var entry2 = globals.state.relativesdata[i]
				entry2.siblings.erase(id)
		
	
	globals.state.relativesdata.erase(id)

func checkifrelatives(person, person2):
	var result = false
	var data1 
	var data2
	if globals.state.relativesdata.has(person.id):
		data1 = globals.state.relativesdata[person.id]
	else:
		createrelativesdata(person)
		data1 = globals.state.relativesdata[person.id]
	if globals.state.relativesdata.has(person2.id):
		data2 = globals.state.relativesdata[person2.id]
	else:
		createrelativesdata(person2)
		data2 = globals.state.relativesdata[person2.id]
	for i in ['mother','father']:
		if str(data1[i]) == str(data2.id) || str(data2[i]) == str(data1.id):
			result = true
	for i in [data1, data2]:
		if i.siblings.has(data1.id) || i.siblings.has(data2.id):
			result = true
	
	
	return result

func showtooltip(text):
	var screen = get_viewport().get_visible_rect()
	var tooltip = main.get_node("tooltip")
	main.get_node("tooltip/RichTextLabel").set_bbcode(text)
	var pos = main.get_global_mouse_position()
	pos = Vector2(pos.x+20, pos.y+20)
	tooltip.set_position(pos)
	tooltip.visible = true
	yield(get_tree(), "idle_frame")
	tooltip.get_node("RichTextLabel").rect_size.y = main.get_node("tooltip/RichTextLabel").get_v_scroll().get_max()
	tooltip.rect_size.y = main.get_node("tooltip/RichTextLabel").rect_size.y + 30
	if tooltip.get_rect().end.x >= screen.size.x:
		tooltip.rect_global_position.x -= tooltip.get_rect().end.x - screen.size.x
	if tooltip.get_rect().end.y >= screen.size.y:
		tooltip.rect_global_position.y -= tooltip.get_rect().end.y - screen.size.y

func hidetooltip():
	main.get_node("tooltip").visible = false
	slavetooltiphide()
	itemtooltiphide()

func slavetooltip(person):
	var text = ''
	var node = main.get_node('slavetooltip')
	if node == null:
		return
	node.visible = true
	text += "Level: " + str(person.level)
	text += "\n[color=yellow]" + person.race.capitalize() + "[/color]\n" 
	description.person = person
	text += description.getbeauty(true).capitalize() + '\n' + person.age.capitalize()
	node.get_node("portrait").texture = loadimage(person.imageportait)
	node.get_node("portrait").visible = !node.get_node('portrait').texture == null
	node.get_node("name").text = person.name_long()
	if globals.player == person:
		node.get_node("name").set('custom_colors/font_color', Color(1,1,0))
		node.get_node("name").text = "Master " + node.get_node("name").text
	else:
		node.get_node("name").set('custom_colors/font_color', Color(1,1,1))
	if person != globals.player:
		node.get_node("spec").set_texture(specimages[str(person.spec)])
	node.get_node("grade").set_texture(gradeimages[person.origins])
	node.get_node("spec").visible = !globals.player == person
	node.get_node("grade").visible = !globals.player == person
	node.get_node("text").bbcode_text = text
	node.get_node("sex").texture = globals.sexicon[person.sex]
	
	text = 'Traits: '
	if person.traits.size() > 0:
		text += "[color=aqua]"
		for i in person.traits:
			text += i + ', '
		text = text.substr(0, text.length() - 2) + '.[/color]'
	else:
		text += "None"
	
	node.get_node('traittext').bbcode_text = text
	
	var screen = get_viewport().get_visible_rect()
	var pos = main.get_global_mouse_position()
	pos = Vector2(pos.x+20, pos.y+20)
	node.set_position(pos)
	if node.get_rect().end.x >= screen.size.x:
		node.rect_global_position.x -= node.get_rect().end.x - screen.size.x
	if node.get_rect().end.y >= screen.size.y:
		node.rect_global_position.y -= node.get_rect().end.y - screen.size.y

func slavetooltiphide(empty = null):
	if get_tree().get_current_scene().has_node('slavetooltip'):
		get_tree().get_current_scene().get_node('slavetooltip').visible = false

func openslave(person):
	if person == globals.player:
		main._on_selfbutton_pressed()
	elif globals.slaves.has(person) && person.away.duration == 0:
		main.openslavetab(person)

func itemtooltip(item):
	var text = itemdescription(item, true)
	var node = main.get_node('itemtooltip')
	if node == null:
		return
	node.visible = true
	node.get_node("image").texture = loadimage(item.icon)
	node.get_node('text').bbcode_text = text
	
	var screen = get_viewport().get_visible_rect()
	var pos = main.get_global_mouse_position()
	pos = Vector2(pos.x+20, pos.y+20)
	node.set_position(pos)
	if node.get_rect().end.x >= screen.size.x:
		node.rect_global_position.x -= node.get_rect().end.x - screen.size.x
	if node.get_rect().end.y >= screen.size.y:
		node.rect_global_position.y -= node.get_rect().end.y - screen.size.y
	

func itemtooltiphide(empty = null):
	if get_tree().get_current_scene().has_node('itemtooltip'):
		get_tree().get_current_scene().get_node('itemtooltip').visible = false

func gradetooltip(person):
	var text = ''
	for i in globals.originsarray:
		if i == person.origins:
			text += '[color=green] ' + i.capitalize() + '[/color]'
		else:
			text += i.capitalize()
		if i != 'noble':
			text += ' - '
	text += '\n\n' + globals.dictionary.getOriginDescription(person)
	globals.showtooltip(text)

static func merge(target, patch):
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge(tv, patch[key])
			elif typeof(tv) == TYPE_INT || typeof(tv) == TYPE_REAL:
				target[key] = target[key] + patch[key]
			else:
				target[key] = patch[key]
		else:
			target[key] = patch[key]

static func merge_overwrite(target, patch):
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge(tv, patch[key])
			else:
				target[key] = patch[key]
		else:
			target[key] = patch[key]

static func mergeclass(target, patch):
	for key in patch:
		target[key] = patch[key]

static func mergearrays(target, patch):
	var count = 0
	for key in patch:
		target[count] = patch[count]
		count += 1

static func fastif(formula, result1, result2):
	if formula == true:
		return result1
	else:
		return result2

static func find_trait(array, trait):
	var result = false
	for i in array:
		if i.name == trait:
			result = true
	return result

func getcodefromarray(array, code):
	var rval = false
	for i in array:
		if i.code == code:
			rval = i
	return rval

static func decapitalize(text):
	text = text.to_lower()
	text = text.replace(' ', '_')
	return text

static func sortbyname(first, second):
	if first.name < second.name:
		return true
	else:
		return false

static func sortbycost(first, second):
	if first.cost < second.cost:
		return true
	elif first.cost == second.cost:
		if first.name < second.name:
			return true
		else:
			return false
	else:
		return false

static func sortbynumber(first, second):
	if first.number < second.number:
		return true
	else:
		return false


var hairlengtharray = ['ear','neck','shoulder','waist','hips']
var sizearray = ['masculine','flat','small','average','big','huge']
var heightarray = ['petite','short','average','tall','towering']
var agesarray = ['child','teen','adult']
var genitaliaarray = ['small','average','big']
var originsarray = ['slave','poor','commoner','rich','noble']
var longtails = ['cat','fox','wolf','demon','dragon','scruffy','snake tail','racoon']
var skincovarray = ['none','scales','feathers','full_body_fur', 'plants']
var penistypearray = ['human','canine','feline','equine']
var alltails = ['cat','fox','wolf','bunny','bird','demon','dragon','scruffy','snake tail','racoon']
var allwings = ['feathered_black', 'feathered_white', 'feathered_brown', 'leather_black','leather_red','insect']
var allears = ['human','feathery','pointy','short_furry','long_pointy_furry','fins','long_round_furry', 'long_droopy_furry']
var statsdict = {sstr = 'Strength', sagi = 'Agility', smaf = "Magic Affinity", send = "Endurance", cour = 'Courage', conf = 'Confidence', wit = 'Wit', charm = 'Charm'}
var maxstatdict = {sstr = 'str_max', sagi = 'agi_max', smaf = 'maf_max', send = 'end_max', cour = 'cour_max', conf = 'conf_max', wit = 'wit_max', charm = 'charm_max'}
var basestatdict = {sstr = 'str_base', sagi = 'agi_base', smaf = 'maf_base', send = 'end_base', cour = 'cour_base', conf = 'conf_base', wit = 'wit_base', charm = 'charm_base'}
var statsdescript = dictionary.statdescription
var sleepdict = {communal = {name = 'Communal Room'}, jail = {name = "Jail"}, personal = {name = 'Personal Room'}, your = {name = "Your bed"}}


func itemdescription(item, short = false):
	var text = ''
	var name = ''
	name = item.name
	if short == false:
		text += item.description + '\n\n'
	elif !item.has('owner'):
		text += item.description
	if item.has('owner'):
		#text += '\n\n'
		if item.enchant == 'basic':
			name = '[color=green]' + name + '[/color]'
		elif item.enchant == 'unique':
			name = '[color=#cc8400]' + name + '[/color]'
		for i in item.effects:
			text += i.descript + "\n"
	if item.type == 'gear':
		text += '\n\n'
		for i in item.effect:
			text += i.descript + "\n"
	if item.has('weight'):
		text += "\n[color=yellow]Weight: " + str(item.weight) + "[/color]"
	return '[center]' + name + '[/center]\n' + text

#saveload system
func save():
	var array = []
	var dict = {}
	for i in spelldict:
		if spelldict[i].learned == true:
			state.spelllist[i] = true
	for i in itemdict:
		if itemdict[i].amount > 0:
			state.itemlist[i] = {}
			state.itemlist[i].amount = itemdict[i].amount
	dict.resources = inst2dict(resources)
	dict.state = inst2dict(state)
	dict.state.currentversion = gameversion
	dict.slaves = []
	dict.babylist = []
	if globals.state.sebastianorder.taken == true:
		dict.sebastianslave = inst2dict(state.sebastianslave)
	for i in slaves:
		dict.slaves.append(inst2dict(i))
	for i in state.babylist:
		dict.babylist.append(inst2dict(i))
	dict.player = inst2dict(player) 
	return dict

func save_game(var savename):
	var savegame = File.new()
	var dir = Directory.new()
	if dir.dir_exists("user://saves") == false:
		dir.make_dir("user://saves")
	savegame.open(savename, File.WRITE)
	var nodedata = save()
	savelistentry(savename)
	overwritesettings()
	savegame.store_line(to_json(nodedata))
	savegame.close()
	get_tree().get_current_scene().infotext("Game Saved.",'green')

func savelistentry(savename):
	var date = OS.get_datetime()
	for i in date:
		if int(date[i]) < 10:
			date[i] = '0' + str(date[i])
		else:
			date[i] = str(date[i])
	var entry = {name = "Master " + player.name + "\nDay: " + str(resources.day) + '\nGold: [color=yellow] ' + str(resources.gold) + '[/color]\nSlaves: ' + str(slavecount()), path = savename, date = date.hour + ":" + date.minute + " " + date.day + '.' + date.month + '.' + date.year, portrait = player.imageportait}
	savelist[savename] = entry

func load_game(text):
	var savegame = File.new()
	var newslave
	if !savegame.file_exists(text):
		return #Error!  We don't have a save to load
	clearstate()
	var currentline = {} 
	savegame.open(text, File.READ)
	currentline = parse_json(savegame.get_as_text())
	get_tree().change_scene("res://files/Mansion.scn")
	for i in currentline.values():
		if i.has("@path") && i['@path'] in ["res://globals.gdc",'res://globals.gdc']:
			i['@path'] = "res://globals.gd"
		if i.has("@path"):
			i['@path'] = i['@path'].replace('.gdc','.gd')
	if currentline.resources['@subpath'] == '':
		currentline.resources['@subpath'] = "resource"
		currentline.player['@subpath'] = 'person'
		currentline.state['@subpath'] = 'progress'
	if currentline.resources['@path'] == "res://globals.gd":
		currentline.resources['@path'] = "res://files/globals.gd"
		currentline.player['@path'] = 'res://files/globals.gd'
		currentline.state['@path'] = 'res://files/globals.gd'
		for i in currentline.values():
			if typeof(i) == TYPE_DICTIONARY:
				if i['@path'].find("res://globals.gd") >= 0:
					i['@path'] = i['@path'].replace("res://globals.gd", "res://files/globals.gd")
			
			if i.has('stats') && i.stats.has("str_cur"):
				i.stats.str_base = i.stats.str_cur
				i.stats.agi_base = i.stats.agi_cur
				i.stats.maf_base = i.stats.maf_cur
				i.stats.end_base = i.stats.end_cur
			elif typeof(i) == TYPE_ARRAY:
				for k in i:
					if k['@path'].find("res://globals.gd") >= 0:
						k['@path'] = k['@path'].replace("res://globals.gd", "res://files/globals.gd")
					if k.has('stats') && k.stats.has("str_cur"):
						k.stats.str_base = k.stats.str_cur
						k.stats.agi_base = k.stats.agi_cur
						k.stats.maf_base = k.stats.maf_cur
						k.stats.end_base = k.stats.end_cur
					if k.has('stats') && k.stats.obed_mod <= 0:
						k.stats.obed_mod = 1
	if currentline.has('sebastianslave'):
		currentline.sebastianslave['@subpath'] = 'person'
	resources = dict2inst(currentline.resources)
	player = dict2inst(currentline.player)
	state = dict2inst(currentline.state)
	var statetemp = progress.new()
	for i in statetemp.reputation:
		if state.ghostrep.has(i) == false:
			state.ghostrep[i] = statetemp.reputation[i]
		if state.reputation.has(i) == false:
			state.reputation[i] = statetemp.reputation[i]
	for i in state.itemlist:
		if itemdict.has(i):
			itemdict[i].amount = state.itemlist[i].amount
	for i in statetemp.sidequests:
		if state.sidequests.has(i) == false:
			state.sidequests[i] = statetemp.sidequests[i]
	for i in statetemp.tutorial:
		if state.tutorial.has(i) == false:
			state.tutorial[i] = statetemp.tutorial[i]
	state.itemlist = {}
	for i in state.spelllist:
		spelldict[i].learned = true
	state.spelllist = {}
	if globals.state.sebastianorder.taken == true:
		state.sebastianslave = person.new()
		state.sebastianslave = dict2inst(currentline.sebastianslave)
	state.babylist.clear()
	for i in currentline.slaves:
		newslave = person.new()
		if i['@path'].find('.gdc') >= 0:
			i['@path'] = i['@path'].replace('.gdc', '.gd')
		if i['@subpath'] == '':
			i['@subpath'] = 'person'
		newslave = dict2inst(i)
		if i.has('face'):
			newslave.beautybase = round(i.face.beauty)
		slaves.append(newslave)
	for i in currentline.babylist:
		newslave = person.new()
		if i['@path'].find('.gdc'):
			i['@path'] = i['@path'].replace('.gdc', '.gd')
		if i['@subpath'] == '':
			i['@subpath'] = 'person'
		newslave = dict2inst(i)
		if i.has('face'):
			newslave.beautybase = round(i.face.beauty)
		state.babylist.append(newslave)
	savegame.close()
	if state.customcursor == null:
		Input.set_custom_mouse_cursor(null)
	else:
		state.customcursor = "res://files/buttons/kursor1.png"
	
	
	gameloaded = true
	if str(state.currentversion) != str(gameversion):
		print("Using old save, attempting repair")
		repairsave()
	

func repairsave():
	state.currentversion = gameversion
	for person in [player] + slaves + state.babylist:
		person.id = str(person.id)
		if person.sexexp.has('partners') == false:
			person.sexexp = {partners = {}, watchers = {}, actions = {}, seenactions = {}, orgasms = {}, orgasmpartners = {}}
	for i in globals.state.unstackables.values():
		if i.enchant == null:
			i.enchant = ''
	globals.state.playergroup.clear()

var showalisegreet = false

func dir_contents(target = "user://saves"):
	var dir = Directory.new()
	var array = []
	if dir.open(target) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				array.append(target + "/" + file_name)
			elif !file_name in ['.','..', null] && dir.current_is_dir():
				array += dir_contents(target + "/" + file_name)
			file_name = dir.get_next()
		return array
	else:
		print("An error occurred when trying to access the path.")

var currentslave
var currentsexslave

func evaluate(input): #used to read strings as conditions when needed
	var script = GDScript.new()
	script.set_source_code("var person\nfunc eval():\n\treturn " + input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	obj.person = currentslave
	return obj.eval()

func weightedrandom(array): #array must be made out of dictionaries with {value = name, weight = number} Number is relative to other elements which may appear
	var total = 0
	var counter = 0
	for i in array:
		if typeof(i) == TYPE_DICTIONARY:
			total += i.weight
		else:
			total += i[1]
	var random = rand_range(0,total)
	for i in array:
		if typeof(i) == TYPE_DICTIONARY:
			if counter + i.weight >= random:
				return i.value
			counter += i.weight
		else:
			if counter + i[1] >= random:
				return i[0]
			counter += i[1]

func randomfromarray(array):
	return array[rand_range(0,array.size())]

func buildportrait(node, person):
	var array = ['race','hairlength','ears'] #add more pieces of layers in order they should be added
	var imagedict = { #should have all pieces you added to the array with paths
	race = {human = load('humanheadimage.png'), elf = load('elfheadimage.png')},
	hairlength = {long = load('longhairimage.png'), short = load('shorthairimage.png')},
	ears = {normal = load('normalears.png'), pointy = load('pointyearsimg.png')},
	} 
	for i in array:
		var newlayer = node.duplicate()
		node.add_child(newlayer)
		newlayer.set_texture(imagedict[i][person[i]])

func checkfurryrace(text):
	if text in ['Cat','Wolf','Fox','Bunny','Tanuki']:
		if rules.furry == true:
			if rand_range(0,1) >= 0.5:
				text = 'Halfkin ' + text
			else:
				text = 'Beastkin ' + text
		else:
			text = 'Halfkin ' + text
	return text
