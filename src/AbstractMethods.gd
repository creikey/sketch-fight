extends Node

class_name AbstractMethods

static func unimplemented(method_string: String, class_string: String):
	printerr(str("Method ", method_string, " not implemented on class ", class_string, "!"))
	