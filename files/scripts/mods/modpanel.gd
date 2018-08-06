extends Node

var run_once = false


var file_dictionary = [] #main files data paths
var mods_dictionary = {} #mod folder data

var modfolder = 'res://mods'

var filedir = 'res://files'
var backupdir = 'res://backup'

var loadorder = []


func _ready():
	var dir = Directory.new()
	var file = File.new()
	var files = globals.dir_contents(filedir)
	for i in files: #collects file_dictionary data and makes a backup
		if (i.find(".gd") != -1):
			dir.open(i.replacen(filedir, backupdir).get_base_dir ())
			if !dir.dir_exists(i.replacen(filedir, backupdir).get_base_dir ()):
				dir.make_dir_recursive(i.replacen(filedir, backupdir).get_base_dir ())
			file_dictionary.append(i)
	for i in scanfolder() : #collects mod_dictionary data
		if !file.file_exists(i +"/info.txt"): #makes info.txt to store mod description
			file.open(i+'/info.txt', File.WRITE)
			file.store_line("There's no information on this mod.")
			file.close()
		
		dir.open(i)
		mods_dictionary[i] = get_mod(i)
	if !dir.dir_exists(backupdir) || globals.dir_contents(backupdir).size() <= 0:
		 storebackup()
	
#	order config file management
	
	loadfromconfig()
	
	file.open(backupdir + "/version", File.READ)
	var text = file.get_as_text()
	file.close()
	
	if int(text) != globals.gameversion:
		storebackup()


func scanfolder(): #makes an array of all folders in modfolder
	var target = modfolder
	var dir = Directory.new()
	var array = []
	if dir.open(target) == OK:
		dir.list_dir_begin()
		
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() && !file_name in ['.','..',null]:
				array.append(target + '/' + file_name)
			file_name = dir.get_next()
		return array


func _on_Mods_pressed():
	self.visible = !self.visible
	show()

func get_mod(string):
	var mods = globals.dir_contents(string)
	var mod = {}
	for i in mods:
		if(i.find(".gd") != -1):
			var modfile = File.new()
			modfile.open(i, File.READ)
			mod[i] = modfile.get_as_text()
			modfile.close()
	return mod

var dir = Directory.new()
var file = File.new()

func loadfromconfig():
	var config = ConfigFile.new()
	var err = config.load(modfolder + "/FileOrder.ini")
	if err == OK:
		loadorder = config.get_value("Mods", "LoadOrder", [])
	for i in loadorder:
		if !dir.dir_exists(modfolder + '/' + str(i)):
			loadorder.erase(i)

func saveconfig():
	var config = ConfigFile.new()
	config.load(modfolder + "/FileOrder.ini")
	config.set_value("Mods", "LoadOrder", loadorder)
	config.save(modfolder + "/FileOrder.ini")

func storebackup(): #clears and restores backups
	var file = File.new()
	var dir = Directory.new()
	
	for i in globals.dir_contents(backupdir):
		dir.remove(i)
	
	for i in file_dictionary:
		var backup = File.new()
		if !backup.file_exists(i.replacen(filedir, backupdir)):
			file.open(i, File.READ)
			backup.open(i.replacen(filedir, backupdir), File.WRITE)
			backup.store_string(file.get_as_text())
			file.close()
			backup.close()
	file.open(backupdir + "/version", File.WRITE)
	file.store_line(str(globals.gameversion))
	file.close()


func loadbackup():
	for i in file_dictionary:
		var backup = File.new()
		backup.open(i.replacen("res://files", "res://backup"), File.READ)
		var file_string = backup.get_as_text()
		backup.close()
		backup.open(i, File.WRITE)
		backup.store_string(file_string)
		backup.close()

