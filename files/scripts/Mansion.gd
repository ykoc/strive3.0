
extends Node

var test = File.new()
var testslaverace = globals.allracesarray
var testslaveage = 'random'
var testslavegender = 'random'
var testslaveorigin = ['slave','poor','commoner','rich','noble']
var currentslave = 0 setget currentslave_set
var selectedslave = -1
var texture = null
var startcombatzone = "grove"
var nameportallocation
onready var maintext = '' setget maintext_set, maintext_get
onready var exploration = get_node("explorationnode")
onready var slavepanel = get_node("MainScreen/slave_tab")

signal animfinished

func _process(delta):
	if get_node("dialogue").visible == false && get_node("popupmessage").visible == false && checkforevents == true:
		nextdayevents()
		checkforevents = false
	for i in get_tree().get_nodes_in_group("messages"):
		if i.modulate.a > 0:
			i.modulate.a = (i.modulate.a - delta)
	
	if shaking == true && _timer >= 0:
		var shake_amount = 10
		$Camera2D.set_offset(Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount))
		_timer -= delta
	elif shaking == true && _timer < 0:
		$Camera2D.set_offset(Vector2(0,0))
		shaking = false
		_timer = 0.0
	
	$screenchange.visible = (float($screenchange.modulate.a) > 0)
	if musicfading == true && get_node("music").get_volume_db() != 0 && get_node("music").playing:
		get_node("music").set_volume_db(get_node('music').get_volume_db() - delta*20)
		if get_node("music").get_volume_db() <= 0:
			musicfading = false
			get_node("music").set_volume_db(0)
			musicvalue = $music.get_playback_position()
			get_node("music").playing = false
	if musicraising == true && get_node("music").volume_db < globals.rules.musicvol && get_node("music").playing:
		get_node("music").set_volume_db(get_node('music').get_volume_db() + delta*20)
		if get_node("music").get_volume_db() >= globals.rules.musicvol:
			musicraising = false
			get_node("music").set_volume_db(globals.rules.musicvol)

var shaking = false
var _timer = 0.0

func shake(duration):
	shaking = true
	_timer = duration

var musicfading = false
var musicraising = false
var musicvalue = 0

func maintext_set(value):
	var wild = $explorationnode.zones[$explorationnode.currentzone.code].combat == true
	$outside/textpanel.visible = !wild
	$outside/exploreprogress.visible = wild
	$outside/textpanelexplore.visible = wild
	$outside/textpanel/outsidetextbox.bbcode_text = value
	$outside/textpanelexplore/outsidetextbox2.bbcode_text = value


func maintext_get():
	var wild = $explorationnode.zones[$explorationnode.currentzone.code].combat == true
	var text = ''
	if wild == false:
		text = $outside/textpanel/outsidetextbox.bbcode_text
	else:
		text = $outside/textpanelexplore/outsidetextbox2.bbcode_text
	return text

func currentslave_set(value):
	currentslave = value
	globals.items.person = globals.slaves[currentslave]
	get_node("spellnode").person = globals.slaves[currentslave]

func _input(event):
	var anythingvisible = false
	for i in get_tree().get_nodes_in_group("blockmaininput"):
		if i.is_visible_in_tree() == true:
			anythingvisible = true
			break
	if event.is_echo() == true || event.is_pressed() == false || anythingvisible || get_node("screenchange/AnimationPlayer").is_playing():
		if event.is_action_pressed("escape") == true && get_node("tutorialnode").visible == true:
			get_node("tutorialnode").close()
		return
	if event.is_action_pressed("escape") == true && $ResourcePanel/menu.visible == true && $ResourcePanel/menu.disabled == false:
		if get_node("FinishDayPanel").is_visible_in_tree():
			get_node("FinishDayPanel").hide()
			return
		if !get_node("menucontrol").is_visible_in_tree():
			_on_menu_pressed()
		else:
			if get_node("menucontrol/menupanel/SavePanel").is_visible_in_tree():
				get_node("menucontrol/menupanel/SavePanel").hide()
			_on_closemenu_pressed()
	
	if event.is_action_pressed("F") && get_node("Navigation/end").is_visible_in_tree():
		_on_end_pressed()
	elif event.is_action_pressed("Q") && get_node("MainScreen").is_visible_in_tree():
		mansion()
	elif event.is_action_pressed("W") && get_node("MainScreen").is_visible_in_tree():
		jail()
	elif event.is_action_pressed("E") && get_node("MainScreen").is_visible_in_tree():
		libraryopen()
	elif event.is_action_pressed("A") && get_node("MainScreen").is_visible_in_tree() && !get_node("Navigation/alchemy").is_disabled():
		alchemy()
	elif event.is_action_pressed("S") && get_node("MainScreen").is_visible_in_tree() && !get_node("Navigation/laboratory").is_disabled():
		laboratory()
	elif event.is_action_pressed("Z") && get_node("MainScreen").is_visible_in_tree() && !get_node("Navigation/farm").is_disabled():
		farm()
	elif event.is_action_pressed("X") && get_node("MainScreen").is_visible_in_tree() && !$MainScreen/mansion/portals.is_disabled():
		portals()
	elif event.is_action_pressed("C") && get_node("MainScreen").is_visible_in_tree():
		leave()
	elif event.is_action_pressed("B") && get_node("MainScreen").is_visible_in_tree():
		_on_inventory_pressed()
	elif event.is_action_pressed("R") && get_node("MainScreen").is_visible_in_tree():
		_on_personal_pressed()
	elif event.is_action_pressed("V") && get_node("MainScreen").is_visible_in_tree():
		_on_combatgroup_pressed()
	elif event.is_action_pressed("L") && get_node("MainScreen").is_visible_in_tree():
		_on_questlog_pressed()

func _ready():
	get_node("music").set_meta('currentsong', 'none')
	if OS.get_executable_path() == 'C:\\Users\\1\\Desktop\\godot\\Godot_v3.0.2-stable_win64.exe':
		globals.developmode = true
		get_node("startcombat").show()
		get_node("new slave button").show()
		get_node("debug").show()
	rebuildrepeatablequests()
	globals.main = self
	globals.resources.panel = get_node("ResourcePanel")
	if globals.player.name == '':
		globals.player = globals.newslave('Human', 'teen', 'male')
		globals.player.relatives.father = 0
		globals.player.relatives.mother = 0
		globals.player.ability.append('escape')
		globals.player.ability.append('acidspit')
		globals.player.abilityactive.append('escape')
		globals.player.abilityactive.append('acidspit')
		globals.state.supporter = true
		for i in globals.gallery.charactergallery.values():
			i.unlocked = true
			i.nakedunlocked = true
			for k in i.scenes:
				k.unlocked = true
		_on_new_slave_button_pressed()
	rebuild_slave_list()
	get_node("spellnode").main = get_tree().get_current_scene()
	get_node("birthpanel/raise/childpanel/child").connect('pressed', self, 'babyage', ['child'])
	get_node("birthpanel/raise/childpanel/teen").connect('pressed', self, 'babyage', ['teen'])
	get_node("birthpanel/raise/childpanel/adult").connect('pressed', self, 'babyage', ['adult'])
	#exploration
	get_node("explorationnode").buttoncontainer = get_node("outside/buttonpanel/outsidebuttoncontainer")
	get_node("explorationnode").button = get_node("outside/buttonpanel/outsidebuttoncontainer/buttontemplate")
	get_node("explorationnode").main = self
	get_node("explorationnode").outside = get_node('outside')
	globals.events.outside = get_node("outside")
	globals.resources.update()
	
	for i in get_tree().get_nodes_in_group("invcategories"):
		i.connect("pressed",self,"selectcategory",[i])
	
	for i in get_tree().get_nodes_in_group("mansionbuttons"):
		i.connect("pressed",self,i.get_name())
	
	for i in get_tree().get_nodes_in_group("spellbookcategory"):
		i.connect("pressed",self,'spellbookcategory',[i])
	
	if globals.state.tutorialcomplete == false && globals.resources.day == 1:
		get_node("tutorialnode").starttutorial()
	
	if globals.showalisegreet == true:
		alisegreet()
	elif globals.gameloaded == true:
		infotext("Game Loaded.",'green')
	
	for i in ['sstr','sagi','smaf','send']:
		self[i].get_node('Control').connect('mouse_entered', self, 'stattooltip',[i])
		self[i].get_node('Control').connect('mouse_exited', globals, 'hidetooltip')
		self[i].get_node('Button').connect("pressed",self,'statup', [i])
	
	_on_mansion_pressed()
	#startending()

func sound(value):
	$soundeffect.stream = globals.sounddict[value]
	$soundeffect.playing = true
	$soundeffect.autoplay = false

func startending():
	var name = globals.player.name + " - Main Quest Completed"
	var scene = load("res://files/ending.tscn").instance()
	animationfade(3)
	yield(get_node("screenchange/AnimationPlayer"), 'animation_finished')
	scene.add_to_group('blockmaininput')
	add_child(scene)
	move_child(scene, 40)
	scene.launch()
	music_set('ending')
	#scene.advance()
	if globals.developmode == false:
		globals.save_game('user://saves/'+name)
	if globals.state.decisions.has('hadekeep'):
		globals.slaves = globals.characters.create("Melissa")
	globals.state.mainquestcomplete = true


func _on_new_slave_button_pressed():
	globals.resources.day = 2
	for i in globals.state.tutorial:
		globals.state.tutorial[i] = true
	#music_set('mansion')
	get_node("music").play(100)
	#globals.state.capturedgroup.append(globals.newslave(testslaverace[rand_range(0,testslaverace.size())], testslaveage, testslavegender, testslaveorigin[rand_range(0,testslaveorigin.size())]))
	var person = globals.newslave(testslaverace[rand_range(0,testslaverace.size())], testslaveage, testslavegender, testslaveorigin[rand_range(0,testslaveorigin.size())])
	person.obed += 100
	person.loyal += 100
	person.xp += 9990
	person.sexuals.affection = 200
	person.consent = true
	person.sexuals.unlocked = true
	person.sexuals.unlocks.append('group')
	person.sexuals.unlocks.append('swing')
	person.lust = 100
	#slave.tattoo.face = 'nature'
	person.attention = 70
	person.skillpoints = 100
	for i in ['conf','cour','charm','wit']:
		person[i] = 100
	person.ability.append('debilitate')
	for i in globals.state.portals.values():
		i.enabled = true
	for i in globals.spelldict.values():
		i.learned = true
	for i in globals.itemdict.values():
		i.unlocked = true
		if !i.type in ['gear','dummy']:
			i.amount += 10
	for i in ['armorchain','weaponclaymore','clothpet','clothkimono','underwearlacy','armortentacle','accamuletemerald','accamuletemerald','clothtentacle']:
		var tmpitem = globals.items.createunstackable(i)
		globals.state.unstackables[str(tmpitem.id)] = tmpitem
		globals.items.enchantrand(tmpitem)
	globals.slaves = person
	person.stats.health_cur = 5
	globals.state.reputation.wimborn = 41
	globals.state.sidequests.ivran = 'potionreceived'
	globals.player.ability.append("mindread")
	globals.player.abilityactive.append("mindread")
	globals.player.abilityactive.append("sedation")
	globals.player.abilityactive += ["aimedstrike"]
	globals.player.ability.append('heal')
	#globals.player.stats.maf_cur = 3
	globals.state.branding = 2
	globals.resources.gold += 1000
	globals.resources.food += 1000
	globals.resources.mana += 5
	globals.player.energy += 100
	globals.player.xp += 50
	globals.resources.upgradepoints += 100
	
	globals.state.sidequests.brothel = 1
	globals.state.sidequests.chloe = 6
	#globals.state.decisions.append('')
	globals.state.rank = 3
	globals.state.mainquest = 5
	globals.resources.mana = 200
	globals.state.farm = 3
	globals.state.mansionupgrades.mansionlab = 1
	globals.state.mansionupgrades.mansionalchemy = 1
	globals.state.mansionupgrades.mansionparlor = 1
	globals.state.backpack.stackables.torch = 1
	globals.player.sstr = 1
	globals.player.send = 5
	globals.player.stats.agi_max = 5
	globals.player.sagi = 1
	globals.state.reputation.frostford = 50
	globals.state.condition -= 100
	globals.state.decisions = ['tishaemilytricked','chloebrothel','ivrantaken','goodroute']
	#lobals.state.upcomingevents.append({code = 'tishaappearance',duration =1})
	globals.state.upcomingevents.append({code = 'aynerisrapierstart', duration = 1})
#	for i in globals.characters.characters:
#		person = globals.characters.create(i)
#		person.loyal = 100
#		person.lust = 0
#		person.consent = true
#		person.attention = 100
#		globals.slaves = person

func mansion():
	_on_mansion_pressed()

func jail():
	_on_jailbutton_pressed()

func libraryopen():
	_on_library_pressed()

func alchemy():
	_on_alchemy_pressed()

func laboratory():
	get_node("MainScreen/mansion/labpanel")._on_lab_pressed()

func farm():
	_on_farm_pressed()

func portals():
	_on_portals_pressed()

func leave():
	get_node("outside")._on_leave_pressed()

func _on_combatgroup_pressed():
	get_node("groupselectnode").show()



func getridof():
	var person = globals.slaves[get_tree().get_current_scene().currentslave]
	person.removefrommansion()
	if get_node("dialogue").visible:
		close_dialogue()
	rebuild_slave_list()
	if get_node("MainScreen").visible:
		_on_nobutton_pressed()
		_on_mansion_pressed()

var showprisoners = false
var listinstance = load("res://files/listline.tscn")

func rebuild_slave_list():
	var node
	var size = 0
	var person
	var clear = find_node('slave_list').get_children()
	var personlist = get_node("charlistcontrol/CharList/scroll_list/slave_list")
	var prison = 0
	var prisonlabel = get_node("charlistcontrol/CharList/scroll_list/slave_list/prisonlabel")
	for i in clear:
		if i != prisonlabel:
			i.queue_free()
			i.hide()
	while globals.slaves.size() > size:
		person = globals.slaves[size]
		if person.sleep != 'jail' && person.sleep != 'farm' && person.away.duration == 0:
			node = listinstance.instance()
			node.set_meta('id', person.id)
			node.set_meta('pos', size)
			personlist.add_child(node)
			var text = person.name_long()
			if person.xp >= 100:
				text = text + "(+)"
			node.find_node('name').set_text(text)
			node.get_node('slavename/name').connect('pressed', self, 'openslavetab', [person])
			node.find_node('health').set_normal_texture(person.health_icon())
			node.find_node('healthvalue').set_text(str(round(person.health)))
			node.find_node('obedience').set_normal_texture(person.obed_icon())
			node.find_node('stress').set_normal_texture(person.stress_icon())
			if person.imageportait != null:
				node.find_node('portait').show()
				node.find_node('portait').set_texture(globals.loadimage(person.imageportait))
#			else:
#				node.find_node('portait').hide()
		elif person.sleep == 'jail':
			prison += 1
		size += 1
	if prison >= 1:
		prisonlabel.show()
		personlist.move_child(prisonlabel, get_node("charlistcontrol/CharList/scroll_list/slave_list").get_children().size()-1)
	else:
		prisonlabel.hide()
	
	if showprisoners == false && prison >= 1:
		var label = Label.new()
		label.set_text("Your jail holds "+str(prison)+ " prisoner(s). ")
		personlist.add_child(label)
	else:
		size = 0
		for i in globals.slaves:
			person = i
			if person.sleep == 'jail' && person.away.duration == 0:
				node = load("res://files/listline.tscn").instance()
				node.set_meta('id', person.id)
				node.set_meta('pos', size)
				personlist.add_child(node)
				node.find_node('name').set_text(person.name_long())
				node.get_node('slavename/name').connect('pressed', self, 'openslavetab', [person])
				node.find_node('health').set_normal_texture(person.health_icon())
				node.find_node('healthvalue').set_text(str(round(person.health)))
				node.find_node('obedience').set_normal_texture(person.obed_icon())
				node.find_node('stress').set_normal_texture(person.stress_icon())
				if person.imageportait != null:
					node.find_node('portait').show()
					node.find_node('portait').set_texture(globals.loadimage(person.imageportait))
				else:
					node.find_node('portait').hide()
			size += 1
	for person in globals.slaves:
		if person.sleep == 'farm':
			var label = Label.new()
			label.set_text(person.name_long() + ' is assigned to your farm.')
			get_node("charlistcontrol/CharList/scroll_list/slave_list").add_child(label)
	
	
	
	for i in globals.slaves:
		person = i
		if person.away.duration != 0 && person.away.at != 'hidden':
			var label = Label.new()
			label.set('font', load('res://mainfont.tres'))
			if person.away.at == 'in labor':
				label.set_text(person.name_long() + ' will be resting after labor for '+ str(person.away.duration))
			elif person.away.at == 'training':
				label.set_text(person.name_long() + ' will be undergoing training for '+ str(person.away.duration))
			elif person.away.at == 'nurture':
				label.set_text(person.name_long() + ' will be undergoing nurturing for '+ str(person.away.duration))
			elif person.away.at == 'growing':
				label.set_text(person.name_long() + ' will keep maturing for '+ str(person.away.duration))
			elif person.away.at == 'lab':
				label.set_text(person.name_long() + ' will be undergoing modification for '+ str(person.away.duration))
			elif person.away.at == 'rest':
				label.set_text(person.name_long() + ' will be taking a rest for '+ str(person.away.duration))
			else:
				label.set_text(person.name_long() + ' will be unavailable for '+ str(person.away.duration))
			if person.away.duration == 1:
				label.set_text(label.get_text() + ' day.')
			else:
				label.set_text(label.get_text() + ' days.')
			get_node("charlistcontrol/CharList/scroll_list/slave_list").add_child(label)
	
	get_node("charlistcontrol/CharList/res_number").set_bbcode('[center]Residents: ' + str(globals.slaves.size())+'[/center]')
	get_node("ResourcePanel/population").set_text(str(globals.slavecount()))
	_on_orderbutton_pressed()

func openslavetab(person):
	currentslave = globals.slaves.find(person)
	get_tree().get_current_scene().hide_everything()
	$MainScreen/slave_tab.slavetabopen()

func _on_prisonbutton_pressed():
	showprisoners = !showprisoners
	rebuild_slave_list()

var enddayprocess = false

