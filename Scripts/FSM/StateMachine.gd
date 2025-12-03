class_name StateMachine extends Node

var current_state
var npc

func init(initial_state, npc_ref):
	npc = npc_ref
	current_state = initial_state
	current_state.npc = npc
	current_state.state_machine = self
	current_state.enter(null)

func change_state(new_state):
	var old = current_state
	current_state = new_state
	current_state.npc = npc
	current_state.state_machine = self
	current_state.enter(old)
