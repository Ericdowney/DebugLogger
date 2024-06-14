@tool
extends EditorPlugin

var DebugLoggerDock = preload("res://addons/DebugLogger/Dock/DebugLoggerDock.tscn")

const DOCK_TITLE = "Logger"
const DEBUG_LOGGER = "DebugLogger"
const DEBUG_LOGGER_PATH = "res://addons/DebugLogger/Globals/DebugLogger.gd"

var dock

#region Properties

#endregion

#region Lifecycle

func _enter_tree():
	dock = DebugLoggerDock.instantiate()
	add_control_to_bottom_panel(dock, DOCK_TITLE)
	
	if not ProjectSettings.has_setting("autoload/" + DEBUG_LOGGER):
		add_autoload_singleton(DEBUG_LOGGER, DEBUG_LOGGER_PATH)

func _exit_tree():
	remove_control_from_bottom_panel(dock)
	remove_autoload_singleton(DEBUG_LOGGER)
	
	dock.free()

#endregion

#region Methods

#endregion
