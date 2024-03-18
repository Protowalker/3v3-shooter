@tool
extends EditorPlugin

func _enter_tree():
	ProjectSettings.settings_changed.connect(update_file)


# https://www.reddit.com/r/godot/comments/19cg2wk/comment/kj0f92h/
func update_file() -> void: 
	InputMap.load_from_project_settings()
	var inputs = InputMap.get_actions().filter(func(input_name:StringName): return input_name.find(".") == -1)

	var inputs_string = "\n".join(inputs.map(func(input): return 'static var {name}:StringName = &"{name}"'.format({"name": input})))

	var script_content = \
"""
class_name InputActions extends RefCounted

{inputs}

""".format({"inputs": inputs_string})
	var script = GDScript.new()
	script.source_code = script_content
	ResourceSaver.save(script, 'res://addons/typed_inputs/InputActions.gd')
