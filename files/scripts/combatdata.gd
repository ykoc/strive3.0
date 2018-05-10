extends Node


var enemygrouppools = {
treasurechest = { units = [['wolf',1,1]], awareness = 0, captured = null, special = 'treasurechest',
description = 'You find a small [color=aqua]treasure chest[/color].',
descriptionambush = '',
},
blockedsection = { units = [['wolf',1,1]], awareness = 0, captured = null, special = 'blockedsection',
description = 'You find a small [color=aqua]treasure chest[/color].',
descriptionambush = '',
},
wolveseasy = { units = [['wolf',2,3]], awareness = 6, captured = null, special = null,
description = 'You come across a [color=aqua]small pack of wolves[/color].',
descriptionambush = 'You are attacked by a [color=aqua]small pack of wolves[/color].',
},
direwolveseasy = { units = [['direwolf',2,5]], awareness = 18, captured = null, special = null,
description = 'You come across a pack of [color=aqua]dangerous dire wolves[/color].',
descriptionambush = 'You are attacked by a pack of [color=aqua]dangerous dire wolves[/color].',
},
wolveswithperson = { units = [['wolf',4,8]], awareness = 0, captured = ['thugvictim'], special = null,
description = 'You come across a [color=aqua]group of wolves[/color] attacking a lost [color=yellow]$capturedrace[/color].',
descriptionambush = 'You are attacked by a [color=aqua]small pack of wolves[/color].',
},
wolveshard = { units = [['wolf',3,6]], awareness = 15, captured = null, special = null,
description = 'You come across a [color=aqua]large pack of wolves[/color].',
descriptionambush = 'You are attacked by a [color=aqua]large pack of wolves[/color].',
},
solobear = { units = [['bear',1,1]], awareness = 6, captured = null, special = null,
description = "$scoutname spots a [color=aqua]brown bear[/color] several yards away, just in time to let you react to him. ",
descriptionambush =  "As you walk through the wildreness, you hear fierce roar. It seems you provoked a [color=aqua]bear[/color] by getting into it's territory. It breaks out of the woodwork and goes for an attack.",
},
plantseasy = { units = [['plant',2,3]], awareness = 0, captured = null, special = null,
description = 'You come across a bunch of [color=aqua]hostile, animated plants[/color]. ',
},
plantswithperson = { units = [['plant',3,6]], awareness = 0, captured = ['thugvictim'], special = null,
description = 'You spot a bunch of frenzied, [color=aqua]man-eating plants[/color] seizing a [color=yellow]$capturedrace $capturedchild[/color]. ',
},
fewcougars = { units = [['cougar',2,3]], awareness = 10, captured = null, special = null,
description = "$scoutname spots a group of [color=aqua]mountain cougars[/color] searching for prey. ",
descriptionambush =  "You are being attacked by a group of [color=aqua]mountain cougars[/color]!",
},
solospider = { units = [['spider',1,1]], awareness = 12, captured = null, special = null,
description = "$scoutname spots a [color=aqua]giant spider hiding[/color] in the shadows. ",
descriptionambush =  "A [color=aqua]horse-sized spider[/color] has detected you trespassing its domain and jumps out to attack.",
},
spidergroup = { units = [['spider',3,4]], awareness = 24, captured = null, special = null,
description = "$scoutname spots a [color=aqua]group of giant spiders[/color] hiding in the shadows. ",
descriptionambush =  "You are attacked by a [color=aqua]group of giant spiders[/color].",
},
oozesgroup = { units = [['ooze',2,3]], awareness = 0, captured = null, special = null,
description = "You come across [color=aqua]group of ooze monsters[/color]. ",
},
banditseasy = {units = [['bandit',2,3]], awareness = 6, captured = null, special = null,
description = 'You spot a [color=aqua]small group of stray bandits[/color]. They seem to be unaware of your presence as of yet. ',
descriptionambush = 'You are attacked by a [color=aqua]small group of stray bandits[/color]. ',
},
thugseasy = {units = [['bandit',2,2]], awareness = 0, captured = ['thugvictim'], special = null,
description = 'You come across a [color=aqua]pair of thugs[/color] bullying a [color=yellow]bystrander[/color]. They are busy right now, so you could pass them by unnoticed... ',
},
banditsmedium = {units = [['banditleader', 0,1],['bandit',3,6]], awareness = 12, captured = null, special = null,
description = 'You spot a [color=aqua]medium-sized group of stray bandits[/color]. They seem to be unaware of your presence as of yet. ',
descriptionambush = 'You are attacked by a [color=aqua]group of stray bandits[/color]. ',
},
banditshard = {units = [['banditleader', 1,1],['bandit',7,8]], awareness = 15, captured = null, special = null,
description = 'You spot a [color=aqua]large group of stray bandits[/color]. They seem to be unaware of your presence as of yet. ',
descriptionambush = 'You are attacked by a [color=aqua]large group of stray bandits[/color]. ',
},
CaliBossSlaver = {units = [['slaver',1,1]], awareness = 0, captured = null, special = null,
description = 'You spot a [color=aqua]small group of stray bandits[/color]. They seem to be unaware of your presence as of yet. ',
descriptionambush = 'You are attacked by a [color=aqua]small group of stray bandits[/color]. ',
},
CaliStrayBandit = {units = [['bandit',1,1]], awareness = 0, captured = null, special = null,
description = 'You spot a [color=aqua]small group of stray bandits[/color]. They seem to be unaware of your presence as of yet. ',
descriptionambush = 'You are attacked by a [color=aqua]small group of stray bandits[/color]. ',
},
banditcamp = {units = [['bandit',6,8],['banditleader', 1,2]], awareness = 0, captured = ['banditcampcaptured', 'banditcampcaptured'], special = null,
description = 'You come across a [color=aqua]bandit encampment[/color]. You can spot numerous watchmen moving around and few captives too, which are likely to be sold for slaves soon. ',
},
elfguards = {units = [['elfguard',2,3]], awareness = 15, captured = null, special = null,
description = "You spot a local [color=aqua]patrol of elven warriors[/color] scouting the surroundings. Surely, they won't be happy with trespassers as this is tribal elven territory. ",
descriptionambush = 'You are attacked by a [color=aqua]small group of elven warriors[/color]. ',
},
fairy = {units = [['fairy',1,1]], awareness = 0, captured = null, special = null,
description = 'You spot a lone [color=aqua]wild fairy $child[/color] floating through the woods. ',
},
fairyfew = {units = [['fairy',2,4]], awareness = 0, captured = null, special = null, escape = 7,
description = 'You spot a [color=aqua]small group of wild fairies[/color] playing around. ',
descriptionescape = "A group of wild fairies escapes from you before you get close to them. ",
},
goblingroup = {units = [['goblin',3,7]], awareness = 9, captured = null, special = null,
description = 'You spot a [color=aqua]group of cave goblins[/color] moving through the tunnels. ',
descriptionescape = "A [color=aqua]group of cave goblins[/color] jumps on you. ",
},
dryad = {units = [['dryad',1,1]], awareness = 0, captured = null, special = null,
description = 'You spot a wild [color=aqua]$race $child[/color] walking through the woods.',
},
monstergirl = {units = [['monstergirl',1,1]], awareness = 0, captured = null, special = null, escape = 6,
description =  "You come across a rare $race monster $child. $He hasn't spotted you yet. ",
descriptionescape = "A wild $race escapes from you before you get close to $him. ",
},
monstergirlfew = {units = [['monstergirl',2,4]], awareness = 0, captured = null, special = null, escape = 12,
description =  "You spot a [color=aqua]small group of wild $race[/color] playing around.  ",
descriptionescape = "A group of [color=aqua]wild $race[/color] escapes from you before you get close to them. ",
},
harpy = {units = [['harpy',1,1]], awareness = 0, captured = null, special = null,
description =  "You come across a [color=aqua]$race monster $child[/color]. $He hasn't spotted you yet. ",
},
slaverseasy = {units = [['slaver',2,3]], awareness = 0, captured = ['slavervictim'], special = 'slaversenc',
description = "You spot a group of [color=aqua]$unitnumber slavers[/color] leading a [color=yellow]sole victim[/color]. You can't make out any more details without getting closer.",
},
slaversmedium = {units = [['slaver',3,5]], awareness = 0, captured = ['slavervictim', 'slavervictim'], special = 'slaversenc',
description = "You spot a group of [color=aqua]$unitnumber slavers[/color] leading few recently [color=yellow]captured victims[/color]. You can't say much about them without getting closer.",
},
peasant = {units = [['peasant',1,1]], awareness = 0, captured = null, special = null,
description = "You meet a lone [color=aqua]$race $child[/color], native to these lands. $He seems to be unaware of your presence as of yet. ",
},
peasantgroup = {units = [['peasant',2,3]], awareness = 0, captured = null, special = null,
description = "You meet a group of [color=aqua]$unitnumber strangers[/color], native to these lands. They seem to be unaware of your presence as of yet. ",
},
travelersgroup = {units = [['traveller',2,3]], awareness = 0, captured = null, special = null,
description = "You meet a group of [color=aqua]$unitnumber travellers[/color] moving by on the road. They seem to be unaware of your presence as of yet. ",
},
troglodytesmall = {units = [['troglodyte',3,5]], awareness = 20, captured = null, special = null,
description = 'You spot a [color=aqua]small group of troglodytes[/color]. They seem to be unaware of your presence as of yet. ',
descriptionambush = 'You are attacked by a [color=aqua]small group of troglodytes[/color]. ',
},
troglodytelarge = {units = [['troglodyte',7,10]], awareness = 16, captured = null, special = null,
description = 'You spot a [color=aqua]large group of troglodytes[/color]. They seem to be unaware of your presence as of yet. ',
descriptionambush = 'You are attacked by a [color=aqua]large group of troglodytes[/color]. ',
},
mutant = {units = [['mutant',1,1]], awareness = 25, captured = null, special = null,
description = 'You spot and [color=aqua]ugly creature[/color], deformed by magical energy.',
descriptionambush = 'You are attacked by a [color=aqua]mutant[/color]. ',
},
gembeetle = {
units = [['gembeetle',1,1]], awareness = 0, captured = null, special = null,
description = "You spot an unusual creature. A shiny, [color=aqua]multicolored bug[/color] of significant size. ",
},
bossgolem = {
units = [['bossgolem',1,1]], awareness = 0, captured = null, special = null,
description = "Golem Boss",
},
bosswyvern = {
units = [['bosswyvern',1,1]], awareness = 0, captured = null, special = null,
description = "Wyvern Boss",
},
tishaquestenemy = {units = [['banditleader',1,1],['bandit',3,3]], awareness = 0, captured = null, special = null,
description = "",
},
ivranquestenemy = {units = [['ivran',1,1],['elfguard',4,4]], awareness = 0, captured = null, special = null,
description = "",
},
ayneris1 = {units = [['ayneris',1,1],['elfguard',3,3]], awareness = 0, captured = null, special = null,
description = "",
},
ayneris2 = {units = [['ayneris',1,1],['elfguard',7,7]], awareness = 0, captured = null, special = null,
description = "",
},
frostforddryadquest = {units = [['direwolf',6,6],['plant',4,4]], awareness = 0, captured = null, special = null,
description = "",
},
frostfordzoequest = {units = [['marauder',9,9]], awareness = 0, captured = null, special = null,
description = "",
},
finaleelves = {units = [['elfguard',7,7],['elfleader',3,3]], awareness = 0, captured = null, special = null,
description = "",
},
finaleslavers = {units = [['marauder',8,8],['marauderleader',2,2]], awareness = 0, captured = null, special = null,
description = "",
},
finaledavid = {units = [['david',1,1],['investigator',4,4]], awareness = 0, captured = null, special = null,
description = "",
},
finalegarthor = {units = [['garthor',1,1],['orcwarrior',7,7]], awareness = 0, captured = null, special = null,
description = "",
},
finalehade = {units = [['hade',1,1],['hademerc',6,6]], awareness = 0, captured = null, special = null,
description = "",
},
finalecouncil = {units = [['councilboss',1,1],['orderprotector',9,9]], awareness = 0, captured = null, special = null,
description = "",
},

wimbornguards = {units = [['wimbornpatrol',3,4]], awareness = 0, captured = null, special = null,
description = "You have been spotted by [color=aqua]patrolling militia[/color] group from Wimborn. ",
},
wimbornguardsmany = {units = [['wimbornpatrol',7,10]], awareness = 0, captured = null, special = null,
description = "You have been spotted by [color=aqua]large patrolling militia[/color] group from Wimborn. ",
},
gornguards = {units = [['gornpatrol',3,4]], awareness = 0, captured = null, special = null,
description = "You have been spotted by [color=aqua]patrolling militia[/color] group from Gorn. ",
},
gornguardsmany = {units = [['gornpatrol',7,10]], awareness = 0, captured = null, special = null,
description = "You have been spotted by [color=aqua]large patrolling militia[/color] group from Gorn. ",
},
frostfordguards = {units = [['frostfordpatrol',3,4]], awareness = 0, captured = null, special = null,
description = "You have been spotted by [color=aqua]patrolling militia[/color] group from Frostford. ",
},
frostfordguardsmany = {units = [['frostfordpatrol',7,10]], awareness = 0, captured = null, special = null,
description = "You have been spotted by [color=aqua]large patrolling militia[/color] group from Frostford. ",
},
amberguardguards = {units = [['amberguardpatrol',3,4]], awareness = 0, captured = null, special = null,
description = "You have been spotted by [color=aqua]patrolling militia[/color] group from Amberguard. ",
},
amberguardguardsmany = {units = [['amberguardpatrol',7,10]], awareness = 0, captured = null, special = null,
description = "You have been spotted by [color=aqua]large patrolling militia[/color] group from Amberguard. ",
},
}

