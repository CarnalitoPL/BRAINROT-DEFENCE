draw_set_font(Fnt_juego);
draw_set_color(c_white);
draw_text(10, 10, "Vida: " + string(global.vida));
draw_text(10, 30, "Dinero: $" + string(global.dinero));
if (global.oleada <= global.oleada_maxima) {
    draw_text(10, 50, "Oleada: " + string(global.oleada) + " / " + string(global.oleada_maxima));
} else {
    draw_text(10, 50, "Oleada: FINALIZADA");
}

// Boton de Pausa (1250, 10 a 1350, 50)
draw_set_color(c_gray);
draw_rectangle(1250, 10, 1350, 50, false);
draw_set_color(c_white);
var txt_pausa = (global.estado_juego == "pausado") ? "Reanudar" : "Pausa";
draw_text(1260, 20, txt_pausa);

if (global.estado_juego == "jugando" || global.estado_juego == "pausado") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Boton "Comprar"
    draw_set_color(menu_tienda_abierto ? c_dkgray : c_gray);
    draw_rectangle(10, 700, 110, 750, false);
    draw_set_color(c_white);
    draw_text(60, 725, "Comprar");

    if (menu_tienda_abierto) {
        // Boton TripleT
        draw_set_color(c_gray); draw_rectangle(120, 700, 220, 750, false); draw_set_color(c_white);
        draw_text(170, 715, "TripleT"); draw_text(170, 735, "$20");

        // Boton Capuchino
        draw_set_color(c_gray); draw_rectangle(230, 700, 330, 750, false); draw_set_color(c_white);
        draw_text(280, 715, "Capuchino"); draw_text(280, 735, "$30");

        // Boton Chimpancini
        draw_set_color(c_gray); draw_rectangle(340, 700, 440, 750, false); draw_set_color(c_white);
        draw_text(390, 715, "Mono"); draw_text(390, 735, "$40");

        // Boton Torre Dinero
        draw_set_color(c_gray); draw_rectangle(450, 700, 550, 750, false); draw_set_color(c_white);
        draw_text(500, 715, "T.Dinero"); draw_text(500, 735, "$50");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Mensaje de colocacion
    if (estado_colocacion > 0) {
        draw_set_color(c_yellow);
        draw_text(device_mouse_x_to_gui(0) + 15, device_mouse_y_to_gui(0) - 20, "Colocando...");
        draw_set_color(c_white);
    }

    // Menu de Mejora de Torre
    if (instance_exists(torre_seleccionada)) {
        var _tx = torre_seleccionada.x - camera_get_view_x(view_camera[0]);
        var _ty = torre_seleccionada.y - camera_get_view_y(view_camera[0]);

        var _box_w = 140;
        var _box_h = 90;
        var _bx1 = _tx - (_box_w / 2);
        var _by1 = _ty - 40 - _box_h;
        var _bx2 = _tx + (_box_w / 2);
        var _by2 = _ty - 40;

        draw_set_color(c_black);
        draw_set_alpha(0.8);
        draw_rectangle(_bx1, _by1, _bx2, _by2, false);
        draw_set_alpha(1.0);

        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(_tx, _by1 + 10, "Nivel: " + string(torre_seleccionada.nivel));

        var _btn_x1 = _bx1 + 10;
        var _btn_y1 = _by1 + 40;
        var _btn_x2 = _bx2 - 10;
        var _btn_y2 = _by2 - 10;

        draw_set_color(c_green);
        draw_rectangle(_btn_x1, _btn_y1, _btn_x2, _btn_y2, false);

        draw_set_color(c_black);
        draw_set_valign(fa_middle);
        draw_text(_tx, _btn_y1 + (_btn_y2 - _btn_y1) / 2, "Mejorar ($50)");

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
    }
}

// Pantallas de Victoria, Derrota y Pausa
if (global.estado_juego == "game_over" || global.estado_juego == "victoria" || global.estado_juego == "pausado") {
    if (global.estado_juego == "pausado" && sprite_exists(pause_sprite)) {
        draw_sprite_stretched(pause_sprite, 0, 0, 0, display_get_gui_width(), display_get_gui_height());
    }
    
    // Fondo semitransparente
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, 1366, 768, false);
    draw_set_alpha(1.0);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    
    if (global.estado_juego == "game_over") {
        draw_text_transformed(1366/2, 150, "GAME OVER", 3, 3, 0);
        draw_text(1366/2, 220, "Bombardilo Cocodrilo gano...");
    } else if (global.estado_juego == "victoria") {
        draw_text_transformed(1366/2, 150, "¡NIVEL COMPLETADO!", 3, 3, 0);
        draw_text(1366/2, 220, "Puntuacion (Vida restante): " + string(global.vida));
    } else if (global.estado_juego == "pausado") {
        draw_text_transformed(1366/2, 150, "PAUSA", 3, 3, 0);
    }
    
    // Botones (misma posicion para todos: 1366/2 - 150... y 1366/2 + 10...)
    draw_set_color(c_maroon);
    draw_rectangle(1366/2 - 150, 300, 1366/2 - 10, 350, false);
    draw_set_color(c_teal);
    draw_rectangle(1366/2 + 10, 300, 1366/2 + 150, 350, false);
    
    draw_set_color(c_white);
    
    if (global.estado_juego == "pausado") {
        draw_text(1366/2 - 80, 315, "Reanudar");
        draw_text(1366/2 + 80, 315, "Salir al Menu");
    } else {
        draw_text(1366/2 - 80, 315, "Reiniciar");
        if (global.estado_juego == "victoria" && room != Rm_Mar) {
            draw_text(1366/2 + 80, 315, "Continuar");
        } else {
            draw_text(1366/2 + 80, 315, "Menu Principal");
        }
    }
    
    draw_set_halign(fa_left);
}