func show():
	for i in $allmodscontainer/VBoxContainer.get_children():
		if i.name != 'Button':
			i.hide()
			i.queue_free()
	var array = []
	for i in scanfolder():
		array.append(i)
	array.sort_custom(self, 'sortmods')
	for i in array:
		i = i.replace(modfolder+'/',"")
		var modactive = loadorder.has(i)
		var newbutton = $allmodscontainer/VBoxContainer/Button.duplicate()
		$allmodscontainer/VBoxContainer.add_child(newbutton)
		newbutton.visible = true
		newbutton.text = i
		if modactive == true:
			newbutton.pressed = true
			newbutton.get_node("order").text = str(loadorder.find(i))
			newbutton.get_node('up').visible = true
			newbutton.get_node('down').visible = true
			newbutton.get_node("order").visible = true
			newbutton.get_node("up").connect("pressed",self,'modup',[i])
			newbutton.get_node("down").connect("pressed",self,'moddown',[i])
		newbutton.connect("mouse_entered", self, 'moddescript',[i])
		newbutton.connect("pressed",self, 'togglemod', [i])

func sortmods(first,second):
	if loadorder.has(first.replace(modfolder+'/',"")):
		if loadorder.has(second.replace(modfolder+'/',"")):
			if loadorder.find(first.replace(modfolder+'/',"")) < loadorder.find(second.replace(modfolder+'/',"")):
				return true
			else:
				return false
		else:
			return true
		return true
	else:
		return false

func moddescript(mod):
	var text
	file.open(modfolder + '/' + mod + '/info.txt', File.READ)
	text = file.get_as_text()
	file.close()
	if text == '':
		text = "There's no information on this mod."
	text = '[center][color=aqua]' + mod + '[/color][/center]\n' + text
	$modinfo.bbcode_text = text

func togglemod(mod):
	if loadorder.has(mod):
		loadorder.erase(mod)
	else:
		loadorder.append(mod)
	show()
	saveconfig()


func modup(mod):
	var order = loadorder.find(mod)
	loadorder.erase(mod)
	if order == 0:
		loadorder.insert(order, mod)
	else:
		loadorder.insert(order-1, mod)
	saveconfig()
	show()

func moddown(mod):
	var order = loadorder.find(mod)
	loadorder.erase(mod)
	if order + 1 > loadorder.size():
		loadorder.append(mod)
	else:
		loadorder.insert(order+1, mod)
	saveconfig()
	show()


func _on_applymods_pressed():
	
	get_tree().quit()
#	var applied_mods = get_node("appliedmodscontainer//VBoxContainer")
#	for i in applied_mods.get_children():
#		if(i.full_string != "NULL"):
#			apply_mod_to_dictionary(mods_dictionary[i.full_string])
#	apply_mod_dictionary()

func apply_mod_dictionary():
	for i in file_dictionary.keys():
		var core_file = File.new()
		core_file.open(i, File.WRITE)
		core_file.store_string(file_dictionary[i])
		core_file.close()

func apply_mod_to_dictionary(dict):
	for file in dict.keys():
		apply_file_to_dictionary(file, dict[file])

func apply_file_to_dictionary(file_name, string):
	var full_func = RegEx.new()
	full_func.compile("func\\s+(\\w*).*([\r\n]*[\\t#]+.*)*")
	var next_match = full_func.search_all(string)
	var full_var = RegEx.new()
	#full_var.compile("[\r\n]+((signal\\s)?((onready\\s)?var.=))[.\r\n^\\t]*")
	full_var.compile("[\r\n]+((onready\\s)?var.*=).*") 
	full_var.compile("[\r\n]+((signal\\s\\w+).*")
	var next_var_match = full_var.search_all(string)
	for key in file_dictionary.keys():
		if key.get_file() == file_name.get_file():
			var file_string = file_dictionary[key]
			var file_match = full_func.search_all(file_string)
			for each_match in next_match:
				var found_match = false
				for nested_match in file_match:
					if(each_match.get_string(1) == nested_match.get_string(1)):
						file_dictionary[key] = file_dictionary[key].replacen(nested_match.get_string(), each_match.get_string())
						found_match = true
				if !found_match :
					file_dictionary[key] = file_dictionary[key] + "\r\n" + each_match.get_string(1)
			file_match = full_var.search_all(file_string)
			for each_match in next_var_match:
				for nested_match in file_match:
					if(each_match.get_string(1) == nested_match.get_string(1)):
						file_dictionary[key] = file_dictionary[key].replacen(nested_match.get_string(), each_match.get_string())

func _on_disablemods_pressed():
	loadbackup()

func _on_closemods_pressed():
	self.visible = false

