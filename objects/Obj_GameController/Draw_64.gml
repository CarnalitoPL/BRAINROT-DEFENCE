draw_set_font(Fnt_juego);
// 1. Barra de Vida Grafica
var barra_x = 20;
var barra_y = 20;
var ancho_total = 200;
var alto_barra = 30;

// Fondo oscuro
draw_set_color(c_dkgray);
draw_rectangle(barra_x, barra_y, barra_x + ancho_total, barra_y + alto_barra, false);

// Barra interior (verde)
var ancho_actual = clamp((global.vida / global.vida_maxima) * ancho_total, 0, ancho_total);
draw_set_color(c_green);
if (ancho_actual > 0) {
    draw_rectangle(barra_x, barra_y, barra_x + ancho_actual, barra_y + alto_barra, false);
}

// Borde
draw_set_color(c_black);
draw_rectangle(barra_x, barra_y, barra_x + ancho_total, barra_y + alto_barra, true);

// Texto de vida centrado
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(barra_x + (ancho_total / 2), barra_y + (alto_barra / 2), string(global.vida) + " / " + string(global.vida_maxima));

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 2. Indicador de Dinero
draw_set_color(c_yellow);
// Usamos fa_middle para que y:35 quede alineado con el texto
draw_set_valign(fa_middle);
draw_text_transformed(240, 35, "$ " + string(global.dinero), 1.5, 1.5, 0);
draw_set_valign(fa_top);
draw_set_color(c_white);

// 3. Contador de Oleadas (Centro Superior)
var gui_w = display_get_gui_width();
var oleada_txt = "";
if (global.oleada <= global.oleada_maxima) {
    oleada_txt = "Oleada: " + string(global.oleada) + " / " + string(global.oleada_maxima);
} else {
    oleada_txt = "Oleada: FINALIZADA";
}

var txt_w = string_width(oleada_txt) + 20;
var txt_h = string_height(oleada_txt) + 10;
var box_x1 = (gui_w / 2) - (txt_w / 2);
var box_y1 = 25 - (txt_h / 2);

draw_set_color(c_black);
draw_set_alpha(0.6);
draw_rectangle(box_x1, box_y1, box_x1 + txt_w, box_y1 + txt_h, false);
draw_set_alpha(1.0);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(gui_w / 2, 25, oleada_txt);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Boton de Pausa (1250, 10 a 1350, 50)
draw_set_color(c_gray);
draw_rectangle(1250, 10, 1350, 50, false);
draw_set_color(c_white);
var txt_pausa = (global.estado_juego == "pausado") ? "Reanudar" : "Pausa";
draw_text(1260, 20, txt_pausa);