func _on_end_pressed():
	if globals.state.mainquest == 41:
		popup("You can't afford to wait. You must go to the Mage's Order.")
		return
	
	var text = ''
	var temp = ''
	var poorcondition = false
	var person
	var count
	var chef
	var jailer
	var headgirl
	var labassist
	var farmmanager
	var workdict
	var text0 = get_node("FinishDayPanel/FinishDayScreen/Global Report")
	var text1 = get_node("FinishDayPanel/FinishDayScreen/Job Report")
	var text2 = get_node("FinishDayPanel/FinishDayScreen/Secondary Report")
	var start_gold = globals.resources.gold
	var start_food = globals.resources.food
	var start_mana = globals.resources.mana
	var deads_array = []
	var gold_consumption = 0
	var lacksupply = false
	var results = 'normal'
	enddayprocess = true
	_on_mansion_pressed()
	for i in range(globals.slaves.size()):
		if globals.slaves[i].away.duration == 0:
			if globals.slaves[i].work == 'cooking':
				chef = globals.slaves[i]
			elif globals.slaves[i].work == 'jailer':
				jailer = globals.slaves[i]
			elif globals.slaves[i].work == 'headgirl':
				headgirl = globals.slaves[i]
			elif globals.slaves[i].work == 'labassist':
				labassist = globals.slaves[i]
			elif globals.slaves[i].work == 'farmmanager':
				farmmanager = globals.slaves[i]
	
	globals.resources.day += 1
	text0.set_bbcode('')
	text1.set_bbcode('')
	text2.set_bbcode('')
	count = 0
	
	if globals.player.preg.duration >= 1:
		globals.player.preg.duration += 1
		if globals.player.preg.duration == 5:
			text0.set_bbcode(text0.get_bbcode() + "[color=yellow]You feel morning sickness. It seems you are pregnant. [/color]\n")
	
	for person in globals.slaves:
		if person.away.duration == 0:
			if person.bodyshape == 'shortstack':
				globals.state.condition = -0.65
			elif person.race in globals.monsterraces:
				globals.state.condition = -1.8
			elif person.race.find('Beastkin') >= 0:
				globals.state.condition = -1.3
			else:
				globals.state.condition = -1.0
	
	for person in globals.slaves:
		person.metrics.ownership += 1
		var handcuffs = false
		for i in person.gear.values():
			if i != null && globals.state.unstackables.has(i):
				var tempitem = globals.state.unstackables[i]
				if tempitem.code in ['acchandcuffs']:
					handcuffs = true
		text = ''
		if person.away.duration == 0:
			if person.sleep != 'jail' && person.sleep != 'farm':
				if person.work in ['rest','forage','hunt','cooking','library','nurse','maid','storewimborn','artistwimborn','assistwimborn','whorewimborn','escortwimborn','fucktoywimborn', 'lumberer', 'ffprostitution','guardian', 'research', 'slavecatcher','fucktoy']:
					if person.work != 'rest' && person.energy < 30:
						text = "$name had no energy to fulfill $his duty and had to take a rest. \n"
						person.health += 10
						person.stress -= 20
					else:
						workdict = globals.jobs.call(person.work, person)
						if workdict.has('dead') && workdict.dead == true:
							deads_array.append({number = count, reason = workdict.text})
							continue
						if person.traits.has("Clumsy") && get_node("MainScreen/slave_tab").jobdict[person.work].tags.has("physical"):
							if workdict.has('gold'):
								workdict.gold *= 0.7
							if workdict.has('food'):
								workdict.food *= 0.7
						if person.traits.has("Hard Worker") && !get_node("MainScreen/slave_tab").jobdict[person.work].tags.has("sex"):
							if workdict.has('gold'):
								workdict.gold *= 1.15
						for i in globals.state.reputation:
							if globals.state.reputation[i] < -10 && rand_range(0,100) < 33 && get_node("MainScreen/slave_tab").jobdict[person.work].tags.find(i) >= 0:
								person.obed -= max(abs(globals.state.reputation[i])*2 - person.loyal/6,0)
								person.loyal -= rand_range(1,3)
								text += "[color=#ff4949]$name has been influenced by local townfolk, which is hostile towards you. [/color]\n"
							elif globals.state.reputation[i] > 10 && rand_range(0,100) < 20:
								person.obed += abs(globals.state.reputation[i])
								person.loyal += rand_range(1,3)
								text += "[color=green]$name has been influenced by local townfolk, which is loyal towards you. [/color]\n"
						text = workdict.text
						if person.spec == 'housekeeper' && person.work in ['rest','chef','library','nurse','maid','headgirl','farmmanager','labassist','jailer']:
							globals.state.condition += (5.5 + (person.sagi+person.send)*6)/2
							text2.set_bbcode(text2.get_bbcode() + person.dictionary("$name has managed to clean the mansion a bit while being around. \n"))
						if workdict.has("gold"):
							globals.resources.gold += workdict.gold
							person.metrics.goldearn += workdict.gold
						if workdict.has("food"):
							globals.resources.food += workdict.food
							person.metrics.foodearn += workdict.food
			text1.set_bbcode(text1.get_bbcode()+person.dictionary(text))
			######## Counting food
			if globals.resources.food >= 5:
				person.loyal += rand_range(0,1)
				person.stress += rand_range(-5,-10)
				if person.race == 'Fairy':
					person.stress += rand_range(-10,-15)
				person.health += rand_range(2,5)
				person.obed += person.loyal/5 - (person.cour+person.conf)/10
				var consumption = variables.basefoodconsumption
				if chef != null:
					consumption = max(3, 10 - (chef.sagi + (chef.wit/20))/2)
					if chef.race == 'Scylla':
						consumption = max(3, consumption - 1)
				if person.traits.has("Small Eater"):
					consumption = consumption/3
				globals.resources.food -= consumption
			else:
				person.stress += 20
				person.health -= rand_range(person.stats.health_max/6,person.stats.health_max/4)
				person.obed += -max(35 - person.loyal/3,10)
				if person.health < 1:
					text = person.dictionary('[color=#ff4949]$name has died of starvation.[/color]\n')
					deads_array.append({number = count, reason = text})
			if person.obed < 25 && person.cour >= 50 && person.rules.silence == false && person.traits.find('Mute') < 0 && person.sleep != 'jail' && person.sleep != 'farm' && person.brand != 'advanced'&& rand_range(0,1) > 0.5:
				text0.set_bbcode(text0.get_bbcode()+person.dictionary('$name dares to openly show $his disrespect towards you and instigates other servants. \n'))
				for ii in globals.slaves:
					if ii != person && ii.loyal < 30 && ii.traits.find('Loner') < 0:
						ii.obed += -(person.charm/3)
			if person.obed < 50 && person.loyal < 25 && person.sleep != 'jail'&& person.sleep != 'farm'&& person.brand != 'advanced':
				if rand_range(0,3) < 1 && globals.resources.gold > 34:
					text0.set_bbcode(text0.get_bbcode()+person.dictionary('You notice that some of your food is gone.\n'))
					globals.resources.food -= -rand_range(35,70)
				elif rand_range(0,3) < 1 && globals.resources.gold > 19:
					text0.set_bbcode(text0.get_bbcode()+person.dictionary('You notice that some of your gold is missing.\n'))
					globals.resources.gold -= rand_range(20,40)
			if person.obed < 25 && person.sleep != 'jail' && person.sleep != 'farm' && person.tags.has('noescape') == false:
				var escape = 0
				var stay = 0
				if person.brand == 'none':
					escape = person.cour/3+person.wit/3+person.stress/2
					stay = person.loyal*2+person.obed
				else:
					escape = person.cour/4+person.stress/4
					stay = person.loyal*2+person.obed+person.wit/5
				
				if globals.state.mansionupgrades.mansionkennels == 1:
					escape *= 0.8
				if escape > stay:
					if handcuffs == false:
						var temptext = person.dictionary('[color=#ff4949]$name has escaped during the night![/color]\n')
						deads_array.append({number = count, reason = temptext})
					else:
						text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=#ff4949]$name attempted to escape during the night but being handcuffed slowed them down and they were quickly discovered![/color]\n'))
			#sleep conditions
			if person.lust < 25 || person.traits.has('Sex-crazed'):
				person.lust += round(rand_range(3,6))
			if person.sleep == 'communal' && globals.count_sleepers()['communal'] > globals.state.mansionupgrades.mansioncommunal:
				person.stress += rand_range(5,15)
				person.health -= rand_range(1,5)
				text2.set_bbcode(text2.get_bbcode() + person.dictionary('$name suffers from communal room being overcrowded.\n'))
			elif person.sleep == 'communal':
				person.stress += -rand_range(5,10)
				person.health += rand_range(1,3)
				person.energy += rand_range(20,30)+ person.stats.end_cur*6
			elif person.sleep == 'personal':
				person.stress += rand_range(-10,-15)
				person.health += rand_range(2,6)
				person.energy += rand_range(40,50)+ person.stats.end_cur*6
				text2.set_bbcode(text2.get_bbcode() + person.dictionary('$name sleeps in a private room, which helps $him heal faster and provides some stress relief.\n'))
				if person.lust >= 50 && person.rules.masturbation == false && person.tags.find('nosex') < 0:
					person.lust -= rand_range(15,25)
					person.lastsexday = globals.resources.day
					text2.set_bbcode(text2.get_bbcode() + person.dictionary('In an attempt to calm $his lust, $he spent some time busying $himself in feverish masturbation, making use of $his private room.\n'))
			elif person.sleep == 'your':
				person.loyal += rand_range(1,4)
				person.energy += rand_range(25,45)+ person.stats.end_cur*6
				person.sexuals.affection += round(rand_range(1,2))
				if person.loyal > 30:
					person.stress -= person.loyal/7
				if person.lust > 40 && person.consent && person.vagvirgin == false && person.tags.find('nosex') < 0:
					text2.set_bbcode(text2.get_bbcode() + person.dictionary('$name went down on you being unable to calm $his lust.\n'))
					person.lust -= rand_range(15,25)
					person.metrics.sex += 1
					person.lastsexday = globals.resources.day
					globals.resources.mana += 2
					globals.impregnation(person, globals.player)
				else:
					text2.set_bbcode(text2.get_bbcode() + person.dictionary('$name keeps you company at night and you grew closer.\n'))
			elif person.sleep == 'jail':
				person.metrics.jail += 1
				person.obed += 25 - person.conf/6
				person.energy += rand_range(20,30) + person.stats.end_cur*6
				if person.stress > 30:
					person.stress -= rand_range(5,10)
				else:
					if globals.state.mansionupgrades.jailtreatment == 0:
						person.stress += person.conf/10
			if person.lust >= 90 && person.rules.masturbation == true && !person.traits.has('Sex-crazed') && (rand_range(0,10)>7 || person.effects.has('stimulated')) && globals.resources.day - person.lastsexday >= 5:
				person.add_trait('Sex-crazed')
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]Left greatly excited and prohibited from masturbating, $name desperate state led $him to become insanely obsessed with sex.[/color]\n"))
			elif person.lust >= 75 && globals.resources.day - person.lastsexday >= 5:
				person.stress += rand_range(10,15)
				person.obed -= rand_range(10,20)
				text0.bbcode_text += person.dictionary("[color=red]$name is suffering from unquenched lust.[/color]\n")
			#Races
			if person.race == 'Elf':
				person.asser = person.conf
			elif person.race == 'Orc':
				person.health += 15
			elif person.race == 'Slime':
				person.toxicity -= 200
			#Traits
			if person.traits.find("Uncivilized") >= 0:
				for i in globals.slaves:
					if i.spec == 'tamer' && (i.work == person.work || i.work in ['rest','headgirl','jailer']) && i.away.duration == 0:
						person.obed += 30
						person.loyal += 5
						if rand_range(0,100) < 10:
							person.trait_remove("Uncivilized")
							text0.set_bbcode(text0.get_bbcode() + i.dictionary("[color=green]$name managed to lift ") + person.dictionary("$name out of $his wild behavior and turn into a socially functioning person.[/color]\n "))
			if person.traits.find("Clingy") >= 0 && person.attention > 75 && rand_range(0,2) > 1:
				person.obed -= rand_range(10,30)
				person.loyal -= rand_range(1,5)
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]$name is annoyed by you paying no attention to $him. [/color]\n"))
			if person.traits.find('Pliable') >= 0:
				if person.loyal >= 60:
					person.trait_remove('Pliable')
					person.add_trait('Devoted')
					text0.set_bbcode(text0.get_bbcode() + person.dictionary('[color=green]$name has become Devoted. $His willpower strengthened.[/color]\n'))
				elif person.lewdness >= 60:
					person.trait_remove('Pliable')
					person.add_trait('Slutty')
					text0.set_bbcode(text0.get_bbcode() + person.dictionary('[color=green]$name has become Slutty. $His willpower strengthened.[/color]\n'))
			if person.traits.has("Scoundrel"):
				globals.resources.gold += 15
				text1.set_bbcode(text1.get_bbcode() + person.dictionary('[color=green]$name has brought some additional gold by the end of day.[/color]\n'))
			if person.traits.has("Authority") && person.obed >= 95:
				for i in globals.slaves:
					if i.away.duration == 0 && i != person:
						i.obed += 5
			if person.traits.has("Mentor"):
				for i in globals.slaves:
					if i.away.duration == 0 && i != person && i.level < 3:
						i.xp += 5
			#Rules and clothes effect
			if person.rules.contraception == true:
				if globals.resources.gold >= 5:
					globals.resources.gold -= 5
					person.preg.fertility = max(person.preg.fertility - rand_range(10,15), 0)
					gold_consumption += 5
				else:
					text0.set_bbcode(text0.get_bbcode()+person.dictionary("[color=#ff4949]You could't afford to provide $name with contraceptives.[/color]\n"))
			if person.rules.aphrodisiac == true:
				var value
				if person.spec != 'housekeeper':
					value = 8
				else:
					value = 4
				if globals.resources.gold >= value:
					globals.resources.gold -= value
					person.lust += rand_range(10,15)
					gold_consumption += value
				else:
					text0.set_bbcode(text0.get_bbcode()+person.dictionary("[color=#ff4949]You could't supply $name's food with aphrodisiac.[/color]\n"))
			if person.rules.silence == true:
				if person.cour > 40:
					person.cour += -rand_range(3,5)
				person.obed += rand_range(5,10)
			if person.rules.pet == true:
				if person.conf > 25:
					person.conf -= rand_range(5,10)
				if person.charm > 25:
					person.charm -= rand_range(4,8)
				person.obed += rand_range(8,15)
			if person.rules.nudity == true:
				person.lust += rand_range(5,10)
				if person.lewdness < 40 && !person.traits.has("Pervert") && !person.traits.has("Sex-crazed"):
					person.stress += rand_range(5,10)
			if person.punish.expect == true:
				person.punish.strength = -1
				person.obed += 15-person.cour/10
				if person.punish.strength <= 0:
					person.punish.expect = false
			if person.praise > 0:
				person.praise -= 1
				person.obed += rand_range(5,10)
			for i in person.gear.values():
				if i != null && globals.state.unstackables.has(i):
					var tempitem = globals.state.unstackables[i]
					for k in tempitem.effects:
						if k.type == 'onendday':
							text2.set_bbcode(text2.get_bbcode() + person.dictionary(globals.items.call(k.effect, person)))
			if person.toxicity > 0:
				if person.toxicity > 35 && rand_range(0,10) > 6.5:
					person.stress += rand_range(10,15)
					person.health -= rand_range(10,15)
					text2.set_bbcode(text2.get_bbcode() + person.dictionary("$name suffers from magical toxicity.\n"))
				if person.toxicity > 60 && rand_range(0,10) > 7.5:
					get_node("spellnode").slave = person
					text0.set_bbcode(text0.get_bbcode()+get_node("spellnode").mutate(person.toxicity/30, true) + "\n\n")
				person.toxicity -= rand_range(1,5)
