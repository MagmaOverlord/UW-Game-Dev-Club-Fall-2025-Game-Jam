extends Object
class_name PathGenerator

var _grid_length : int = 16
var _grid_height : int = 9

var _path : Array[Vector2i]

func _init(length:int, height:int):
	_grid_length = length
	_grid_height = height

func generate_path() -> Array[Vector2i]:
	_path.clear()
	
	var x = 0
	var y = int(_grid_height / 2)
	
	while x < _grid_length:
		#potential improvement: allow the path to go left as well
		if not _path.has(Vector2i(x, y)):
			_path.append(Vector2i(x, y))
		var choice = randi_range(0, 2) #0 right, 1 up, 2 down
		if choice == 0 or x % 2 == 0 or x == _grid_length - 1:
			x += 1
		elif choice == 1 and y < _grid_height - 1 and not _path.has(Vector2i(x, y + 1)):
			y += 1
		elif choice == 2 and y > 0 and not _path.has(Vector2i(x, y - 1)):
			y -= 1
		
	return _path

func get_tile_score(tile : Vector2i) -> int:
	var x : int = tile.x
	var y  : int = tile.y
	var score  : int = 0
	score += 1 if _path.has(Vector2i(x, y - 1)) else 0
	score += 2 if _path.has(Vector2i(x + 1, y)) else 0
	score += 4 if _path.has(Vector2i(x, y + 1)) else 0
	score += 8 if _path.has(Vector2i(x - 1, y)) else 0
	
	return score

func get_path() -> Array[Vector2i]:
	return _path
