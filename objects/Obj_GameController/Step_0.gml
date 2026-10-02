// Reinicio rapido: mantener R durante 3 segundos (funciona tambien en pausa y en las pantallas finales)
if (keyboard_check(ord("R"))) {
    tiempo_reinicio++;
    if (tiempo_reinicio >= duracion_reinicio) {
        if (global.estado_juego == "pausado") {
            instance_activate_all();
            if (sprite_exists(pause_sprite)) sprite_delete(pause_sprite);
        }
        room_restart();
        exit;
    }
} else {
    tiempo_reinicio = 0; // Al soltar R la pantalla vuelve a la normalidad
}

// Condiciones de victoria y derrota
if (global.estado_juego == "jugando") {
    if (global.vida <= 0) {
        global.estado_juego = "game_over";
        audio_stop_sound(musica_actual);
        musica_actual = audio_play_sound(Snd_MusicaDerrota, 1, false, global.vol_musica);
    } else if (current_wave_index >= array_length(waves) && !instance_exists(Obj_EnemyParent)) {
        global.estado_juego = "victoria";
        audio_stop_sound(musica_actual);
        musica_actual = audio_play_sound(Snd_MusicaVictoria, 1, false, global.vol_musica);

        // Guardar progreso: "Continuar" del menu lleva al siguiente nivel
        ini_open("save.ini");
        if (siguiente_nivel != noone) ini_write_string("Progreso", "Nivel", room_get_name(siguiente_nivel));
        else ini_section_delete("Progreso"); // Juego completado
        ini_close();
    } else {
        if (estado_oleada == "aviso") {
            tiempo_aviso--;
            if (tiempo_aviso <= 0) {
                estado_oleada = "spawning";
                var current_wave = waves[current_wave_index];
                alarm[0] = current_wave[current_subwave_index].delay;
            }
        } else if (estado_oleada == "esperando_fin") {
            if (!instance_exists(Obj_EnemyParent)) {
                current_wave_index++;
                global.oleada++;
                if (current_wave_index < array_length(waves)) {
                    global.dinero += bonus_oleada_base + bonus_oleada_extra * current_wave_index;
                    estado_oleada = "aviso";
                    tiempo_aviso = 180;
                }
            }
        }
    }
}

