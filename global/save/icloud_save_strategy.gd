extends SaveStrategy

class_name  ICloudSaveStrategy

var _icloud: Object

func _init(icloud: Object) -> void:
	_icloud = icloud

func save_experience_state(save_id: String, experience_state: ExperienceState) -> void:
	var experience_state_dict = experience_state.to_dict()
	var dict_to_store = { "experience_state:%s" % save_id: experience_state_dict }
	_icloud.set_key_values(dict_to_store)
	_icloud.synchronize_key_values()

func load_experience_state(save_id: String) -> ExperienceState:
	_icloud.synchronize_key_values()
	var dict_to_load = _icloud.get_key_value("experience_state:%s" % save_id)
	if dict_to_load == null:
		dict_to_load = {}
	return ExperienceState.from_dict(dict_to_load)

func delete_experience_state(save_id: String) -> void:
	_icloud.remove_key("experience_state:%s" % save_id)
	_icloud.synchronize_key_values()
