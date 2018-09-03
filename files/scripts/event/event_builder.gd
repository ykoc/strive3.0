###Ku-Ku-Ku-Kurapanda!!!
### EventBuilder - Workspace for event creation and testing

###Resources
const Quest = preload("res://files/scripts/event/quest.gd")

###Variables
var buildQuest
var mainquestTexts
var sidequestTexts


###Public Functions
func quest_maker(questName): 
	#Load quest text files
	var questTextFile = File.new()
	questTextFile.open("res://files/data/quest/dialogue/mainquest.dialogue.json", File.READ)
	mainquestTexts = JSON.parse(questTextFile.get_as_text()).result
	questTextFile.close()
	
	questTextFile.open("res://files/data/quest/dialogue/sidequest.dialogue.json", File.READ)
	sidequestTexts = JSON.parse(questTextFile.get_as_text()).result
	questTextFile.close()
	
	#Build Quest
	match questName:
		'emily':
			_quest_maker_emily()
		'tisha':
			_quest_maker_tisha()
	
	return buildQuest

func quest_loader():	
	### Load Emily Quest
	var emilyQuestFile = File.new()	
	emilyQuestFile.open("res://files/data/quest/emilyQuest.json", File.READ)
	
	var emilyQuestDict = JSON.parse(emilyQuestFile.get_as_text()).result
	emilyQuestFile.close()
	buildQuest.from_dict(emilyQuestDict)
	
	return buildQuest
	
	
#Emily Quest Maker	
func _quest_maker_emily():
	### Create Quest Event
	buildQuest = Quest.new()
	buildQuest.uid = 'emily'
	buildQuest.state = {stage = 0, branch = -1}
	
	#Add meetEmilyEvent
	var emilyEvent = _quest_maker_emily_01()	
	buildQuest.add_event(emilyEvent)
	
	#Add emilyMansionEvent
	emilyEvent = _quest_maker_emily_02()
	buildQuest.add_event(emilyEvent)
	
	#Add emilyEscapeEvent
	emilyEvent = _quest_maker_emily_03()
	buildQuest.add_event(emilyEvent)
		
	#Convert quest to json file
	var sidequestFile = File.new()
	sidequestFile.open("res://files/data/quest/emilyQuest.json", File.WRITE)
	sidequestFile.store_string(JSON.print(buildQuest.to_dict(), "    "))
	sidequestFile.close()	
	
func _quest_maker_emily_01():
	#Create meetEmilyEvent
	var meetEmilyEvent = Quest.Event.new()
	var reqs = {place = {region = 'wimborn', area = 'wimbornCity', location = 'backstreets'}, sidequests = [{name = 'emily', state = {stage = 0, branch = -1}, compare = 'equals'}]}
	meetEmilyEvent.name = 'meetEmily'
	meetEmilyEvent.startType = 'hook'
	meetEmilyEvent.activateChance = 100
	meetEmilyEvent.place = {region = 'wimborn', area = 'wimbornCity', location = 'backstreets'}
	meetEmilyEvent.requirements = reqs
	
	#Create start action
	var meetEmilyAction = Quest.Event.EventAction.new()
	meetEmilyAction.text = "You see an urchin girl trying to draw your attention"
	meetEmilyAction.add_button("Respond to the urchin girl", '1.meet', {'requirements' : {}, 'result' : {}})	
	meetEmilyEvent.add_action('start', meetEmilyAction)
	
	#Add Step01, '1.meet' action
	meetEmilyAction = Quest.Event.EventAction.new()
	meetEmilyAction.text = sidequestTexts.emilyQuest.EmilyMeet
	meetEmilyAction.sprites.append(['emilynormal','pos1','opac'])
	meetEmilyAction.add_button("Give her food", '2.foodGiven', {'requirements' : {'resources' : {'food' : 10}}, 'result' : {'resources' : {'food' : -10}, 'gallery' : {'emily' : {'unlock' : 'basic'}}}})
	meetEmilyAction.add_button("Shoo her away", 'finish', {'requirements' : {}, 'result' : {'sidequest' : {'emily' : {'stage' : 5, 'branch' : -1}}}})
	meetEmilyAction.add_button("Make an excuse and tell her you'll bring some later", 'reset', {'requirements' : {}, 'result' : {}})
	meetEmilyEvent.add_action('1.meet', meetEmilyAction)
	
	#Step02, '2.foodGiven'
	meetEmilyAction = Quest.Event.EventAction.new()
	meetEmilyAction.text = sidequestTexts.emilyQuest.EmilyFeed
	meetEmilyAction.sprites.append(['emilynormal','pos1'])
	meetEmilyAction.add_button("Offer to take her as a servant", '3.emilyTake', {'requirements' : {}, 'result' : {'sidequest' : {'emily' : {'stage' : 3, 'branch' : -1}}, 'newSlave' : {'isUnique' : true, 'name' : 'Emily'}, 'scheduleEvent' : {'tishaappearance' : 7}}})
	meetEmilyAction.add_button("Leave her alone", 'finish', {'requirements' : {}, 'result' : {'sidequest' : {'emily' : {'stage' : 5, 'branch' : -1}}}})
	meetEmilyEvent.add_action('2.foodGiven', meetEmilyAction)
	
	#Step03, '3.emilyTake'
	meetEmilyAction = Quest.Event.EventAction.new()
	meetEmilyAction.text = sidequestTexts.emilyQuest.EmilyTake
	meetEmilyAction.sprites.append(['emilyhappy','pos1'])
	meetEmilyAction.add_button("Close", 'finish', {'requirements' : {}, 'result' : {}})
	meetEmilyEvent.add_action('3.emilyTake', meetEmilyAction)
	
	return meetEmilyEvent
	
