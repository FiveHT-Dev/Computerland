class_name DialogueAdvanceConnectionVar
extends DialogueAdvanceConnectionComparison

@export_category("Variable to check")
@export var var_name : String
@export var var_comparison : String

func _on_evaluate() -> bool:
	if var_name in node_to_check:
		var var_to_check = node_to_check.get(var_name)
		var comparison_var
		if var_comparison.is_valid_int():
			comparison_var = var_comparison.to_int()
		elif var_comparison.is_valid_float():
			comparison_var = var_comparison.to_float()
		elif var_comparison == "true" || var_comparison == "TRUE":
			comparison_var = true
		elif var_comparison == "false" || var_comparison == "FALSE":
			comparison_var = false
		elif var_comparison == "null" || var_comparison == "NULL":
			comparison_var = null
		return compare(var_to_check, comparison_var)
	return false
