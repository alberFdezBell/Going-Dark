extends Control

# Rutas a las escenas que se cargarán en el futuro
const GAME_SCENE_PATH = "res://scenes/game/game_level.tscn"
const SETTINGS_SCENE_PATH = "res://scenes/settings_menu/settings_menu.tscn"

@onready var continue_button: Button = $MarginContainer/VBoxContainer/ButtonsContainer/ContinueButton
@onready var message_label: Label = $MessageLabel

# CAMBIADO: 'def' por 'func'
func _ready() -> void:
	# Ocultar el mensaje de aviso al iniciar
	message_label.visible = false
	
	# Opcional: Podrías desactivar visualmente el botón de continuar si no hay partida,
	# descomenta la siguiente línea si prefieres bloquearlo en lugar de mostrar un mensaje:
	# if not SaveManager.existe_partida(): continue_button.disabled = true

# --- Conexión de Señales (Eventos de los botones) ---

# CAMBIADO: 'def' por 'func'
func _on_new_game_button_pressed() -> void:
	# 1. Inicializamos los datos desde cero
	SaveManager.nueva_partida()
	# 2. Cambiamos a la escena del juego
	_cambiar_escena(GAME_SCENE_PATH)

# CAMBIADO: 'def' por 'func'
func _on_continue_button_pressed() -> void:
	# Intentamos cargar la partida usando el Autoload
	if SaveManager.cargar_partida():
		_cambiar_escena(GAME_SCENE_PATH)
	else:
		# Si no hay datos, mostramos el mensaje de advertencia de forma temporal
		_mostrar_mensaje("¡No hay ninguna partida guardada disponible!")

# CAMBIADO: 'def' por 'func'
func _on_settings_button_pressed() -> void:
	# Abre la escena de opciones de forma directa (o podrías instanciarla encima)
	_cambiar_escena(SETTINGS_SCENE_PATH)

# CAMBIADO: 'def' por 'func'
func _on_exit_button_pressed() -> void:
	# Cierra el árbol de escenas del juego de forma limpia
	get_tree().quit()

# --- Funciones Utilitarias Helper ---

# CAMBIADO: 'def' por 'func'
func _cambiar_escena(ruta_escena: String):
	if ResourceLoader.exists(ruta_escena):
		get_tree().change_scene_to_file(ruta_escena)
	else:
		_mostrar_mensaje("Error: La escena destino no existe en la ruta.")
		print("Error: No se encontró la escena en: ", ruta_escena)

# CAMBIADO: 'def' por 'func'
func _mostrar_mensaje(texto: String):
	message_label.text = texto
	message_label.visible = true
	
	# Creamos un Timer dinámico para ocultar el mensaje tras 3 segundos
	await get_tree().create_timer(3.0).timeout
	message_label.visible = false
