extends Node
class_name GameplayEffect

enum EffectActivationEvent {
	AttributeChanged,
	ImmediateActivation
}


export(EffectActivationEvent) var activation_trigger = EffectActivationEvent.ImmediateActivation


func _ready():
	if not Engine.editor_hint:
		setup_effect()
		if should_activate(EffectActivationEvent.ImmediateActivation):
			apply_effect()

			if should_deactivate():
				queue_free()


func setup_effect() -> void:
	connect_to_parent_signal()


func apply_effect() -> void:
	pass


func connect_to_parent_signal() -> void:
	var parent = get_parent()

	if parent.has_signal("attribute_changed"):
		parent.connect("attribute_changed", self, "on_attribute_changed")


func get_parent_attribute_map():
	return get_parent()


func on_attribute_changed(attribute: GameplayAttribute) -> void:
	if should_activate(EffectActivationEvent.AttributeChanged):
		apply_effect();

		if should_deactivate():
			queue_free()


func should_activate(activation_event: int) -> bool:
	return activation_trigger == activation_event


func should_deactivate() -> bool:
	return true


func _get_configuration_warning():
	if get_parent().has_signal("attribute_changed"):
		return ""

	return "GameplayAttribute must be a direct child of a GameplayAttributeMap node."

