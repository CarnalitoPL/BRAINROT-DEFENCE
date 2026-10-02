if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    if (!en_ajustes) {
        if (nivel_guardado != "") {
            // Clic en Continuar
            if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 380 && my < 460) {
                var rm = asset_get_index(nivel_guardado);
                if (rm != -1) room_goto(rm);
                else room_goto(Rm_Ciudad);
            }
            // Clic en Nueva Partida
            else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 480 && my < 560) {
                // Solo se borra el progreso; los ajustes [Config] se conservan
                ini_open("save.ini");
                ini_section_delete("Progreso");
                ini_close();
                room_goto(Rm_Ciudad);
            }
        } else {
            // Clic en Jugar
            if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 400 && my < 480) {
                ini_open("save.ini");
                ini_section_delete("Progreso");
                ini_close();
                room_goto(Rm_Ciudad);
            }
        }
        
        // Clic en Ajustes
        if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 580 && my < 660) {
            en_ajustes = true;
        }
    } else {
        // Logica de Ajustes
        // Musica [-]
        if (mx > 1366/2 - 150 && mx < 1366/2 - 100 && my > 335 && my < 385) {
            global.vol_musica = clamp(global.vol_musica - 0.1, 0, 1);
            if (audio_is_playing(musica_actual)) audio_sound_gain(musica_actual, global.vol_musica, 0);
        }
        // Musica [+]
        else if (mx > 1366/2 + 100 && mx < 1366/2 + 150 && my > 335 && my < 385) {
            global.vol_musica = clamp(global.vol_musica + 0.1, 0, 1);
            if (audio_is_playing(musica_actual)) audio_sound_gain(musica_actual, global.vol_musica, 0);
        }
        // SFX [-]
        else if (mx > 1366/2 - 150 && mx < 1366/2 - 100 && my > 415 && my < 465) {
            global.vol_sfx = clamp(global.vol_sfx - 0.1, 0, 1);
        }
        // SFX [+]
        else if (mx > 1366/2 + 100 && mx < 1366/2 + 150 && my > 415 && my < 465) {
            global.vol_sfx = clamp(global.vol_sfx + 0.1, 0, 1);
        }
        // Pantalla Completa
        else if (mx > 1366/2 - 200 && mx < 1366/2 + 200 && my > 500 && my < 550) {
            global.fullscreen = !global.fullscreen;
            window_set_fullscreen(global.fullscreen);
        }
        // Volver
        else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 600 && my < 650) {
            ini_open("save.ini");
            ini_write_real("Config", "Musica", global.vol_musica);
            ini_write_real("Config", "SFX", global.vol_sfx);
            ini_write_real("Config", "Fullscreen", global.fullscreen);
            ini_close();
            en_ajustes = false;
        }
    }
}
