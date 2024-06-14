extends Node

enum LogType {
	MESSAGE,
	WARNING,
	ERROR
}

const DELIMITER = " || "
const LOGGER_FEATURE = "log_enabled"

class LogExport extends Resource:
	var logs: Array[String]
	
	func _init(logs: Array[String]):
		self.logs = logs

#region Properties

var filters: Dictionary = {
	"exclude_files": [],
	"exclude_functions": [],
	"exclude_messages": []
}
var override_excludes_for_errors: bool = false
var export_path: String = ""
var include_source_caller: bool = false
var buffer_size: int = 100

var _log_buffer: Array[String] = []

var _is_enabled: bool :
	get: return OS.has_feature(LOGGER_FEATURE)

#endregion

#region Lifecycle



#endregion

#region Signals



#endregion

#region  Methods

func log(message: String, type: LogType, bbColor: String = "", metadata: Dictionary = {}):
	match type:
		LogType.MESSAGE:
			log_message(message, bbColor, metadata)
		LogType.WARNING:
			log_warning(message, metadata)
		LogType.ERROR:
			log_error(message, metadata)

func log_message(message: String, bbColor: String = "", metadata: Dictionary = {}):
	var caller = _get_call_stack_source()
	if _should_exclude_file(caller.get("source")):
		return
	if _should_exclude_function(caller.get("function")):
		return
	if _should_exclude_message(message):
		return
	
	if include_source_caller:
		metadata = add_source_caller_to_metadata(metadata, caller)
	
	var time = Time.get_datetime_string_from_system()
	if bbColor == "":
		print("", time, DELIMITER, _build_string(message, metadata))
	else:
		print_rich(_color_string(bbColor), time, DELIMITER, _build_string(message, metadata), _color_string_end())
	
	_append_to_buffer("{time} {delimiter} {message}".format({ "time": time, "delimiter": DELIMITER, "message": _build_string(message, metadata) }))

func log_warning(message: String, metadata: Dictionary = {}):
	var caller = _get_call_stack_source()
	if _should_exclude_file(caller.get("source")):
		return
	if _should_exclude_function(caller.get("function")):
		return
	if _should_exclude_message(message):
		return
	
	if include_source_caller:
		metadata = add_source_caller_to_metadata(metadata, caller)
	
	var time = Time.get_datetime_string_from_system()
	print_rich(_color_string("Gold"), time, DELIMITER, " WARNING: ", _color_string_end(), _build_string(message, metadata))
	push_warning(message, metadata)
	_append_to_buffer("{time} {delimiter} {message}".format({ "time": time, "delimiter": DELIMITER, "message": _build_string(message, metadata) }))

func log_error(message: String, metadata: Dictionary = {}):
	var caller = _get_call_stack_source()
	if not override_excludes_for_errors:
		if _should_exclude_file(caller.get("source")):
			return
		if _should_exclude_function(caller.get("function")):
			return
		if _should_exclude_message(message):
			return
	
	if include_source_caller:
		metadata = add_source_caller_to_metadata(metadata, caller)
	
	var time = Time.get_datetime_string_from_system()
	printerr(time, DELIMITER, _build_string(message, metadata))
	push_error(message, metadata)
	_append_to_buffer("{time} {delimiter} {message}".format({ "time": time, "delimiter": DELIMITER, "message": _build_string(message, metadata) }))

func export_logs(path: String):
	var export = LogExport.new(_log_buffer)
	ResourceSaver.save(export, path)

func _build_string(message: String, metadata: Dictionary) -> String:
	if not metadata.is_empty():
		return message + DELIMITER + "{m}".format({ "m": metadata })
	return message

func _color_string(bbColor: String, metadata: Dictionary = {}) -> String:
	return "[color=" + bbColor + "]"

func _color_string_end() -> String:
	return "[/color]"

func _should_exclude_file(source_file: String) -> bool:
	return filters.get("exclude_files").has(source_file)

func _should_exclude_function(function: String) -> bool:
	return filters.get("exclude_functions").has(function)

func _should_exclude_message(message: String) -> bool:
	for excludeRegex in filters.get("exclude_messages"):
		var regex = RegEx.new()
		var error = regex.compile(excludeRegex)
		if error == OK:
			return regex.search(message) != null
	
	return false

func add_source_caller_to_metadata(metadata: Dictionary, caller: Dictionary) -> Dictionary:
	var new_metadata = metadata
	new_metadata["source"] = caller.get("source")
	new_metadata["function"] = caller.get("function")
	new_metadata["line"] = caller.get("line")
	return new_metadata

func _get_call_stack_source() -> Dictionary:
	var call_stack = get_stack()
	if call_stack != null and call_stack.size() > 2:
		return call_stack[2]
	
	return {}

func _append_to_buffer(value: String):
	_log_buffer.append(value)
	if _log_buffer.size() > buffer_size:
		_log_buffer.pop_at(0)

#endregion
