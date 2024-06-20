class_name DebugLoggerDebugger extends EditorDebuggerPlugin

var DebugLoggerDock = preload("res://addons/DebugLogger/Dock/DebugLoggerDock.tscn")

var debugger_panel

#region Properties

var _log: DebugLog

#endregion

#region Lifecycle

#endregion

#region Signals

#endregion

#region Methods

func _has_capture(prefix) -> bool:
	return prefix == "debug_logger"

func _capture(message, data, session_id) -> bool:
	if message == "debug_logger:log_message":
		if data.size() == 1:
			var value = data[0]
			debugger_panel.log_message(value)
			return true
	elif message == "debug_logger:log_error":
		if data.size() == 1:
			var value = data[0]
			debugger_panel.log_error(value)
			return true
	elif message == "debug_logger:delimiter_updated":
		if data.size() == 1:
			var value = data[0]
			debugger_panel.update_delimiter(value)
			return true
	
	return false

func _setup_session(session_id):
	debugger_panel = DebugLoggerDock.instantiate()
	debugger_panel.name = "Logger"
	
	var session = get_session(session_id)
	session.started.connect(
		func ():
			debugger_panel.enable()
	)
	session.stopped.connect(
		func ():
			debugger_panel.stop()
			debugger_panel.disable()
	)
	
	session.add_session_tab(debugger_panel)

func _get_debug_log() -> DebugLog:
	if _log == null:
		_log = DebugLog.new()
	return _log

#endregion
