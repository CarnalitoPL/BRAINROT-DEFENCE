if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    if (!en_ajustes) {
        if (nivel_guardado != "") {
            // Clic en Continuar (270 - 325)
            if (mx > 1366/2 - 160 && mx < 1366/2 + 160 && my > 270 && my < 325) {
                global.modo_infinito = false;
                var rm = asset_get_index(nivel_guardado);
                if (rm != -1) {
                    room_goto(rm);
                } else {
                    global.historia_sprite = Spr_ComienzoDeHistoria;
                    global.historia_siguiente_room = Rm_Ciudad;
                    room_goto(Rm_Historia);
                }
            }
            // Clic en Nueva Partida (340 - 395)
            else if (mx > 1366/2 - 160 && mx < 1366/2 + 160 && my > 340 && my < 395) {
                global.modo_infinito = false;
                ini_open("save.ini");
                ini_section_delete("Progreso");
                ini_close();
                global.historia_sprite = Spr_ComienzoDeHistoria;
                global.historia_siguiente_room = Rm_Ciudad;
                room_goto(Rm_Historia);
            }
            // Clic en Modo Infinito (410 - 465)
            else if (mx > 1366/2 - 160 && mx < 1366/2 + 160 && my > 410 && my < 465) {
                global.modo_infinito = true;
                room_goto(Rm_Mar);
            }
            // Clic en Ajustes (480 - 535)
            else if (mx > 1366/2 - 160 && mx < 1366/2 + 160 && my > 480 && my < 535) {
                en_ajustes = true;
            }
            // Clic en Salir (550 - 605)
            else if (mx > 1366/2 - 160 && mx < 1366/2 + 160 && my > 550 && my < 605) {
                game_end();
            }
        } else {
            // Clic en Jugar Historia (310 - 370)
            if (mx > 1366/2 - 160 && mx < 1366/2 + 160 && my > 310 && my < 370) {
                global.modo_infinito = false;
                ini_open("save.ini");
                ini_section_delete("Progreso");
                ini_close();
                global.historia_sprite = Spr_ComienzoDeHistoria;
                global.historia_siguiente_room = Rm_Ciudad;
                room_goto(Rm_Historia);
            }
            // Clic en Modo Infinito (385 - 445)
            else if (mx > 1366/2 - 160 && mx < 1366/2 + 160 && my > 385 && my < 445) {
                global.modo_infinito = true;
                room_goto(Rm_Mar);
            }
            // Clic en Ajustes (460 - 520)
            else if (mx > 1366/2 - 160 && mx < 1366/2 + 160 && my > 460 && my < 520) {
                en_ajustes = true;
            }
            // Clic en Salir (535 - 595)
            else if (mx > 1366/2 - 160 && mx < 1366/2 + 160 && my > 535 && my < 595) {
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
