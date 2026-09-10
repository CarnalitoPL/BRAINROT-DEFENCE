// Condiciones de victoria y derrota
if (global.estado_juego == "jugando") {
    if (global.vida <= 0) {
        global.estado_juego = "game_over";
    } else if (current_wave_index >= array_length(waves) && !instance_exists(Obj_EnemyParent)) {
        global.estado_juego = "victoria";
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
            instance_activate_all();
            if (sprite_exists(pause_sprite)) sprite_delete(pause_sprite);
        }
    }
    
    // Si estamos en Pausa, detectar botones
    if (global.estado_juego == "pausado") {
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
            if (global.estado_juego == "victoria") {
                if (room == Rm_Ciudad) room_goto(Rm_Bosque);
                else if (room == Rm_Bosque) room_goto(Rm_Mar);
                else room_goto(Rm_MenuInit);
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
if (estado_colocacion > 0) {
    if (mouse_check_button_pressed(mb_left)) {
        var torre_obj = noone;
        var costo = 0;
        
        if (estado_colocacion == 1) { torre_obj = Obj_TorreTripleT; costo = 20; }
        else if (estado_colocacion == 2) { torre_obj = Obj_TorreCapuchino; costo = 30; }
        else if (estado_colocacion == 3) { torre_obj = Obj_TorreChimpancini; costo = 40; }
        else if (estado_colocacion == 4) { torre_obj = Obj_TorreDinero; costo = 50; }
        
        if (global.dinero >= costo) {
            instance_create_layer(mouse_x, mouse_y, "Instances", torre_obj);
            global.dinero -= costo;
        }
        estado_colocacion = 0; // Termina el modo de colocacion
    }
} else {
    // Detectar clics en la interfaz
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);
        
        // Boton Comprar (10, 700 a 110, 750)
        if (mx > 10 && mx < 110 && my > 700 && my < 750) {
            menu_tienda_abierto = !menu_tienda_abierto;
        }
        // Botones de compra (si esta abierto)
        else if (menu_tienda_abierto && my > 700 && my < 750) {
            if (mx > 120 && mx < 220) estado_colocacion = 1;
            else if (mx > 230 && mx < 330) estado_colocacion = 2;
            else if (mx > 340 && mx < 440) estado_colocacion = 3;
            else if (mx > 450 && mx < 550) estado_colocacion = 4;
            
            if (estado_colocacion > 0) menu_tienda_abierto = false; // Cierra menu al seleccionar
        }
    }
}

// Clics para el menu de mejoras
if (mouse_check_button_pressed(mb_left) && instance_exists(torre_seleccionada)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    var _tx = torre_seleccionada.x - camera_get_view_x(view_camera[0]);
    var _ty = torre_seleccionada.y - camera_get_view_y(view_camera[0]);

    var _box_w = 140;
    var _box_h = 90;
    var _bx1 = _tx - (_box_w / 2);
    var _by1 = _ty - 40 - _box_h;
    var _bx2 = _tx + (_box_w / 2);
    var _by2 = _ty - 40;

    var _btn_x1 = _bx1 + 10;
    var _btn_y1 = _by1 + 40;
    var _btn_x2 = _bx2 - 10;
    var _btn_y2 = _by2 - 10;
    
    // Si clicamos en el boton de mejorar
    if (mx >= _btn_x1 && mx <= _btn_x2 && my >= _btn_y1 && my <= _btn_y2) {
        if (global.dinero >= 50) {
            global.dinero -= 50;
            torre_seleccionada.nivel++;
            torre_seleccionada.danio += 2;
            torre_seleccionada.cooldown *= 0.9;
            
            if (torre_seleccionada.nivel >= 3) torre_seleccionada.puede_ver_camuflados = true;
            if (torre_seleccionada.nivel >= 5) torre_seleccionada.perfora_piedra = true;
        }
    } 
    // Si clicamos fuera del recuadro del menu
    else if (mx < _bx1 || mx > _bx2 || my < _by1 || my > _by2) {
        torre_seleccionada = noone;
    }
}

// Detectar clic en torres
if (mouse_check_button_pressed(mb_left) && estado_colocacion == 0) {
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

