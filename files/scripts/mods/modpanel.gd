extends Node

var run_once = false


var file_dictionary = [] #main files data paths
var mods_dictionary = {} #mod folder data

var modfolder = 'res://mods'

var temp_mod_scripts = {} #variable to store all original + mod script data before overwrite

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
	if dir.dir_exists(modfolder) == false:
		dir.make_dir(modfolder)
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
	
	print("Making Backup...")
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
	print("Backup finished.")


func loadbackup():
	print("Loading Backup...")
	for i in file_dictionary:
		var backup = File.new()
		backup.open(i.replacen(filedir, backupdir), File.READ)
		var file_string = backup.get_as_text()
		backup.close()
		backup.open(i, File.WRITE)
		backup.store_string(file_string)
		backup.close()
	print("Load Finished")

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
	
	for i in loadorder:
		apply_mod_to_dictionary(modfolder + '/' + i)
	apply_mod_dictionary()
	get_tree().quit()

func apply_mod_dictionary():
	for i in temp_mod_scripts:
		var core_file = File.new()
		core_file.open(i, File.WRITE)
		core_file.store_string(temp_mod_scripts[i])
		core_file.close()

func apply_mod_to_dictionary(mod):
	loadbackup()
	var dict = get_mod(mod)
	
	for file in dict.keys():
		apply_file_to_dictionary(file, dict[file])

func get_mod(string):
	var mods = globals.dir_contents(string)
	var mod = {}
	string = string.replace(modfolder, '')
	for i in mods:
		if(i.find(".gd") != -1):
			var modfile = File.new()
			modfile.open(i, File.READ)
			mod[i.replace(modfolder, filedir).replace(string, '')] = modfile.get_as_text()
			modfile.close()
	return mod