func _quest_maker_emily_02():
	#Create emilyMansionEvent
	var emilyMansionEvent = Quest.Event.new()
	var reqs = {place = {region = 'any', area = 'mansion', location = 'foyer'}, sidequests = [{name = 'emily', state = {stage = 3, branch = -1}, compare = 'equals'}]}
	emilyMansionEvent.name = 'emilyMansion'
	emilyMansionEvent.startType = 'trigger'
	emilyMansionEvent.activateChance = 100
	emilyMansionEvent.place = {region = 'any', area = 'mansion', location = 'foyer'}
	emilyMansionEvent.requirements = reqs
	
	#Create start action
	var emilyMansionAction = Quest.Event.EventAction.new()
	emilyMansionAction.text = sidequestTexts.emilyQuest.EmilyMansion
	emilyMansionAction.sprites.append(['emilynormal','pos1','opac'])
	
	var personEffect = {'emily' : {'isUnique' : true, 'consent' : true, 'tags' : {'nosex' : 'erase'}, 'virgin' : {'vagina' : false}, 'metrics' : {'orgasm' : 1, 'vag' : 1, 'partners' : ['player']}, 'meters' : {'stress' : 50, 'loyal' : 15, 'lust' : 50}}}
	emilyMansionAction.add_button("Spike her with aphrodisiac", '1.aphrodisiac', {'requirements' : {'items' : {'aphrodisiac' : 1}}, 'result' : {'items' : {'aphrodisiac' : -1}, 'globalState' : { 'decisions' : ['emilyseduced']}, 'modifyPeople' : personEffect, 'gallery' : {'emily' : {'unlock' : 'naked', 'scenes' : 0}}}})
	
	personEffect = {'emily' : {'isUnique' : true, 'consent' : true, 'tags' : {'nosex' : 'erase'}, 'virgin' : {'vagina' : false}, 'metrics' : {'vag' : 1, 'partners' : ['player']}, 'meters' : {'stress' : 100, 'obedience' : -100}}}
	emilyMansionAction.add_button("Assault her after bath", '1.sexAssault', {'requirements' : {}, 'result' : {'globalState' : { 'decisions' : ['emilyseduced']}, 'modifyPeople' : personEffect, 'gallery' : {'emily' : {'unlock' : 'naked', 'scenes' : 1}}, 'scheduleEvent' : {'emilyEscape' : 2}}})
	emilyMansionAction.add_button("Wait patiently", '1.wait', {'requirements' : {}, 'result' : {}})
	emilyMansionEvent.add_action('start', emilyMansionAction)
	
	#Step01, '1.aphrodisiac'
	emilyMansionAction = Quest.Event.EventAction.new()
	emilyMansionAction.actionType = 'scene'
	emilyMansionAction.text = sidequestTexts.emilyQuest.EmilyShowerSex
	emilyMansionAction.image = 'emilyshower'
	emilyMansionAction.sprites.append(['emilynakedhappy','pos1'])
	emilyMansionAction.add_button("Close", 'finish', {'requirements' : {}, 'result' : {'sidequest' : {'emily' : {'stage' : 6, 'branch' : -1}}}})
	emilyMansionEvent.add_action('1.aphrodisiac', emilyMansionAction)	
	
	#Step01, '1.sexAssault'
	emilyMansionAction = Quest.Event.EventAction.new()
	emilyMansionAction.actionType = 'scene'
	emilyMansionAction.text = sidequestTexts.emilyQuest.EmilyShowerRape
	emilyMansionAction.image = 'emilyshowerrape'
	emilyMansionAction.sprites.append(['emilynakedneutral','pos1'])
	emilyMansionAction.add_button("Close", 'finish', {'requirements' : {}, 'result' : {'sidequest' : {'emily' : {'stage' : 6, 'branch' : -1}}}})	
	emilyMansionEvent.add_action('1.sexAssault', emilyMansionAction)

	#Step01, '1.wait'
	emilyMansionAction = Quest.Event.EventAction.new()	
	emilyMansionAction.text = sidequestTexts.emilyQuest.EmilyShowerWait	
	emilyMansionAction.sprites.append(['emily2happy','pos1','opac'])
	emilyMansionAction.add_button("Close", 'finish', {'requirements' : {}, 'result' : {'sidequest' : {'emily' : {'stage' : 6, 'branch' : -1}}}})	
	emilyMansionEvent.add_action('1.wait', emilyMansionAction)
	
	return emilyMansionEvent