// Botones persistentes (Pausa y Menus de finalizacion)
if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    // Boton de Pausa (Esquina superior derecha: x=1250 a 1350, y=10 a 50)
    if (mx > 1250 && mx < 1350 && my > 10 && my < 50) {
        if (global.estado_juego == "jugando") {
            global.estado_juego = "pausado";
            if (sprite_exists(pause_sprite)) sprite_delete(pause_sprite);
            pause_sprite = sprite_create_from_surface(application_surface, 0, 0, surface_get_width(application_surface), surface_get_height(application_surface), false, false, 0, 0);
            instance_deactivate_all(true);
        } else if (global.estado_juego == "pausado") {
            global.estado_juego = "jugando";
            en_ajustes = false; // Si se reanuda desde Ajustes, la proxima pausa abre el menu normal
            instance_activate_all();
            if (sprite_exists(pause_sprite)) sprite_delete(pause_sprite);
        }
    }
    
    // Si estamos en Pausa, detectar botones
    if (global.estado_juego == "pausado") {
        if (!en_ajustes) {
            // "Reanudar": x=1366/2 - 150 a 1366/2 - 10, y=300 a 350
            if (mx > 1366/2 - 150 && mx < 1366/2 - 10 && my > 300 && my < 350) {
                global.estado_juego = "jugando";
                instance_activate_all();
                if (sprite_exists(pause_sprite)) sprite_delete(pause_sprite);
            }
            // "Salir al Menu": x=1366/2 + 10 a 1366/2 + 150, y=300 a 350
            if (mx > 1366/2 + 10 && mx < 1366/2 + 150 && my > 300 && my < 350) {
                ini_open("save.ini");
                ini_write_string("Progreso", "Nivel", room_get_name(room));
                ini_close();
                instance_activate_all();
                if (sprite_exists(pause_sprite)) sprite_delete(pause_sprite);
                room_goto(Rm_MenuInit);
            }
            // "Ajustes": x=1366/2 - 150 a 1366/2 + 150, y=380 a 430
            if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 380 && my < 430) {
                en_ajustes = true;
            }
        } else {
            // Logica Ajustes
            // Musica [-]
            if (mx > 1366/2 - 150 && mx < 1366/2 - 100 && my > 185 && my < 235) {
                global.vol_musica = clamp(global.vol_musica - 0.1, 0, 1);
                if (audio_is_playing(musica_actual)) audio_sound_gain(musica_actual, global.vol_musica, 0);
            }
            // Musica [+]
            else if (mx > 1366/2 + 100 && mx < 1366/2 + 150 && my > 185 && my < 235) {
                global.vol_musica = clamp(global.vol_musica + 0.1, 0, 1);
                if (audio_is_playing(musica_actual)) audio_sound_gain(musica_actual, global.vol_musica, 0);
            }
            // SFX [-]
            else if (mx > 1366/2 - 150 && mx < 1366/2 - 100 && my > 265 && my < 315) {
                global.vol_sfx = clamp(global.vol_sfx - 0.1, 0, 1);
            }
            // SFX [+]
            else if (mx > 1366/2 + 100 && mx < 1366/2 + 150 && my > 265 && my < 315) {
                global.vol_sfx = clamp(global.vol_sfx + 0.1, 0, 1);
            }
            // Pantalla Completa
            else if (mx > 1366/2 - 200 && mx < 1366/2 + 200 && my > 350 && my < 400) {
                global.fullscreen = !global.fullscreen;
                window_set_fullscreen(global.fullscreen);
            }
            // Volver
            else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 450 && my < 500) {
                ini_open("save.ini");
                ini_write_real("Config", "Musica", global.vol_musica);
                ini_write_real("Config", "SFX", global.vol_sfx);
                ini_write_real("Config", "Fullscreen", global.fullscreen);
                ini_close();
                en_ajustes = false;
            }
        }
        exit;
    }
    
    // Si estamos en Game Over o Victoria, detectar botones
    if (global.estado_juego == "game_over" || global.estado_juego == "victoria") {
        // Boton Reiniciar
        if (mx > 1366/2 - 150 && mx < 1366/2 - 10 && my > 300 && my < 350) {
            room_restart();
        }
        // Boton Continuar / Menu
        if (mx > 1366/2 + 10 && mx < 1366/2 + 150 && my > 300 && my < 350) {
            if (global.estado_juego == "victoria" && siguiente_nivel != noone) {
                room_goto(siguiente_nivel);
            } else {
                room_goto(Rm_MenuInit);
            }
        }
        exit;
    }
}

if (global.estado_juego != "jugando") { if (alarm[0] > 0) alarm[0]++; exit; }

// ================= Lógica original de colocación y mejoras (jugando) =================

// Logica de colocacion tactil / mouse
var clic_consumido = false; // Evita que el clic que coloca una torre la seleccione en el mismo frame
if (estado_colocacion > 0) {
    var mx_g = device_mouse_x_to_gui(0);
    var my_g = device_mouse_y_to_gui(0);

    var torre_obj = torres_info[estado_colocacion].obj;
    var costo = torres_info[estado_colocacion].costo;

    motivo_invalido = motivo_colocacion_invalida(mouse_x, mouse_y, mx_g, my_g, costo);

    if (mouse_check_button_pressed(mb_right) || keyboard_check_pressed(ord("X"))) {
        estado_colocacion = 0;
    } else if (mouse_check_button_pressed(mb_left)) {
        clic_consumido = true;
        // Clic en el boton "Cancelar" (Esquina inferior derecha)
        if (mx_g > 1366 - 150 && mx_g < 1366 - 10 && my_g > 700 && my_g < 750) {
            estado_colocacion = 0;
        } 
        // Clic en el boton "Comprar" para cancelar/alternar
        else if (mx_g > 10 && mx_g < 110 && my_g > 650 && my_g < 750) {
            estado_colocacion = 0;
            menu_tienda_abierto = !menu_tienda_abierto;
        } 
        // Colocar la torre (si la posicion no es valida se sigue en modo colocacion)
        else if (motivo_invalido == "") {
            var inst = instance_create_layer(mouse_x, mouse_y, "Instances", torre_obj);
            inst.inversion_total = costo;
            inst.costo_base = costo;
            global.dinero -= costo;
            audio_play_sound(Snd_PonerTorre, 2, false, global.vol_sfx);
            estado_colocacion = 0; // Termina el modo de colocacion
        }
    }
} else {
    // Detectar clics en la interfaz
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);
        
        // Boton Comprar (10, 650 a 110, 750)
        if (mx > 10 && mx < 110 && my > 650 && my < 750) {
            menu_tienda_abierto = !menu_tienda_abierto;
        }
        // Botones de compra (si esta abierto)
        else if (menu_tienda_abierto && my > 650 && my < 750) {
            var selected = false;
            if (mx > 120 && mx < 220) { estado_colocacion = 1; selected = true; }
            else if (mx > 230 && mx < 330) { estado_colocacion = 2; selected = true; }
            else if (mx > 340 && mx < 440) { estado_colocacion = 3; selected = true; }
            else if (mx > 450 && mx < 550) { estado_colocacion = 4; selected = true; }
            
            if (selected) {
                menu_tienda_abierto = false; // Cierra menu al seleccionar
                torre_seleccionada = noone;  // Cierra el menu de mejora mientras se coloca
                clic_consumido = true;
                audio_play_sound(Snd_PresionarBtn, 2, false, global.vol_sfx);
            }
        }
    }
}

