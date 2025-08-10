extends SaveStrategy

class_name  OfflineSaveStrategy

const EXPERIENCE_STATE_SAVE_PATH: String = "user://experience_state_%s.dat"

func save_experience_state(save_id: String, experience_state: ExperienceState) -> void:
	var json = JSON.stringify(experience_state.to_dict())
	
	var file = FileAccess.open(EXPERIENCE_STATE_SAVE_PATH % save_id, FileAccess.WRITE)
	file.store_string(json)
	
	file.close()

func load_experience_state(save_id: String) -> ExperienceState:
	if not FileAccess.file_exists(EXPERIENCE_STATE_SAVE_PATH % save_id):
		return null
	
	var file = FileAccess.open(EXPERIENCE_STATE_SAVE_PATH % save_id, FileAccess.READ)
	var json = file.get_as_text()
	var data = JSON.parse_string(json)
	
	file.close()
	
	return ExperienceState.from_dict(data)

func delete_experience_state(save_id: String) -> void:
	if not FileAccess.file_exists(EXPERIENCE_STATE_SAVE_PATH % save_id):
		return
	DirAccess.remove_absolute(EXPERIENCE_STATE_SAVE_PATH % save_id)
