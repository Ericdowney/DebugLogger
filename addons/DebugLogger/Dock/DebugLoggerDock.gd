@tool
class_name DebugLoggerDock extends Control

const FilterItemScene = preload("res://addons/DebugLogger/Dock/FilterItem.tscn")

signal logger_started
signal logger_stopped
signal delimiter_updated(value: String)

#region Properties

@export var start_icon: Texture2D
@export var stop_icon: Texture2D

@onready var add_button: Button = %AddButton
@onready var remove_button: Button = %RemoveButton
@onready var filter_list: VBoxContainer = %FilterList
@onready var delimiter_edit: LineEdit = %DelimiterEdit
@onready var start_stop_button: Button = %StartStopButton
@onready var clear_button: Button = %ClearButton
@onready var line_limit_edit: LineEdit = %LineLimitEdit
@onready var export_button: Button = %ExportButton
@onready var logger_output_label: RichTextLabel = %LoggerOutputLabel
@onready var file_dialog: FileDialog = %FileDialog

var is_started: bool = false
var is_disabled: bool = true
var log: DebugLog

var _line_limit: int = 1000
var _filter: Array[String] = []
var _delimiter: String = ""
var _old_delimiter: String = "||"

#endregion

#region Lifecycle

func _ready():
	_update_action_button()

#endregion

#region Signals

func _on_add_button_pressed():
	remove_button.disabled = false
	var new_filter: FilterItem = FilterItemScene.instantiate()
	filter_list.add_child(new_filter)
	new_filter.index = _filter.size()
	new_filter.filter_changed.connect(_on_filter_item_filter_item_changed)
	new_filter.remove_filter.connect(_on_filter_item_remove_filter)
	_filter.append("")

func _on_remove_button_pressed():
	if _filter.size() > 0:
		_filter.pop_back()
		var list_children = filter_list.get_children()
		filter_list.remove_child(list_children[list_children.size() - 1])
		if _filter.size() == 0:
			remove_button.disabled = true

func _on_start_stop_button_pressed():
	if is_started:
		stop()
	else:
		start()

func _on_clear_button_pressed():
	logger_output_label.clear()

func _on_line_limit_edit_text_changed(new_text: String):
	var value = int(new_text)
	if value != null:
		_line_limit = value

func _on_export_button_pressed():
	if log != null:
		file_dialog.show()

func _on_file_dialog_confirmed():
	var file_value = "%s\n".repeat(log.logs.size()).strip_edges() % log.logs
	var file = FileAccess.open(file_dialog.current_path, FileAccess.WRITE)
	file.store_string(file_value)
	file.close()

func _on_filter_item_filter_item_changed(item: FilterItem, new_filter: String, is_regex: bool):
	pass

func _on_filter_item_remove_filter(item: FilterItem, index: int):
	if get_children().size() > index: 
		get_children().remove_at(index)

func _on_delimiter_edit_text_changed(new_text: String):
	delimiter_updated.emit(new_text)

#endregion

#region Methods

func enable():
	is_disabled = false
	_update_action_button()

func disable():
	is_disabled = true
	_update_action_button()
	
func start():
	if not is_started:
		is_started = true
		logger_started.emit()
		logger_output_label.append_text("[color=#B0B0B0]Logger Started...[/color]")
		logger_output_label.newline()
		logger_output_label.newline()
	
	_update_action_button()

func stop():
	if is_started:
		is_started = false
		logger_stopped.emit()
		logger_output_label.newline()
		logger_output_label.append_text("[color=#B0B0B0]Logger Stopped[/color]")
		logger_output_label.newline()
		logger_output_label.newline()
	
	_update_action_button()

func log_message(value: String):
	if is_started:
		_append_to_log(value)
		logger_output_label.append_text(value)
		logger_output_label.newline()

func log_error(value: String):
	if is_started:
		_append_to_log(value)
		logger_output_label.append_text(value)
		logger_output_label.newline()

func update_delimiter(new_value: String):
	_old_delimiter = _delimiter
	_delimiter = new_value
	logger_output_label.text.replace(_old_delimiter, _delimiter)

func _update_filter_list():
	pass

func _append_to_log(value: String):
	if log == null:
		log = DebugLog.new()
	
	log.append(value)

func _update_action_button():
	if is_started:
		start_stop_button.icon = stop_icon
		start_stop_button.text = "Stop"
		start_stop_button.modulate = Color("#ff3b30")
	else:
		start_stop_button.icon = start_icon
		start_stop_button.text = "Start"
		start_stop_button.modulate = Color.WHITE
	
	start_stop_button.disabled = is_disabled

#endregion
