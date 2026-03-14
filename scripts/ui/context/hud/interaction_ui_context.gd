extends UIContext

var view: InteractionView


func _on_enter_context(v: Node) -> void:
	super._on_enter_context(view)

	view = v as InteractionView

	var interactions := World.get_player().interactions
	interactions.target_changed.connect(_on_target_changed)

	_on_target_changed(interactions.get_current_target())


func _try_handle_input(event: InputEvent) -> bool:
	var interactions := World.get_player().interactions

	if event.is_action_pressed("interact"):
		if interactions.get_current_target() != null:
			interactions.get_current_target().interact(World.get_player())
			return true
	return false


func _on_leave_context() -> void:
	var interactions := World.get_player().interactions
	interactions.target_changed.disconnect(_on_target_changed)

	super._on_leave_context()


func _on_target_changed(target: Interactable3D) -> void:
	if target:
		view.show_interaction(target.interaction_text, target.interaction_icon)
	else:
		view.hide_interaction()
