class_name DialogueAdvanceConnectionDictKey
extends DialogueAdvanceConnectionComparison

@export_category("Dictionary key to check")
@export var dict_name : String
@export var dict_key : String
@export var dict_comparison : String

func _on_evaluate() -> bool:
	if dict_name in node_to_check:
		var dict = node_to_check.get(dict_name)
		if dict is Dictionary && dict.has(dict_key):
			var comparison_var
			if dict_comparison.is_valid_int():
				comparison_var = dict_comparison.to_int()
			elif dict_comparison.is_valid_float():
				comparison_var = dict_comparison.to_float()
			elif dict_comparison == "true" || dict_comparison == "TRUE":
				comparison_var = true
			elif dict_comparison == "false" || dict_comparison == "FALSE":
				comparison_var = false
			elif dict_comparison == "null" || dict_comparison == "NULL":
				comparison_var = null
			return compare(dict[dict_key], comparison_var)
	return false
