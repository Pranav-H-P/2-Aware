extends Node


const userSavePath = 'user://UserData.json' # save file
const globalSavePath = 'user://GlobalData.json' # preferences and other global data 

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
