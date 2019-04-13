extends Node

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

var mainmenu = 'res://files/mainmenu.scn'

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	goto_scene(mainmenu)

func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		#show_error()
		return
	#print(true)
	set_process(true)
	#current_scene.queue_free() # get rid of the old scene
	
	# start your "loading..." animation
	#get_node("animation").play("loading")
	
	wait_frames = 1


#warning-ignore:unused_argument
func _process(delta):
	if loader == null:
	    # no need to process anymore
		set_process(false)
		return
	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
		# poll your loader
		var err = loader.poll()
		if err == ERR_FILE_EOF: # load finished
			var resource = loader.get_resource()
			loader = null
#warning-ignore:return_value_discarded
			get_tree().change_scene_to(resource)
			#set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			#show_error()
			loader = null
			break

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# update your progress bar?
	get_node("progress").value = progress*100
	
	# or update a progress animation?
	#var length = get_node("animation").get_current_animation_length()
	
	# call this on a paused animation. use "true" as the second parameter to force the animation to update
	#get_node("animation").seek(progress * length, true)

#warning-ignore:unused_argument
func set_new_scene(scene_resource):
	pass
#	current_scene = scene_resource.instance()
#	globals.CurrentScene = current_scene
#	get_node("/root").add_child(current_scene)
#	get_node("/root").remove_child(self)
#	globals.emit_signal("scene_changed")
#	self.queue_free()
