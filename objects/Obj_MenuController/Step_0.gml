if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    if (!en_ajustes) {
        if (nivel_guardado != "") {
            // Clic en Continuar
            if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 330 && my < 395) {
                var rm = asset_get_index(nivel_guardado);
                if (rm != -1) {
                    room_goto(rm);
                } else {
                    global.historia_sprite = Spr_ComienzoDeHistoria;
                    global.historia_siguiente_room = Rm_Ciudad;
                    room_goto(Rm_Historia);
                }
            }
            // Clic en Nueva Partida
            else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 410 && my < 475) {
                // Solo se borra el progreso; los ajustes [Config] se conservan
                ini_open("save.ini");
                ini_section_delete("Progreso");
                ini_close();
                global.historia_sprite = Spr_ComienzoDeHistoria;
                global.historia_siguiente_room = Rm_Ciudad;
                room_goto(Rm_Historia);
            }
            // Clic en Ajustes
            else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 490 && my < 555) {
                en_ajustes = true;
            }
            // Clic en Salir
            else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 570 && my < 635) {
                game_end();
            }
        } else {
            // Clic en Jugar
            if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 370 && my < 440) {
                ini_open("save.ini");
                ini_section_delete("Progreso");
                ini_close();
                global.historia_sprite = Spr_ComienzoDeHistoria;
                global.historia_siguiente_room = Rm_Ciudad;
                room_goto(Rm_Historia);
            }
            // Clic en Ajustes
            else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 460 && my < 530) {
                en_ajustes = true;
            }
            // Clic en Salir
            else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 550 && my < 620) {
                game_end();
            }
        }
    } else {
        // Logica de Ajustes
        // Musica [-]
        if (mx > 1366/2 - 150 && mx < 1366/2 - 100 && my > 250 && my < 295) {
            global.vol_musica = clamp(global.vol_musica - 0.1, 0, 1);
            if (audio_is_playing(musica_actual)) audio_sound_gain(musica_actual, global.vol_musica, 0);
        }
        // Musica [+]
        else if (mx > 1366/2 + 100 && mx < 1366/2 + 150 && my > 250 && my < 295) {
            global.vol_musica = clamp(global.vol_musica + 0.1, 0, 1);
            if (audio_is_playing(musica_actual)) audio_sound_gain(musica_actual, global.vol_musica, 0);
        }
        // SFX [-]
        else if (mx > 1366/2 - 150 && mx < 1366/2 - 100 && my > 320 && my < 365) {
            global.vol_sfx = clamp(global.vol_sfx - 0.1, 0, 1);
        }
        // SFX [+]
        else if (mx > 1366/2 + 100 && mx < 1366/2 + 150 && my > 320 && my < 365) {
            global.vol_sfx = clamp(global.vol_sfx + 0.1, 0, 1);
        }
        // Pantalla Completa
        else if (mx > 1366/2 - 200 && mx < 1366/2 + 200 && my > 390 && my < 440) {
            global.fullscreen = !global.fullscreen;
            window_set_fullscreen(global.fullscreen);
        }
        // Barra de Vida en Peces
        else if (mx > 1366/2 - 200 && mx < 1366/2 + 200 && my > 460 && my < 510) {
            global.mostrar_vida_enemigos = !global.mostrar_vida_enemigos;
        }
        // Volver
        else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 560 && my < 615) {
            ini_open("save.ini");
            ini_write_real("Config", "Musica", global.vol_musica);
            ini_write_real("Config", "SFX", global.vol_sfx);
            ini_write_real("Config", "Fullscreen", global.fullscreen);
            ini_write_real("Config", "VidaEnemigos", global.mostrar_vida_enemigos);
            ini_close();
            en_ajustes = false;
        }
    }
}
