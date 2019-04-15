extends Node

#warning-ignore:unused_class_variable
var traits = {
  "Foul Mouth": {
    "name": "Foul Mouth",
    "description": "All too often, $name uses words more suited for construction workers and sailors. \n\n[color=aqua]Vocal occupations less effective. Max Charm -25. [/color]",
    "effect": {
      "code": "foul_mouth",
      "charm_max": -25
    },
    "tags": [
      "mental",
      "detrimental"
    ],
    "conflict": [
      "Mute"
    ]
  },
  "Mute": {
    "name": "Mute",
    "description": "$name can't speak in a normal way and only uses signs and moans to communicate. \n\n[color=aqua]Obedience +25%. Can't work at occupations requiring speech. [/color]",
    "effect": {
      "code": "mute",
      "obed_mod": 0.25
    },
    "tags": [
      "mental",
      "detrimental"
    ],
    "conflict": [
      "Foul Mouth"
    ]
  },
  "Devoted": {
    "name": "Devoted",
    "description": "$name trusts you to a great degree. $His willingness to follow you caused $him to find new strengths in $his character. \n\n[color=aqua]Courage +25. Wit +25. Min Loyalty: 80.[/color]",
    "effect": {
      "code": "devoted",
      "cour_base": 25,
      "wit_base": 25,
      "loyalty_min": 80
    },
    "tags": [
      "mental",
      "secondary"
    ],
    "conflict": [
      ""
    ]
  },
  "Passive": {
    "name": "Passive",
    "description": "$name prefers to go with the flow and barely tries to proactively affect $his surroundings. \n\n[color=aqua]Can't take management related jobs. Obedience +25%. [/color]",
    "effect": {
      "code": "passive",
      "obed_mod": 0.25
    },
    "tags": [
      "mental"
    ],
    "conflict": [
      ""
    ]
  },
  "Masochist": {
    "name": "Masochist",
    "description": "$name enjoys pain far more than $he should. \n\n[color=aqua]Physical punishments more effective and cause lust to grow. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental",
      "perversy"
    ],
    "conflict": [
      ""
    ]
  },
  "Deviant": {
    "name": "Deviant",
    "description": "$name has a fondness for very unusual sexual practices. A cat or dog is fine for $him too. \n\n[color=aqua]Degrading sexual actions have no penalty. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental",
      "perversy",
	  "secondary",
    ],
    "conflict": [
      "Prude"
    ]
  },
  "Slutty": {
    "name": "Slutty",
    "description": "Your influence over $name caused $him to accept sex in many forms and enjoy $his body to the fullest. \n\n[color=aqua]Confidence +25. Charm +25. Min Loyalty: 80. [/color]",
    "effect": {
      "code": "slutty",
      "charm_base": 25,
      "conf_base": 25,
      "loyalty_min": 80
    },
    "tags": [
      "mental",
      "perversy",
      "secondary"
    ],
    "conflict": [
      ""
    ]
  },
  "Bisexual": {
    "name": "Bisexual",
    "description": "$name is open to having affairs with people of the same sex. \n\n[color=aqua]Same-sex encounters are easier to accept. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental"
    ],
    "conflict": [
      "Homosexual",
    ]
  },
  "Homosexual": {
    "name": "Homosexual",
    "description": "$name is only expecting to have same-sex affairs. \n\n[color=aqua]Same-sex encounters have no penalty, opposite sex actions are unpreferred. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental",
      "secondary"
    ],
    "conflict": [
      "Bisexual",
    ]
  },
  "Monogamous": {
    "name": "Monogamous",
    "description": "$name does not favor random encounters and believes there is one true partner in life for $him. \n\n[color=aqua]Refuses to work as prostitute, loyalty builds faster from sex with master. Sleeping with other partners is more stressful. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental"
    ],
    "conflict": [
      "Fickle"
    ]
  },
  "Pretty voice": {
    "name": "Pretty voice",
    "description": "$name's voice is downright charming, making surrounding people just want to hear more of it.\n\n[color=aqua]Vocal occupations more effective. Charm +20. [/color]",
    "effect": {
      "code": "pretty_voice",
      "charm_base": 20
    },
    "tags": [
      "physical"
    ],
    "conflict": [
      "Mute"
    ]
  },
  "Clingy": {
    "name": "Clingy",
    "description": "$name gets easily attached to people. However this behavior is rarely met with acceptance, which in turn annoys $him. \n\n[color=aqua]Loyalty +35%. Obedience drops quickly if constantly ignored. [/color]",
    "effect": {
      "code": "clingy",
      "loyalty_mod": 35
    },
    "tags": [
      "mental"
    ],
    "conflict": [
      ""
    ]
  },
  "Fickle": {
    "name": "Fickle",
    "description": "$name prefers having as many sexual partners as possible, unable to stay confined to only one person for long. \n\n[color=aqua]Prostituion job bonus, multiple partners are unlocked by default. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental"
    ],
    "conflict": [
      "Monogamous"
    ]
  },
  "Weak": {
    "name": "Weak",
    "description": "$name is rather weak compared to others. \n\n[color=aqua]Strength -2[/color]",
    "effect": {
      "code": "weak",
      "str_mod": -2
    },
    "tags": [
      "physical",
      "detrimental"
    ],
    "conflict": [
      "Strong"
    ]
  },
  "Strong": {
    "name": "Strong",
    "description": "$name has been blessed with greater strength than most. $He also appears to be harder to tame. \n\n[color=aqua]Strength +2, Obedience -20%[/color]",
    "effect": {
      "code": "strong",
      "str_mod": 2,
	  "obed_mod": -0.2
    },
    "tags": [
      "physical"
    ],
    "conflict": [
      "weak"
    ]
  },
  "Clumsy": {
    "name": "Clumsy",
    "description": "$name's reflexes are somewhat slower, than the others. \n\n[color=aqua]Agility -2[/color]",
    "effect": {
      "code": "clumsy",
      "agi_mod": -2
    },
    "tags": [
      "physical",
      "detrimental"
    ],
    "conflict": [
      "Quick"
    ]
  },
  "Quick": {
    "name": "Quick",
    "description": "$name is very active whenever $he does something. However, it also makes $his nervous system less stable. \n\n[color=aqua]Agility +2, Stress +20%[/color]",
    "effect": {
      "code": "quick",
      "agi_mod": 2,
	  "stress_mod": 0.2
    },
    "tags": [
      "physical"
    ],
    "conflict": [
      "Clumsy"
    ]
  },
  "Magic Deaf": {
    "name": "Magic Deaf",
    "description": "$name's senses are very dull when it comes to magic. \n\n[color=aqua]Magic Affinity -2[/color]",
    "effect": {
      "code": "magicdeaf",
      "maf_mod": -2
    },
    "tags": [
      "physical",
      "detrimental"
    ],
    "conflict": [
      "Responsive"
    ]
  },
  "Responsive": {
    "name": "Responsive",
    "description": "$name is in touch with raw energy, making $him potentially useful in magic area. \n\n[color=aqua]Magic Affinity +2, Toxicity +20%[/color]",
    "effect": {
      "code": "responsive",
      "maf_mod": 2,
	  "tox_mod": 0.2
    },
    "tags": [
      "physical"
    ],
    "conflict": [
      "Magic Deaf"
    ]
  },
  "Frail": {
    "name": "Frail",
    "description": "$name's body is much less durable than most. $His physical potential is severely impaired. \n\n[color=aqua]Endurance -2[/color]",
    "effect": {
      "code": "frail",
      "end_mod": -2
    },
    "tags": [
      "physical",
      "detrimental"
    ],
    "conflict": [
      "Robust"
    ]
  },
  "Robust": {
    "name": "Robust",
    "description": "$name's physiques is way better than most. \n\n[color=aqua]Endurance +2, Fear -20%[/color]",
    "effect": {
      "code": "robust",
      "end_mod": 2,
	  "fear_mod": -0.2
    },
    "tags": [
      "physical"
    ],
    "conflict": [
      "Frail"
    ]
  },
  "Scarred": {
    "name": "Scarred",
    "description": "$name's body is covered in massive burn scars. Besides being terrifying to look at, this also makes $him suffer from low confidence.\n\n[color=aqua]Charm -30. Beauty -30. [/color]",
    "effect": {
      "code": "scarred",
      "charm_base": -30,
      "beautybase": -30
    },
    "tags": [
      "physical",
      "detrimental"
    ],
    "conflict": [
      ""
    ]
  },
 "Blemished": {
    "name": "Blemished",
    "description": "$name's skin is covered in a lot of imperfections. Besides being unappealing to look at, this also makes $him suffer from low self esteem.\n\n[color=aqua]Charm -10. Beauty -10. [/color]",
    "effect": {
      "code": "Blemished",
      "charm_base": -10,
      "beautybase": -10
    },
    "tags": [
      "physical",
      "detrimental"
    ],
    "conflict": [
      "Natural Beauty"
    ]
  },
  "Natural Beauty": {
    "name": "Natural Beauty",
    "description": "$name is unusually pretty since $his birth and often was an object of envy. \n\n[color=aqua]Beauty +35. [/color]",
    "effect": {
      "code": "beauty",
      "beautybase": 35
    },
    "tags": [
      "physical",
    ],
    "conflict": [
      "Blemished"
    ]
  },
  "Coward": {
    "name": "Coward",
    "description": "$name is of a meek character and has a difficult time handling $himself in physical confrontations. \n\n[color=aqua]Physical punishments build obedience quicker, stress in combat grows twice as fast. [/color]",
    "effect": {
    },
    "tags": [
      "detrimental",
      "mental"
    ],
    "conflict": [
      ""
    ]
  },
  "Alcohol Intolerance": {
    "name": "Alcohol Intolerance",
    "description": "$name does not stomach alcoholic beverages too well. \n\n[color=aqua]Alcohol intakes make slave drunker lot quicker. [/color]",
    "effect": {
    },
    "tags": [
      "detrimental",
      "physical"
    ],
    "conflict": [
      ""
    ]
  },
  "Prude": {
    "name": "Prude",
    "description": "$name is very intolerant of many sexual practices, believing there are many inappropriate behaviors which shouldn't be practiced.\n\n[color=aqua]Sexual actions are harder to initiate and are less impactful. Refuses to work on sex-related jobs. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental"
    ],
    "conflict": [
      "Pervert",
      "Deviant",
      "Fickle"
    ]
  },
  "Pervert": {
    "name": "Pervert",
    "description": "$name has a pretty broad definition of stuff $he finds enjoyable.\n\n[color=aqua]Sexual actions are easier to unlock. Fetishist actions have no penalty. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental",
      "perversy"
    ],
    "conflict": [
      "Prude"
    ]
  },
  "Clever": {
    "name": "Clever",
    "description": "$name is more prone to creative thinking than an average person, which makes $him learn faster. \n\n[color=aqua]Teach effectiveness increased by 25%. [/color]",
    "effect": {
    },
    "tags": [
      "mental"
    ],
    "conflict": [
      ""
    ]
  },
  "Pliable": {
    "name": "Pliable",
    "description": "$name is still naive and can be swayed one way or another... \n\n[color=aqua]Has room for changes and growth. [/color]",
    "effect": {
      
    },
    "tags": [
      "mental"
    ],
    "conflict": [
      ""
    ]
  },
  "Dominant": {
    "name": "Dominant",
    "description": "$name really prefers to be in control, instead of being controlled. \n\n[color=aqua]Obedience -20%. Confidence +25. Max Confidence +15.  [/color]",
    "effect": {
      "code": "dominant",
      "conf_max": 15,
      "conf_base": 25,
      "obed_mod": -0.2
    },
    "tags": [
      "mental"
    ],
    "conflict": [
      "Submissive"
    ]
  },
  "Submissive": {
    "name": "Submissive",
    "description": "$name is very comfortable when having someone $he can rely on. \n\n[color=aqua]Obedience +40%. No penalty for rape actions as long as loyalty is above average. Confidence -10. Max Confidence -30. [/color]",
    "effect": {
      "code": "submissive",
      "conf_max": -30,
      "conf_base": -10,
      "obed_mod": 0.4
    },
    "tags": [
      "mental"
    ],
    "conflict": [
      "Dominant"
    ]
  },
  "Infertile": {
    "name": "Infertile",
    "description": "$name appear to have a rare condition making $him much less likely to have children. \n\n[color=aqua]Imregnation chance greatly reduced. [/color]",
    "effect": {
    },
    "tags": [
      "physical",
	  "detrimental"
    ],
    "conflict": [
	  ""
    ]
  },
  "Infirm": {
    "name": "Infirm",
    "description": "$name's wounds require additional care. \n\n[color=aqua]Natural regeneration is greatly reduced. [/color]",
    "effect": {
    },
    "tags": [
      "physical",
	  "detrimental"
    ],
    "conflict": [
	  ""
    ]
  },
  "Uncivilized": {
    "name": "Uncivilized",
    "description": "$name has spent most of $his lifetime in the wilds barely interacting with modern society and acting more like an animal. As a result, $he can't realistically fit into common groups and be accepted there. \n\n[color=aqua]Social jobs disabled. Max Wit -50. Max Obedience -30. Max Loyalty -65. [/color]",
    "effect": {
      "code": "uncivilized",
      "wit_max": -50,
      "obed_max": -30,
      "loyal_max": -65
    },
    "tags": [
      "secondary"
    ],
    "conflict": [
      ""
    ]
  },
  "Regressed": {
    "name": "Regressed",
    "description": "Due to some circumstances, $name's mind reversed to infantile state. $He's barely capable of normal tasks, but $he's a lot more responsive to social training.\n\n[color=aqua]Social jobs disabled. [/color]",
    "effect": {
      "code": "regressed"
    },
    "tags": [
      "secondary",
      "mental"
    ],
    "conflict": [
      ""
    ]
  },
  "Sex-crazed": {
    "name": "Sex-crazed",
    "description": "$name barely can keep $his mind off dirty stuff. $His perpetual excitement makes $him look and enjoy nearly everything at the cost of $his sanity. \n\n[color=aqua]Max Wit -80. Max Confidence -60. Min Lust +50. No penalty from any sexual activity and brothel assignement. [/color]",
    "effect": {
      "code": "sexcrazed",
      "wit_max": -80,
      "conf_max": -60,
      "lust_min": 50
    },
    "tags": [
      "secondary",
      "mental",
      "perversy",
      "detrimental"
    ],
    "conflict": [
      ""
    ]
  },
  "Likes it rough": {
    "name": "Likes it rough",
    "description": "$name secretly enjoys being treated badly and taken by force. \n\n[color=aqua]Rape actions cause no loyalty and obedience reduction. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental",
      "perversy"
    ],
    "conflict": [
      ""
    ]
	},
  "Enjoys Anal": {
    "name": "Enjoys Anal",
    "description": "$name is quite comfortable with $his ass being used for pleasure and even favors it. \n\n[color=aqua]Anal actions are more effective and preferred. [/color]",
    "effect": {
      
    },
    "tags": [
      "sexual",
      "mental",
      "perversy",
	  "secondary"
    ],
    "conflict": [
      ""
    ]
  },
  "Ascetic": {
    "name": "Ascetic",
    "description": "$name cares little about luxury around $him. \n\n[color=aqua]Luxury demands are lowered. [/color]",
    "effect": {
      
    },
    "tags": [
      "mental",
    ],
    "conflict": [
      ""
    ]    
  },
  "Spoiled": {
    "name": "Spoiled",
    "description": "$name cares a great deal about the environment around $him and expects to be treated well. \n\n[color=aqua]Luxury demands are increased. [/color]",
    "effect": {
    },
    "tags": [
      "mental",
    ],
    "conflict": [
      "Ascetic"
    ]    
  },
  "Small Eater": {
    "name": "Small Eater",
    "description": "[color=aqua]Food consumption reduced to 1/3. [/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
  "Hard Worker": {
    "name": "Hard Worker",
    "description": "[color=aqua]+15% gold from non-sexual occupations. [/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
      "mental",
    ],
    "conflict": [
      ""
    ]    
  },
  "Sturdy": {
    "name": "Sturdy",
    "description": "[color=aqua]Takes 15% less damage in combat [/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
  "Influential": {
    "name": "Influential",
    "description": "[color=aqua]Selling slaves worth 20% more gold. [/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
  "Gifted": {
    "name": "Gifted",
    "description": "[color=aqua]+20% upgrade points received. [/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
  "Scoundrel": {
    "name": "Scoundrel",
    "description": "[color=aqua]+15 gold per day. [/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
  "Nimble": {
    "name": "Nimble",
    "description": "[color=aqua]+25% to hit chances. [/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
  "Authority": {
    "name": "Authority",
    "description": "[color=aqua]If obedience above 95 , all other slaves gain +5 obedience per day. [/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
  "Mentor": {
    "name": "Mentor",
    "description": "[color=aqua]Slaves below level 3 gain +5 exp points per day[/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
  "Experimenter": {
    "name": "Experimenter",
    "description": "[color=aqua]Produces a random potion once in a while[/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
  "Grateful": {
    "name": "Grateful",
    "description": "Due to your actions, $name will overlook certain hardships willing to stick close to you.\n\n [color=aqua]No luxury requirements. [/color]",
    "effect": {
      
    },
    "tags": [
      "secondary",
    ],
    "conflict": [
      ""
    ]    
  },
}