#			if person.gear.armor == null && person.gear.costume == null:
#				person.obed += rand_range(10,20)
#				if person.traits.find('Pervert') >= 0 && person.traits.find('Sex-crazed') < 0 && person.conf > 40:
#					person.stress += rand_range(10,15)
#					text2.set_bbcode(text2.get_bbcode() + person.dictionary("Your denial of upper clothing to $name causes $him to take you more seriously, but $he certainly is stressed out having to walk around almost naked.\n"))
#				else:
#					text2.set_bbcode(text2.get_bbcode() + person.dictionary("Your denial of upper clothing to $name causes $him to take you more seriously, however, it does not seem that $he's feels too bothered about being almost naked.\n"))
#			if person.gear.underwear == null:
#				person.lust = rand_range(5,10)
#				if person.traits.find('Pervert') < 0 && person.traits.find('Sex-crazed') < 0:
#					person.obed -= rand_range(10,20)
#					text2.set_bbcode(text2.get_bbcode() + person.dictionary("Wearing no underwear causes $name to become more open to dirty behavior, although $he does not seem to be very happy about it.\n"))
#				else:
#					text2.set_bbcode(text2.get_bbcode() + person.dictionary("Wearing no underwear causes $name to become more open to dirty behavior, but $he seems to accept it surprisingly well.\n"))
			if person.stress > 80 && person.sleep != 'jail' && person.sleep != 'farm' && person.away.duration < 1:
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("$name complained "+globals.fastif(headgirl == null, "to you, ", "to your headgirl, ")+"that $he's having it too hard and hoped to get some rest.\n"))
			if person.stress >= 100 && person.cour+person.conf+person.wit+person.charm > 50:
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=#ff4949]$name had a severe mental breakdown due to high stress.[/color] \n"))
				person.cour += -rand_range(5,person.cour/4)
				person.conf += -rand_range(5,person.conf/4)
				person.wit += -rand_range(5,person.wit/4)
				person.charm += -rand_range(5,person.charm/4)
				if person.effects.has('captured') == true:
					person.add_effect(globals.effectdict.captured, true)
				person.health -= rand_range(0,person.stats.health_max/6)
			if person.skillpoints == -1:
				person.skillpoints = 0
			if person.attention < 150 && person.sleep != 'your':
				person.attention += rand_range(5,7)
			if person.preg.duration > 0:
				person.preg.duration += 1
				if person.health < 20 && rand_range(0,100) > person.health*2:
					text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=#ff4949]Due to poor health condition, $name had a miscarriage and lost $his child.[/color]\n'))
					person.preg.baby = null
					person.preg.duration = 0
					person.stress += rand_range(35,50)
				if person.race == 'Goblin':
					if person.preg.duration > 5:
						person.lactation = true
						if headgirl != null:
							if person.preg.duration == 6:
								text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name appears to be pregnant. [/color]\n'))
							elif person.preg.duration == 12:
								text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name will likely give birth soon. [/color]\n'))
				else:
					if person.preg.duration > 10:
						person.lactation = true
						if headgirl != null:
							if person.preg.duration == 11:
								text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name appears to be pregnant. [/color]\n'))
							elif person.preg.duration == 23:
								text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name will likely give birth soon. [/color]\n'))
				if rand_range(0,100) < 40:
					person.stress += rand_range(15,20)
			if person.away.duration == 0 && !person.sleep in ['jail','farm'] && !person.traits.has("Grateful"):
				var personluxury = person.calculateluxury()
				var luxurycheck = person.countluxury()
				var luxury = luxurycheck.luxury
				gold_consumption += luxurycheck.goldspent
				if luxurycheck.nosupply == true:
					lacksupply = true
				if luxury < personluxury && person.metrics.ownership - person.metrics.jail > 7 :
					person.loyal -= (personluxury - luxury)/2.5
					person.obed -= (personluxury - luxury)
					text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=#ff4949]$name appears to be rather unhappy about quality of $his life and demands better living conditions from you. [/color]\n"))
		elif person.away.duration > 0:
			person.away.duration -= 1
			if person.away.duration == 0 && person.away.at == 'lab' && person.health < 5:
				var temptext = "$name has not survived the laboratory operation due to poor health."
				deads_array.append({number = count, reason = temptext})
			elif person.away.duration == 0:
				person.away.at = ''
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("$name returned to the mansion and went back to $his duty. \n"))
		for i in person.effects.values():
			if i.has('duration') && i.code != 'captured':
				if person.race != 'Dark Elf' || rand_range(0,1) > 0.5:
					i.duration -= 1
				if i.duration <= 0:
					person.add_effect(i, true)
			elif i.has('duration'):
				i.duration -= 1
				if person.sleep == 'jail' && globals.state.mansionupgrades.jailincenses == 1 && rand_range(0,100) >= 50:
					i.duration -= 1
				if person.brand != 'none':
					i.duration -= 1
				if i.duration <= 0:
					if i.code == 'captured':
						text0.set_bbcode(text0.get_bbcode() + person.dictionary('$name grew accustomed to your ownership.\n'))
					person.add_effect(i, true)
		count+=1
	if headgirl != null && globals.state.headgirlbehavior != 'none':
		headgirl.conf += rand_range(1,4)
		var headgirlconf = headgirl.conf
		if headgirl.spec == 'executor':
			headgirlconf = 100
		for i in globals.slaves:
			if i != headgirl && i.traits.find('Loner') < 0 && i.away.duration < 1 && i.sleep != 'jail' && i.sleep != 'farm':
				headgirl.xp += 3
				if i.obed < 65 && globals.state.headgirlbehavior == 'strict':
					var obedbase = i.obed
					i.obed += (-(i.cour/15) + headgirlconf/3)
					i.stress += rand_range(5,10)
					if i.obed <= obedbase:
						text0.set_bbcode(text0.get_bbcode() + i.dictionary('$name was acting frivolously. ') + headgirl.dictionary('$name tried to put ') + i.dictionary("$him in place, but failed to make any impact.\n\n"))
					else:
						text0.set_bbcode(text0.get_bbcode() + i.dictionary('$name was acting frivolously, but ') + headgirl.dictionary('$name managed to make ') + i.dictionary("$him submit to your authority and slightly improve $his behavior.\n\n"))
				elif globals.state.headgirlbehavior == 'kind':
					if rand_range(0,100) < headgirl.charm:
						i.loyal += rand_range(1,3)
					i.stress += -(headgirl.charm/6)
	if jailer != null:
		jailer.conf += rand_range(1,4)
		var jailerconf = jailer.conf
		if jailer.spec == 'executor':
			jailerconf = 100
		for person in globals.slaves:
			if person.sleep == 'jail':
				jailer.xp += 5
				person.health += round(jailer.wit/10)
				person.obed += round(jailer.charm/8)
				if person.effects.has('captured') == true && jailerconf-30 >= rand_range(0,100):
					person.effects.captured.duration -= 1
	if farmmanager != null:
		var farmconf = farmmanager.conf
		if farmmanager.spec == 'executor':
			farmconf = 100
		for person in globals.slaves:
			if person.sleep == 'farm':
				var production = 0
				if person.work == 'cow' && person.titssize != 'masculine':
					production = rand_range(0,15) + 18*globals.sizearray.find(person.titssize)
					if person.titsextradeveloped == true:
						production = production + production * (0.33 * person.titsextra)
					if person.race == 'Taurus':
						production = production*1.2
				elif person.work == 'hen':
					production = rand_range(50,100)
					if person.vagina != 'none':
						production = production + 50
					if person.race == 'Harpy':
						production = production*1.2
				production = production * (0.4 + farmmanager.wit * 0.004 + farmconf * 0.002)
				if globals.state.mansionupgrades.farmtreatment == 0:
					person.stress += 50 - (0.25*farmmanager.charm)
				if person.farmoutcome == false:
					globals.resources.food += production
					person.metrics.foodearn += round(production)
					text1.set_bbcode(text1.get_bbcode()+person.dictionary('$name produced ') + str(round(production))+ ' units worth of food.\n')
				else:
					globals.resources.gold += round(production/2)
					person.metrics.goldearn += round(production/2)
					text1.set_bbcode(text1.get_bbcode()+person.dictionary('$name produced valueables worth of ') + str(round(production/2))+ ' gold.\n')
	#####          Dirtiness
	if globals.state.condition <= 40:
		for person in globals.slaves:
			if person.away.duration != 0:
				continue
			if globals.state.condition >= 30 && rand_range(0,10) >= 7:
				person.stress += rand_range(5,15)
				person.obed += -rand_range(15,20)
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]$name was distressed by mansion's poor condition. [/color]\n"))
			elif globals.state.condition >= 15 && rand_range(0,10) >= 5:
				person.stress += rand_range(10,25)
				person.obed += -rand_range(15,35)
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]$name was distressed by mansion's poor condition. [/color]\n"))
			elif rand_range(0,10) >= 4:
				person.stress += rand_range(25,30)
				person.health -= rand_range(5,10)
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=#ff4949]Mansion's terrible condition causes $name a lot of stress and impacted $his health. [/color]\n"))
	#####          Outside Events
	for i in globals.guildslaves:
		for person in globals.guildslaves[i]:
			count = 0
			if rand_range(0,100) < 20:
				globals.guildslaves[i].remove(count)
			count += 1
		if globals.guildslaves[i].size() < 4:
			get_node("outside").newslaveinguild(1, i)
		if globals.guildslaves[i].size() < 6 && rand_range(0,100) > 25:
			get_node("outside").newslaveinguild(1, i)
	
	
	if globals.state.sebastianorder.duration > 0:
		globals.state.sebastianorder.duration -= 1
		if globals.state.sebastianorder.duration == 0:
			text0.set_bbcode(text0.get_bbcode() + "[color=green]Sebastian should have your order ready by this time. [/color]\n")
	globals.state.groupsex = true
	
	if globals.state.mansionupgrades.foodpreservation == 0 && globals.resources.food >= globals.resources.foodcaparray[globals.state.mansionupgrades.foodcapacity]*0.80:
		globals.resources.food -= globals.resources.food*0.03
		text0.set_bbcode(text0.get_bbcode() + '[color=yellow]Some of your food reserves have spoiled.[/color]\n')
	
	if globals.resources.food >= 5:
		if chef != null:
			globals.resources.food -= max(3, variables.basefoodconsumption - (chef.sagi + (chef.wit/20))/2)
		else:
			globals.resources.food -= variables.basefoodconsumption
	else:
		if globals.resources.gold < 5:
			get_node("gameover").show()
			get_node("gameover/Panel/text").set_bbcode("[center]With no food and money your mansion falls in chaos. \nGame over.[/center]")
		else:
			globals.resources.gold -= 20
			text0.set_bbcode(text0.get_bbcode()+ "[color=#ff4949]You have no food in the mansion and left dining at town, paying 20 gold in process.[/color]\n")
	
	for i in globals.state.repeatables:
		for ii in globals.state.repeatables[i]:
			temp = ii.difficulty
			var removed = false
			if ii.time >= 0 && ii.taken == true:
				ii.time -= 1
			elif rand_range(0,10) < 0 && ii.taken == false:
				removed = true
				globals.state.repeatables[i].remove(globals.state.repeatables[i].find(ii))
			if ii.time < 0:
				removed = true
				text0.set_bbcode(text0.get_bbcode() + '[color=#ff4949]You have failed to complete your quest at ' + ii.location.capitalize() +'.[/color]\n')
				globals.state.repeatables[i].remove(globals.state.repeatables[i].find(ii))
	
	if int(globals.resources.day)%5 == 0.0:
		rebuildrepeatablequests()
	
	if globals.player.xp >= 100:
		globals.player.xp -= 100
		globals.player.value += 1
		globals.player.skillpoints += 1
		text0.set_bbcode(text0.get_bbcode() + '[color=green]You have leveled up and earned an additional skillpoint. [/color]\n')
	
	if globals.player.preg.duration > variables.pregduration/3:
		globals.player.energy += 60
	else:
		globals.player.energy += 100
	globals.player.health += 50
	
	#####         Results
	if start_gold < globals.resources.gold:
		results = 'good'
		text = 'Your residents earned [color=yellow]' + str(globals.resources.gold - start_gold) + '[/color] gold by the end of day. \n'
	elif start_gold == globals.resources.gold:
		results = 'med'
		text = "By the end of day your gold reserve didn't change. "
	else:
		results = 'bad'
		text = "By the end of day your gold reserve shrunk by [color=yellow]" + str(start_gold - globals.resources.gold) + "[/color] pieces. "
	if start_food > globals.resources.food:
		text = text + 'Your food storage shrank by [color=aqua]' + str(start_food - globals.resources.food) + '[/color] units of food.\n'
	else:
		text = text + 'Your food storage grew by [color=aqua]' + str(globals.resources.food - start_food) + '[/color] units of food.\n'
	text0.set_bbcode(text0.get_bbcode() + text)
	globals.state.sexactions = globals.player.send/2 + 1
	if deads_array.size() > 0:
		results = 'worst'
		deads_array.invert()
		for i in deads_array:
			globals.slaves.remove(i.number)
			text0.set_bbcode(text0.get_bbcode() + i.reason + '\n')
	text0.set_bbcode(text0.get_bbcode()+ "[color=yellow]" +str(round(gold_consumption))+'[/color] gold was used for various tasks.\n'  )
	get_node("FinishDayPanel/FinishDayScreen").set_current_tab(0)
	aliseresults = results
	if lacksupply == true:
		text0.set_bbcode(text0.get_bbcode()+"[color=#ff4949]You have expended your supplies and some of the actions couldn't be finished. [/color]\n")
	enddayprocess = false
	dailyevent = false
	nextdayevents()

var aliseresults
var checkforevents = false

func nextdayevents():
	var player = globals.player
	if player.preg.duration > variables.pregduration && player.preg.baby != null:
		childbirth(player)
		get_node("FinishDayPanel").hide()
		return
	for i in globals.slaves:
		if i.preg.baby != null && (i.preg.duration > variables.pregduration || (i.race == 'Goblin' && i.preg.duration > variables.pregduration/2)):
			if i.race == 'Goblin':
				i.away.duration = 2
			else:
				i.away.duration = 3
			i.away.at = 'in labor'
			childbirth(i)
			get_node("FinishDayPanel").hide()
			return
	for i in globals.state.upcomingevents:
		if $scene.is_visible_in_tree() == true:
			continue
		if i.duration > 0:
			i.duration -= 1
		if i.duration <= 0:
			var text = globals.events.call(i.code)
			if text != null:
				get_node("FinishDayPanel/FinishDayScreen/Global Report").set_bbcode(get_node("FinishDayPanel/FinishDayScreen/Global Report").get_bbcode() + text)
			globals.state.upcomingevents.erase(i)
			checkforevents = true
			return
	globals.state.dailyeventcountdown -= 1
	if globals.state.dailyeventcountdown <= 0 && !$scene.is_visible_in_tree() && !$dialogue.is_visible_in_tree():
		var event
		event = launchrandomevent()
		if event != null:
			globals.state.dailyeventcountdown = rand_range(5,10)
			get_node("dailyevents").show()
			get_node("dailyevents").currentevent = event
			get_node("dailyevents").call(event)
			dailyevent = true
			return
	startnewday()

var dailyevent = false

func launchrandomevent():
	var rval
	var personlist = []
	for i in globals.slaves:
		if i.away.duration == 0 && i.sleep != 'jail' && i.sleep != 'farm' && i.attention >= 50:
			personlist.append(i)
	while personlist.size() > 0:
		var number = floor(rand_range(0,personlist.size()))
		if personlist[number].attention < rand_range(30,150):
			get_node("dailyevents").person = personlist[number]
			rval = get_node("dailyevents").getrandomevent(personlist[number])
			personlist[number].attention = 0
			break
		else:
			personlist.remove(number)
	return rval


var alisesprite = {
good = ['happy1','happy2',"wink1",'wink2','side'],
med = ["neutral",'side'],
bad = ["neutral",'side'],
worst = ["neutral"]
}
var alisetext = {
good = ['Nice job! Income is currently on the rise!', 'Great work, $name, We are currently getting wealthier!', 'Things are doing well, $name!', 'If we keep gaining like this, could I get a vacation one day?', 'Another great day, high-five!', 'Remarkable work! Income outlook at this time is positive.', 'A well known artist once stated, "Making money is art and working is art and business is the best art."', 'They say money talks... what does yours say?', 'We are doing great!  Please keep this up $name!'],
med = ['We might need to start making money soon.', 'Things are steady... but should be better financially', "Well we aren't losing money... but we aren't really gaining any either", 'We have added next to nothing to our coffers.  We need a stronger income.', 'I believe it is about time we gain some money.', 'Time waits for no man, neither does good commerce.'],
bad = ['We are losing money $name!', 'Things are not going too well.', 'We should do something about this cash loss.', 'Oh dear! We are bleeding gold.', 'This funding loss needs to be addressed.', 'You must be scaring the gold away, it is disappearing!', 'A financial analysis of assets states a net loss by my calculations.', '$name, do something about this funding leak before you end up poor!', 'Did I miss a memo as to why there is a loss in funds?'],
worst = ["Well... looks like we lost one of our workers. Don't let that to discourage you though!", "So we lost a worker... Let's move on and fix issues for the future.", 'This is an unfortunate situation', "The outlook is unfavorable, let's change that!", "It's just one bad day out of how many other days.", "Don't get discouraged, learn from these failures and fix the issues.", 'I am very sorry about your bad day, let us proceed to fix this.']
}

func alisebuild(state):
	get_node("FinishDayPanel/alise").show()
	if globals.resources.gold > 5000 && state in ['bad','med']:
		state = 'good'
	
	var truesprite = alisesprite[state][rand_range(0,alisesprite[state].size())]
	var showtext = globals.player.dictionary(alisetext[state][rand_range(0,alisetext[state].size())])
	if state == 'good':
		showtext = '[color=#19ec1c]' + showtext + '[/color]'
	elif state == 'med':
		showtext = '[color=yellow]' + showtext + '[/color]'
	elif state in ['bad','worst']:
		showtext = '[color=#ff4949]' + showtext + '[/color]'
	get_node("FinishDayPanel/alise/speech/RichTextLabel").set_bbcode(showtext)
	get_node("tutorialnode").buildbody(get_node("FinishDayPanel/alise"), truesprite)

func alisehide():
	get_node("FinishDayPanel/alise").hide()


var thread = Thread.new()

func startnewday():
	rebuild_slave_list()
	get_node("FinishDayPanel").show()
	if thread.is_active():
		thread.wait_to_finish()
	thread.start(globals,"save_game",'user://saves/autosave')
	
#	globals.save_game('autosave')
	if globals.rules.enddayalise == 0:
		alisebuild(aliseresults)
	elif globals.rules.enddayalise == 1 && dailyevent == true:
		alisebuild(aliseresults)
	else:
		alisehide()
	_on_mansion_pressed()
#	if globals.state.supporter == false && int(globals.resources.day)%100 == 0:
#		get_node("sellout").show()





func rebuildrepeatablequests():
	var rand
	var town
	var count
	var array = []
	for i in globals.state.repeatables:
		array = []
		count = 0
		for ii in globals.state.repeatables[i]:
			if ii.taken == false:
				array.append(count)
			count += 1
		array.invert()
		for ii in array:
			globals.state.repeatables[i].remove(ii)
		rand = rand_range(0,2)
		if i == 'wimbornslaveguild':
			town = 'wimborn'
		elif i == 'gornslaveguild':
			town = 'gorn'
		elif i == 'frostfordslaveguild':
			town = 'frostford'
		while rand > 0:
			globals.repeatables.generatequest(town, 'easy')
			rand -= 1
		rand = rand_range(0,2)
		while rand > 0:
			globals.repeatables.generatequest(town, 'medium')
			rand -= 1



func _on_FinishDayCloseButton_pressed():
	get_node("FinishDayPanel").hide()

#####GUI ELEMENTS

func popup(text):
	get_node("popupmessage").popup()
	get_node("popupmessage/popupmessagetext").set_bbcode(globals.player.dictionaryplayer(text))


func _on_popupmessagetext_meta_clicked( meta ):
	if meta == 'patreon':
		OS.shell_open('https://www.patreon.com/maverik')

var spritedict = globals.spritedict
onready var nodedict = {pos1 = get_node("dialogue/charactersprite1"), pos2 = get_node("dialogue/charactersprite2")}

