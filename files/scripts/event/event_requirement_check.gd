### Ku-Ku-Ku-Kurapanda!!!
### EventRequirementCheck - Handles the requirement checks for all event components
### ReturnType - CheckResult = {'pass' : true/false, 'meta' : {'tooltip' = '', ...}}
### Requirement Categories - Progress (unlocks, event choices, permanents), Globals (variable states), Resources, Items, Quests (Main & Side), People

### Constants
const IdType = ['unique']

### Public Functions
### Main Requirement Check Function
static func check_requirements(reqs):
	var checkResult = {'meetsReqs' : true, 'meta' : {tooltip = ''}}
	
	#No requirements found
	if reqs.empty():
		return checkResult
		
	#Check requirements by category
	for icategory in reqs:
		var partCheckResult = {'meetsReqs' : true, 'meta' : {tooltip = ''}}
		match icategory:
			'progress':
				pass
			'globals':
				partCheckResult = _check_global_reqs(reqs[icategory])
			'resources':
				partCheckResult = _check_resource_reqs(reqs[icategory])
			'items':
				partCheckResult = _check_item_reqs(reqs[icategory])
			'sidequests':
				partCheckResult = _check_sidequest_reqs(reqs[icategory])
			'people':
				partCheckResult = _check_person_reqs(reqs[icategory])
		
		if !partCheckResult.meetsReqs:
			checkResult.meetsReqs = false
			if checkResult.meta.tooltip != '':
				checkResult.meta.tooltip += '\n'
			checkResult.meta.tooltip += partCheckResult.meta.tooltip
	
	return checkResult

#Place Check Function is exposed as it requires 'place' parameter, ToFix after Place system updated
static func check_place_reqs(placeReq, place):
	var checkResult = {'meetsReqs' : true, 'meta' : {tooltip = ''}}
	
	#Check region
	if placeReq.region != 'any' && placeReq.region != place.region:
		checkResult.meetsReqs = false
		checkResult.tooltip = "In wrong region: " + place.region.capitalize()
		return checkResult
	
	#Check area
	if placeReq.area != 'any' && placeReq.area != place.area:
		checkResult.meetsReqs = false
		checkResult.tooltip = "In wrong area: " + place.area.capitalize()
		return checkResult
	
	#Check location
	if placeReq.location != 'any' && placeReq.location != place.location:
		checkResult.meetsReqs = false
		checkResult.tooltip = "In wrong location: " + place.location.capitalize()
	
	return checkResult
	
### Private Functions
#Globals Check Function
static func _check_global_reqs(globals):
	var checkResult = {'meetsReqs' : true, 'meta' : {tooltip = ''}}
	var tooltip = ''
	
	for iglobal in globals:
		match iglobal:
			'staff':
				for istaff in globals[iglobal]:
					match istaff:
						'hasHeadslave':
							if globals[iglobal][istaff] == true && globals.jobs.mansionStaff.headslave == null:
								checkResult.meetsReqs = false
								if tooltip != '':
									tooltip += '\n'
								tooltip += 'No current Headslave'
							elif globals[iglobal][istaff] == false && globals.jobs.mansionStaff.headslave != null:
								checkResult.meetsReqs = false
								if tooltip != '':
									tooltip += '\n'
								tooltip += 'There is a Headslave'
	
	return checkResult

#Resources Check Function
static func _check_resource_reqs(resources):
	var checkResult = {'meetsReqs' : true, 'meta' : {tooltip = ''}}
	var ownedResources = globals.resources
	var tooltip = ''
		
	for ires in resources:
		if resources[ires] > ownedResources[ires]:			
			if tooltip != '':
				tooltip += ", "
			tooltip += ires + '(' + str(resources[ires]) + ')'
				
	if tooltip != '':
		tooltip = "Not enough " + tooltip
		checkResult.meetsReqs = false
		checkResult.tooltip = tooltip
		
	return checkResult
	
#Item Check Function
static func _check_item_reqs(items):
	var checkResult = {'meetsReqs' : true, 'meta' : {tooltip = ''}}
	var ownedItems = globals.itemdict	
	var tooltip = ''
	
	for kitem in items:
		if items[kitem] > ownedItems[kitem].amount:
			if tooltip != '':
				tooltip += ", "
			tooltip += kitem + '[' + str(items[kitem]) + ']'
	
	if tooltip != '':
		tooltip = "Insufficient " + tooltip
		checkResult.meetsReqs = false
		checkResult.tooltip = tooltip
		
	return checkResult

#Sidequest Check Function
static func _check_sidequest_reqs(sidequests):
	var checkResult = {'meetsReqs' : true, 'meta' : {tooltip = ''}}
	
	for iquest in sidequests:
		match iquest.compare:
			'equals':
				if iquest.state.hash() != globals.events.sidequests[iquest.name].state.hash():
					checkResult.meetsReqs = false
					if checkResult.meta.tooltip != '':
						checkResult.meta.tooltip += '\n'
					checkResult.meta.tooltip += "Doesn't meet " + iquest.name.capitalize() + " sidequest reqs"
			'inSet':							
				if !sidequests[iquest.name].state.stage in iquest.state.stage:
					checkResult.meetsReqs = false
				elif !sidequests[iquest.name].state.branch in iquest.state.branch:
					checkResult.meetsReqs = false
				
				if checkResult.meetsReqs == false:
					if checkResult.meta.tooltip != '':
						checkResult.meta.tooltip += '\n'
					checkResult.meta.tooltip += "Doesn't meet " + iquest.name.capitalize() + " sidequest reqs"
					
	return checkResult

# People Check Functions
static func _check_person_reqs(people): 
	var checkResult = {'meetsReqs' : true, 'meta' : {tooltip = ''}}
	
	if people.empty():
		return checkResult
	
	for iperson in people:
		var focusPerson = null
		
		#Find Person
		var idType = iperson.id.keys()[0]		
		match idType:
			'unique':
				for islave in globals.slaves:
					if islave.unique == iperson.id.unique.capitalize():
						focusPerson = islave
		
		if focusPerson == null:
			checkResult.meetsReqs = false
			checkResult.meta['tooltip'] = "Missing person"
			return checkResult
		
		#Check Person Reqs		
		for ireq in iperson:
			match ireq:
				'brand':
					_check_person_brand(iperson[ireq], focusPerson, checkResult)
		
		return checkResult

static func _check_person_brand(brandReq, person, checkResult):
	var tooltip = ''
	
	if brandReq == 'any' && person.brand == 'none':
		tooltip = person.name + " has no Brand"
	elif brandReq == 'none' && person.brand != 'none':
		tooltip = person.name + " has a Brand"
	elif !brandReq == 'any' && brandReq != person.brand:
		tooltip = person.name + " needs " + brandReq.capitalize() + " Brand"

	if tooltip != '':
		checkResult.meetsReqs = false
		if checkResult.meta.tooltip == '':
			checkResult.meta.tooltip = tooltip
		else:
			checkResult.meta.tooltip = '\n' + tooltip