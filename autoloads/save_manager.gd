extends Node

const SAVE_PATH = "user://savegame.save"

# Variables globales que representarán los datos del juego
var datos_partida = {
	"nivel_actual": 1,
	"puntuacion": 0,
	"posicion_jugador": Vector2.ZERO
}

# CORREGIDO: 'def' cambiado por 'func'
func existe_partida() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func nueva_partida():
	print("Inicializando nueva partida...")
	# CORREGIDO: Se eliminó 'var' para modificar la variable global real
	datos_partida = {
		"nivel_actual": 1,
		"puntuacion": 0,
		"posicion_jugador": Vector2.ZERO
	}
	guardar_partida()

func guardar_partida():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		# Clonamos el diccionario para no alterar el original durante la conversión
		var datos_a_guardar = datos_partida.duplicate()
		# Convertimos el Vector2 a un formato amigable para JSON (Diccionario)
		datos_a_guardar["posicion_jugador"] = {
			"x": datos_partida["posicion_jugador"].x,
			"y": datos_partida["posicion_jugador"].y
		}
		
		var json_string = JSON.stringify(datos_a_guardar)
		file.store_line(json_string)
		file.close()
		print("Partida guardada con éxito.")

func cargar_partida() -> bool:
	if not existe_partida():
		print("No hay datos para cargar.")
		return false
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_line()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(json_string)
		if error == OK:
			var datos_cargados = json.get_data()
			
			# CORREGIDO: Reconstruimos el Vector2 desde el JSON
			if datos_cargados.has("posicion_jugador") and datos_cargados["posicion_jugador"] is Dictionary:
				var pos = datos_cargados["posicion_jugador"]
				datos_cargados["posicion_jugador"] = Vector2(pos.get("x", 0), pos.get("y", 0))
			
			datos_partida = datos_cargados
			print("Partida cargada con éxito: ", datos_partida)
			return true
	return false