func apply_file_to_dictionary(file_name, string):
	var regex_dictionary = {}
	var func_regex = "(func\\s+\\w*.*).*(([\r\n]*[\\t#]+.*)*)"
	var class_regex = "(class\\s+\\w*).*(([\r\n]*[\\t#]+.*)*)"
	var var_regex = "(var.*=)\\s([{]([^\\{\\}]*[\r\n]*)*[}])?([^\\{\\}\\s]*)"
	var onready_var_regex = "(onready\\svar.*=).*([\\{]([^\\{\\}]*[\r\n]*)*[\\}])?"
	var signal_regex = "(signal\\s.*)"
	var tag_regex = "<(\\w*)(\\s+\\d+)?(\\s\\d+)?>"
	var add_to = "AddTo"
	var remove_from = "RemoveFrom"
	var full_func = RegEx.new()
	full_func.compile(func_regex)
	var full_var = RegEx.new()
	full_var.compile(var_regex)
	var full_signal = RegEx.new()
	full_signal.compile(signal_regex) 
	var full_onready = RegEx.new()
	full_onready.compile(onready_var_regex)
	var full_class = RegEx.new()
	full_class.compile(class_regex)
	var full_tag = RegEx.new()
	full_tag.compile(tag_regex) 
	
	var key
	var file_string
	#print(file_dictionary)
	if file_dictionary.has(file_name):
		key = file_dictionary[file_dictionary.find(file_name)]
		file.open(file_dictionary[file_dictionary.find(file_name)], File.READ)
		file_string = file.get_as_text()
		file.close()
		file.open(file_name, File.READ)
		temp_mod_scripts[file_name] = file.get_as_text()
		file.close()
	if key != null:
		var offset = 0
		var has_next = true
		while has_next :
			var all_func = full_func.search_all(file_string)
			var all_var = full_var.search_all(file_string)
			var all_signal = full_signal.search_all(file_string)
			var all_onready = full_onready.search_all(file_string)
			var all_class = full_class.search_all(file_string)
			var all_tag = full_tag.search_all(file_string)
			var which_operation = "NULL"
			var next_func = full_func.search(string, offset)
			var next_var = full_var.search(string, offset)
			var next_signal = full_signal.search(string, offset)
			var next_onready = full_onready.search(string, offset)
			var next_class = full_class.search(string, offset)
			var next_tag = full_tag.search(string, offset)
			var new_offset = 0
			has_next = false
			var current_match
			if next_func != null && (new_offset == 0 || new_offset == -1 || new_offset > next_func.get_start()) && next_func.get_start() > -1:
				new_offset = next_func.get_start()
				current_match = next_func
				which_operation = "FUNC"
				has_next = true
			if next_var != null && (new_offset == 0 || new_offset == -1 || new_offset > next_var.get_start()) && next_var.get_start() > -1:
				new_offset = next_var.get_start()
				current_match = next_var
				which_operation = "VAR"
				has_next = true
			if next_signal != null && (new_offset == 0 || new_offset == -1 || new_offset > next_signal.get_start()) && next_signal.get_start() > -1:
				new_offset = next_signal.get_start()
				current_match = next_signal
				which_operation = "SIGN"
				has_next = true
			if next_onready != null && (new_offset == 0 || new_offset == -1 || new_offset > next_onready.get_start()) && next_onready.get_start() > -1:
				new_offset = next_onready.get_start()
				current_match = next_onready
				which_operation = "ONREADY"
				has_next = true
			if next_class != null && (new_offset == 0 || new_offset == -1 || new_offset > next_class.get_start()) && next_class.get_start() > -1:
				new_offset = next_class.get_start()
				current_match = next_class
				which_operation = "CLASS"
				has_next = true
			if new_offset != 0 :
				new_offset = new_offset + current_match.get_string().length()
			var file_match
			if has_next && (next_tag == null || new_offset <= next_tag.get_start() || next_tag.get_start() == -1):
				if which_operation == "FUNC":
					file_match = full_func.search_all(file_string)
				elif which_operation == "VAR":
					file_match = full_var.search_all(file_string)
				elif which_operation == "SIGN":
					file_match = full_signal.search_all(file_string)
				elif which_operation == "ONREADY":
					file_match = full_onready.search_all(file_string)
				elif which_operation == "CLASS":
					file_match = full_class.search_all(file_string)
				else:
					#operation not supported
					pass
				var found_match = false
				for nested_match in file_match:
					if(current_match.get_string(1) == nested_match.get_string(1)):
						temp_mod_scripts[key] = temp_mod_scripts[key].replacen(nested_match.get_string(), current_match.get_string())
						found_match = true
				if !found_match :
					#new_offset += current_match.get_string().length() - 1
					temp_mod_scripts[key] = temp_mod_scripts[key] + "\r\n" + current_match.get_string(1)
				pass
			elif has_next :
				if which_operation == "FUNC":
					file_match = full_func.search_all(file_string)
				elif which_operation == "VAR":
					file_match = full_var.search_all(file_string)
				elif which_operation == "SIGN":
					file_match = full_signal.search_all(file_string)
				elif which_operation == "ONREADY":
					file_match = full_onready.search_all(file_string)
				elif which_operation == "CLASS":
					file_match = full_class.search_all(file_string)
				else:
					#operation not supported
					pass
				if next_tag.get_string(1) == add_to:
					var param = next_tag.get_string(2).to_int()
					for nested_match in file_match:
						if(current_match.get_string(1) == nested_match.get_string(1)):
							var pool_string = nested_match.get_string().split("\n")
							if param > pool_string.size() :
								param = pool_string.size()
							var new_string = current_match.get_string()
							
							if which_operation in ["FUNC",'CLASS']:
								var param_temp = param
								for i in current_match.get_string(2).split("\n"):
									if i != "":
										pool_string.insert(param_temp, i)
										param_temp += 1
								temp_mod_scripts[key] = temp_mod_scripts[key].replacen(nested_match.get_string(), pool_string.join("\n"))
							elif which_operation == "VAR":
								var param_temp = param
								for i in current_match.get_string(2).replacen("{", "").replacen("}", "").split("\n"):
									if i != "":
										pool_string.insert(param_temp, i)
										param_temp += 1
								temp_mod_scripts[key] = temp_mod_scripts[key].replacen(nested_match.get_string(), pool_string.join("\n"))
							elif which_operation == "SIGN":
								pool_string.insert(param, current_match.get_string(1))
								temp_mod_scripts[key] = temp_mod_scripts[key].replacen(nested_match.get_string(), pool_string.join("\n"))
							elif which_operation == "ONREADY":
								pool_string.insert(param, current_match.get_string(2))
								temp_mod_scripts[key] = temp_mod_scripts[key].replacen(nested_match.get_string(), pool_string.join("\n"))
							elif which_operation == "CLASS":
								var param_temp = param
								for i in current_match.get_string(2).split("\n"):
									if i != "":
										pool_string.insert(param_temp, i)
										param_temp += 1
								temp_mod_scripts[key] = temp_mod_scripts[key].replacen(nested_match.get_string(), pool_string.join("\n"))
							else:
								#operation not supported
								pass
							break
				elif next_tag.get_string(1) == remove_from:
					# does not appear functional
					var param = next_tag.get_string(2).to_int()
					var param_2 = next_tag.get_string(3).to_int()
					for nested_match in file_match:
						if(current_match.get_string(1) == nested_match.get_string(1)):
							var new_string = nested_match.get_string().split("\n")
							for i in range(0, param_2 - param + 1):
								if i < new_string.size():
									new_string.remove(param)
							temp_mod_scripts[key] = temp_mod_scripts[key].replacen(nested_match.get_string(), new_string.join("\n"))
							break
					pass
				else:
					# operation not supported
					pass
			offset = new_offset + 1

#func apply_file_to_dictionary(file_name, string):
#	var full_func = RegEx.new()
#	full_func.compile("func\\s+(\\w*).*([\r\n]*[\\t#]+.*)*")
#	var next_match = full_func.search_all(string)
#	var full_var = RegEx.new()
#	#full_var.compile("[\r\n]+((signal\\s)?((onready\\s)?var.=))[.\r\n^\\t]*")
#	full_var.compile("[\r\n]+((onready\\s)?var.*=).*") 
#	full_var.compile("[\r\n]+((signal\\s\\w+).*")
#	var next_var_match = full_var.search_all(string)
#	for key in file_dictionary.keys():
#		if key.get_file() == file_name.get_file():
#			var file_string = file_dictionary[key]
#			var file_match = full_func.search_all(file_string)
#			for each_match in next_match:
#				var found_match = false
#				for nested_match in file_match:
#					if(each_match.get_string(1) == nested_match.get_string(1)):
#						file_dictionary[key] = file_dictionary[key].replacen(nested_match.get_string(), each_match.get_string())
#						found_match = true
#				if !found_match :
#					file_dictionary[key] = file_dictionary[key] + "\r\n" + each_match.get_string(1)
#			file_match = full_var.search_all(file_string)
#			for each_match in next_var_match:
#				for nested_match in file_match:
#					if(each_match.get_string(1) == nested_match.get_string(1)):
#						file_dictionary[key] = file_dictionary[key].replacen(nested_match.get_string(), each_match.get_string())

func _on_disablemods_pressed():
	loadbackup()

func _on_closemods_pressed():
	self.visible = false

