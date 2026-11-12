display_set_gui_size(1366, 768);
game_set_speed(60, gamespeed_fps);

// Control de espera inicial para no saltar la pantalla con un clic previo
tiempo_espera = 25; // Aprox. 0.4 segundos
alpha_texto = 0;
alpha_dir = 1;

if (!variable_global_exists("historia_sprite")) {
    global.historia_sprite = Spr_ComienzoDeHistoria;
}

if (!variable_global_exists("historia_siguiente_room")) {
    global.historia_siguiente_room = Rm_Ciudad;
}
