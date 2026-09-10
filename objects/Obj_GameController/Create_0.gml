global.vida = 100;
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
