extends Node


const userSavePath := 'user://UserData.json' # save file
const globalSettingsPath := 'user://GlobalSettings.json' # preferences and other global data 

const userSaveDataTemplate := {
	"level": 0,
	"name": "",
	"health": 100,
	"ammo": [
		0,
		0
	]
}
const globalSettingsTemplate := {
	"patched": false,
	"masterVolume": 1,
	"musicVolume": 1,
	"sfxVolume": 1
}

var userSaveData := {
	"level": 0,
	"name": '',
	"health": 100,
	"ammo": [
		0,
		0
	]
}
var globalSettings := {
	"patched": false,
	"masterVolume": 1,
	"musicVolume": 1,
	"sfxVolume": 1
}


func _ready() -> void:
	
	loadSaveData()
	loadGlobalSettings()
	print(userSaveData)
	
func loadSaveData():
	var tempSaveData = loadJson(userSavePath)
	userSaveData = tempSaveData if tempSaveData != {} &&\
	tempSaveData.has('level') && tempSaveData.has('name') &&\
	tempSaveData.has('ammo')\
	 else userSaveDataTemplate.duplicate()
	
	
	

func loadGlobalSettings():
	var tempSettings = loadJson(globalSettingsPath)
	globalSettings = tempSettings if tempSettings != {} &&\
	tempSettings.has('patched') && tempSettings.has('masterVolume') &&\
	tempSettings.has('musicVolume') && tempSettings.has('sfxVolume') \
	else globalSettingsTemplate.duplicate()


func loadJson(path: String):
	if FileAccess.file_exists(path):
		var dataFile = FileAccess.open(path, FileAccess.READ)
		var parsed = JSON.parse_string(dataFile.get_as_text())
		
		if parsed is Dictionary:
			return parsed
		else:
			return {}
	else:
		return {}

func writeJson(path: String, data: Dictionary):
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		
		var jsonString = JSON.stringify(data, "\t")
		
		file.store_string(jsonString)
	else:
		print("Error opening file")
func saveSettings():
	writeJson(globalSettingsPath, globalSettings)

func getAmmoData():
	return userSaveData['ammo']

func saveUserData(level = 0, health = 100, shotgun = 0, sniper = 0):
	userSaveData['ammo'] = [shotgun, sniper]
	userSaveData['level'] = level
	userSaveData['health'] = clamp(health, 80,100)
	writeJson(userSavePath, userSaveData)

func getGlobalSettings():
	return globalSettings

func getUserSaveData():
	return userSaveData

func eraseAndReloadUserData():
	
	DirAccess.remove_absolute(userSavePath)
	
	loadSaveData()
	
func getHealth():
	return userSaveData['health']
	
func removePatch():
	globalSettings["patched"] = false
	saveSettings()
	
