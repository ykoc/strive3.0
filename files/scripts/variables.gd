extends Node
var basehealth = 50
var healthperend = 25
var geardropchance = 15
var pregduration = 31
var enchantitemprice = 1.5
var sellingitempricemod = 0.2
var basefoodconsumption = 10
var skillpointsperlevel = 2
var timeforinteraction = 20
var consumerope = 1
var learnpointsperstat = 3



#slave stats & combat
var damageperstr = 3
var speedperagi = 3
var speedbase = 10


#slave prices constants
var priceperlevel = 40
var priceperbasebeauty = 2.5
var priceperbonusbeauty = 1.5
var pricebonusvirgin = 0.15
var pricebonusfuta = 0.1
var pricebonusbadtrait = -0.1
var pricebonustoxicity = -0.33
var priceuncivilized = -0.5
var priceminimum = 5
var priceminimumsell = 10

var racepricemods = { #race mod will apply to _base_ price as baseprice*mod
	Elf = 1.5, "Dark Elf" : 1.5, Orc = 1.5, Goblin = 1.5, Gnome = 1.5,
	Drow = 2.5, Demon = 2.5, Seraph = 2.5,
	"Beaskin Cat" : 1.75, "Beaskin Wolf" : 1.75, "Beaskin Tanuki" : 1.75, "Beaskin Bunny" : 1.75,
	"Halfkin Cat" : 1.75, "Halfkin Wolf" : 1.75, "Halfkin Tanuki" : 1.75, "Halfkin Bunny" : 1.75,
	"Beaskin Fox" : 2, "Halfkin Fox" : 2, Fairy = 2, Dryad = 2, Taurus = 2,
	Slim = 2.5, Lamia = 2.5, Arachna = 2.5, Harpy = 2.5, Scylla = 2.5,
	Dragonkin = 3.5,
	}
var gradepricemod = { # grade and age mods will be added as bonus to base price which starts at 1 [baseprice*(1+value)]
	slave = -0.2, poor = 0, commoner = 0.2, rich = 0.5, noble = 1
	}
var agepricemods = {
	child = 0, teen = 0, adult = 0
}

var luxuryreqs = {slave = 0, poor = 5, commoner = 15,rich = 25, noble = 40}


var list = {
basehealth = {descript = "Character's health before modifiers", default = 50, min = 1, max = 1000},
healthperend = {descript = "Bonus health per point of endurance",default = 25, min = 0, max = 1000},
geardropchance = {descript = "Percent chance of getting enemy's gear on defeat", default = 15, min = 0, max = 100},
pregduration = {descript = "Basic pregnancy duration in days", default = 31, min = 1, max = 1000},
enchantitemprice = {descript = "Selling price modifier for enchanted gear", default = 1.5, min = 0, max = 10},
sellingitempricemod = {descript = "Selling price modifier for all items", default = 0.2, min = 0, max = 1},
basefoodconsumption = {descript = "Basic food consumption for characters per day", default = 10, min = 1, max = 100},
skillpointsperlevel = {descript = "Attribute points gained on levelup", default = 3, min = 1, max = 10},
timeforinteraction = {descript = "Number of actions you can perform during interaction sequence", default = 20, min = 1, max = 50},
consumerope  = {descript = "Number of ropes to be consumed when capturing a slave in the wild", default = 1, min = 0, max = 5,},
learnpointsperstat = {descript = "Number of skill points required to increase mental stat by 1", default = 3, min = 1, max = 100},
}