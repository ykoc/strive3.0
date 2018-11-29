
extends Node

var abilitydict = {
attack = {
name = 'Attack',
code = 'attack',
iconnorm = load("res://files/buttons/abils/Attack.png"),
iconpressed = load("res://files/buttons/abils/Attack3.png"),
icondisabled = load("res://files/buttons/abils/Attack2.png"),
learnable = false,
description = 'Attempts to attack chosen enemy.',
usetext = '$name goes for straight hit. ',
target = 'one',
targetgroup = 'enemy',
effect = null,
can_miss = true,
power = 1,
cooldown = 0,
type = 'physical',
price = 0,
costenergy = 0,
costmana = 0,
costother = '',
attributes = ['damage'],
reqs = {level = 0},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 1,
castersfx = 'attackanimation',
},
"pass" : {
name = 'Pass',
code = 'pass',
learnable = false,
description = 'Do nothing.',
usetext = '$name does nothing. ',
target = 'self',
targetgroup = 'ally',
effect = null,
can_miss = false,
power = 0,
cooldown = 0,
type = 'physical',
price = 0,
costenergy = 0,
costmana = 0,
costother = '',
attributes = [],
reqs = {level = 0}
},
escape = {
name = 'Escape',
code = 'escape',
iconnorm = load("res://files/buttons/abils/Escape.png"),
iconpressed = load("res://files/buttons/abils/Escape3.png"),
icondisabled = load("res://files/buttons/abils/Escape2.png"),
learnable = false,
description = 'Attempts to escape from the fight.',
usetext = '$name tries to escape from the fight. ',
target = 'self',
targetgroup = 'ally',
effect = 'escapeeffect',
can_miss = false,
power = 1,
cooldown = 4,
type = 'physical',
price = 0,
costenergy = 10,
costmana = 0,
costother = '',
attributes = [],
reqs = {level = 0},
aipatterns = ['any'],
aitargets = 'self',
aiselfcond = 'combatant.health < 20',
aitargetcond = 'any',
aipriority = 10,
},
debilitate = {
name = 'Debilitate',
code = 'debilitate',
iconnorm = load("res://files/buttons/abils/Debilitate.png"),
iconpressed = load("res://files/buttons/abils/Debilitate3.png"),
icondisabled = load("res://files/buttons/abils/Debilitate2.png"),
learnable = true,
description = 'Light attack aimed to slow enemy down.',
usetext = '$name goes for swift, maiming strike. ',
target = 'one',
targetgroup = 'enemy',
effect = 'debilitateeffect',
can_miss = true,
learncost = 25,
power = 0.65,
cooldown = 2,
type = 'physical',
price = 100,
costenergy = 8,
costmana = 0,
costother = '',
attributes = ['damage', 'debuff'],
reqs = {'level' : 1, 'sagi' : 1},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'notineffect',
aipriority = 3,
castersfx = 'attackanimation',
},
protect = {
name = 'Protect',
code = 'protect',
iconnorm = load("res://files/buttons/abils/Protect.png"),
iconpressed = load("res://files/buttons/abils/Protect3.png"),
icondisabled = load("res://files/buttons/abils/Protect2.png"),
learnable = false,
description = 'Shields target ally from incoming attacks. Takes less physical and energy damage from attacks. ',
usetext = '$name moves in to protect $targetname. ',
target = 'one',
targetgroup = 'ally',
effect = 'protecteffect',
effectself = 'protectselfeffect',
can_miss = true,
power = 1,
cooldown = 0,
type = 'physical',
price = 0,
costenergy = 5,
costmana = 0,
costother = '',
attributes = [],
reqs = {level = 0},
aipatterns = ['support'],
aitargets = '1ally',
aiselfcond = 'combatant.health > 50',
aitargetcond = 'any',
aipriority = 2,
},
heal = {
name = 'Heal',
code = 'heal',
iconnorm = load("res://files/buttons/abils/Heal.png"),
iconpressed = load("res://files/buttons/abils/Heal3.png"),
icondisabled = load("res://files/buttons/abils/Heal2.png"),
learnable = true,
requiredspell = 'heal',
description = 'Restores some health to the target. Requires mana to use. ',
usetext = '$name supports $targetname with a [color=aqua]Healing Spell[/color]. ',
target = 'one',
targetgroup = 'ally',
effect = null,
can_miss = false,
learncost = 25,
power = 1,
cooldown = 3,
type = 'spell',
price = 100,
costenergy = 0,
costmana = 10,
costother = '',
attributes = [],
reqs = {'level' : 1, 'smaf' : 1},
aipatterns = ['support'],
aitargets = '1ally',
aiselfcond = 'any',
aitargetcond = 'target.health < 50',
aipriority = 4,
},
sedation = {
name = 'Sedation',
code = 'sedation',
iconnorm = load("res://files/buttons/abils/Sedation.png"),
iconpressed = load("res://files/buttons/abils/Sedation3.png"),
icondisabled = load("res://files/buttons/abils/Sedation2.png"),
learnable = true,
requiredspell = 'sedation',
description = "Slows target's reaction, lowering it's speed. ",
usetext = '$name casts Sedation onto $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = 'sedationeffect',
can_miss = true,
learncost = 40,
power = 1,
cooldown = 5,
type = 'spell',
price = 150,
costenergy = 0,
costmana = 10,
costother = '',
attributes = [],
reqs = {'level' : 2, 'smaf' : 1},
aipatterns = ['support'],
aitargets = '1ally',
aiselfcond = 'any',
aitargetcond = 'target.health < 50',
aipriority = 4,
},
barrier = {
name = 'Barrier',
code = 'barrier',
iconnorm = load("res://files/buttons/abils/Barrier.png"),
iconpressed = load("res://files/buttons/abils/Barrier3.png"),
icondisabled = load("res://files/buttons/abils/Barrier2.png"),
learnable = true,
requiredspell = 'barrier',
description = "Creates a magical barrier around target, raising it's armor. ",
usetext = '$name casts Barrier onto $targetname. ',
target = 'one',
targetgroup = 'ally',
effect = 'barriereffect',
can_miss = false,
learncost = 35,
power = 1,
cooldown = 4,
type = 'spell',
price = 150,
costenergy = 0,
costmana = 12,
costother = '',
attributes = ['buff'],
reqs = {'level' : 2, 'smaf' : 2},
aipatterns = ['support'],
aitargets = '1ally',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 3,
targetsfx = 'barrieranimation'
},
shackle = {
name = 'Shackle',
code = 'shackle',
iconnorm = load("res://files/buttons/abils/Shackle.png"),
iconpressed = load("res://files/buttons/abils/Shackle3.png"),
icondisabled = load("res://files/buttons/abils/Shackle2.png"),
learnable = true,
requiredspell = 'shackle',
description = "Ties single target to ground making escape impossible. ",
usetext = '$name casts Shackle onto $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = 'shackleeffect',
can_miss = false,
learncost = 40,
power = 0,
cooldown = 5,
type = 'spell',
price = 150,
costenergy = 0,
costmana = 10,
costother = '',
attributes = ['debuff', 'noescape'],
reqs = {'level' : 3, 'smaf' : 2},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 5,
},
mindblast = {
name = 'Mind Blast',
code = 'mindblast',
iconnorm = load("res://files/buttons/abils/Mindblast.png"),
iconpressed = load("res://files/buttons/abils/Mindblast3.png"),
icondisabled =load("res://files/buttons/abils/Mindblast2.png"),
learnable = true,
description = "Deals damage to single target enemy based on your Magic Affinity. ",
usetext = '$name [color=aqua]uses Mind Blast[/color] at $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = null,
can_miss = true,
learncost = 50,
power = 2,
cooldown = 2,
type = 'spell',
price = 100,
costenergy = 5,
costmana = 5,
costother = '',
attributes = ['damage'],
reqs = {'level' : 2, 'smaf' : 1},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 6,
},
acidspit = {
name = 'Acid Spit',
code = 'acidspit',
learnable = true,
iconnorm = load("res://files/buttons/abils/Acid spit.png"),
iconpressed = load("res://files/buttons/abils/Acid spit3.png"),
icondisabled = load("res://files/buttons/abils/Acid spit2.png"),
description = "Deals damage to single target enemy and recudes it's armor. Effect grows with Magic Affinity. ",
usetext = '$name [color=aqua]Spits Acid[/color] at $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = 'acidspiteffect',
can_miss = true,
learncost = 40,
power = 4,
cooldown = 4,
type = 'spell',
price = 200,
costenergy = 0,
costmana = 6,
costother = '',
attributes = ['damage','debuff'],
reqs = {'level' : 4, 'smaf' : 4},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 4,
},
heavystike = {
name = 'Heavy Strike',
code = 'heavystike',
iconnorm = load("res://files/buttons/abils/Heavy Strike.png"),
iconpressed = load("res://files/buttons/abils/Heavy Strike3.png"),
icondisabled = load("res://files/buttons/abils/Heavy Strike2.png"),
learnable = true,
description = "A slow, yet powerful attack. Has a chance to Stun.",
usetext = '$name goes for a powerful swing at $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = null,
script = 'stunchance',
can_miss = true,
learncost = 25,
power = 1.75,
cooldown = 3,
type = 'physical',
price = 250,
costenergy = 10,
costmana = 0,
costother = '',
attributes = ['damage'],
reqs = {'level' : 3, 'sstr' : 2},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 1,
castersfx = 'attackanimation',
},
aimedstrike = {
name = 'Aimed Strike',
code = 'aimedstrike',
iconnorm = load("res://files/buttons/abils/Aimed strike.png"),
iconpressed = load("res://files/buttons/abils/Aimed strike3.png"),
icondisabled = load("res://files/buttons/abils/Aimed strike2.png"),
learnable = true,
description = "Powerful, quick strike ignoring target's armor. ",
usetext = '$name goes for an Aimed Strike at $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = null,
can_miss = true,
learncost = 40,
power = 1.5,
cooldown = 4,
type = 'physical',
price = 250,
costenergy = 8,
costmana = 0,
costother = '',
attributes = ['damage','physpen'],
reqs = {'level' : 2, 'sagi' : 2},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 3,
castersfx = 'attackanimation',
},
leechingstrike = {
name = 'Leeching Strike',
code = 'leechingstrike',
iconnorm = load("res://files/buttons/abils/Lich strike.png"),
iconpressed = load("res://files/buttons/abils/Lich strike3.png"),
icondisabled = load("res://files/buttons/abils/Lich strike2.png"),
learnable = true,
description = "Mana infused attack which restores health based on dealt damage. ",
usetext = '$name launches Leeching Strike at $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = null,
can_miss = true,
learncost = 50,
power = 1.2,
cooldown = 5,
type = 'physical',
price = 300,
costenergy = 4,
costmana = 4,
costother = '',
attributes = ['damage', 'lifesteal'],
reqs = {'level' : 4, 'sagi' : 3, 'smaf' : 2},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 2,
castersfx = 'attackanimation',
},
mindread = {
name = 'Mind reading',
code = 'mindread',
iconnorm = load("res://files/buttons/abils/Mindread.png"),
iconpressed = load("res://files/buttons/abils/Mindread3.png"),
icondisabled = load("res://files/buttons/abils/Mindread2.png"),
learnable = true,
requiredspell = 'mindread',
description = "A faster, combat oriented appliance of Mind Reading, allows you to get more information from your enemies. ",
usetext = '$name cast Mind reading onto self. ',
target = 'self',
targetgroup = 'ally',
effect = 'mindreadeffect',
can_miss = false,
learncost = 20,
power = 0,
cooldown = 0,
type = 'physical',
price = 100,
costenergy = 0,
costmana = 5,
costother = '',
attributes = ['buff', 'onlyself'],
reqs = {},
aitargets = 'self',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = -1,
},
aoeattack = {
name = 'Slam',
code = 'aoeattack',
iconnorm = load("res://files/buttons/abils/Attack.png"),
iconpressed = load("res://files/buttons/abils/Attack2.png"),
learnable = false,
description = 'Attempts to attack chosen enemy.',
usetext = '$name performs [color=aqua]Slam attack[/color]. ',
target = 'all',
targetgroup = 'enemy',
effect = null,
can_miss = true,
power = 0.8,
cooldown = 4,
type = 'physical',
price = 0,
costenergy = 0,
costmana = 0,
costother = '',
attributes = ['damage','allparty'],
reqs = {level = 0},
aipatterns = ['attack'],
aitargets = 'enemies',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 100,
castersfx = 'attackanimation',
targetsfx = 'slamanimation'
},
dragonfirebreath = {
name = 'Dragon Breath',
code = 'dragonfirebreath',
iconnorm = load("res://files/buttons/abils/Attack.png"),
iconpressed = load("res://files/buttons/abils/Attack2.png"),
learnable = false,
description = 'Attempts to attack chosen enemy.',
usetext = '$name uses [color=aqua]Dragon Breath[/color]. ',
target = 'all',
targetgroup = 'enemy',
effect = 'firebreatheffect',
can_miss = false,
power = 0.4,
cooldown = 6,
type = 'spell',
price = 0,
costenergy = 0,
costmana = 0,
costother = '',
attributes = ['damage','allparty','debuff'],
reqs = {level = 0},
aipatterns = ['attack'],
aitargets = 'enemies',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 100,
castersfx = 'firebreathanimationcaster',
targetsfx = 'firebreathanimationtarget'
},
darknessattack = {
name = 'Darkness Attack',
code = 'darknessattack',
iconnorm = load("res://files/buttons/abils/Attack.png"),
iconpressed = load("res://files/buttons/abils/Attack2.png"),
learnable = false,
description = 'Attempts to attack chosen enemy.',
usetext = '$name uses [color=aqua]Drain[/color]. ',
target = 'all',
targetgroup = 'enemy',
effect = 'darknesscurseeffect',
can_miss = false,
power = 1,
cooldown = 4,
type = 'spell',
price = 0,
costenergy = 0,
costmana = 0,
costother = '',
attributes = ['damage','allparty','debuff'],
reqs = {level = 0},
aipatterns = ['attack'],
aitargets = 'enemies',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 100,
castersfx = 'firebreathanimationcaster',
targetsfx = 'firebreathanimationtarget'
},
alwayshitattack = {
name = 'Precise Attack',
code = 'alwayshitattack',
iconnorm = load("res://files/buttons/abils/Attack.png"),
iconpressed = load("res://files/buttons/abils/Attack2.png"),
learnable = false,
description = 'Attempts to attack chosen enemy.',
usetext = '$name uses [color=aqua]Precise attack[/color] landing on $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = null,
can_miss = false,
power = 1.2,
cooldown = 5,
type = 'physical',
price = 0,
costenergy = 0,
costmana = 0,
costother = '',
attributes = ['damage'],
reqs = {level = 0},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 5,
castersfx = 'attackanimation',
},
stunattack = {
name = 'Stun',
code = 'stunattack',
iconnorm = null,
iconpressed = null,
learnable = false,
description = 'Attempts to attack chosen enemy.',
usetext = '$name launches [color=aqua]Stun attack[/color] at $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = 'stun',
can_miss = true,
power = 1,
cooldown = 6,
type = 'physical',
price = 0,
costenergy = 0,
costmana = 0,
costother = '',
attributes = ['damage'],
reqs = {level = 0},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 5,
castersfx = 'attackanimation',
},
webattack = {
name = 'Shoot Web',
code = 'webattack',
iconnorm = null,
iconpressed = null,
learnable = false,
description = 'Attempts to attack chosen enemy.',
usetext = '$name [color=aqua]shoots web[/color] at $targetname. ',
target = 'one',
targetgroup = 'enemy',
effect = 'enemyslow',
can_miss = true,
power = 1,
accuracy = 0.8,
cooldown = 4,
type = 'physical',
price = 0,
costenergy = 0,
costmana = 0,
costother = '',
attributes = ['damage'],
reqs = {level = 0},
aipatterns = ['attack'],
aitargets = '1enemy',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 3,
castersfx = 'attackanimation',
},
masshealcouncil = {
name = 'Mass Heal',
code = 'masshealcouncil',
iconnorm = null,
iconpressed = null,
learnable = false,
description = 'Attempts to attack chosen enemy.',
usetext = '$name [color=aqua]casts mass heal[/color]. ',
target = 'all',
targetgroup = 'ally',
effect = null,
can_miss = false,
power = 1,
accuracy = 1,
cooldown = 4,
type = 'spell',
price = 0,
costenergy = 0,
costmana = 0,
costother = '',
attributes = [],
reqs = {level = 0},
aipatterns = ['support'],
aitargets = 'allies',
aiselfcond = 'any',
aitargetcond = 'any',
aipriority = 2,
},
}

