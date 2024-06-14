@tool
class_name DebugLoggerDock extends Control

#region Properties

var add_button: Button = %AddButton
var remove_button: Button = %RemoveButton
var filter_item_list: Button = %FilterItemList
var start_stop_button: Button = %StartStopButton
var clear_button: Button = %ClearButton
var line_limit_edit: Button = %LineLimitEdit
var export_button: Button = %ExportButton
var logger_output_label: Button = %LoggerOutputLabel

var _line_limit: int = 1000

#endregion

#region Lifecycle

#endregion

#region Signals

func _on_add_button_pressed():
	pass # Replace with function body.

func _on_remove_button_pressed():
	pass # Replace with function body.

func _on_filter_item_list_item_selected(index):
	pass # Replace with function body.

func _on_start_stop_button_pressed():
	pass # Replace with function body.

func _on_clear_button_pressed():
	logger_output_label.text = ""

func _on_line_limit_edit_text_changed(new_text: String):
	var value = int(new_text)
	if value != null:
		_line_limit = value

func _on_export_button_pressed():
	pass # Replace with function body.

#endregion

#region Methods

#endregion