var capturespool = {
thugvictim = {
race = ['area'],
originspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 6},{value = 'slave', weight = 12}],
agepool = [{value = 'child', weight = 1},{value = 'teen', weight = 3}, {value = 'adult', weight = 2}],
sex = ['any'],
faction = 'stranger',
},
slavervictim = {
race = ['area'],
originspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 5},{value = 'poor', weight = 5},{value = 'slave', weight = 12}],
agepool = [['child',20],['teen',60], ['adult', 100]],
sex = ['any'],
faction = 'stranger',
},
banditcampcaptured = {
race = ['any'],
originspool = [{value = 'noble', weight = 2},{value = 'rich', weight = 5},{value = 'commoner', weight = 8},{value = 'poor', weight = 10}],
agepool = [{value = 'child', weight = 2},{value = 'teen', weight = 3}, {value = 'adult', weight = 3}],
sex = ['any'],
faction = 'stranger',
},


}


var enemypool = {
wolf = {
name = 'Wolf',
code = 'wolf',
faction = 'animal',
icon = load("res://files/images/enemies/wolf.png"),
special = null,
capture = null,
level = 2,
rewardpool = {bestialessenceing = 25},
rewardgold = 0,
rewardexp = 10,
stats = {health = 25, power = 5, speed = 12, energy = 50, armor = 0, magic = 0, abilities = ['attack']},
skills = [],
},
direwolf = {
name = 'Dire Wolf',
code = 'direwolf',
faction = 'animal',
icon = load("res://files/images/enemies/wolf.png"),
special = null,
level = 4,
capture = null,
rewardpool = {bestialessenceing = 40},
rewardgold = 0,
rewardexp = 20,
stats = {health = 50, power = 8, speed = 15, energy = 50, armor = 1, magic = 0, abilities = ['attack']},
skills = [],
},
plant = {
name = 'Plant',
code = 'plant',
level = 3,
faction = 'plant',
icon = load("res://files/images/enemies/plant.png"),
special = null,
capture = null,
rewardpool = {natureessenceing = 30},
rewardgold = 0,
rewardexp = 15,
stats = {health = 40, power = 5, speed = 12, energy = 50, armor = 3, magic = 0, abilities = ['attack']},
skills = [],
},
ooze = {
name = 'Ooze',
code = 'ooze',
level = 6,
faction = 'animal',
icon = load("res://files/images/enemies/slime.png"),
special = null,
capture = null,
rewardpool = {taintedessenceing = 25, fluidsubstanceing = 20},
rewardgold = 0,
rewardexp = 25,
stats = {health = 75, power = 7, speed = 15, energy = 50, armor = 15, magic = 0, abilities = ['attack']},
skills = [],
},
bear = {
name = 'Bear',
code = 'bear',
faction = 'animal',
icon = load("res://files/images/enemies/bear.png"),
special = null,
capture = null,
rewardpool = {bestialessenceing = 50},
rewardgold = 0,
rewardexp = 20,
level = 7,
stats = {health = 90, power = 7, speed = 18, energy = 50, armor = 3, magic = 0, abilities = ['attack']},
skills = [],
},
cougar = {
name = 'Cougar',
code = 'cougar',
faction = 'animal',
icon = load("res://files/images/enemies/cougar.png"),
special = null,
capture = null,
level = 4,
rewardpool = {bestialessenceing = 35},
rewardgold = 0,
rewardexp = 20,
stats = {health = 60, power = 6, speed = 20, energy = 50, armor = 1, magic = 0, abilities = ['attack']},
skills = [],
},
spider = {
name = 'Giant Spider',
code = 'spider',
faction = 'animal',
icon = load("res://files/images/enemies/spider.png"),
special = null,
capture = null,
rewardpool = {bestialessenceing = 75},
level = 12,
rewardgold = 0,
rewardexp = 50,
stats = {health = 120, power = 12, speed = 18, energy = 50, armor = 5, magic = 2, abilities = ['attack','webattack']},
skills = [],
},
peasant = {
name = 'Lone Stranger',
code = 'peasant',
faction = 'stranger',
icon = load("res://files/images/enemies/stranger.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 5},{value = 'poor', weight = 20}],
captureagepool = [{value = 'child', weight = 1},{value = 'teen', weight = 3}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 15, supply = 25},
rewardgold = [1,5],
rewardexp = 15,
stats = {health = 40, power = 4, speed = 15, energy = 50, armor = 2, magic = 1, abilities = ['attack']},
gear = 'peasant',
skills = [],
},
elfguard = {
name = 'An Elf Warrior',
code = 'elfguard',
faction = 'elf',
icon = load("res://files/images/enemies/elfguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 75, power = 8, speed = 20, energy = 50, armor = 3, magic = 2, abilities = ['attack']},
gear = 'elfs',
skills = [],
},
elfleader = {
name = 'An Elf Leader',
code = 'elfleader',
faction = 'elf',
icon = load("res://files/images/enemies/elfguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 125, power = 13, speed = 24, energy = 50, armor = 6, magic = 2, abilities = ['attack']},
gear = 'elfs',
skills = [],
},

orcwarrior = {
name = 'An Orc Warrior',
code = 'orcwarrior',
faction = 'gorn',
icon = load("res://files/images/enemies/orcguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 90, power = 11, speed = 23, energy = 50, armor = 5, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},
investigator = {
name = 'Investigator',
code = 'investigator',
faction = 'gorn',
icon = load("res://files/images/enemies/humanguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 125, power = 14, speed = 28, energy = 50, armor = 4, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},
orderprotector = {
name = "Order's Protector",
code = 'orderprotector',
faction = 'gorn',
icon = load("res://files/images/enemies/humanguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 110, power = 12, speed = 22, energy = 50, armor = 8, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},
garthor = {
name = 'Garthor',
code = 'garthor',
faction = 'gorn',
icon = load("res://files/images/enemies/garthor.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 250, power = 15, speed = 29, energy = 50, armor = 6, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},
david = {
name = 'David',
code = 'david',
faction = 'gorn',
icon = load("res://files/images/enemies/humanguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 200, power = 18, speed = 35, energy = 50, armor = 5, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},
hade = {
name = 'Hade',
code = 'hade',
faction = 'bandit',
icon = load("res://files/images/enemies/hade.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 400, power = 25, speed = 35, energy = 50, armor = 12, magic = 5, abilities = ['attack','alwayshitattack']},
gear = 'guard',
skills = [],
},
hademerc = {
name = "Hade's associate",
code = 'hademerc',
faction = 'bandit',
icon = load("res://files/images/enemies/banditleaderm.png"),
iconalt = load("res://files/images/enemies/banditleaderf.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 100, power = 15, speed = 30, energy = 50, armor = 6, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},
councilboss = {
name = "Council leader",
code = 'councilboss',
faction = 'bandit',
icon = null,
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 2},{value = 'commoner', weight = 6},{value = 'poor', weight = 10}],
captureagepool = [{value = 'teen', weight = 2}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 30,
stats = {health = 240, power = 22, speed = 30, energy = 50, armor = 9, magic = 2, abilities = ['attack','masshealcouncil']},
gear = 'guard',
skills = [],
},
fairy = {
name = 'Fairy',
code = 'fairy',
faction = 'monster',
icon = load("res://files/images/enemies/fairym.png"),
iconalt = load("res://files/images/enemies/fairyf.png"),
special = '',
capture = true,
capturerace = [['Fairy',100]],
captureoriginspool = [{value = 'commoner', weight = 1},{value = 'poor', weight = 3}],
captureagepool = [{value = 'child', weight = 1},{value = 'teen', weight = 3}, {value = 'adult', weight = 2}],
capturesex = ['any'],
rewardpool = {magicessenceing = 55},
rewardgold = [5,10],
rewardexp = 20,
stats = {health = 65, power = 5, speed = 18, energy = 50, armor = 0, magic = 5, abilities = ['attack']},
gear = 'forest',
skills = [],
},
goblin = {
name = 'Goblin',
code = 'goblin',
faction = 'monster',
icon = null,
special = '',
capture = true,
capturerace = [['Goblin',100]],
captureoriginspool = [{value = 'commoner', weight = 1},{value = 'poor', weight = 3}],
captureagepool = [{value = 'child', weight = 1},{value = 'teen', weight = 3}, {value = 'adult', weight = 3}],
capturesex = ['any'],
rewardpool = {gold = 55},
rewardgold = [5,10],
rewardexp = 15,
stats = {health = 60, power = 8, speed = 21, energy = 50, armor = 1, magic = 2, abilities = ['attack']},
gear = 'weakbandits',
skills = [],
},
harpy = {
name = 'Harpy',
code = 'harpy',
faction = 'monster',
icon = null,
special = '',
capture = true,
capturerace = [['Harpy',100]],
captureoriginspool = [{value = 'commoner', weight = 1},{value = 'poor', weight = 2}],
captureagepool = [{value = 'child', weight = 1},{value = 'teen', weight = 3}, {value = 'adult', weight = 3}],
capturesex = ['any'],
rewardpool = {bestialessenceing = 35},
rewardgold = [5,10],
rewardexp = 20,
stats = {health = 75, power = 6, speed = 22, energy = 50, armor = 1, magic = 0, abilities = ['attack']},
gear = 'weakbandits',
skills = [],
},
dryad = {
name = 'Dryad',
code = 'dryad',
faction = 'monster',
icon = load("res://files/images/enemies/dryadm.png"),
iconalt = load("res://files/images/enemies/dryadf.png"),
special = '',
capture = true,
capturerace = [['Dryad',100]],
captureoriginspool = [{value = 'commoner', weight = 1},{value = 'poor', weight = 1}],
captureagepool = [{value = 'child', weight = 1},{value = 'teen', weight = 3}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {natureessenceing = 35},
rewardgold = [5,10],
rewardexp = 20,
stats = {health = 75, power = 6, speed = 15, energy = 50, armor = 0, magic = 0, abilities = ['attack']},
gear = 'forest',
skills = [],
},
monstergirl = {
name = 'Monster ',
code = 'monstergirl',
faction = 'monster',
icon = null,
special = '',
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 2}],
captureagepool = [{value = 'child', weight = 1},{value = 'teen', weight = 3}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {},
rewardgold = [5,10],
rewardexp = 25,
stats = {health = 100, power = 9, speed = 22, energy = 50, armor = 2, magic = 1, abilities = ['attack']},
gear = 'medbandits',
skills = [],
},
bandit = {
name = 'Bandit',
code = 'bandit',
faction = 'bandit',
icon = load("res://files/images/enemies/banditm.png"),
iconalt = load("res://files/images/enemies/banditf.png"),
special = '',
capture = true,
capturerace = ['bandits'],
captureoriginspool = [{value = 'commoner', weight = 1},{value = 'poor', weight = 5},{value = 'slave', weight = 2}],
captureagepool = [{value = 'child', weight = 1},{value = 'teen', weight = 3}, {value = 'adult', weight = 5}],
capturesex = ['any'],
rewardpool = {gold = 35},
rewardgold = [5,15],
rewardexp = 20,
stats = {health = 65, power = 4, speed = 14, energy = 50, armor = 2, magic = 0, abilities = ['attack']},
gear = 'weakbandits',
skills = [],
},
banditleader = {
name = 'Bandit Leader',
code = 'banditleader',
faction = 'bandit',
icon = load("res://files/images/enemies/banditleaderm.png"),
iconalt = load("res://files/images/enemies/banditleaderf.png"),
special = '',
capture = true,
capturerace = ['bandits'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 2},{value = 'slave', weight = 1}],
captureagepool = [{value = 'teen', weight = 1}, {value = 'adult', weight = 5}],
capturesex = ['any'],
rewardpool = {gold = 100},
rewardgold = [30,50],
rewardexp = 50,
stats = {health = 90, power = 6, speed = 21, energy = 80, armor = 4, magic = 0, abilities = ['attack','stunattack']},
gear = 'medbandits',
skills = [],
},
marauder = {
name = 'Marauder',
code = 'marauder',
faction = 'bandit',
icon = load("res://files/images/enemies/banditleaderm.png"),
iconalt = load("res://files/images/enemies/banditleaderf.png"),
special = '',
capture = true,
capturerace = ['bandits'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 4},{value = 'slave', weight = 1}],
captureagepool = [{value = 'teen', weight = 1}, {value = 'adult', weight = 5}],
capturesex = ['any'],
rewardpool = {gold = 65},
rewardgold = [25,40],
rewardexp = 50,
stats = {health = 100, power = 12, speed = 24, energy = 80, armor = 4, magic = 0, abilities = ['attack']},
gear = 'medbandits',
skills = [],
},
marauderleader = {
name = 'Marauder Leader',
code = 'marauder',
faction = 'bandit',
icon = load("res://files/images/enemies/banditleaderm.png"),
iconalt = load("res://files/images/enemies/banditleaderf.png"),
special = '',
capture = true,
capturerace = ['bandits'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 4},{value = 'slave', weight = 1}],
captureagepool = [{value = 'teen', weight = 1}, {value = 'adult', weight = 5}],
capturesex = ['any'],
rewardpool = {gold = 65},
rewardgold = [25,40],
rewardexp = 50,
stats = {health = 120, power = 14, speed = 25, energy = 80, armor = 5, magic = 0, abilities = ['attack','stunattack']},
gear = 'strongbandits',
skills = [],
},
traveller = {
name = 'Traveller',
code = 'traveller',
faction = 'stranger',
icon = load("res://files/images/enemies/stranger.png"),
special = '',
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 4},{value = 'poor', weight = 2}],
captureagepool = [{value = 'child', weight = 1},{value = 'teen', weight = 3}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 50, supply = 50},
rewardgold = [5,15],
rewardexp = 20,
stats = {health = 50, power = 5, speed = 15, energy = 50, armor = 2, magic = 0, abilities = ['attack']},
gear = 'peasant',
skills = [],
},
slaver = {
name = 'Slaver',
code = 'slaver',
faction = 'stranger',
icon = load("res://files/images/enemies/slaverm.png"),
iconalt = load("res://files/images/enemies/slaverf.png"),
special = null,
capture = true,
capturerace = ['bandits'],
captureoriginspool = [{value = 'slave', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 4}],
captureagepool = [{value = 'teen', weight = 1}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 35, supply = 35},
rewardgold = [5,15],
rewardexp = 25,
stats = {health = 70, power = 7, speed = 18, armor = 4, energy = 50, magic = 0, abilities = ['attack']},
gear = 'medbandits',
skills = [],
},
wimbornpatrol = {
name = 'Wimborn Defender',
code = 'wimbornpatrol',
faction = 'stranger',
icon = load("res://files/images/enemies/humanguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 3}],
captureagepool = [{value = 'teen', weight = 1}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 25,
stats = {health = 100, power = 15, speed = 35, energy = 50, armor = 5, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},
frostfordpatrol = {
name = 'Frostford Defender',
code = 'frostfordpatrol',
faction = 'stranger',
icon = load("res://files/images/enemies/wolfguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 3}],
captureagepool = [{value = 'teen', weight = 1}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 25,
stats = {health = 100, power = 16, speed = 33, energy = 50, armor = 5, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},
gornpatrol = {
name = 'Gorn Defender',
code = 'gornpatrol',
faction = 'stranger',
icon = load("res://files/images/enemies/orcguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 3}],
captureagepool = [{value = 'teen', weight = 1}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 25,
stats = {health = 120, power = 16, speed = 34, energy = 50, armor = 4, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},
amberguardpatrol = {
name = 'Amberguard Defender',
code = 'amberpatrol',
faction = 'stranger',
icon = load("res://files/images/enemies/elfguard.png"),
special = null,
capture = true,
capturerace = ['area'],
captureoriginspool = [{value = 'rich', weight = 1},{value = 'commoner', weight = 3},{value = 'poor', weight = 3}],
captureagepool = [{value = 'teen', weight = 1}, {value = 'adult', weight = 4}],
capturesex = ['any'],
rewardpool = {gold = 20, supply = 35},
rewardgold = [1,5],
rewardexp = 25,
stats = {health = 100, power = 16, speed = 35, energy = 50, armor = 4, magic = 2, abilities = ['attack']},
gear = 'guard',
skills = [],
},



ivran = {
name = 'An Elf Leader',
code = 'ivran',
faction = 'elf',
icon = null,
special = null,
capture = true,
capturerace = ['Dark Elf',100],
captureoriginspool = [{value = 'noble', weight = 100}],
captureagepool = [{value = 'adult', weight = 100}],
capturesex = ['any'],
rewardpool = {gold = 20},
rewardgold = [5,10],
rewardexp = 50,
stats = {health = 100, power = 10, speed = 25, energy = 50, armor = 4, magic = 2, abilities = ['attack']},
gear = 'weakbandits',
skills = [],
},
ayneris = {
name = 'An Elf Leader',
code = 'ayneris',
faction = 'elf',
icon = null,
special = null,
capture = true,
capturerace = ['Elf',100],
captureoriginspool = [{value ='noble', weight = 100}],
captureagepool = [{value = 'teen', weight = 100}],
capturesex = ['female'],
rewardpool = {gold = 20},
rewardgold = [5,10],
rewardexp = 40,
stats = {health = 80, power = 12, speed = 24, energy = 50, armor = 3, magic = 3, abilities = ['attack']},
gear = 'weakbandits',
skills = [],
},
#undercity
mutant = {
name = 'Crazed mutant',
code = 'mutant',
faction = 'animal',
icon = load("res://files/images/enemies/mutant.png"),
special = null,
capture = null,
level = 15,
rewardpool = {taintedessenceing = 40, armortentacle = 5, clothtentacle = 5},
rewardgold = 0,
rewardexp = 50,
stats = {health = 150, power = 15, speed = 22, energy = 50, armor = 2, magic = 2, abilities = ['attack']},
skills = [],
},
troglodyte = {
name = 'Troglodyte',
code = 'troglodyte',
faction = 'animal',
level = 12,
icon = load("res://files/images/enemies/troglodyte.png"),
special = null,
capture = null,
rewardpool = {taintedessenceing = 40, accslavecollar = 3},
rewardgold = 0,
rewardexp = 50,
stats = {health = 90, power = 12, speed = 18, energy = 50, armor = 2, magic = 2, abilities = ['attack']},
gear = 'weakbandits',
skills = [],
},
gembeetle = {
name = 'Gem Beetle',
code = 'gembeetle',
faction = 'animal',
icon = load("res://files/images/enemies/gembettle.png"),
special = null,
capture = null,
level = 6,
rewardpool = {gem = 50},
rewardgold = 0,
rewardexp = 10,
stats = {health = 75, power = 15, speed = 20, energy = 50, armor = 15, magic = 2, abilities = ['attack']},
skills = [],
},
bossgolem = {
name = 'Animated Golem',
code = 'bossgolem',
faction = 'boss',
icon = load("res://files/images/enemies/golem.png"),
special = null,
capture = null,
rewardpool = {gem = 50},
rewardgold = 0,
rewardexp = 10,
stats = {health = 500, power = 20, speed = 25, energy = 50, armor = 20, magic = 2, abilities = ['attack','aoeattack']},
skills = [],
},
bosswyvern = {
name = 'Cave Wyvern',
code = 'bosswyvern',
faction = 'boss',
icon = null,
special = null,
capture = null,
rewardpool = {gem = 50, armorplate = 100},
rewardgold = 0,
rewardexp = 10,
stats = {health = 450, power = 24, speed = 30, energy = 50, armor = 15, magic = 2, abilities = ['attack','aoeattack']},
skills = [],
},

}

var enemyequips = {
weakbandits = {
armor = [['nothing', 10], ['armorleather',10], ['armorchain', 1], ['armorleather+', 1]],
weapon = [['weapondagger',10], ['weaponsword', 2], ['weapondagger+', 2]],
abilities = [],
},
medbandits = {
armor = [['armorleather+',3], ['armorchain', 3], ['armorchain+', 1], ['armorninja', 0.5], ['armorrogue', 0.1]],
weapon = [['weaponsword', 4], ['weaponsword+', 1], ['weapondagger+', 2], ['weaponhammer', 0.1]],
accessory = [['accamuletruby', 1], ['nothing',10]],
abilities = [],
},
strongbandits = {
armor = [['armorchain', 8], ['armorchain+', 2], ['armorninja', 1], ['armorninja+', 0.1], ['armorrogue', 0.2], ['armorplate', 0.5], ['armorplate+', 0.1]],
weapon = [['weaponsword', 4], ['weaponsword+', 1], ['weaponclaymore', 2], ['weaponclaymore+', 0.3], ['weaponhammer', 1], ['weaponhammer+', 0.2]],
accessory = [['accamuletruby', 1], ['accamuletemerald',1], ['accamuletruby+', 0.3], ['accamuletemerald+',0.3]],
abilities = [],
},
elfs = {
armor = [['armorchain', 3], ['armorchain+', 1], ['armorelvenchain', 10], ['armorelvenchain+', 2]],
weapon = [['weaponelvensword', 4], ['weaponelvensword+', 1], ['weapondagger+', 2]],
accessory = [['accamuletemerald', 1], ['accamuletemerald+', 1],['nothing',10]],
abilities = [],
},
peasant = {
armor = [['nothing', 25],['armorleather',10], ['armorleather+', 1]],
weapon = [['nothing', 7],['weapondagger',10], ['weapondagger+', 2]],
abilities = [],
},
forest = {
armor = [['armorleather',10], ['armorleather+', 3]],
weapon = [['nothing', 5],['weapondagger+', 3],['weaponnaturestaff', 2],['weaponnaturestaff', 0.5]],
accessory = [['accamuletemerald', 1], ['accamuletemerald+', 0.2],['nothing',3]],
abilities = [],
},
guard = {
armor = [ ['armorchain', 10], ['armorchain+', 3], ['armorplate',1], ['armorplate+', 0.3]],
weapon = [['weaponsword', 5], ['weaponsword+', 1],  ['weaponhammer', 1], ['weaponhammer+', 0.2]],
accessory = [['accgoldring', 1], ['nothing',10]],
abilities = [],
}
}