var effects = {
protecteffect = {
icon = load("res://files/buttons/abils/Protect.png"),
duration = 1,
name = 'Protected',
description = 'This character is being covered from direct hits',
code = 'protecteffect',
effect = 'protecttarget',
type = 'buff',
stats = [],
},
protectselfeffect = {
icon = load("res://files/buttons/mainscreen/48.png"),
duration = 1,
name = 'Protector',
description = 'Reduces received damage.',
code = 'protectselfeffect',
effect = 'protectself',
type = 'buff',
stats = [],
},
escapeeffect = {
icon = load("res://files/buttons/abils/Escape.png"),
duration = 1,
name = 'Escape',
description = 'Escapes combat on next turn.',
code = 'escapeeffect',
effect = 'escapeeffect',
type = 'buff',
stats = [],
},
healeffect = {
icon = load("res://files/buttons/abils/Heal.png"),
duration = 0,
effect = 'restorehealth',
type = 'buff',
},
sedationeffect = {
icon = load("res://files/buttons/abils/Sedation.png"),
duration = 3,
name = 'Sedation',
code = 'sedationeffect',
type = 'debuff',
stats = [['speed', '-(3+,caster.magic,)']],
},
barriereffect = {
icon = load("res://files/buttons/abils/Barrier.png"),
duration = 3,
name = 'Barrier',
code = 'barriereffect',
type = 'buff',
stats = [['armor', '3+,caster.magic,*3']],
},
debilitateeffect = {
icon = load('res://files/buttons/abils/Debilitate.png'),
duration = 3,
name = 'Debilitate',
code = 'debilitateeffect',
type = 'debuff',
stats = [['speed', '-(2+,caster.attack,/3)']],
},
mindreadeffect = {
icon = load('res://files/buttons/abils/Mindread.png'),
duration = 5,
name = 'Mind Reading',
code = 'mindreadeffect',
type = 'buff',
stats = [],
},
shackleeffect = {
icon = load("res://files/buttons/abils/Shackle.png"),
duration = 6,
name = "Shackled",
code = 'shackleeffect',
type = 'debuff',
stats = [],
},
acidspiteffect = {
icon = load("res://files/buttons/abils/Acid spit.png"),
duration = 5,
name = "Acid",
code = 'acidspiteffect',
type = 'debuff',
stats = [['armor', '-(3+,caster.magic,)']],
},
firebreatheffect = {
icon = load("res://files/buttons/combat/fire.png"),
duration = 2,
name = "On Fire",
code = 'firebreatheffect',
type = 'onendturn',
description = "Target is taking damage every turn",
script = 'firebreathdamage',
stats = [],
},
darknesscurseeffect = {
icon = load("res://files/buttons/abils/Acid spit.png"),
duration = 4,
name = "Drained",
code = 'darknesscurseeffect',
type = 'script',
description = "",
script = 'darknesscurse',
stats = [],
},
curseeffectatk = {
icon = load("res://files/buttons/combat/curse1.png"),
duration = 5,
name = "Drained",
code = 'curseeffectatk',
type = 'debuff',
description = "Attack is drastically reduced.",
stats = [['attack', '-(25, )']],
},
curseeffectmgc = {
icon = load("res://files/buttons/combat/curse2.png"),
duration = 5,
name = "Drained",
code = 'curseeffectmgc',
type = 'debuff',
description = "Magic is drastically reduced.",
stats = [['magic', '-(6, )']],
},
enemyslow = {
icon = load("res://files/buttons/abils/Sedation.png"),
duration = 3,
name = "Slow",
code = 'enemyslow',
type = 'debuff',
stats = [['speed', '-(5, )']],
},
stun = {
icon = load("res://files/buttons/abils/Heavy Strike.png"),
duration = 1,
name = "Stunned",
code = 'stun',
type = 'debuff',
description = "This character can't act this turn.",
stats = [],
},
lustweak = {
icon = load("res://files/buttons/sex.png"),
duration = -1,
name = "Horny",
code = 'lustweak',
type = 'passive',
stats = [['speed', '-(3,)']],
},
luststrong = {
icon = load("res://files/buttons/sexdown.png"),
duration = -1,
name = "Very Horny",
code = 'luststrong',
type = 'passive',
stats = [['speed', '-(5,)'],['attack','-(3,)']],
},
exhaust = {
icon = load("res://files/buttons/exhaust.png"),
duration = -1,
name = "Exhausted",
code = 'exhaust',
type = 'passive',
description = 'This character suffers from exhaustion and they deal less damage\n[color=yellow]-33% damage[/color]',
stats = [],
},
pregnancy = {
icon = load("res://files/buttons/abils/pregnant.png"),
duration = -1,
name = "Pregnant",
code = 'pregnancy',
description = '-25% Speed',
type = 'passive',
stats = [],
},
}

