global.vida_maxima = 100;
global.vida = global.vida_maxima;
global.dinero = 50;
global.oleada = 1;
alarm[0] = 60; // Spawner timer
estado_colocacion = 0;
torre_seleccionada = noone;
global.estado_juego = "jugando";

waves = [];

if (room == Rm_Ciudad) {
    waves[0] = [ {obj: Obj_EnemigoPez, count: 5, delay: 60} ];
    waves[1] = [ {obj: Obj_EnemigoPez, count: 10, delay: 45} ];
    waves[2] = [ {obj: Obj_EnemigoPez, count: 15, delay: 30} ];
} else if (room == Rm_Bosque) {
    waves[0] = [ {obj: Obj_EnemigoPez, count: 5, delay: 45}, {obj: Obj_EnemigoPezPiedra, count: 2, delay: 60} ];
    waves[1] = [ {obj: Obj_EnemigoPez, count: 10, delay: 40}, {obj: Obj_EnemigoPulpo, count: 3, delay: 50} ];
    waves[2] = [ {obj: Obj_EnemigoPez, count: 10, delay: 30}, {obj: Obj_EnemigoPezPiedra, count: 5, delay: 40}, {obj: Obj_EnemigoPulpo, count: 5, delay: 40} ];
} else if (room == Rm_Mar) {
    waves[0] = [ {obj: Obj_EnemigoPez, count: 10, delay: 30}, {obj: Obj_EnemigoPezPiedra, count: 5, delay: 40} ];
    waves[1] = [ {obj: Obj_EnemigoPulpo, count: 10, delay: 40} ];
    waves[2] = [ {obj: Obj_EnemigoPezPiedra, count: 10, delay: 30}, {obj: Obj_EnemigoPulpo, count: 10, delay: 30} ];
    waves[3] = [ {obj: Obj_EnemigoPez, count: 20, delay: 15} ];
    waves[4] = [ {obj: Obj_EnemigoPez, count: 15, delay: 20}, {obj: Obj_EnemigoPezPiedra, count: 15, delay: 20}, {obj: Obj_EnemigoPulpo, count: 15, delay: 20} ];
} else {
    waves[0] = [ {obj: Obj_EnemigoPez, count: 5, delay: 60} ];
}

global.oleada_maxima = array_length(waves);

current_wave_index = 0;
current_subwave_index = 0;
enemies_spawned_in_subwave = 0;
menu_tienda_abierto = false;
pause_sprite = -1;
estado_oleada = "aviso";
tiempo_aviso = 180;

// Valores por defecto si se entra al nivel sin pasar por el menu (ej. al probar una room)
if (!variable_global_exists("vol_musica")) global.vol_musica = 1.0;
if (!variable_global_exists("vol_sfx")) global.vol_sfx = 1.0;
if (!variable_global_exists("fullscreen")) global.fullscreen = false;

audio_stop_all();
musica_actual = audio_play_sound(Snd_MusicaDeFondo, 1, true, global.vol_musica);

en_ajustes = false;

// ================= Validacion de colocacion de torres =================
path_nivel = Path_Enemy;
if (room == Rm_Ciudad) path_nivel = Path_Ciudad;
else if (room == Rm_Bosque) path_nivel = Path_Bosque;
else if (room == Rm_Mar) path_nivel = Path_Mar;

radio_torre = 32;          // Mitad del sprite de torre (64x64)
margen_camino = 48;        // Distancia minima entre el centro de la torre y el camino
distancia_min_torres = 56; // Distancia minima entre centros de torres
motivo_invalido = "";      // "" = posicion valida; si no, texto que se muestra al jugador

// Zonas de la interfaz donde no se puede colocar [x1, y1, x2, y2] (coordenadas GUI)
zonas_ui = [
    [0, 0, 400, 60],          // Barra de vida y dinero
    [560, 0, 806, 50],        // Contador de oleadas
    [1250, 10, 1350, 50],     // Boton de pausa
    [10, 650, 110, 750],      // Boton comprar
    [1216, 700, 1356, 750]    // Boton cancelar
];

// Distancia minima de un punto a los segmentos del path del nivel
distancia_a_camino = function(_x, _y) {
    var _min = infinity;
    var _n = path_get_number(path_nivel);
    for (var i = 0; i < _n - 1; i++) {
        var _x1 = path_get_point_x(path_nivel, i);
        var _y1 = path_get_point_y(path_nivel, i);
        var _dx = path_get_point_x(path_nivel, i + 1) - _x1;
        var _dy = path_get_point_y(path_nivel, i + 1) - _y1;
        var _len2 = _dx * _dx + _dy * _dy;
        var _t = (_len2 > 0) ? clamp(((_x - _x1) * _dx + (_y - _y1) * _dy) / _len2, 0, 1) : 0;
        _min = min(_min, point_distance(_x, _y, _x1 + _t * _dx, _y1 + _t * _dy));
    }
    return _min;
}

// Devuelve "" si se puede colocar una torre en (_x, _y), o el motivo por el que no
motivo_colocacion_invalida = function(_x, _y, _gx, _gy, _costo) {
    if (_x < radio_torre || _y < radio_torre || _x > room_width - radio_torre || _y > room_height - radio_torre) {
        return "Fuera del mapa";
    }
    for (var i = 0; i < array_length(zonas_ui); i++) {
        var _z = zonas_ui[i];
        if (_gx > _z[0] - radio_torre && _gx < _z[2] + radio_torre && _gy > _z[1] - radio_torre && _gy < _z[3] + radio_torre) {
            return "Sobre la interfaz";
        }
    }
    if (distancia_a_camino(_x, _y) < margen_camino) {
        return "Sobre el camino";
    }
    var _cerca = false;
    var _dist_min = distancia_min_torres;
    with (Obj_TowerParent) {
        if (point_distance(x, y, _x, _y) < _dist_min) { _cerca = true; break; }
    }
    if (_cerca) return "Muy cerca de otra torre";
    if (global.dinero < _costo) return "Dinero insuficiente";
    return "";
}
