extends Node

class_name AI

var _ai_architecture: AIArchitecture
var _ai_allocation: AIAllocation
var _ai_campaign: AICampaign
var _ai_troop: AITroop

func _init():
	_ai_architecture = AIArchitecture.new(self)
	_ai_campaign = AICampaign.new(self)
	_ai_allocation = AIAllocation.new(self)
	_ai_troop = AITroop.new(self)

func run_faction(faction: Faction, scenario):
	for sect in faction.get_sections():
		run_section(faction, sect, scenario)
		
func run_section(faction: Faction, section: Section, scenario):
	if not faction.player_controlled:
		_ai_allocation._allocate_person(section)
	for arch in section.get_architectures():
		if not faction.player_controlled or arch.auto_task:
			_ai_architecture._assign_task(arch, scenario)
	for arch in section.get_architectures():
		if not faction.player_controlled:
			_ai_campaign.defence(arch, scenario)
	for troop in section.get_troops():
		if not faction.player_controlled:
			_ai_troop.run_troop(troop, scenario)

func military_kind_power(military_kind: MilitaryKind) -> float:
	var offence_factor = military_kind.offence * (sqrt(military_kind.range_max) - sqrt(military_kind.range_min - 1))
	var defence_factor = military_kind.defence
	return offence_factor + defence_factor

func _frontline_connected_archs(arch: Architecture) -> Array:
	var archs = []
	for arch_id in arch.adjacent_archs:
		if arch.scenario.architectures[arch_id].get_belonged_faction().is_enemy_to(arch.get_belonged_faction()):
			archs.append(arch.scenario.architectures[arch_id])
	return archs
