@tool
extends EditorPlugin

var DebugLoggerDebugger = preload("res://addons/DebugLogger/DebugLoggerDebugger.gd")

const DOCK_TITLE = "Logger"
const DEBUG_LOGGER = "DebugLogger"
const DEBUG_LOGGER_PATH = "res://addons/DebugLogger/Globals/DebugLogger.gd"

var debugger: EditorDebuggerPlugin

#region Properties

#endregion

#region Lifecycle

func _enter_tree():
	debugger = DebugLoggerDebugger.new()
	add_debugger_plugin(debugger)
	
	if not ProjectSettings.has_setting("autoload/" + DEBUG_LOGGER):
		add_autoload_singleton(DEBUG_LOGGER, DEBUG_LOGGER_PATH)

func _exit_tree():
	remove_debugger_plugin(debugger)
	remove_autoload_singleton(DEBUG_LOGGER)

#endregion

#region Methods

#endregion