func dialogue(showclose, destination, dialogtext, dialogbuttons = null, sprites = null, background = null): #for arrays: 0 - boolean to show close button or not. 1 - node to return connection back. 2 - text to show 3+ - arrays of buttons and functions in those
	var text = get_node("dialogue/dialoguetext")
	var buttons = get_node("dialogue/popupbuttoncenter/popupbuttons")
	var closebutton
	var newbutton
	var counter = 1
	get_node("dialogue/blockinput").hide()
	get_node("dialogue/background").set_texture(null)
	if background != null:
		get_node("dialogue/background").set_texture(globals.backgrounds[background])
	if !get_node("dialogue").visible:
		get_node("dialogue").visible = true
		get_node("dialogue/AnimationPlayer").play("fading")
	text.set_bbcode('')
	for i in buttons.get_children():
		if i != get_node("dialogue/popupbuttoncenter/popupbuttons/Button"):
			i.hide()
			i.queue_free()
	if dialogtext == "":
		dialogtext = var2str(dialogtext)
	if showclose == true:
		closebutton = true
	else:
		closebutton = false
	text.set_bbcode(globals.player.dictionaryplayer(dialogtext))
	if dialogbuttons != null:
		counter = 1
		for i in dialogbuttons:
			call("dialoguebuttons", dialogbuttons[counter-1], destination, counter)
			counter += 1
	if closebutton == true:
		newbutton = get_node("dialogue/popupbuttoncenter/popupbuttons/Button").duplicate()
		newbutton.show()
		newbutton.set_text('Close')
		newbutton.connect('pressed',self,'close_dialogue')
		newbutton.get_node("Label").set_text(str(counter))
		buttons.add_child(newbutton)
	
	var sprite1 = false
	var sprite2 = false
	
	if sprites != null && globals.rules.spritesindialogues == true:
		for i in sprites:
			if !spritedict.has(i[0]) && globals.loadimage(i[0]) == null:
				continue
			else:
				if spritedict.has(i[0]):
					if i.size() > 2 && (i[2] != 'opac' || spritedict[i[0]] != nodedict[i[1]].get_texture()):
						get_node("AnimationPlayer").play(i[2])
					nodedict[i[1]].set_texture(spritedict[i[0]])
				else:
					if i.size() > 2 && (i[2] != 'opac' || globals.loadimage(i[0]) != nodedict[i[1]].get_texture()):
						get_node("AnimationPlayer").play(i[2])
					nodedict[i[1]].set_texture(globals.loadimage(i[0]))
				if i[1] == 'pos1': sprite1 = true
				if i[1] == 'pos2': sprite2 = true
	if sprite1 == false: nodedict.pos1.set_texture(null)
	if sprite2 == false: nodedict.pos2.set_texture(null)


func dialoguebuttons(array, destination, counter):
	var newbutton = get_node("dialogue/popupbuttoncenter/popupbuttons/Button").duplicate()
	newbutton.get_node("Label").set_text(str(counter))
	newbutton.show()
	if typeof(array) == TYPE_DICTIONARY:
		newbutton.set_text(array.text)
		if array.has('args'):
			newbutton.connect("pressed", destination, array.function, [array.args])
		else:
			newbutton.connect("pressed", destination, array.function)
		if array.has('disabled') && array.disabled == true:
			newbutton.set_disabled(true)
		if array.has('tooltip'):
			newbutton.set_tooltip(array.tooltip)
	else:
		newbutton.set_text(array[0])
		if array.size() < 3:
			newbutton.connect('pressed',destination,array[1])
		else:
			newbutton.connect('pressed',destination,array[1],[array[2]])
	get_node("dialogue/popupbuttoncenter/popupbuttons").add_child(newbutton)

func close_dialogue(mode = 'normal'):
	get_node("dialogue/AnimationPlayer").play_backwards("fading")
	get_node("dialogue/blockinput").show()
	if OS.get_name() != "HTML5" && globals.rules.fadinganimation == true && mode != 'instant':
		yield(get_node("dialogue/AnimationPlayer"), 'animation_finished')
	get_node("dialogue").hide()
	for i in nodedict.values():
		i.set_texture(null)


var savedtrack


func scene(target, image, scenetext, scenebuttons = null):
	if !get_node("scene").visible:
		get_node("scene").visible = true
		get_node("scene/AnimationPlayer").play("fading")
	get_node("scene").show()
	get_node("infotext").hide()
	get_node("scene/Panel/sceneeffects").set_texture(null)
	get_node("scene/Panel/scenepicture").set_normal_texture(globals.scenes[image])
	get_node("scene/textpanel/scenetext").set_bbcode(globals.player.dictionary(scenetext))
	get_node("scene/resources/gold").set_text(str(globals.resources.gold))
	get_node("scene/resources/food").set_text(str(globals.resources.food))
	get_node("scene/resources/mana").set_text(str(globals.resources.mana))
	get_node("scene/resources/energy").set_text(str(globals.player.energy))
	if !(image in ['finale', 'finale2']):
		savedtrack = $music.get_meta("currentsong")
		music_set("intimate")
	for i in get_node("scene/popupbuttoncenter/popupbuttons").get_children():
		if i.get_name() != 'Button':
			i.hide()
			i.queue_free()
	var counter = 1
	for i in scenebuttons:
		newbuttonscene(i, target, counter)
		counter += 1

func newbuttonscene(button, target, counter):
	var newbutton = get_node("scene/popupbuttoncenter/popupbuttons/Button").duplicate()
	get_node("scene/popupbuttoncenter/popupbuttons").add_child(newbutton)
	newbutton.show()
	newbutton.set_text(button.text)
	newbutton.get_node("Label").set_text(str(counter))
	if button.has('args'):
		newbutton.connect("pressed", target, button.function , [button.args])
	else:
		newbutton.connect("pressed", target, button.function)

func _on_scenepicture_pressed():
	if get_node("scene/Panel/scenepicture").is_pressed():
		get_node("scene/Panel/scenepicture").set_size(get_node("scene/Panel/Panel2").get_size())
		$scene/Panel/scenepicture.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		get_node("scene/Panel/coverpanel").hide()
	else:
		get_node("scene/Panel/scenepicture").set_size(get_node("scene/Panel").get_size())
		$scene/Panel/scenepicture.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_COVERED
		get_node("scene/Panel/coverpanel").show()

func closescene():
	get_node("scene/AnimationPlayer").play_backwards("fading")
	get_node("infotext").show()
	if $music.stream == globals.musicdict.intimate:
		music_set(savedtrack)
	if OS.get_name() != "HTML5" && globals.rules.fadinganimation == true:
		yield(get_node("scene/AnimationPlayer"), 'animation_finished')
	get_node("scene").hide()

func _on_menu_pressed():
	music_set('pause')
	get_node("menucontrol").popup()

func _on_closemenu_pressed():
	music_set('start')
	get_node("menucontrol").hide()

func _on_closegamebuttonm_pressed():
	yesnopopup("Are you leaving us?", "quit")


func quit():
	get_tree().quit()

func _on_savebutton_pressed():
	get_node("menucontrol/menupanel/SavePanel").show()

func _on_optionsbutton_pressed():
	get_node("options").show()
	get_node("menucontrol").hide()


func _on_mainmenubutton_pressed():
	yesnopopup('Exit to main menu? Make sure to save', 'mainmenu')

func mainmenu():
	get_tree().change_scene("res://files/mainmenu.scn")


func _on_cancelsaveload_pressed():
	get_node("menucontrol/menupanel/SavePanel").hide()

var yesbutton = {target = null, function = null}

func yesnopopup(text, yesfunc, target = self):
	if yesbutton.target != null && get_node("menucontrol/yesnopopup/HBoxContainer/yesbutton").is_connected("pressed",yesbutton.target, yesbutton.function):
		get_node("menucontrol/yesnopopup/HBoxContainer/yesbutton").disconnect("pressed",yesbutton.target,yesbutton.function)
	get_node("menucontrol/yesnopopup/HBoxContainer/yesbutton").connect('pressed',target,yesfunc,[],4)
	yesbutton.target = target
	yesbutton.function = yesfunc
	get_node("menucontrol/yesnopopup/Label").set_bbcode(text)
	get_node("menucontrol/yesnopopup").popup()


func _on_yesbutton_pressed():
	get_node("menucontrol/yesnopopup").hide()


func _on_nobutton_pressed():
	get_node("menucontrol/yesnopopup").hide()

##### Saveload

var savefilename = 'user://saves/autosave'

func _on_SavePanel_visibility_changed():
	if get_node("menucontrol/menupanel/SavePanel").visible == false:
		return
	var node
	var pressedsave
	var moddedtext
	for i in get_node("menucontrol/menupanel/SavePanel/ScrollContainer/savelist").get_children():
		if i != get_node("menucontrol/menupanel/SavePanel/ScrollContainer/savelist/Button"):
			i.hide()
			i.queue_free()
	var dir = Directory.new()
	if dir.dir_exists("user://saves") == false:
		dir.make_dir("user://saves")
	var savefiles = globals.dir_contents()
	for i in globals.savelist:
		if savefiles.find(i) < 0:
			globals.savelist.erase(i)
	pressedsave = get_node("menucontrol/menupanel/SavePanel//saveline").text
	for i in savefiles:
		node = get_node("menucontrol/menupanel/SavePanel/ScrollContainer/savelist/Button").duplicate()
		node.show()
		if globals.savelist.has(i):
			node.get_node("date").set_text(globals.savelist[i].date)
			node.get_node("name").set_text(i.replacen("user://saves/",''))
		else:
			node.get_node("name").set_text(i.replacen("user://saves/",''))
		get_node("menucontrol/menupanel/SavePanel/ScrollContainer/savelist").add_child(node)
		node.set_meta("name", i)
		node.connect('pressed', self, 'loadchosen', [node])



func loadchosen(node):
	var savename = node.get_meta('name')
	var text
	savefilename = savename
	for i in $menucontrol/menupanel/SavePanel/ScrollContainer/savelist.get_children():
		i.pressed = (i== node)
	get_node("menucontrol/menupanel/SavePanel/saveline").set_text(savefilename.replacen("user://saves/",''))
	if globals.savelist.has(savename):
		if globals.savelist[savename].has('portrait') && globals.loadimage(globals.savelist[savename].portrait):
			$menucontrol/menupanel/SavePanel/saveimage.set_texture(globals.loadimage(globals.savelist[savename].portrait))
		else:
			$menucontrol/menupanel/SavePanel/saveimage.set_texture(null)
		text = globals.savelist[savename].name
	else:
		text = "This save has no info stored."
		$menucontrol/menupanel/SavePanel/saveimage.set_texture(null)
	$menucontrol/menupanel/SavePanel/RichTextLabel.bbcode_text = text
	#_on_SavePanel_visibility_changed()

func _on_deletebutton_pressed():
	var dir = Directory.new()
	if dir.file_exists(savefilename):
		yesnopopup('Delete this file?', 'deletefile')
	else:
		popup('No file with such name')

func deletefile():
	var dir = Directory.new()
	if dir.dir_exists("user://saves") == false:
		dir.make_dir("user://saves")
	dir.remove(savefilename)
	_on_nobutton_pressed()
	_on_SavePanel_visibility_changed()


func _on_loadbutton_pressed():
	if Directory.new().file_exists(savefilename):
		yesnopopup('Load this file?', 'loadfile')
	else:
		popup('No file with such name')

func loadfile():
	if thread.is_active():
		thread.wait_to_finish()
	globals.load_game(savefilename)
	_on_SavePanel_visibility_changed()
	get_node("menucontrol").hide()
	get_node("music").playing = true
	

func _on_saveline_text_changed( text ):
	savefilename = "user://saves/" + text

func _on_savefilebutton_pressed():
	var dir = Directory.new()
	if dir.file_exists(savefilename) == true:
		yesnopopup('This file already exists. Overwrite?', 'savefile')
	else:
		savefile()

func savefile():
	globals.save_game(savefilename)
	_on_SavePanel_visibility_changed()
	_on_nobutton_pressed()
	get_node("menucontrol/menupanel/SavePanel").hide()
	get_node("menucontrol").hide()
	get_node("music").playing = true


func _on_saveloadfolder_pressed():
	var temp = OS.get_user_data_dir()
	OS.shell_open('file://'+temp + '/saves')


func hide_everything():
	for i in get_tree().get_nodes_in_group("mansioncontrols"):
		i.hide()
	get_node("MainScreen/mansion/jailpanel").hide()
	get_node("MainScreen/slave_tab").hide()
	get_node("MainScreen/mansion/alchemypanel").hide()
	get_node("MainScreen/mansion/mansioninfo").hide()
	get_node("MainScreen/mansion/labpanel").hide()
	get_node("MainScreen/mansion/labpanel/labmodpanel").hide()
	get_node("MainScreen/mansion/librarypanel").hide()
	get_node("MainScreen/mansion/farmpanel").hide()
	get_node("MainScreen/mansion/selfinspect").hide()
	get_node("MainScreen/mansion/portalspanel").hide()
	get_node("MainScreen/mansion/upgradespanel").hide()
	globals.hidetooltip()



func background_set(text):
	var player = get_node("screenchange/AnimationPlayer")
	if player.is_playing() == true:
		return
	if OS.get_name() != "HTML5" && globals.rules.fadinganimation == true:
		if get_node("TextureFrame").get_texture() != globals.backgrounds[text]:
			animationfade()
			yield(player, "animation_finished")
	texture = globals.backgrounds[text]
	get_node("TextureFrame").set_texture(texture)
	yield(get_tree(), "idle_frame")
	emit_signal('animfinished')


func animationfade(value = 0.4, duration = 0.05):
	var player = $screenchange/AnimationPlayer
	player.get_animation("fadetoblack").length = value + duration
	#print(var2str(player.get_animation("fadetoblack").track_get_key_value(0,0)))
	player.get_animation("fadetoblack").track_remove_key(0, 1)
	player.get_animation("fadetoblack").track_insert_key(0, value, Color(1,1,1,1)) 
	#print(player.get_animation('fadetoblack').track_set_key_value(0,1))
	if OS.get_name() != 'HTML5' && globals.rules.fadinganimation == true:
		player.play('fadetoblack')
		yield(player, "animation_finished")
		emit_signal("animfinished")
		player.play_backwards("fadetoblack")
	else:
		yield(get_tree(), 'idle_frame')
		emit_signal("animfinished")

func screenanimation(text):
	var player = get_node("screenchange/AnimationPlayer")
	if OS.get_name() != 'HTML5' && globals.rules.fadinganimation == true:
		player.play(text)
		yield(player, "animation_finished")
		emit_signal("animfinished")
	

var musicdict = globals.musicdict
var musicvolume = 0


func music_set(text):
	var music = get_node("music")
	if music.is_playing() == false && globals.rules.musicvol > 0:
		music.playing = true
	if text == 'stop':
		musicfading = true
		music.stop()
		return
	elif text == 'pause':
		musicfading = true
		return
	elif text == 'start':
		musicraising = true
		music.play(musicvalue)
		return
	if globals.rules.musicvol == 0 || (music.get_meta("currentsong") == text && music.playing == true):
		return
	var path = ''
	var array = []
	musicraising = true
	music.set_autoplay(true)
	if text == 'combat':
		array = ['combat1', 'combat3']
		path = musicdict[array[rand_range(0,array.size())]]
	elif text == 'mansion':
		music.set_autoplay(false)
		array = ['mansion1','mansion2','mansion3','mansion4']
		path = musicdict[array[rand_range(0,array.size())]]
	else:
		path = musicdict[text]
	music.set_meta('currentsong', text)
	music.set_stream(path)
	music.play(0)
	music.set_volume_db(globals.rules.musicvol)


func _on_music_finished():
	if get_node("music").get_meta("currentsong") == 'mansion':
		get_node("music").set_meta("currentsong", 'over')
		music_set("mansion")
	elif get_node("music").get_meta("currentsong") == 'combat':
		get_node("music").set_meta("currentsong", 'over')
		music_set("combat")
	else:
		music_set(get_node("music").get_meta("currentsong"))



func _on_mansionbutton_pressed():
	_on_mansion_pressed()

var selftexture = load("res://files/buttons/mainscreen/53(2).png")

