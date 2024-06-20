class_name DebugLog extends Resource

#region Properties

@export var logs: Array[String] = []

#endregion

#region Methods

### Resets the logs to specified string split on newlines
func set_logs(logs: Array[String]):
	self.logs = []
	self.logs = logs

### Resets the logs to specified string split on newlines
func set_logs_from_string(full_log: String):
	self.logs = []
	self.logs.assign(full_log.split("\n"))

### Adds the specified line to the logs
func append(log_line: String):
	self.logs.append(log_line)

#endregion
