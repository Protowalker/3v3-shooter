extends Object
class_name EventListener

var listeners: Dictionary = {} 

func _init():
	pass
	
	
func subscribe(node: Node, callable: Callable) -> void:
	listeners[node.get_instance_id()] = callable;
	node.tree_exited.connect(_on_listener_exits_tree)


func _on_listener_exits_tree(node: Node) -> void:
	unsubscribe(node)

func unsubscribe(node: Node) -> void:
	listeners.erase(node.get_instance_id())
	node.tree_exited.disconnect(_on_listener_exits_tree)
	
func emit(value: Variant) -> void:
	for callable in listeners.values():
		callable.call(value)