func _quest_maker_emily_03():
	#Create emilyEscapeEvent
	var emilyEscapeEvent = Quest.Event.new()
	var reqs = {place = {region = 'any', area = 'mansion', location = 'foyer'}}
	emilyEscapeEvent.name = 'emilyEscape'
	emilyEscapeEvent.startType = 'schedule'
	emilyEscapeEvent.activateChance = 100
	emilyEscapeEvent.place = {region = 'any', area = 'mansion', location = 'foyer'}
	emilyEscapeEvent.requirements = reqs
	
	#Create start action
	var emilyEscapeAction = Quest.Event.EventAction.new()
	emilyEscapeAction.actionType = 'decision'
	emilyEscapeAction.add_node({'eventState' : '1.headslave', 'meta' : {'requirements' : {'globals' : {'hasHeadslave' : true}}, 'result' : {}}})
	emilyEscapeAction.add_node({'eventState' : '1.noHeadslave', 'meta' : {'requirements' : {}, 'result' : {}}})	
	emilyEscapeEvent.add_action('start', emilyEscapeAction)
	
	#Add Step01, '1.headslave'
	emilyEscapeAction = Quest.Event.EventAction.new()	
	emilyEscapeAction.text = sidequestTexts.emilyQuest.EscapeHeadslave
	var personEffect = {'emily' : {'isUnique' : true, 'meters' : {'stress' : 25, 'loyal' : 10, 'health' : -10}}}
	emilyEscapeAction.add_button("Activate Emily's brand", '2.brandSuccess', {'requirements' : {'resources' : {'mana' : 10}, 'people' : [{'id' : {'unique' : 'emily'}, 'brand' : 'any'}]}, 'result' : {'resources' : {'mana' : -10}, 'modifyPeople' : personEffect}})	
	emilyEscapeAction.add_button("Chase after her", '2.headChase')
	emilyEscapeEvent.add_action('1.headslave', emilyEscapeAction)
	
	#Add Step02, '2.brandSuccess'
	emilyEscapeAction = Quest.Event.EventAction.new()	
	emilyEscapeAction.text = sidequestTexts.emilyQuest.EscapeBrandSuccess
	emilyEscapeAction.add_button("Approach the Gardens", '3.gardenCapture')
	emilyEscapeEvent.add_action('2.brandSuccess', emilyEscapeAction)
	
	#Add Step03, '3.gardenCapture'
	emilyEscapeAction = Quest.Event.EventAction.new()
	emilyEscapeAction.text = sidequestTexts.emilyQuest.EscapeGardenCapture
	emilyEscapeAction.add_button("Close", 'finish')
	emilyEscapeEvent.add_action('3.gardenCapture', emilyEscapeAction)
	
	#Add Step02, '2.headChase'
	emilyEscapeAction = Quest.Event.EventAction.new()
	emilyEscapeAction.text = sidequestTexts.emilyQuest.EscapeHeadChase
	emilyEscapeAction.add_button("Cautiously follow after the duo...", '3.headCapture')
	emilyEscapeEvent.add_action('2.headChase', emilyEscapeAction)
	
	#Add Step03, '3.headCapture'
	emilyEscapeAction = Quest.Event.EventAction.new()
	emilyEscapeAction.text = sidequestTexts.emilyQuest.EscapeHeadCapture
	emilyEscapeAction.add_button("Close", 'finish')
	emilyEscapeEvent.add_action('3.headCapture', emilyEscapeAction)
	
	#Add Step01, '1.noHeadslave'
	emilyEscapeAction = Quest.Event.EventAction.new()
	emilyEscapeAction.text = sidequestTexts.emilyQuest.EscapeNoHeadslave
	emilyEscapeAction.add_button("Activate Emily's brand", '2.brandEscape', {'requirements' : {'resources' : {'mana' : 10}}, 'result' : {'resources' : {'mana' : -10}}})
	emilyEscapeAction.add_button("Search within the Manor", '2.searchManorClue', {'requirements' : {}, 'result' : {}})
	emilyEscapeAction.add_button("Search the Courtyard", '2.searchCourtyard', {'requirements' : {}, 'result' : {}})
	emilyEscapeAction.add_button("Search the Gardens", '2.searchGardens', {'requirements' : {}, 'result' : {}})
	emilyEscapeEvent.add_action('1.noHelp', emilyEscapeAction)
	

	
	return emilyEscapeEvent

	
