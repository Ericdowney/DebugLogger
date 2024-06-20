@tool
class_name FilterItem extends Control

signal filter_changed(item: FilterItem, new_filter: String, is_regex: bool)
signal remove_filter(item: FilterItem, index: int)

#region Properties

@onready var filter_line_edit: LineEdit = %FilterLineEdit
@onready var is_regex_checkbox: CheckBox = %IsRegexCheckBox

var index: int = -1

#var text: String :
	#get: return filter_line_edit.text
	#set(new_value):
		#if filter_line_edit != null and is_instance_valid(filter_line_edit):
			#filter_line_edit.text = new_value
#
#var is_regex: bool:
	#get: return is_regex_checkbox.button_pressed
	#set(new_value):
		#if is_regex_checkbox != null and is_instance_valid(is_regex_checkbox):
			#is_regex_checkbox.button_pressed = new_value

#endregion

#region Lifecycle

#endregion

#region Signals

func _on_filter_line_edit_text_submitted(new_text: String):
	filter_changed.emit(self, new_text, is_regex_checkbox.button_pressed)

func _on_is_regex_check_box_toggled(toggled_on: bool):
	filter_changed.emit(self, filter_line_edit.text, toggled_on)

func _on_remove_button_pressed():
	remove_filter.emit(self, index)

#endregion

#region Methods

#endregion