func _on_mansion_pressed():
	var textnode = get_node("MainScreen/mansion/mansioninfo")
	var text = ''
	background_set('mansion')
	yield(self, 'animfinished')
	hide_everything()
	for i in get_tree().get_nodes_in_group("mansioncontrols"):
		i.show()
	get_node("outside/slavesellpanel").hide()
	get_node("outside/slavebuypanel").hide()
	get_node("outside/slaveguildquestpanel").hide()
	get_node("outside/slaveservicepanel").hide()
	get_node("outside").hide()
	get_node("hideui").hide()
	get_node("charlistcontrol").show()
	get_node("MainScreen").show()
	get_node("Navigation").show()
	get_node("ResourcePanel/menu").disabled = false
	get_node("ResourcePanel/helpglossary").disabled = false
	get_node("MainScreen/mansion/sexbutton").set_disabled(globals.state.sexactions < 1)
	if globals.player.imageportait != null && globals.loadimage(globals.player.imageportait):
		$Navigation/personal/TextureRect.texture = globals.loadimage(globals.player.imageportait)
	else:
		$Navigation/personal/TextureRect.texture = selftexture
	$ResourcePanel/clean.set_text(str(round(globals.state.condition)) + '%')
	#var portals = false
	#for i in globals.state.portals.values():
	#	if i.enabled == true:
	#		portals = true
	#$MainScreen/mansion/portals.set_disabled(!portals)
	textnode.show()
	var sleepers = globals.count_sleepers()
	text = 'You are at your mansion, which is located near [color=aqua]'+ globals.state.location.capitalize()+'[/color].\n\n'
	text += 'You have '
	if sleepers.communal > globals.state.mansionupgrades.mansioncommunal:
		text += '[color=#ff4949]'
	elif sleepers.communal == globals.state.mansionupgrades.mansioncommunal:
		text += '[color=yellow]'
	else:
		text += '[color=green]'
	text += str(globals.state.mansionupgrades.mansioncommunal) + '[/color] beds in communal room\n'
	text += 'You have ' + globals.fastif(sleepers.personal >= globals.state.mansionupgrades.mansionpersonal, '[color=#ff4949]', '[color=green]') + str(globals.state.mansionupgrades.mansionpersonal) + '[/color] ' + globals.fastif(globals.state.mansionupgrades.mansionpersonal > 1, 'personal rooms', 'personal room')+ ' available for living\nYour bed can fit ' +globals.fastif(sleepers['your_bed'] >= globals.state.mansionupgrades.mansionbed, '[color=#ff4949]', '[color=green]') + str(globals.state.mansionupgrades.mansionbed) + '[/color] ' +  globals.fastif(globals.state.mansionupgrades.mansionpersonal > 1, 'persons', 'person')+' besides you.\n\nYour jail can hold up to ' +globals.fastif(sleepers.jail >= globals.state.mansionupgrades.jailcapacity, '[color=#ff4949]', '[color=green]') + str(globals.state.mansionupgrades.jailcapacity) +'[/color] prisoners. \n\n'
	if globals.state.condition <= 20:
		text += 'Mansion is [color=#ff4949]in a complete mess[/color].\n\n'
	elif globals.state.condition <= 40:
		text += 'Mansion is [color=#FFA500]very dirty[/color].\n\n'
	elif globals.state.condition <= 60:
		text += 'Mansion is [color=yellow]quite unclean[/color].\n\n'
	elif globals.state.condition <= 80:
		text += 'Mansion is [color=lime]passably clean[/color].\n\n'
	else:
		text += 'Mansion is [color=green]immaculate[/color].\n\n'
	if globals.state.playergroup.size() <= 0:
		text = text + 'Nobody is assigned to follow you.\n\n'
	else:
		for i in globals.state.playergroup:
			var person = globals.state.findslave(i)
			if person != null:
				text = text + person.dictionary('$name is assigned to your group.\n')
			else:
				globals.state.playergroup.erase(i)
	textnode.set_bbcode(text)
	var headgirl = false
	for i in globals.slaves:
		if i.work == 'headgirl':
			headgirl = true
			text = text + i.dictionary('$name is your headgirl.')
	if (globals.slaves.size() >= 8 && headgirl == true) || globals.developmode == true:
		get_node("charlistcontrol/slavelist").show()
	else:
		get_node("charlistcontrol/slavelist").hide()
	if globals.state.farm >= 3:
		get_node("Navigation/farm").set_disabled(false)
	else:
		get_node("Navigation/farm").set_disabled(true)
	if globals.state.mansionupgrades.mansionlab > 0:
		get_node("Navigation/laboratory").set_disabled(false)
	else:
		get_node("Navigation/laboratory").set_disabled(true)
	music_set('mansion')
	if globals.state.sidequests.emily == 3:
		globals.events.emilymansion()
	if globals.state.capturedgroup.size() > 0:
		var array = []
		var nojailcells = false
		for i in globals.state.capturedgroup:
			array.append(i)
		for i in array:
			for k in i.gear:
				i.gear[k] = null
			globals.slaves = i
			if globals.count_sleepers().jail < globals.state.mansionupgrades.jailcapacity:
				i.sleep = 'jail'
			else:
				nojailcells = true
			globals.state.capturedgroup.erase(i)
		text = "You have assigned your captives to the mansion. " + globals.fastif(nojailcells, '[color=yellow]You are out of free jail cells and some captives were assigned to living room.[/color]', '')
		popup(text)
	rebuild_slave_list()

#jail settings

func _on_jailbutton_pressed():
	background_set('jail')
	yield(self, 'animfinished')
	hide_everything()
	get_node("MainScreen/mansion/jailpanel").show()
	if globals.state.tutorial.jail == false:
		get_node("tutorialnode").jail()

func _on_jailpanel_visibility_changed():
	var temp = ''
	var text = ''
	var count = 0
	var prisoners = []
	var jailer
	
	for i in get_node("MainScreen/mansion/jailpanel/ScrollContainer/prisonerlist").get_children():
		i.hide()
		i.queue_free()
	
	if get_node("MainScreen/mansion/jailpanel").visible == false:
		return
	for i in globals.slaves:
		if i.sleep == 'jail':
			temp = temp + i.name
			prisoners.append(i)
			var button = Button.new()
			var node = get_node("MainScreen/mansion/jailpanel/ScrollContainer/prisonerlist")
			node.add_child(button)
			button.set_text(i.name_long())
			button.set_name(str(count))
			button.connect('pressed', self, 'prisonertab', [count])
		if i.work == 'jailer':
			jailer = i
		count += 1
	if temp == '':
		text = 'You have no prisoners at this moment.'
	else:
		text = 'You have '+str(prisoners.size()) + ' prisoner(s).\nYou have ' + str(globals.state.mansionupgrades.jailcapacity-prisoners.size()) + ' free cell(s).\nPrisoners can be disciplined at "Interactions" with abuse setting. '
	if globals.state.mansionupgrades.jailincenses:
		text += "\n[color=green]Your jail is decently furnished and tiled. [/color]"
	if globals.state.mansionupgrades.jailincenses:
		text += "\n[color=green]You can smell soft burning incenses in the air.[/color]"
	if jailer == null:
		text = text + '\nYou have no assigned jailer.'
	else:
		text = text + jailer.dictionary('\n$name is assigned as jailer.')
	
	
	get_node("MainScreen/mansion/jailpanel/jailtext").set_bbcode(text)

func _on_jailsettingspanel_visibility_changed(inputslave = null):
	var jailer = inputslave
	for i in globals.slaves:
		if i.work == 'jailer':
			jailer = i
	var text = ''
	if jailer == null:
		text = 'You have no assigned jailer. '
		get_node("MainScreen/mansion/jailpanel/jailsettings/jailsettingspanel/jailerchange").set_text('Change')
	else:
		text = 'Your current jailer is - ' + jailer.name_long()
		jailer.work = 'jailer'
		get_node("MainScreen/mansion/jailpanel/jailsettings/jailsettingspanel/jailerchange").set_text('Unassign')
	get_node("MainScreen/mansion/jailpanel/jailsettings/jailsettingspanel/currentjailertext").set_bbcode(text)
	if globals.slaves.size() < 1:
		get_node("MainScreen/mansion/jailpanel/jailsettings/jailsettingspanel/jailerchange").set_disabled(true)
	else:
		get_node("MainScreen/mansion/jailpanel/jailsettings/jailsettingspanel/jailerchange").set_disabled(false)
	_on_jailpanel_visibility_changed()

func prisonertab(number):
	self.currentslave = number
	get_node("MainScreen/slave_tab").tab = 'prison'
	get_node("MainScreen/slave_tab").slavetabopen()

func _on_jailerchange_pressed():
	if get_node("MainScreen/mansion/jailpanel/jailsettings/jailsettingspanel/jailerchange").get_text() != 'Unassign':
		selectslavelist(false, '_on_jailsettingspanel_visibility_changed', self, 'globals.currentslave.loyal >= 20 && globals.currentslave.conf >= 50')
	else:
		for i in globals.slaves:
			if i.work == 'jailer':
				i.work = 'rest'
		_on_jailsettingspanel_visibility_changed()


func _on_jailsettings_pressed():
	get_node("MainScreen/mansion/jailpanel/jailsettings/jailsettingspanel").show()

func _on_jailerclose_pressed():
	get_node("MainScreen/mansion/jailpanel/jailsettings/jailsettingspanel").hide()

var potselected

func _on_alchemy_pressed():
	background_set('alchemy' + str(globals.state.mansionupgrades.mansionalchemy))
	yield(self, 'animfinished')
	hide_everything()
	get_node("MainScreen/mansion/alchemypanel").show()
	if globals.state.tutorial.alchemy == false:
		get_node("tutorialnode").alchemy()
	if globals.state.sidequests.chloe == 8 && globals.state.mansionupgrades.mansionalchemy >= 1:
		globals.events.chloealchemy()
	potselected = ''
	var potlist = get_node("MainScreen/mansion/alchemypanel/ScrollContainer/selectpotionlist")
	var potline = get_node("MainScreen/mansion/alchemypanel/ScrollContainer/selectpotionlist/selectpotionline")
	var maintext = get_node("MainScreen/mansion/alchemypanel/alchemytext")
	if globals.state.mansionupgrades.mansionalchemy == 0:
		maintext.set_bbcode("Your alchemy room lacks sufficient tools to craft your own potions. You have to unlock it from [color=yellow]Mansion Upgrades[/color] first.")
		for i in get_node("MainScreen/mansion/alchemypanel").get_children():
			i.hide()
		maintext.show()
		return
	else:
		get_node("MainScreen/mansion/alchemypanel/alchemytext").set_bbcode("This is your alchemy room. Chemistry equipment is ready to use and shelves contain your fresh ingredients.")
		get_node("MainScreen/mansion/alchemypanel/potdescription").set_bbcode('')
		for i in get_node("MainScreen/mansion/alchemypanel").get_children():
			i.show()
	for i in potlist.get_children():
		if i != potline:
			i.hide()
			i.queue_free()
	var array = []
	for i in globals.itemdict.values():
		if i.recipe != '' && i.unlocked == true:
			array.append(i)
	array.sort_custom(globals.items,'sortitems')
	for i in array:
		var newpotline = potline.duplicate()
		potlist.add_child(newpotline)
		if i.icon != null:
			newpotline.get_node("potbutton/icon").set_texture(i.icon)
		newpotline.show()
		newpotline.get_node("potnumber").set_text(str(i.amount))
		newpotline.get_node("potbutton").set_text(i.name)
		newpotline.get_node("potbutton").connect('pressed', self, 'brewlistpressed', [i])
		newpotline.set_name(i.name)
	alchemyclear()

func alchemyclear():
	get_node("MainScreen/mansion/alchemypanel/Panel 2").hide()
	get_node("MainScreen/mansion/alchemypanel/Label").hide()
	get_node("MainScreen/mansion/alchemypanel/Label1").hide()
	for i in get_node("MainScreen/mansion/alchemypanel/VBoxContainer").get_children():
		if i.get_name() != 'Panel':
			i.hide()
			i.queue_free()
	

func brewlistpressed(potion):
	potselected = potion
	var counter = get_node("MainScreen/mansion/alchemypanel/brewcounter").get_value()
	var text = ''
	var recipedict = {}
	var brewable = true
	recipedict = globals.items[potion.recipe]
	var array = []
	for i in recipedict:
		array.append(i)
	array.sort_custom(globals.items,'sortbytype')
	alchemyclear()
	if potselected.icon != null:
		get_node("MainScreen/mansion/alchemypanel/Panel 2").show()
		get_node("MainScreen/mansion/alchemypanel/Panel 2/bigicon").set_texture(potselected.icon)
	get_node("MainScreen/mansion/alchemypanel/Label").show()
	get_node("MainScreen/mansion/alchemypanel/Label1").show()
	for i in array:
		var item = globals.itemdict[i]
		var newpanel = get_node("MainScreen/mansion/alchemypanel/VBoxContainer/Panel").duplicate()
		get_node("MainScreen/mansion/alchemypanel/VBoxContainer/").add_child(newpanel)
		newpanel.show()
		newpanel.get_node("icon").set_texture(item.icon)
		newpanel.get_node("icon").connect("mouse_entered",globals, 'showtooltip', [item.description])
		newpanel.get_node("icon").connect("mouse_exited",globals, 'hidetooltip')
		newpanel.get_node('name').set_text(item.name)
		newpanel.get_node("number").set_text(str(recipedict[i]*counter))
		newpanel.get_node("totalnumber").set_text(str(item.amount))
		if item.amount < recipedict[i]*counter:
			newpanel.get_node("totalnumber").set('custom_colors/font_color', Color(1,0.29,0.29))
			brewable = false
	text = text + '\n[center][color=aqua]'+ potselected.name + '[/color][/center]\n' + '' + potselected.description + '\n'
	for i in get_tree().get_nodes_in_group('alchemypot'):
		if i.get_text() != potion.name && i.is_pressed() == true:
			i.set_pressed(false)
	get_node("MainScreen/mansion/alchemypanel/potdescription").set_bbcode(text)
	if counter == 0:
		brewable = false
	if brewable == false:
		get_node("MainScreen/mansion/alchemypanel/brewbutton").set_disabled(true)
	else:
		get_node("MainScreen/mansion/alchemypanel/brewbutton").set_disabled(false)


func _on_brewbutton_pressed():
	if potselected == null:
		return
	var counter = get_node("MainScreen/mansion/alchemypanel/brewcounter").get_value()
	while counter > 0:
		counter -= 1
		globals.items.recipemake(potselected)
	brewlistpressed(potselected)
	_on_alchemy_pressed()
	get_node("MainScreen/mansion/alchemypanel/brewbutton").set_disabled(true)

func _on_brewcounter_value_changed( value ):
	if typeof(potselected) != 4:
		brewlistpressed(potselected)

func chloealchemy():
	globals.events.chloealchemy()

var loredict = globals.dictionary.loredict

func _on_library_pressed():
	if globals.state.mansionupgrades.mansionlibrary == 0:
		background_set('library1')
	else:
		background_set('library2')
	yield(self, 'animfinished')
	hide_everything()
	get_node("MainScreen/mansion/librarypanel").show()
	var text = ''
	if globals.state.mansionupgrades.mansionlibrary == 0:
		text = "Tucked away in a large room off the main passage in the mansion is the library. Bookshelves line every wall leaving only spaces for long narrow windows and the door. The shelves are mostly empty a few scarce books from your days studying you've brought with you. "
	else:
		text = "Tucked away in a large room off the main passage in the mansion is the library. Bookshelves line every wall leaving only spaces for long narrow windows and the door. Your collection of books grew bigger since your earlier days, and you are fairly proud of it."
	var list = get_node("MainScreen/mansion/librarypanel/TextureFrame/ScrollContainer/VBoxContainer")
	for i in list.get_children():
		if i.get_name() != "Button":
			i.hide()
			i.queue_free()
	
	var array = []
	for i in loredict.values():
		if globals.evaluate(i.reqs) == false:
			continue
		var newbutton = get_node("MainScreen/mansion/librarypanel/TextureFrame/ScrollContainer/VBoxContainer/Button").duplicate()
		list.add_child(newbutton)
		newbutton.show()
		newbutton.set_text(i.name)
		newbutton.set_meta('lore', i)
		newbutton.connect('pressed',self,'lorebutton', [i])
	
	var personarray = []
	for person in globals.slaves:
		if person.work == 'library':
			personarray.append(person)
	if personarray.size() > 0:
		text += '\n\nYou can see '
		for i in personarray:
			text += i.dictionary('$name')
			if i != personarray.back() && personarray.find(i) != personarray.size()-2:
				text += ', '
			elif personarray.find(i) == personarray.size()-2:
				text += ' and '
		text += " studying here."
	get_node("MainScreen/mansion/librarypanel/libraryinfo").set_bbcode(text)

func lorebutton(lore):
	for i in get_node("MainScreen/mansion/librarypanel/TextureFrame/ScrollContainer/VBoxContainer").get_children():
		if i.get_name() != 'Button' && i.get_meta('lore') != lore:
			i.set_pressed(false)
		else:
			i.set_pressed(true)
	get_node("MainScreen/mansion/librarypanel/TextureFrame/librarytext").set_bbcode(lore.text)
	get_node("MainScreen/mansion/librarypanel/TextureFrame/librarytext").get_v_scroll().set_value(0)

func _on_lorebutton_pressed():
	get_node("MainScreen/mansion/librarypanel/TextureFrame").show()

func _on_libraryclose_pressed():
	get_node("MainScreen/mansion/librarypanel/TextureFrame").hide()
###########QUEST LOG

func _on_questlog_pressed():
	get_node("questnode").popup()


func _on_questsclosebutton_pressed():
	get_node("questnode").hide()

var mainquestdict = {
'0' : "You should try joining Mage Order in town to get access to better stuff and start your career.",
'1' : "Old chancellor at Mage Order wants me to bring him a girl before I can join. She must be: \nFemale;\nHuman; \nAverage look (40) or better; \nHigh obedience; \n\nI can probably take a look at Slavers's Guild or explore outsides. ",
'2' : "Visit Mage Order again and seek for further promotions.",
'3' : "Melissa from Mage Order wants you to bring them captured Fairy. ",
'3.1' : "Melissa from Mage Order wants you to bring them captured Fairy, I should be able to find them in far forests around Wimborn. ",
'4' : "Return to Melissa for further information.",
'5' : "Melissa told you to find Sebastian at the market and get her 'delivery'.",
'6' : "Acquire alchemical station, brew Elixir of Youth and return it to Melissa.",
'7' : "Visit Melissa for your next task.",
'8' : "Set up a laboratory. You can buy tools at Mage's Order. Then return to Melissa.",
'9' : "Return to Melissa.",
'10': "Bring Melissa a Taurus girl with huge lactating tits. Size can be altered with certain potions. ",
'11': "Visit Melissa for your next mission. ",
'12': "Melissa told you to travel to Gorn and find the Orc named Garthor. ",
'13': "Garthor from Gorn ordered you to capture and bring Dark Elf Ivran who you can find at Gorn's outskirts.",
'14': "Wait for next day until returning to Garthor. ",
'15': "Return to Garthor and decide what should be done with Ivran. ",
'16': "Return back to Melissa for your next task. ",
'17': "Get to the Amberguard through the Deep Elven Grove. ",
'18': "Get to the Tunnel Entrance which lays after the Amber Road. ",
'19': "Search through Amberguard for a way to get into Tunnel Entrance. ",
'20': "Purchase the information from stranger in Amberguard. ",
'21': "Locate Witch's Hut at the Amber Road. ",
'22': "Ask Shuriya in the Hut near Amber Road how to get into tunnels",
'23': "Bring 2 slaves to the Shuriya: an elf and a drow. ",
'24': "Search through Undercity ruins for any remaining documents. ",
'25': "Return to Melissa with your findings. ",
'26': "Visit Melissa for your next assignement. ",
'27': "Visit Capital. ",
'28': "Visit Frostford's City Hall. ",
'28.1': "Investigate suspicious hunting grounds at Frostford's outskirts. ",
'29': "Report back to Theron about your findings. ",
'30': "Decide on the solution for Frostford's issue. ",
'31': "Let Theron know about Zoe's decision.",
'32': "Return to Zoe while having total 500 units of food, 15 Nature Essences and 5 Fluid Substances.",
'33': "Return to Theron.",
'34': "Return to Theron.",
'35':"Return to Theron.",
'36': "Visit Melissa",
'37': "Visit Garthor at Gorn",
'38': "Search for Ayda at her shop",
'39': "Search for Ayda at Gorn's Mountain region",
'41': "Return to Wimborn's Mage Order",
'42': "Main story quest Finished"
}
var chloequestdict = {
'3':"Chloe from Shaliq wants you to get 25 mana and visit her to trade it for a spell.",
'5':"Visit Chloe in the Shaliq.",
'6':"Chloe seems to be missing from her hut. You should try looking for her in the woods.",
'7':"Check on Chloe's condition in Shaliq. ",
'8':"Chloe asked you to brew an antidote for her. ",
'9':"Return with potion to [color=green]Chloe in Shaliq[/color].",
}
var caliquestdict = {
'12':"Talk to Cali about her parents",
'13':"Talk to Cali",
'14':"Ask around Wimborn for potential clues of Cali's origins",
'15':"Get information from Jason in Wimborn's Bar",
'16':"Pay up rest of the cash to the Jason for information",
'17':"Search Shaliq village in the Wimborn forest for clues",
'18':"Search forest bandits for clues",
'19':"Defeat bandits in camp in Wimborn forest",
'20':"Return to Shaliq for reward",
'21':"Return to Shaliq for reward",
'22':"Talk to Cali",
'23':"Locate slavers camp in Wimborn outskirts",
'24':"Locate slavers camp in Wimborn outskirts",
'25':"Locate bandit responsible for Cali's kidnap",
'26':"Locate Cali's house in Eerie woods"
}
var emilyquestdict = {
'12':"Search for Tisha at the Wimborn's Mage Order",
'13':"Search for suspicious person at the backstreets",
'14':"Your investigation tells you Tisha might be at Gorn.",
'15':"Get Tisha out of Gorn's Slavers Guild",
}
var yrisquestdict = {
"1":"Accept Yris's challenge at Gorn's bar",
"2":"Find a way to win Yris's challenge at Gorn's bar. Perhaps, some potion might provide an option",
"3":"Talk to Yris at Gorn's Bar",
"4":"Find a way to secure your bet with Yris. Perhaps, some alchemist might shine some light upon your findings. You'll also need 1000 gold and 1 Deterrent potion.",
"5":"Beat Yris at her challenge at Gorn's Bar. You'll also need to bring 1000 gold and Deterrent potion. ",
}
var questtype = {slaverequest = 'Slave Request'}
var selectedrepeatable

