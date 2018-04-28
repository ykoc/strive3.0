extends Node
var basehealth = 50
var healthperend = 25
var geardropchance = 15
var pregduration = 31
var enchantitemprice = 1.5
var sellingitempricemod = 0.2
var basefoodconsumption = 10
var skillpointsperlevel = 3
var timeforinteraction = 20
var consumerope = 1


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
consumerope  = {descript = "Number of ropes to be consumed when capturing a slave in the wild", default = 1, min = 0, max = 5,}
}