if (global.estado_juego == "jugando" && estado_oleada == "aviso") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_red);
    draw_text_transformed(1366/2, 768/2, "OLEADA " + string(global.oleada), 4, 4, 0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (global.estado_juego == "jugando" || global.estado_juego == "pausado") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Boton "Comprar"
    draw_set_color(menu_tienda_abierto ? c_dkgray : c_gray);
    draw_rectangle(10, 650, 110, 750, false);
    draw_set_color(c_white);
    draw_text(60, 700, "Comprar");

    if (menu_tienda_abierto) {
        var btn_w = 100;
        var btn_h = 100;
        var btn_y = 650;
        
        for (var i = 0; i < 4; i++) {
            var _info = torres_info[i + 1];
            var bx = 120 + (i * 110);
            draw_set_color(c_gray);
            draw_rectangle(bx, btn_y, bx + btn_w, btn_y + btn_h, false);

            // Dibujar Sprite base de la torre en la mitad superior
            var _spr = object_get_sprite(_info.obj);
            if (_spr != -1) {
                draw_sprite_ext(_spr, 0, bx + (btn_w / 2), btn_y + 35, 0.8, 0.8, 0, c_white, 1);
            }

            // Dibujar Textos (precio en rojo si no alcanza el dinero)
            draw_set_color(c_white);
            draw_text(bx + (btn_w / 2), btn_y + 65, _info.nombre);
            draw_set_color((global.dinero >= _info.costo) ? c_white : c_red);
            draw_text(bx + (btn_w / 2), btn_y + 85, "$" + string(_info.costo));
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Mensaje de colocacion y Boton de Cancelar
    if (estado_colocacion > 0) {
        var _msg = (motivo_invalido == "") ? "Colocando..." : motivo_invalido;
        draw_set_color((motivo_invalido == "") ? c_yellow : c_red);
        draw_text(device_mouse_x_to_gui(0) + 15, device_mouse_y_to_gui(0) - 20, _msg);
        
        // Boton Cancelar
        draw_set_color(c_maroon);
        draw_rectangle(1366 - 150, 700, 1366 - 10, 750, false);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(1366 - 80, 725, "Cancelar (X)");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    // Menu de Mejora de Torre
    if (instance_exists(torre_seleccionada)) {
        var _tx = torre_seleccionada.x - camera_get_view_x(view_camera[0]);
        var _ty = torre_seleccionada.y - camera_get_view_y(view_camera[0]);

        var _box_w = 140;
        var _box_h = 130;
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

        // Boton Mejorar
        var _btn_upg_y1 = _by1 + 35;
        var _btn_upg_y2 = _by1 + 70;
        var _es_max = torre_seleccionada.nivel >= nivel_max_torre;
        var _costo_mejora = costo_mejora(torre_seleccionada);
        draw_set_color((_es_max || global.dinero < _costo_mejora) ? c_dkgray : c_green);
        draw_rectangle(_bx1 + 10, _btn_upg_y1, _bx2 - 10, _btn_upg_y2, false);
        draw_set_color(c_black);
        draw_set_valign(fa_middle);
        draw_text(_tx, _btn_upg_y1 + 17, _es_max ? "Nivel MAX" : "Mejorar ($" + string(_costo_mejora) + ")");

        // Boton Vender
        var _btn_sell_y1 = _by1 + 80;
        var _btn_sell_y2 = _by1 + 115;
        draw_set_color(c_maroon);
        draw_rectangle(_bx1 + 10, _btn_sell_y1, _bx2 - 10, _btn_sell_y2, false);
        draw_set_color(c_white);
        var venta = round(torre_seleccionada.inversion_total * porcentaje_venta);
        draw_text(_tx, _btn_sell_y1 + 17, "Vender (+$" + string(venta) + ")");

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
        if (!en_ajustes) {
            draw_text_transformed(1366/2, 150, "PAUSA", 3, 3, 0);
            
            draw_set_color(c_maroon);
            draw_rectangle(1366/2 - 150, 300, 1366/2 - 10, 350, false);
            draw_set_color(c_teal);
            draw_rectangle(1366/2 + 10, 300, 1366/2 + 150, 350, false);
            draw_set_color(c_gray);
            draw_rectangle(1366/2 - 150, 380, 1366/2 + 150, 430, false);
            
            draw_set_color(c_white);
            draw_text(1366/2 - 80, 315, "Reanudar");
            draw_text(1366/2 + 80, 315, "Salir al Menu");
            draw_text(1366/2, 395, "Ajustes");
        } else {
            // Menu de Ajustes
            draw_set_color(c_black);
            draw_set_alpha(0.8);
            draw_rectangle(1366/2 - 300, 100, 1366/2 + 300, 600, false);
            draw_set_alpha(1.0);
            
            draw_set_color(c_white);
            draw_text_transformed(1366/2, 130, "AJUSTES", 2, 2, 0);
            
            // Musica
            draw_text(1366/2, 200, "Musica: " + string(round(global.vol_musica * 100)) + "%");
            draw_set_color(c_gray);
            draw_rectangle(1366/2 - 150, 185, 1366/2 - 100, 235, false); // [-]
            draw_rectangle(1366/2 + 100, 185, 1366/2 + 150, 235, false); // [+]
            draw_set_color(c_black);
            draw_text(1366/2 - 125, 195, "-");
            draw_text(1366/2 + 125, 195, "+");
            
            // SFX
            draw_set_color(c_white);
            draw_text(1366/2, 280, "SFX: " + string(round(global.vol_sfx * 100)) + "%");
            draw_set_color(c_gray);
            draw_rectangle(1366/2 - 150, 265, 1366/2 - 100, 315, false); // [-]
            draw_rectangle(1366/2 + 100, 265, 1366/2 + 150, 315, false); // [+]
            draw_set_color(c_black);
            draw_text(1366/2 - 125, 275, "-");
            draw_text(1366/2 + 125, 275, "+");
            
            // Pantalla Completa
            var txt_fs = global.fullscreen ? "Pantalla Completa: SI" : "Pantalla Completa: NO";
            draw_set_color(c_teal);
            draw_rectangle(1366/2 - 200, 350, 1366/2 + 200, 400, false);
            draw_set_color(c_black);
            draw_text(1366/2, 360, txt_fs);
            
            // Boton Volver
            draw_set_color(c_maroon);
            draw_rectangle(1366/2 - 150, 450, 1366/2 + 150, 500, false);
            draw_set_color(c_white);
            draw_text(1366/2, 460, "VOLVER");
        }
    }

    // Botones de Victoria / Game Over
    if (global.estado_juego == "game_over" || global.estado_juego == "victoria") {
        draw_set_color(c_maroon);
        draw_rectangle(1366/2 - 150, 300, 1366/2 - 10, 350, false);
        draw_set_color(c_teal);
        draw_rectangle(1366/2 + 10, 300, 1366/2 + 150, 350, false);
        draw_set_color(c_white);
        draw_text(1366/2 - 80, 315, "Reiniciar");
        if (global.estado_juego == "victoria" && siguiente_nivel != noone) {
            draw_text(1366/2 + 80, 315, "Continuar");
        } else {
            draw_text(1366/2 + 80, 315, "Menu Principal");
        }
    }

    draw_set_halign(fa_left);
}

// Oscurecimiento mientras se mantiene R para reiniciar (encima de todo)
if (tiempo_reinicio > 0) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    draw_set_alpha(tiempo_reinicio / duracion_reinicio);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_gw / 2, _gh / 2, "Reiniciando...", 2, 2, 0);

    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}