// Clics para el menu de mejoras
if (mouse_check_button_pressed(mb_left) && !clic_consumido && instance_exists(torre_seleccionada)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    var _tx = torre_seleccionada.x - camera_get_view_x(view_camera[0]);
    var _ty = torre_seleccionada.y - camera_get_view_y(view_camera[0]);

    var _box_w = 140;
    var _box_h = 130;
    var _bx1 = _tx - (_box_w / 2);
    var _by1 = _ty - 40 - _box_h;
    var _bx2 = _tx + (_box_w / 2);
    var _by2 = _ty - 40;

    var _btn_upg_y1 = _by1 + 35;
    var _btn_upg_y2 = _by1 + 70;
    
    var _btn_sell_y1 = _by1 + 80;
    var _btn_sell_y2 = _by1 + 115;
    
    // Si clicamos en el boton de mejorar
    if (mx >= _bx1 + 10 && mx <= _bx2 - 10 && my >= _btn_upg_y1 && my <= _btn_upg_y2) {
        var _costo_mejora = costo_mejora(torre_seleccionada);
        if (torre_seleccionada.nivel < nivel_max_torre && global.dinero >= _costo_mejora) {
            global.dinero -= _costo_mejora;
            torre_seleccionada.inversion_total += _costo_mejora;
            torre_seleccionada.nivel++;
            torre_seleccionada.danio += 2;
            torre_seleccionada.cooldown *= 0.9;
            
            if (torre_seleccionada.nivel >= 3) torre_seleccionada.puede_ver_camuflados = true;
            if (torre_seleccionada.nivel >= 5) torre_seleccionada.perfora_piedra = true;

            audio_play_sound(Snd_PresionarBtn, 2, false, global.vol_sfx);
        }
    } 
    // Si clicamos en el boton de vender
    else if (mx >= _bx1 + 10 && mx <= _bx2 - 10 && my >= _btn_sell_y1 && my <= _btn_sell_y2) {
        var venta = round(torre_seleccionada.inversion_total * porcentaje_venta);
        global.dinero += venta;
        instance_destroy(torre_seleccionada);
        torre_seleccionada = noone;
    }
    // Si clicamos fuera del recuadro del menu
    else if (mx < _bx1 || mx > _bx2 || my < _by1 || my > _by2) {
        torre_seleccionada = noone;
    }
}

// Detectar clic en torres
if (mouse_check_button_pressed(mb_left) && !clic_consumido && estado_colocacion == 0) {
    var mx_room = mouse_x;
    var my_room = mouse_y;
    var clicked_tower = noone;
    
    with (Obj_TowerParent) {
        if (point_distance(x, y, mx_room, my_room) < 20) {
            clicked_tower = id;
        }
    }
    if (clicked_tower != noone) {
        torre_seleccionada = clicked_tower;
    }
}

