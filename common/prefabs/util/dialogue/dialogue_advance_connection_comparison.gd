class_name DialogueAdvanceConnectionComparison
extends DialogueAdvanceConnection

enum ComparisonType{
	LESS,
	GREATER,
	LEQUAL,
	GEQUAL,
	EQUAL,
	NONE
}

@export var node_to_check : Node
@export var comparison_type : ComparisonType

func evaluate() -> bool:
	if comparison_type != ComparisonType.NONE || node_to_check != null:
		return _on_evaluate()
	return true

func _on_evaluate() -> bool:
	return true

func compare(a, b) -> bool:
	match comparison_type:
		ComparisonType.LESS:
			return a < b
		ComparisonType.GREATER:
			return a > b
		ComparisonType.LEQUAL:
			return a <= b
		ComparisonType.GEQUAL:
			return a >= b
		ComparisonType.EQUAL:
			return a == b
	return false