func restorehealth(caster, target):
	var text = ''
	var value = 25 + (caster.magic*9)
	target.hp += max(value, 10)
	text = '$name restores ' + str(value) + ' health.'
	return text

func damage(combatant, value):
	combatant.attack += value

func armor(combatant, value):
	combatant.armor += value

func speed(combatant, value):
	combatant.speed += value

func passive(combatant, value):
	combatant.passives.append(value)

func protection(combatant, value):
	combatant.protection += value

func lust(combatant, value):
	combatant.lust += 2

var passivesdict = {
doubleattack15 = {code = 'doubleattack15', effect = 'doubleattack', effectvalue = 15, descript = '15% chance to attack twice'},
doubleattack25 = {code = 'doubleattack25', effect = 'doubleattack', effectvalue = 25, descript = '25% chance to attack twice'},
cultleaderpassive = {code = 'cultleaderpassive', effect = 'cultleaderpassive', effectvalue = null, descript = 'Grows stronger when alies defeated'}
}

func stunchance(caster, target, basechance = 25):
	var chance = basechance
	if caster.person != null:
		chance = caster.person.sstr*8
	if target.faction == 'boss':
		chance = chance/4
	if chance >= rand_range(0,100):
		caster.scene.sendbuff(caster, target, 'stun')
		target.actionpoints = 0

func firebreathdamage(target):
	var value = 6
	target.hp -= value
	var text = '$name burns for [color=red]' + str(value) + '[/color] damage.'
	return target.person.dictionary(text)

func darknesscurse(target):
	target.scene.removebuff("darknesscurseeffect",target)
	if randf() >= 0.5:
		target.scene.sendbuff(target,target,"curseeffectatk")
	else:
		target.scene.sendbuff(target,target,"curseeffectmgc")