func _on_questnode_visibility_changed():
	if get_node("questnode").visible == false:
		return
	var maintext = get_node("questnode/TabContainer/Main Quest/mainquesttext")
	var sidetext = get_node("questnode/TabContainer/Side Quests/sidequesttext")
	var repeattext = get_node("questnode/TabContainer/Repeatable Quests/repetablequesttext")
	maintext.set_bbcode(mainquestdict[str(globals.state.mainquest)])
	sidetext.set_bbcode('')
	repeattext.set_bbcode('')
	#sidequests
	if globals.state.sidequests.brothel == 1:
		sidetext.set_bbcode(sidetext.get_bbcode() + "—To let your slaves work at prostitution, you'll have to bring [color=green]Elf girl[/color] to the brothel. \n\n")
	if globals.state.farm == 2:
		sidetext.set_bbcode(sidetext.get_bbcode()+ "—Sebastian proposed you to purchase to set up your own human farm for 1000 gold.\n\n")
	if chloequestdict.has(str(globals.state.sidequests.chloe)):
		sidetext.set_bbcode(sidetext.get_bbcode() + "—"+ chloequestdict[str(globals.state.sidequests.chloe)]+"\n\n")
	if caliquestdict.has(str(globals.state.sidequests.cali)):
		sidetext.set_bbcode(sidetext.get_bbcode() + "—"+ caliquestdict[str(globals.state.sidequests.cali)]+"\n\n")
	if emilyquestdict.has(str(globals.state.sidequests.emily)):
		sidetext.set_bbcode(sidetext.get_bbcode() + "—"+ emilyquestdict[str(globals.state.sidequests.emily)]+"\n\n")
	if yrisquestdict.has(str(globals.state.sidequests.yris)):
		sidetext.set_bbcode(sidetext.get_bbcode() + "—"+ yrisquestdict[str(globals.state.sidequests.yris)]+"\n\n")
	#repeatables
	for i in get_node("questnode/TabContainer/Repeatable Quests/ScrollContainer/VBoxContainer").get_children():
		if i != get_node("questnode/TabContainer/Repeatable Quests/ScrollContainer/VBoxContainer/Button"):
			i.hide()
			i.queue_free()
	selectedrepeatable = null
	get_node("questnode/TabContainer/Repeatable Quests/questforfeit").set_disabled(true)
	for i in globals.state.repeatables:
		for ii in globals.state.repeatables[i]:
			if ii.taken == true:
				var newbutton = get_node("questnode/TabContainer/Repeatable Quests/ScrollContainer/VBoxContainer/Button").duplicate()
				get_node("questnode/TabContainer/Repeatable Quests/ScrollContainer/VBoxContainer").add_child(newbutton)
				newbutton.show()
				newbutton.set_text(ii.location.capitalize() + ' - ' + questtype[ii.type])
				newbutton.connect("pressed",self,'repeatableselect', [ii])
				newbutton.set_meta('quest', ii)
	
	
	if sidetext.get_bbcode() == '':
		sidetext.set_bbcode('You have no active sidequests.')
	if get_node("questnode/TabContainer/Repeatable Quests/ScrollContainer/VBoxContainer").get_children().size() <= 1:
		repeattext.set_bbcode('You have no active repeatable quests.')
	else:
		repeattext.set_bbcode('Choose repeatable quest to see detailed info.')

func repeatableselect(quest):
	selectedrepeatable = quest
	get_node("questnode/TabContainer/Repeatable Quests/questforfeit").set_disabled(false)
	var text = ''
	for i in get_node("questnode/TabContainer/Repeatable Quests/ScrollContainer/VBoxContainer").get_children():
		if i.has_meta('quest') == true:
			if i.get_meta('quest') != quest && i.is_pressed() == true:
				i.set_pressed(false)
	text = get_node("outside").slavequesttext(quest)
	text = text.replace('Time Limit:', 'Time Remained:')
	get_node("questnode/TabContainer/Repeatable Quests/repetablequesttext").set_bbcode(text)

func _on_questforfeit_pressed():
	if selectedrepeatable != null:
		yesnopopup("Cancel this quest?", 'removequest')

func removequest():
	for i in globals.state.repeatables:
		for ii in globals.state.repeatables[i]:
			if ii == selectedrepeatable:
				globals.state.repeatables[i].remove(globals.state.repeatables[i].find(ii))
	get_node("menucontrol/yesnopopup").hide()
	_on_questnode_visibility_changed()

var spellscategory = 'control'
var spellbookimages = {
control = load("res://files/buttons/book/control.png"),
offensive = load("res://files/buttons/book/offensive.png"),
defensive = load("res://files/buttons/book/defensive.png"),
utility = load("res://files/buttons/book/utility.png"),
}

func _on_spellbook_pressed():
	get_node("spellbooknode").popup()
	var spelllist = get_node("spellbooknode/spellbooklist/ScrollContainer/spellist")
	var spellbutton = get_node("spellbooknode/spellbooklist/ScrollContainer/spellist/spellbutton")
	get_node("spellbooknode/spellbooklist").set_texture(spellbookimages[spellscategory])
	for i in spelllist.get_children():
		if i != spellbutton:
			i.hide()
			i.queue_free()
	var array = []
	for i in globals.spelldict.values():
		array.append(i)
	array.sort_custom(get_node("spellnode"),'sortspells')
	get_node("spellbooknode/spellbooklist/spelldescription").set_bbcode('')
	for i in array:
		if i.learned == true && i.type == spellscategory:
			var newbutton = spellbutton.duplicate()
			spelllist.add_child(newbutton)
			newbutton.set_text(i.name)
			newbutton.show()
			newbutton.connect('pressed',self,'spellbookselected',[i])
	#get_node("screenchange/AnimationPlayer").play("fadetoblack")

func spellbookselected(spell):
	var text = ''
	for i in get_tree().get_nodes_in_group("spellbutton"):
		if i.get_text() != spell.name: i.set_pressed(false)
	text = '[center]'+ spell.name + '[/center]\n\n' + spell.description + '\n\nType: ' + spell.type.capitalize() + '\n\nMana: ' + str(spell.manacost)
	if spell.combat == true:
		text += '\n\nCan be used in combat'
	get_node("spellbooknode/spellbooklist/spelldescription").set_bbcode(text)

func spellbookcategory(button):
	spellscategory = button.get_name()
	_on_spellbook_pressed()

func _on_spellbookclose_pressed():
	get_node("spellbooknode").hide()


func _on_debug_pressed():
	get_node("options").show()
	get_node("options")._on_cheats_pressed()

var baby

func childbirth(person):
	person.metrics.birth += 1
	get_node("birthpanel").show()
	baby = globals.state.findbaby(person.preg.baby)
	var text = ''
	person.preg.duration = 0
	person.preg.baby = null
	person.preg.fertility = 5
	if globals.state.mansionupgrades.mansionnursery == 1:
		if globals.player == person:
			text = person.dictionary('You gave birth to a ')
		else:
			text = person.dictionary('$name gave birth to a ')
		text += baby.dictionary('healthy $race $child. ') + globals.description.getBabyDescription(baby)
		if globals.state.rank < 2:
			get_node("birthpanel/raise").set_disabled(true)
			text = text + "\nSadly, you can't allow to raise it, as your guild rank is too low. "
		else:
			text = text + "\nWould you like to send it to another dimension to accelerate its growth? This will cost you 500 gold. "
			if globals.resources.gold >= 500:
				get_node("birthpanel/raise").set_disabled(false)
			else:
				get_node("birthpanel/raise").set_disabled(true)
	else:
		if globals.player == person:
			text = person.dictionary("You've had to use town's hospital to give birth to your child. Sadly, you can't keep it without Nursery Room and had to give it away.")
		else:
			text = person.dictionary("$name had to use town's hospital to give birth to your child. Sadly, you can't keep it without Nursery Room and had to give it away.")
		get_node("birthpanel/raise").set_disabled(true)
	get_node("birthpanel/birthtext").set_bbcode(text)

func _on_giveaway_pressed():
	get_node("birthpanel").hide()
	nextdayevents()

func _on_raise_pressed():
	get_node("birthpanel/raise/childpanel").show()
	globals.resources.gold -= 500
	get_node("birthpanel/raise/childpanel/LineEdit").set_text(baby.name)
	if globals.rules.children != true:
		get_node("birthpanel/raise/childpanel/child").hide()
	else:
		get_node("birthpanel/raise/childpanel/child").show()

func babyage(age):
	baby.name = get_node("birthpanel/raise/childpanel/LineEdit").get_text()
	if get_node("birthpanel/raise/childpanel/surnamecheckbox").is_pressed() == true:
		baby.surname = globals.player.surname
	if age == 'child':
		baby.age = 'child'
		var sizes = ['flat','small']
		if baby.sex != 'male':
			baby.titssize = sizes[rand_range(0,sizes.size())]
			baby.asssize = sizes[rand_range(0,sizes.size())]
		baby.away.duration = 15
	elif age == 'teen':
		baby.age = 'teen'
		var sizes = ['flat','small','average','big']
		if baby.sex != 'male':
			baby.titssize = sizes[rand_range(0,sizes.size())]
			baby.asssize = sizes[rand_range(0,sizes.size())]
		baby.away.duration = 20
	elif age == 'adult':
		baby.age = 'adult'
		var sizes = ['flat','small','average','big','huge']
		if baby.sex != 'male':
			baby.titssize = sizes[rand_range(0,sizes.size())]
			baby.asssize = sizes[rand_range(0,sizes.size())]
		baby.away.duration = 25
	baby.away.at = 'growing'
	baby.obed += 75
	baby.loyal += 20
	if baby.sex != 'male':
		baby.vagvirgin = true
		#baby.pussy.first = 'none'
	globals.slaves = baby
	globals.state.babylist.erase(baby)
	baby = null
	get_node("birthpanel").hide()
	get_node("birthpanel/raise/childpanel").hide()
	nextdayevents()





func _on_helpglossary_pressed():
	get_node("tutorialnode").callalise()

#### selfinsepct


func _on_selfbutton_pressed():
	hide_everything()
	get_node("MainScreen/mansion/selfinspect").show()
	get_node("MainScreen/mansion/selfinspect/selflookspanel").hide()
	var text = '[center]Personal Achievments[/center]\n'
	var text2 = ''
	var person = globals.player
	var dict = {
	0: "You do not belong in an Order.",
	1: "Neophyte",
	2: "Apprentice",
	3: "Journeyman",
	4: "Adept",
	5: "Master",
	6: "Grand Archmage"}
	text += 'Combat Abilities: '
	for i in person.ability:
		var ability = globals.abilities.abilitydict[i]
		if ability.learnable == true:
			text2 += ability.name + ', '
	if text2 == '':
		text += 'none. \n'
	else:
		text2 = text2.substr(0, text2.length() -2)+ '. '
	text += text2 + '\nReputation: '
	for i in globals.state.reputation:
		text += i.capitalize() + " - "+ reputationword(globals.state.reputation[i]) + ", "
	text += "\nYour mage order rank: " + dict[int(globals.state.rank)]
	get_node("MainScreen/mansion/selfinspect/mainstatlabel").set_bbcode(text)
	updatestats(person)




func stattooltip(value):
	var text = globals.statsdescript[value]
	globals.showtooltip(text)

func statup(stat):
	globals.player[stat] += 1
	globals.player.skillpoints -= 1
	updatestats(globals.player)

onready var sstr = get_node("MainScreen/mansion/selfinspect/statspanel/sstr")
onready var sagi = get_node("MainScreen/mansion/selfinspect/statspanel/sagi")
onready var smaf = get_node("MainScreen/mansion/selfinspect/statspanel/smaf")
onready var send = get_node("MainScreen/mansion/selfinspect/statspanel/send")

func updatestats(person):
	var text = ''
	for i in ['sstr','sagi','smaf','send']:
		text = str(person[i])
		self[i].get_node('cur').set_text(text)
		if i in ['sstr','sagi','smaf','send']:
			if person.stats[globals.maxstatdict[i].replace("_max",'_mod')] >= 1:
				self[i].get_node('cur').set('custom_colors/font_color', Color(0,1,0))
			elif person.stats[globals.maxstatdict[i].replace("_max",'_mod')] < 0:
				self[i].get_node('cur').set('custom_colors/font_color', Color(1,0.29,0.29))
			else:
				self[i].get_node('cur').set('custom_colors/font_color', Color(1,1,1))
		self[i].get_node('max').set_text(str(min(person.stats[globals.maxstatdict[i]], person.originvalue[person.origins])))
	text = person.name_long() + '\n[color=aqua][url=race]' +person.dictionary('$race[/url][/color]').capitalize() +  '\nLevel : '+str(person.level)
	get_node("MainScreen/mansion/selfinspect/statspanel/info").set_bbcode(person.dictionary(text))
	get_node("MainScreen/mansion/selfinspect/statspanel/attribute").set_text("Free Attribute Points : "+str(person.skillpoints))
	
	for i in ['send','smaf','sstr','sagi']:
		if person.skillpoints >= 1 && (globals.slaves.find(person) >= 0||globals.player == person) && person.stats[globals.maxstatdict[i].replace('_max','_cur')] < person.stats[globals.maxstatdict[i]]:
			get_node("MainScreen/mansion/selfinspect/statspanel/" + i +'/Button').visible = true
		else:
			get_node("MainScreen/mansion/selfinspect/statspanel/" + i+'/Button').visible = false
	get_node("MainScreen/mansion/selfinspect/statspanel/hp").set_value((person.stats.health_cur/float(person.stats.health_max))*100)
	get_node("MainScreen/mansion/selfinspect/statspanel/en").set_value((person.stats.energy_cur/float(person.stats.energy_max))*100)
	get_node("MainScreen/mansion/selfinspect/statspanel/xp").set_value(person.xp)
	text = "Health: " + str(person.stats.health_cur) + "/" + str(person.stats.health_max) + "\nEnergy: " + str(person.stats.energy_cur) + "/" + str(person.stats.energy_max) + "\nExperience: " + str(person.xp)
	get_node("MainScreen/mansion/selfinspect/statspanel/hptooltip").set_tooltip(text)
	if person.imageportait != null && globals.loadimage(person.imageportait):
		$MainScreen/mansion/selfinspect/statspanel/TextureRect/portrait.set_texture(globals.loadimage(person.imageportait))
	else:
		person.imageportait = null
		$MainScreen/mansion/selfinspect/statspanel/TextureRect/portrait.set_texture(null)

var gradeimages = {
slave = load("res://files/buttons/mainscreen/40.png"),
poor = load("res://files/buttons/mainscreen/41.png"),
commoner = load("res://files/buttons/mainscreen/42.png"),
rich = load("res://files/buttons/mainscreen/43.png"),
noble = load("res://files/buttons/mainscreen/44.png"),
}




func _on_selfinspectclose_pressed():
	get_node("MainScreen/mansion/selfinspect").hide()
	_on_mansion_pressed()


func _on_selfgear_pressed():
	globals.items.person = globals.player
	get_node("paperdoll").person = globals.player
	get_node("paperdoll").showup()


func reputationword(value):
	var text = ""
	if value >= 30:
		text = "[color=green]Great[/color]"
	elif value >= 10:
		text = "[color=green]Positive[/color]"
	elif value <= -10:
		text = "[color=#ff4949]Bad[/color]"
	elif value <= -30:
		text = "[color=#ff4949]Terrible[/color]"
	else:
		text = "Neutral"
	return text


func _on_selfinspectlooks_pressed():
	get_node("MainScreen/mansion/selfinspect/selflookspanel/selfdescript").set_bbcode(globals.player.description())
	get_node("MainScreen/mansion/selfinspect/selflookspanel").show()

func _on_selfskillclose_pressed():
	get_node("MainScreen/mansion/selfinspect/selflookspanel").hide()

func _on_selfabilityupgrade_pressed():
	get_node("MainScreen/mansion/selfinspect/selfabilitypanel/abilitydescript").set_bbcode('')
	get_node("MainScreen/mansion/selfinspect/selfabilitypanel").show()
	get_node("MainScreen/mansion/selfinspect/selfabilitypanel/abilitypurchase").set_disabled(true)
	for i in get_node("MainScreen/mansion/selfinspect/selfabilitypanel/ScrollContainer/VBoxContainer").get_children():
		if i != get_node("MainScreen/mansion/selfinspect/selfabilitypanel/ScrollContainer/VBoxContainer/Button"):
			i.hide()
			i.queue_free()
	for i in globals.abilities.abilitydict.values():
		if i.learnable == true && globals.player.ability.find(i.code) < 0 && (i.has('requiredspell') == false || globals.spelldict[i.requiredspell].learned == true):
			var newbutton = get_node("MainScreen/mansion/selfinspect/selfabilitypanel/ScrollContainer/VBoxContainer/Button").duplicate()
			get_node("MainScreen/mansion/selfinspect/selfabilitypanel/ScrollContainer/VBoxContainer").add_child(newbutton)
			newbutton.show()
			newbutton.set_text(i.name)
			newbutton.connect("pressed",self,'selfabilityselect',[i])


