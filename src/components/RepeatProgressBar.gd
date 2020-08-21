tool
extends Container

export var value = 0 setget _set_value
export(Texture) var texture setget _set_texture


func _set_texture(new_texture):
	texture = new_texture
	
	for i in get_children():
		i.texture = texture
		

func _set_value(new_value):
	if value == new_value:
		return
	
	if new_value < 0:
		new_value = 0
	
	if new_value > value:
		for i in range(value, new_value):
			var textRect = TextureRect.new()
			textRect.texture = texture
			add_child(textRect)
	elif new_value < value:
		for i in range(value, new_value, -1):
			remove_child(get_child(i - 1))

	value = new_value
