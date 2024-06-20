class_name Demo1 extends Node2D

@onready var test_button: Button = %TestButton

func _ready():
	test_button.button_down.connect(_on_test_button_button_down)
	test_button.button_up.connect(_on_test_button_button_up)

func _on_area_2d_area_entered(area):
	DebugLogger.log_message("_on_area_2d_area_entered", { "area": area })

func _on_area_2d_body_entered(body):
	DebugLogger.log_message("_on_area_2d_body_entered", { "body": body })

func _on_area_2d_body_exited(body):
	DebugLogger.log_message("_on_area_2d_body_exited")

func _on_area_2d_area_exited(area):
	DebugLogger.log_message("_on_area_2d_area_exited")

func _on_test_button_pressed():
	DebugLogger.log_message("_on_test_button_pressed")

func _on_test_button_button_down():
	DebugLogger.log_message("_on_test_button_button_down")

func _on_test_button_button_up():
	DebugLogger.log_message("_on_test_button_button_up")