func selfabilityselect(ability):
	var text = ''
	var person = globals.player
	var dict = {'sstr': 'Strength', 'sagi' : 'Agility', 'smaf': 'Magic', 'level': 'Level'}
	var confirmbutton = get_node("MainScreen/mansion/selfinspect/selfabilitypanel/abilitypurchase")
	
	for i in get_node("MainScreen/mansion/selfinspect/selfabilitypanel/ScrollContainer/VBoxContainer").get_children():
		if i.get_text() != ability.name:
			i.set_pressed(false)
	
	confirmbutton.set_disabled(false)
	
	text = '[center]'+ ability.name + '[/center]\n' + ability.description + '\nCooldown:' + str(ability.cooldown) + '\nLearn requirements: '
	
	var array = []
	for i in ability.reqs:
		array.append(i)
	array.sort_custom(self, 'levelfirst')
	
	for i in array:
		var temp = i
		var ref = person
		if i.find('.') >= 0:
			temp = i.split('.')
			for ii in temp:
				ref = ref[ii]
		else:
			ref = person[i]
		if ref < ability.reqs[i]:
			confirmbutton.set_disabled(true)
			text += '[color=#ff4949]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
		else:
			text += '[color=green]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
	text = text.substr(0, text.length() - 2) + '.'
	
	confirmbutton.set_meta('abil', ability)
	
	
	
	
	get_node("MainScreen/mansion/selfinspect/selfabilitypanel/abilitydescript").set_bbcode(text)





func _on_abilitypurchase_pressed():
	var abil = get_node("MainScreen/mansion/selfinspect/selfabilitypanel/abilitypurchase").get_meta('abil')
	globals.player.ability.append(abil.code)
	popup('You have learned ' + abil.name+'. ')
	_on_selfabilityupgrade_pressed()
	_on_selfbutton_pressed()


func _on_selfportait_pressed():
	imageselect("portrait",globals.player)


func _on_abilityclose_pressed():
	get_node("MainScreen/mansion/selfinspect/selfabilitypanel").hide()


func _on_selfpotion_pressed():
	_on_inventory_pressed('self')

var potionselected

func potbuttonpressed(potion):
	potionselected = potion
	var description = get_node("MainScreen/mansion/selfinspect/selectpotionpanel/potionusedescription")
	var potlist = get_node("MainScreen/mansion/selfinspect/selectpotionpanel/ScrollContainer/selectpotionlist")
	for i in get_tree().get_nodes_in_group('usables'):
		if i.get_text() != potion.name && i.is_pressed() == true:
			i.set_pressed(false)
	description.set_bbcode(potion.description + '\n\nIn possession: ' + str(potion.amount))


func _on_potioncancelbutton_pressed():
	get_node("MainScreen/mansion/selfinspect/selectpotionpanel").hide()
	potionselected = ''

func _on_potionusebutton_pressed():
	var person = globals.player
	var itemnode = globals.items
	itemnode.person = person
	if potionselected.code != 'minoruspot' && potionselected.code != 'majoruspot' && potionselected.code != 'hairdye':
		if potionselected.code in ['aphrodisiac', 'regressionpot', 'miscariagepot','amnesiapot','stimulantpot','deterrentpot']:
			popup(person.dictionary(itemnode.call(potionselected.effect)))
			return
		popup(person.dictionary(itemnode.call(potionselected.effect)))
		_on_selfbutton_pressed()
		person.toxicity += potionselected.toxicity
		potionselected.amount -= 1
	else:
		itemnode.call(potionselected.effect)
	get_node("MainScreen/mansion/selfinspect/selectpotionpanel").hide()



func _on_selfrelatives_pressed():
	get_node("MainScreen/mansion/selfinspect/relativespanel").show()
	var person = globals.player
	var mother = person.relatives.mother
	var father = person.relatives.father
	var id = person.id
	var parentslist = get_node("MainScreen/mansion/selfinspect/relativespanel/parentscontainer/parentscontainer")
	var siblingslist = get_node("MainScreen/mansion/selfinspect/relativespanel/siblingscontainer/siblingscontainer")
	var childrenlist = get_node("MainScreen/mansion/selfinspect/relativespanel/childrencontainer/childrencontainer")
	var newlabel
	for i in parentslist.get_children():
		if i != parentslist.get_node('Label'):
			i.hide()
			i.queue_free()
	for i in siblingslist.get_children():
		if i != siblingslist.get_node('Label'):
			i.hide()
			i.queue_free()
	for i in childrenlist.get_children():
		if i != childrenlist.get_node('Label'):
			i.hide()
			i.queue_free()
	############PARENTS
	newlabel = parentslist.get_node("Label").duplicate()
	parentslist.add_child(newlabel)
	newlabel.show()
	if mother == -1:
		newlabel.set_text('Mother - unknown')
	else:
		var found = false
		if typeof(mother) == 2 || typeof(mother) == 3:
			for i in globals.slaves:
				if i.id == person.relatives.mother && i != person:
					mother = i
					found = true
					newlabel.set_text(i.dictionary('Mother - $name, $race'))
			if found == false:
				newlabel.set_text('Mother - unknown')
	newlabel = parentslist.get_node("Label").duplicate()
	newlabel.show()
	parentslist.add_child(newlabel)
	if father == -1:
		newlabel.set_text('Father - unknown')
	else:
		var found = false
		if typeof(father) == 2 || typeof(father) == 3:
			for i in globals.slaves:
				if i.id == person.relatives.father:
					father = i
					found = true
					newlabel.set_text(i.dictionary('Father - $name, $race'))
			if found == false:
				newlabel.set_text('Father - unknown')
	####### Siblings
	for i in globals.slaves:
		var found = false
		if i != person && i.relatives.mother != -1:
			if (i.relatives.mother == person.relatives.mother|| i.relatives.mother == person.relatives.father) :
				found = true
		if i != person && i.relatives.father != -1:
			if (i.relatives.father == person.relatives.mother || i.relatives.father == person.relatives.father) :
				found = true
		if found == true:
			newlabel = siblingslist.get_node("Label").duplicate()
			newlabel.show()
			siblingslist.add_child(newlabel)
			newlabel.set_text(i.dictionary("$name - $sibling, $race"))
	#children
	for i in globals.slaves:
		if i.relatives.mother == person.id || i.relatives.father == person.id:
			newlabel = childrenlist.get_node("Label").duplicate()
			newlabel.show()
			childrenlist.add_child(newlabel)
			newlabel.set_text(i.dictionary("$name $sex $race"))


func _on_relativesclose_pressed():
	get_node("MainScreen/mansion/selfinspect/relativespanel").hide()





func showracedescript(person):
	var text = globals.dictionary.getRaceDescription(person.race)
	dialogue(true, self, text)

func showracedescriptsimple(race):
	var text = globals.dictionary.getRaceDescription(race)
	dialogue(true, self, text)

func _on_orderbutton_pressed():
	for i in get_tree().get_nodes_in_group("sortbutton"):
		if get_node("charlistcontrol/orderbutton").is_pressed() == true:
			i.show()
		else:
			i.hide()

####### PORTALS
func _on_portals_pressed():
	if globals.state.calculateweight().overload == true:
		infotext("Your backpack is too heavy to leave", 'red')
		return
	_on_mansion_pressed()
	if OS.get_name() != 'HTML5' && globals.rules.fadinganimation == true:
		yield(self, 'animfinished')
	var list = get_node("MainScreen/mansion/portalspanel/ScrollContainer/VBoxContainer")
	var button = get_node("MainScreen/mansion/portalspanel/ScrollContainer/VBoxContainer/portalbutton")
	get_node("MainScreen/mansion/portalspanel").popup()
	nameportallocation = null
	$MainScreen/mansion/portalspanel/imagelocation.texture = null
	$MainScreen/mansion/portalspanel/imagelocation/RichTextLabel.bbcode_text = 'Select a desired location to travel'
	$MainScreen/mansion/portalspanel/imagelocation/namelocation.text = ''
	$MainScreen/mansion/portalspanel/traveltoportal.disabled = true
	for i in list.get_children():
		if i != button:
			i.hide()
			i.queue_free()
	for i in globals.state.portals.values():
		var newbutton = button.duplicate()
		list.add_child(newbutton)
		if i.code !='wimborn':
			newbutton.show()
		if i.enabled == true:
			newbutton.disabled = false
			newbutton.set_text(i.code.capitalize())
			newbutton.connect('pressed', self, 'portalbuttonpressed', [newbutton, i])
		else:
			newbutton.set_text('???')
			newbutton.disabled = true


func portalbuttonpressed(newbutton, portal):
	var text
	nameportallocation = portal.code
	$MainScreen/mansion/portalspanel/traveltoportal.disabled = false
	for i in $MainScreen/mansion/portalspanel/ScrollContainer/VBoxContainer.get_children():
		i.pressed = (i== newbutton)
		if i.pressed == true:
			get_node("MainScreen/mansion/portalspanel/imagelocation").set_texture(globals.backgrounds[nameportallocation])
			get_node("MainScreen/mansion/portalspanel/imagelocation/namelocation").text = newbutton.text+" Portal"
			if newbutton.text == 'Umbra':
				get_node("MainScreen/mansion/portalspanel/imagelocation/RichTextLabel").text = "Portal leads to the "+newbutton.text+" Undergrounds"
			else:
				get_node("MainScreen/mansion/portalspanel/imagelocation/RichTextLabel").text = "Portal leads to the city of "+newbutton.text

func _on_traveltoportal_pressed():
	if nameportallocation != null:
		get_node("MainScreen/mansion/portalspanel").hide()
		get_node("outside").gooutside()
		get_node("explorationnode").call('zoneenter', nameportallocation)

func _on_portalsclose_pressed():
	get_node("MainScreen/mansion/portalspanel").hide()

########FARM
func _on_farmreturn_pressed():
	get_node("MainScreen/mansion/farmpanel").hide()

func _on_farm_pressed(inputslave = null):
	var manager = inputslave
	var text = ''
	var residentlimit = [2,5,8,12]
	residentlimit = residentlimit[globals.state.mansionupgrades.farmcapacity]
	for i in globals.slaves:
		if i.work == 'farmmanager':
			manager = i
	if manager != null:
		manager.work = 'farmmanager'
		text = manager.dictionary('Your farm manager is ' + manager.name_long() + '.')
	else:
		text = "[color=yellow]You have no assigned manager. Without manager you won't be able to recieve farm income. [/color]"
	if globals.state.mansionupgrades.farmhatchery > 0:
		text = text + '\n\nYou have ' + str(globals.state.snails) + ' snails.'
	var counter = 0
	var list = get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer")
	var button = get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer/farmbutton")
	for i in list.get_children():
		if i != button && i != get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer/farmadd"):
			i.hide()
			i.queue_free()
	for i in globals.slaves:
		if i.sleep == 'farm':
			counter += 1
			var newbutton = button.duplicate()
			newbutton.set_text(i.name_long())
			newbutton.show()
			list.add_child(newbutton)
			newbutton.connect("pressed",self,'farminspect',[i])
	if counter >= residentlimit:
		get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer/farmadd").set_disabled(true)
	else:
		get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer/farmadd").set_disabled(false)
	if globals.state.mansionupgrades.farmtreatment == 1:
		text += "\n\n[color=green]Your farm won't break down its residents. [/color]"
	else:
		text += "\n\n[color=yellow]Your farm will cause heavy stress to its residents. [/color]"
	text = text + '\n\nYou have ' + str(counter)+ '/' + str(residentlimit) + ' people present in farm. '
	get_node("MainScreen/mansion/farmpanel").show()
	get_node("MainScreen/mansion/farmpanel/farminfo").set_bbcode(text)
	if globals.state.tutorial.farm == false:
		get_node("tutorialnode").farm()

func farminspect(person):
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct").show()
	if person.work == 'cow':
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/slaveassigntext").set_bbcode(person.dictionary("You walk to the pen with $name. The " +person.race+ " $child is tightly kept here being milked out of $his mind all day long. $His eyes are devoid of sentience barely reacting at your approach."))
	elif person.work == 'hen':
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/slaveassigntext").set_bbcode(person.dictionary("You walk to the pen with $name. The " +person.race+ " $child is tightly kept here as a hatchery for giant snail, with a sturdy leather harness covering $his body. $His eyes are devoid of sentience barely reacting at your approach. Crouching down next to $him, you can see the swollen curve of $his stomach, stuffed full of the creature's eggs. As you lay a hand on it, you can feel some movement inside - seems like something hatched quite recently and is making its way to be 'born' from $name's well-used hole."))
	selectedfarmslave = person
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/releasefromfarm").set_meta('slave', person)
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/sellproduction").set_pressed(person.farmoutcome)


var selectedfarmslave

func _on_addcow_pressed():
	var person = selectedfarmslave
	person.sleep = 'farm'
	person.work = 'cow'
	popup(person.dictionary("You put $name into specially designed pen and hook milking cups onto $his nipples, leaving $him shortly after in the custody of farm."))
	_on_closeslavefarm_pressed()
	_on_farm_pressed()
	rebuild_slave_list()


func _on_addhen_pressed():
	var person = selectedfarmslave
	person.sleep = 'farm'
	person.work = 'hen'
	popup(person.dictionary("You put $name into specially designed pen and fixate $his body, exposing $his orificies to be fully accessible to giant snail, leaving $him shortly after in the custody of farm."))
	_on_closeslavefarm_pressed()
	_on_farm_pressed()
	rebuild_slave_list()


func _on_closeslavefarm_pressed():
	get_node("MainScreen/mansion/farmpanel/slavetofarm").hide()


func _on_farmadd_pressed():
	get_node("MainScreen/mansion/farmpanel/slavetofarm").show()
	selectslavelist(false, 'farmassignpanel')

func farmassignpanel(person):
	selectedfarmslave = person
	if person.lactation == true:
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcow").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcow").set_tooltip('')
	else:
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcow").set_tooltip(person.dictionary('$name is not lactating.'))
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcow").set_disabled(true)
	var counter = 0
	for i in globals.slaves:
		if i.work == 'hen':
			counter += 1
	if globals.state.mansionupgrades.farmhatchery == 0:
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_tooltip("You have to unlock Hatchery first.")
	else:
		if counter >= globals.state.snails:
			get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_disabled(true)
			get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_tooltip("You don't have any free snails.")
		else:
			get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_disabled(false)
			get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_tooltip("")
	get_node("MainScreen/mansion/farmpanel/slavetofarm/slaveassigntext").set_bbcode("Selected servant - " + person.name_long()+ '. \nLactation: ' +globals.fastif(person.lactation == true, '[color=green]present[/color]', '[color=#ff4949]not present[/color]')+ '. \nTits size : '+person.titssize)

func _on_releasefromfarm_pressed():
	var person = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/releasefromfarm").get_meta('slave')
	person.work = 'rest'
	person.sleep = 'communal'
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct").hide()
	_on_farm_pressed()
	rebuild_slave_list()

func _on_closeslaveinspect_pressed():
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct").hide()

func _on_sellproduction_pressed():
	selectedfarmslave.farmoutcome = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/sellproduction").is_pressed()

func _on_over_pressed():
	mainmenu()




func _on_endlog_pressed():
	get_node("FinishDayPanel").show()


var nodetocall
var functiontocall

func selectslavelist(prisoners = false, calledfunction = 'popup', targetnode = self, reqs = 'true', player = false, onlyparty = false):
	nodetocall = targetnode
	functiontocall = calledfunction
	for i in find_node("chooseslavelist").get_children():
		i.hide()
		i.free()
	if player == true:
		var person = globals.player
		var button = load("res://files/ChoseSlaveButton.tscn").instance()
		button.get_node("slaveinfo").set_bbcode(person.name_long()+', '+person.race+ ' - You.')
		button.connect("pressed", self, "slaveselected", [button])
		button.set_meta("slave", person)
		if person.imageportait != null:
			button.get_node("portrait").set_texture(globals.loadimage(person.imageportait))
		get_node("chooseslavepopup/Panel/ScrollContainer/chooseslavelist").add_child(button)
	for person in globals.slaves:
		if person.away.duration == 0:
			if onlyparty == true && globals.state.playergroup.find(person.id) < 0:
				continue
			globals.currentslave = person
			if prisoners == false || person.sleep != 'jail' :
				var button = load("res://files/ChoseSlaveButton.tscn").instance()
				button.get_node("slaveinfo").set_bbcode(person.name_long()+', '+person.race+ ', occupation - ' + person.work + ", grade - " + person.origins.capitalize())
				button.connect("pressed", self, "slaveselected", [button])
				button.set_meta("slave", person)
				if person.imageportait != null:
					button.get_node("portrait").set_texture(globals.loadimage(person.imageportait))
				get_node("chooseslavepopup/Panel/ScrollContainer/chooseslavelist").add_child(button)
				if globals.evaluate(reqs) == false:
					button.set_disabled(true)
					button.set_tooltip(person.dictionary("$name does not pass the requirements."))
	get_node("chooseslavepopup").popup()
	_on_hideinvalidslaves_pressed()

func slaveselected(button):
	var person = button.get_meta('slave')
	nodetocall.call(functiontocall, person)
	get_node("chooseslavepopup").hide()


func _on_hideinvalidslaves_pressed():
	for i in get_node("chooseslavepopup/Panel/ScrollContainer/chooseslavelist").get_children():
		if i.is_disabled() == true && get_node("chooseslavepopup/Panel/hideinvalidslaves").is_pressed() == true:
			i.hide()
		else:
			i.show()






func _on_startcombat_pressed():
	globals.state.playergroup.append(globals.slaves[0].id)
	var array = []
	array.append(globals.player)
	for i in globals.state.playergroup:
		array.append(globals.state.findslave(i))
	for i in array:
		for j in ['sstr','sagi','smaf','send','wit','cour','conf','charm','health']:
			i[j] = 100
	get_node("outside").gooutside()
	globals.state.backpack.stackables.rope = 3
	get_node("explorationnode").zoneenter(startcombatzone)
	#get_node("combat").start_battle()