#Tisha Quest Maker
func _quest_maker_tisha():
	### Create Quest Event
	buildQuest = Quest.new()
	buildQuest.uid = 'tisha'
	buildQuest.state = {stage = 0, branch = -1}
	
	#Add tishaAppearanceEvent
	var tishaEvent = _quest_maker_tisha_01()	
	buildQuest.add_event(tishaEvent)
				
	#Convert quest to json file
	var sidequestFile = File.new()
	sidequestFile.open("res://files/data/quest/tishaQuest.json", File.WRITE)
	sidequestFile.store_string(JSON.print(buildQuest.to_dict(), "    "))
	sidequestFile.close()
	
func _quest_maker_tisha_01():
	#Create tishaAppearanceEvent
	var tishaAppearanceEvent = Quest.Event.new()
	var reqs = {place = {region = 'any', area = 'mansion', location = 'foyer'}, sidequests = [{name = 'tisha', state = {stage = 0, branch = -1}, compare = 'equals'}]}
	tishaAppearanceEvent.name = 'tishaAppearance'
	tishaAppearanceEvent.startType = 'schedule'
	tishaAppearanceEvent.activateChance = 100
	tishaAppearanceEvent.place = {region = 'any', area = 'mansion', location = 'foyer'}
	tishaAppearanceEvent.requirements = reqs
	
	#Create start action
	var tishaAppearanceAction = Quest.Event.EventAction.new()
	tishaAppearanceAction.actionType = 'decision'
	tishaAppearanceAction.add_node({'eventState' : '1.hasEmily', 'meta' : {'requirements' : {'people' : [{'id' : {'unique' : 'emily'}}]}, 'result' : {}}})
	tishaAppearanceAction.add_node({'eventState' : '1.noEmily', 'meta' : {'requirements' : {}, 'result' : {}}})
	tishaAppearanceEvent.add_action('start', tishaAppearanceAction)
	
	
"""
func tishaappearance():
	var emily = null
	var buttons = []
	var sprite
	for i in globals.slaves:
		if i.unique == 'Emily':
			emily = i
	if emily == null:
		return
	var text = textnode.TishaEncounter
	sprite = [['emily2normal','pos2','opac2'],['tishaangry','pos1','opac']]
	globals.charactergallery.tisha.unlocked = true
	if emily.loyal >= 25:
		text += globals.player.dictionary(textnode.TishaEmilyLoyal)
		sprite = [['emily2happy','pos2','opac2'],['tishashocked','pos1','opac']]
		emilystate = 'loyal'
		buttons.append(['Make Emily leave', 'tishadecision', 1])
		buttons.append(['Make Emily stay', 'tishadecision', 2])
	elif emily.brand != 'none':
		emilystate = 'brand'
		text += textnode.TishaEmilyBranded
		[['emily2normal','pos2','opac2'],['tishaangry','pos1','opac']]
		buttons.append(['Release Emily', 'tishadecision', 3])
		buttons.append(['Keep Emily', 'tishadecision', 4])
		buttons.append(['Offer Tisha to take her place', 'tishadecision', 5])
	else:
		text += textnode.TishaEmilyUnloyal
		emilystate = 'unloyal'
		buttons.append(['Let them leave', 'tishadecision', 6])
		if globals.resources.gold >= 50 && globals.resources.food >= 50:
			buttons.append(['Help them with gold and provision', 'tishadecision', 7])		
		else:
			buttons.append({text = 'Help them with gold and provisions',function = 'tishadecision',args = 7, disabled = true})
		buttons.append(['Ask for compensation', 'tishadecision', 8])
	globals.main.dialogue(false,self,text,buttons,sprite)"""