func checkplayergroup():
	var removed = []
	var checked = false
	for i in range(0, globals.state.playergroup.size()):
		checked = false
		for ii in globals.slaves:
			if ii.id == str(globals.state.playergroup[i]) && ii.away.duration <= 0 && ii.away.at != 'hidden':
				checked = true
		if checked == false:
			removed.append(i)
	removed.invert()
	for i in removed:
		globals.state.playergroup.remove(i)







func _on_cleanbutton_pressed():
	animationfade()
	yield(self, 'animfinished')
	globals.state.condition = 100
	globals.resources.gold -= min(ceil(globals.resources.day/7.0)*10,100)
	_on_mansionsettings_pressed()
	_on_mansion_pressed()




func _on_defeateddescript_meta_clicked( meta ):
	var person = get_node("explorationnode/winningpanel/defeateddescript").get_meta('slave')
	showracedescript(person)





func _on_selloutclose_pressed():
	get_node("sellout").hide()


func _on_sellouttext_meta_clicked( meta ):
	OS.shell_open('https://www.patreon.com/maverik')




func _on_popupclosebutton_pressed():
	get_node("popupmessage").hide()


func infotext(newtext, color = null):
	if (enddayprocess == true && newtext.findn("trait") < 0) || newtext == '' || (get_node("combat").visible && !get_node("combat/win").visible):
		return
	if get_node("infotext").get_children().size() >= 15:
		get_node("infotext").get_child(get_node("infotext").get_children().size() - 14).queue_free()
	var text = newtext
	var label = get_node("infotext/Label").duplicate()
	label.set_text(text)
	label.modulate = Color(1,1,1,1)
	if color == 'red':
		label.set('custom_colors/font_color', Color(1,0.29,0.29))
	elif color == 'green':
		label.set('custom_colors/font_color', Color(0,1,0))
	elif color == 'yellow':
		label.set('custom_colors/font_color', Color(1,1,0))
	var timer = Timer.new()
	timer.set_wait_time(4)
	timer.start()
	timer.connect("timeout", self, 'infotextfade', [label])
	timer.set_name("timer")
	label.add_child(timer)
	get_node("infotext").add_child(label)
	label.show()

func infotextfade(label):
	label.add_to_group('messages')
	label.get_node('timer').stop()



func _on_infotextpanel_mouse_enter():
	for i in get_node("infotext").get_children():
		if i != get_node("infotext/Label"):
			i.modulate.a = 1
			if i.is_in_group("messages"):
				i.remove_from_group("messages")


func setname(person):
	var text = person.dictionary("Choose new name for $name")
	get_node("entertext").show()
	get_node("entertext").set_meta("action", "rename")
	get_node("entertext").set_meta("slave", person)
	get_node("entertext/dialoguetext").set_bbcode(text)

func _on_confirmentertext_pressed():
	var text = get_node("entertext/LineEdit").get_text()
	if text == "":
		return
	var person
	var meta = get_node("entertext").get_meta("action")
	if meta == 'rename':
		person = get_node("entertext").get_meta("slave")
		person.name = text
		rebuild_slave_list()
	get_node("entertext").hide()

func _on_infotextpanel_mouse_exit():
	for i in get_node("infotext").get_children():
		if i != get_node("infotext/Label"):
			i.modulate.a = 1
			i.add_to_group("messages")

func _on_slavelist_pressed():
	get_node("slavelist").visible = !get_node("slavelist").visible
	slavelist()


func slavelist():
	for i in get_node("slavelist/ScrollContainer/VBoxContainer").get_children():
		if i != get_node("slavelist/ScrollContainer/VBoxContainer/line"):
			i.hide()
			i.queue_free()
	for person in globals.slaves:
		if person.away.duration == 0 && !person.sleep in ['farm']:
			var newline = get_node("slavelist/ScrollContainer/VBoxContainer/line").duplicate()
			newline.show()
			get_node("slavelist/ScrollContainer/VBoxContainer").add_child(newline)
			newline.get_node("line/name/choseslave").connect("pressed",self,'openslave',[person])
			newline.get_node("line/name/Label").set_text(person.name_short())
			newline.get_node("line/grade/Label").set_text(person.origins.capitalize())
			if person.spec != null:
				newline.get_node("line/spec/Label").set_text(person.spec.capitalize())
			else:
				newline.get_node("line/spec/Label").set_text("None")
			newline.get_node("line/phys/Label").set_text("S:" + str(person.sstr) + " A:" + str(person.sagi) + " M:" + str(person.smaf) + " E:"+str(person.send))
			newline.get_node("line/mentals/Label").set_text("R:" + str(person.cour) + " O:" + str(person.conf) + " W:" + str(person.wit) + " H:" + str(person.charm) )
			newline.get_node("line/mentals").set_custom_minimum_size(newline.get_node("line/mentals/Label").get_minimum_size() + Vector2(10,0))
			newline.get_node("line/race/Label").set_text(person.race_short())
			newline.get_node("line/race/Label").set_tooltip(person.race)
			newline.get_node("job").set_text(get_node("MainScreen/slave_tab").jobdict[person.work].name)
			newline.get_node("job").connect("pressed",self,'selectjob',[person])
			if person.sleep == 'jail':
				newline.get_node("job").set_disabled(true)
			newline.get_node("sleep").set_text(globals.sleepdict[person.sleep].name)
			newline.get_node("sleep").set_meta("slave", person)
			newline.get_node("sleep").connect("pressed", self, 'sleeppressed', [newline.get_node("sleep")])
			newline.get_node("sleep").connect("item_selected",self, 'sleepselect', [newline.get_node("sleep")])


func sleeppressed(button):
	var person = button.get_meta('slave')
	var beds = globals.count_sleepers()
	button.clear()
	button.add_item(globals.sleepdict['communal'].name)
	if person.sleep == 'communal':
		button.set_item_disabled(button.get_item_count()-1, true)
		button.select(button.get_item_count()-1)
	button.add_item(globals.sleepdict['jail'].name)
	if beds.jail >= globals.state.mansionupgrades.jailcapacity:
		button.set_item_disabled(button.get_item_count()-1, true)
	if person.sleep == 'jail':
		button.set_item_disabled(button.get_item_count()-1, true)
		button.select(button.get_item_count()-1)
	button.add_item(globals.sleepdict['personal'].name)
	if beds.personal >= globals.state.mansionupgrades.mansionpersonal:
		button.set_item_disabled(button.get_item_count()-1, true)
	if person.sleep == 'personal':
		button.set_item_disabled(button.get_item_count()-1, true)
		button.select(button.get_item_count()-1)
	button.add_item(globals.sleepdict['your'].name)
	if beds.your_bed >= globals.state.mansionupgrades.mansionbed || (person.loyal + person.obed < 130 || person.tags.find('nosex') >= 0):
		button.set_item_disabled(button.get_item_count()-1, true)
	if person.sleep == 'your':
		button.set_item_disabled(button.get_item_count()-1, true)
		button.select(button.get_item_count()-1)

var sleepdict = {0 : 'communal', 1 : 'jail', 2 : 'personal', 3 : 'your'}

func sleepselect(item, button):
	var person = button.get_meta('slave')
	person.sleep = sleepdict[item]
	if person.sleep == 'jail':
		person.work = 'rest'
	rebuild_slave_list()
	slavelist()



func selectjob(person):
	globals.currentslave = person
	joblist()

func openslave(person):
	currentslave = globals.slaves.find(person)
	if get_node("MainScreen/slave_tab").visible:
		get_node("MainScreen/slave_tab").hide()
	get_node("MainScreen/slave_tab").show()
	get_node("slavelist").hide()

func joblist():
	get_node("joblist").joblist()

func _on_listclose_pressed():
	get_node("slavelist").hide()




var itemselected
var categoryselected
var inventorymode = 'mainscreen'


func _on_inventory_pressed(mode = 'mainscreen'):
	get_node("inventory").open("mansion")
#
#func itemhovered(button):
#	var item = button.get_meta("item")
#	var pos
#	get_node("inventory/Panel/tooltip/Label").set_text(item.name)
#	get_node("inventory/Panel/tooltip").show()
#	pos = button.get_global_pos()
#	pos.y -= 40
#	pos.x -= 62
#	
#	get_node("inventory/Panel/tooltip").set_global_pos(pos)
#
#func itemunhovered(button):
#	get_node("inventory/Panel/tooltip").hide()



func _on_wiki_pressed():
	OS.shell_open('http://strive4power.wikia.com/wiki/Strive4power_Wiki')





func _on_personal_pressed():
	_on_selfbutton_pressed()



func alisegreet():
	get_node("tutorialnode").show()
	get_node("tutorialnode").alisegreet()


func _on_ugrades_pressed():
	get_node("MainScreen/mansion/upgradespanel").show()

func _on_upgradesclose_pressed():
	get_node("MainScreen/mansion/upgradespanel").hide()

func imageselect(mode = 'portrait', person = globals.currentslave):
	if OS.get_name() != 'HTML5':
		get_node("imageselect").person = person
		get_node("imageselect").mode = mode
		get_node("imageselect").chooseimage()
	else:
		popup("Sorry, this option can't be utilized in HTML5 Version. ")

#Sex & interactions


func _on_sexbutton_pressed():
	sexslaves.clear()
	sexassist.clear()
	sexselect()

var sexarray = ['sex','abuse']
var sexmode = 'sex'

func sexselect():
	var newbutton
	get_node("sexselect").show()
	get_node("sexselect/selectbutton").set_text('Mode: ' + sexmode.capitalize())
	for i in get_node("sexselect/ScrollContainer1/VBoxContainer").get_children() + get_node("sexselect/ScrollContainer/VBoxContainer").get_children():
		if i.get_name() != 'Button':
			i.hide()
			i.queue_free()
	for i in globals.slaves:
		if sexmode == 'sex':
			if i.consent == false || i.away.duration != 0 || i.sleep in ['jail','farm']:
				continue
			newbutton = get_node("sexselect/ScrollContainer/VBoxContainer/Button").duplicate()
			get_node("sexselect/ScrollContainer/VBoxContainer").add_child(newbutton)
			newbutton.set_text(i.dictionary('$name'))
			newbutton.show()
			if sexslaves.find(i) >= 0:
				newbutton.set_pressed(true)
			newbutton.connect("pressed",self,'selectsexslave',[newbutton, i])
			if i.lastinteractionday == globals.resources.day:
				newbutton.set_disabled(true)
				newbutton.set_tooltip(i.dictionary('You have already interacted with $name today.'))
		elif sexmode == 'abuse':
			if i.away.duration != 0 || i.sleep in ['farm']:
				continue
			newbutton = get_node("sexselect/ScrollContainer/VBoxContainer/Button").duplicate()
			get_node("sexselect/ScrollContainer/VBoxContainer").add_child(newbutton)
			newbutton.set_text(i.dictionary('$name'))
			newbutton.show()
			if sexslaves.find(i) >= 0:
				newbutton.set_pressed(true)
			elif sexslaves.size() > 0:
				newbutton.set_disabled(true)
			newbutton.connect("pressed",self,'selectsexslave',[newbutton, i])
			if i.consent == false || sexslaves.find(i) >= 0:
				continue
			newbutton = get_node("sexselect/ScrollContainer/VBoxContainer/Button").duplicate()
			get_node("sexselect/ScrollContainer1/VBoxContainer").add_child(newbutton)
			newbutton.set_text(i.dictionary('$name'))
			newbutton.show()
			if sexassist.find(i) >= 0:
				newbutton.set_pressed(true)
			elif sexassist.size() > 0:
				newbutton.set_disabled(true)
			newbutton.connect("pressed",self,'selectassist',[newbutton, i])
			if i.lastinteractionday == globals.resources.day:
				newbutton.set_disabled(true)
				newbutton.set_tooltip(i.dictionary('You have already interacted with $name today.'))
	updatedescription()

func _on_selectbutton_pressed():
	sexmode = sexarray[sexarray.find(sexmode)+1] if sexarray.size() > sexarray.find(sexmode)+1 else sexarray[0]
	_on_sexbutton_pressed()

var sexslaves = []
var sexassist = []

func selectsexslave(button, person):
	if button.is_pressed():
		sexslaves.append(person)
		if sexassist.find(person) >= 0:
			sexassist.erase(person)
	else:
		sexslaves.erase(person)
	sexselect()

func selectassist(button, person):
	if button.is_pressed():
		sexassist.append(person)
	else:
		sexassist.erase(person)
	sexselect()

func updatedescription():
	var text = ''
	
	if sexmode == 'sex':
		if sexslaves.size() <= 1:
			text += "[center][color=yellow]Consensual Sex[/color][/center]"
		elif sexslaves.size() in [2,3]:
			text += "[center][color=yellow]Group sex[/color][/center]"
		else:
			text += "[center][color=yellow]Orgy[/color][/center]"
			text += "\n[color=aqua]Aphrodite's Brew[/color] is required to initialize an orgy. "
		text += "\nConsent is required from participants. \nCurrent participants: "
		for i in sexslaves:
			text += i.dictionary('$name') + ", "
		text = text.substr(0, text.length() - 2) + '.\nClick Start to initiate.'
	elif sexmode == 'abuse':
		text += "[center][color=yellow]Rape[/color][/center]"
		text += "\nRequires a target and an optional assistant. Can be initiated with prisoners. \nCurrent target: "
		for i in sexslaves:
			text += i.dictionary('$name') + ". "
		text += "\nCurrent assistant: "
		for i in sexassist:
			text += i.dictionary('$name') + ". "
		text += '\nClick Start to initiate.'
		get_node("sexselect/startbutton").set_disabled(sexslaves.size() == 1 && sexassist.size() <= 1)
	text += "\nInteractions left for today: " + str(globals.state.sexactions)
	
	if sexslaves.size() >= 4 && sexmode == 'sex':
		get_node("sexselect/startbutton").set_disabled(globals.itemdict.aphroditebrew.amount < 1)
	elif sexslaves.size() == 0:
		get_node("sexselect/startbutton").set_disabled(true)
	else:
		get_node("sexselect/startbutton").set_disabled(false)
	get_node("sexselect/sextext").set_bbcode(text)


func _on_startbutton_pressed():
	globals.state.sexactions -= 1
	if globals.state.sidequests.emily == 16:
		var emily = false
		var tisha = false
		for i in sexslaves + sexassist:
			if i.unique == 'Emily':
				emily = true
			elif i.unique == 'Tisha':
				tisha = true
		if emily && tisha:
			globals.state.sidequests.emily = 17
			$sexselect.visible = false
			globals.events.emilytishasex()
			return
	var mode = 'normal'
	if sexslaves.size() >= 4 && sexmode == 'sex':
		globals.itemdict.aphroditebrew.amount -= 1
	animationfade()
	yield(self, 'animfinished')
	if sexmode == 'abuse':
		mode = 'abuse'
		get_node("interactions").startsequence([globals.player] + sexassist, mode, sexslaves)
	else:
		get_node("interactions").startsequence([globals.player] + sexslaves + sexassist, mode)
	get_node("Navigation").hide()
	get_node('MainScreen').hide()
	get_node("charlistcontrol").hide()
	get_node("interactions").show()
	get_node("sexselect").hide()

func _on_cancelbutton_pressed():
	get_node("sexselect").hide()




func _on_mansionsettings_pressed():
	get_node("mansionsettings").show()
	var text = ''
	text += "Cleaning can be done by either assigning your persons to the cleaning task or by hiring one time help from city. \n\nCost: "
	text += '[color=yellow]' + str(min(ceil(globals.resources.day/5.0)*10,100)) + '[/color]'
	if globals.resources.gold >= min(ceil(globals.resources.day/5.0)*10,100) && globals.state.condition < 80:
		get_node("mansionsettings/Panel/cleanbutton").set_disabled(false)
	elif globals.state.condition >= 80:
		text += '\n\nYour mansion requires no cleaning.'
		get_node("mansionsettings/Panel/cleanbutton").set_disabled(true)
	else:
		text += "\n\nYou don't have enough gold."
		get_node("mansionsettings/Panel/cleanbutton").set_disabled(true)
	get_node("mansionsettings/Panel/cleaningtext").set_bbcode(text)
	var dict = {'none':0,'kind':1,'strict':2}
	get_node("mansionsettings/Panel/headgirlbehavior").select(dict[globals.state.headgirlbehavior])
	_on_headgirlbehavior_item_selected(dict[globals.state.headgirlbehavior])



func _on_headgirlbehavior_item_selected( ID ):
	var text = ''
	if ID == 0:
		globals.state.headgirlbehavior = 'none'
		text += "Headgirl will not interfere with others' business. "
	if ID == 1:
		globals.state.headgirlbehavior = 'kind'
		text += 'The Headgirl will focus on a kind approach and reduce the stress of others, trying to endrose acceptance of their master. '
	if ID == 2:
		globals.state.headgirlbehavior = 'strict'
		text += "Headgirl will focus on putting other servants in line at the cost of their stress. "
	var headgirl = null
	for i in globals.slaves:
		if i.work == 'headgirl':
			headgirl = i
	if headgirl == null:
		text += "\nCurrently you have no headgirl assigned. "
	else:
		text += headgirl.dictionary("\n$name is your current headgirl. ")
	get_node("mansionsettings/Panel/headgirldescript").set_bbcode(text)
	get_node("mansionsettings/Panel/foodbuy").set_value(globals.state.foodbuy)
	get_node("mansionsettings/Panel/supplykeep").set_value(globals.state.supplykeep)
	get_node("mansionsettings/Panel/supplykeep/supplybuy").set_pressed(globals.state.supplybuy)

func _on_foodbuy_value_changed( value ):
	globals.state.foodbuy = get_node("mansionsettings/Panel/foodbuy").get_value()

func _on_supplykeep_value_changed( value ):
	globals.state.supplykeep = get_node("mansionsettings/Panel/supplykeep").get_value()


func _on_supplybuy_pressed():
	globals.state.supplybuy = get_node("mansionsettings/Panel/supplykeep/supplybuy").is_pressed()


func _on_close_pressed():
	get_node("mansionsettings").hide()







func _on_hideui_pressed():
	$outside.visible = !$outside.visible
	$ResourcePanel.visible = !$ResourcePanel.visible



