gpu_set_texfilter(false);
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
if (global.modo_infinito) {
    oleada_txt = "Modo Infinito - Oleada: " + string(global.oleada);
} else if (global.oleada <= global.oleada_maxima) {
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

// Boton de Velocidad (1140, 10 a 1240, 50)
var col_spd = make_color_rgb(50, 50, 60);
if (global.velocidad_juego == 2) col_spd = make_color_rgb(200, 120, 20); // Naranja para 2x
else if (global.velocidad_juego == 3) col_spd = make_color_rgb(180, 40, 40); // Rojo para 3x
draw_set_color(col_spd);
draw_rectangle(1140, 10, 1240, 50, false);
draw_set_color(c_white);
draw_rectangle(1140, 10, 1240, 50, true);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(1190, 30, string(global.velocidad_juego) + "x");

// Boton de Pausa (1250, 10 a 1350, 50)
draw_set_color(c_gray);
draw_rectangle(1250, 10, 1350, 50, false);
draw_set_color(c_white);
draw_rectangle(1250, 10, 1350, 50, true);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var txt_pausa = (global.estado_juego == "pausado") ? "Reanudar" : "Pausa";
draw_text(1300, 30, txt_pausa);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

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

        var _box_w = 240;
        var _box_h = 210;
        var _bx1 = clamp(_tx - (_box_w / 2), 10, 1366 - _box_w - 10);
        var _bx2 = _bx1 + _box_w;
        var _by1 = _ty - 35 - _box_h;
        if (_by1 < 60) {
            _by1 = min(_ty + 40, 768 - _box_h - 10);
        }
        var _by2 = _by1 + _box_h;

        // Fondo y borde
        draw_set_color(c_black);
        draw_set_alpha(0.85);
        draw_rectangle(_bx1, _by1, _bx2, _by2, false);
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_rectangle(_bx1, _by1, _bx2, _by2, true);

        var _t_mid = _bx1 + (_box_w / 2);

        // Nombre de la torre
        var _nom = "Torre";
        if (torre_seleccionada.object_index == Obj_TorreTripleT) _nom = "TripleT";
        else if (torre_seleccionada.object_index == Obj_TorreCapuchino) _nom = "Capuchino";
        else if (torre_seleccionada.object_index == Obj_TorreChimpancini) _nom = "Mono";
        else if (torre_seleccionada.object_index == Obj_TorreDinero) _nom = "T. Dinero";

        var _es_max = torre_seleccionada.nivel >= nivel_max_torre;
        var _next_lvl = torre_seleccionada.nivel + 1;

        // Titulo: Nombre y Nivel
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(c_aqua);
        draw_text(_t_mid, _by1 + 10, _nom + " (Nv. " + string(torre_seleccionada.nivel) + "/5)");

        // Que mejora en el siguiente nivel
        if (!_es_max) {
            draw_set_color(c_yellow);
            draw_text(_t_mid, _by1 + 32, "-> Siguiente Nivel (" + string(_next_lvl) + "):");

            draw_set_halign(fa_left);
            var _info_x = _bx1 + 16;
            draw_set_color(c_white);

            if (torre_seleccionada.object_index == Obj_TorreDinero) {
                var _mon_act = 15 + (torre_seleccionada.nivel - 1) * 10;
                var _mon_sig = 15 + torre_seleccionada.nivel * 10;
                draw_text(_info_x, _by1 + 52, "+ Moneda: $" + string(_mon_act) + " -> $" + string(_mon_sig));
                draw_text(_info_x, _by1 + 72, "+ Generacion: +10% rapido");
                draw_set_color(c_lime);
                draw_text(_info_x, _by1 + 92, "(+$10 por cada moneda)");
            } else if (torre_seleccionada.object_index == Obj_TorreChimpancini) {
                draw_text(_info_x, _by1 + 52, "+ Dano: " + string(torre_seleccionada.danio) + " -> " + string(torre_seleccionada.danio + 2));
                draw_text(_info_x, _by1 + 72, "+ Usos: " + string(1 + torre_seleccionada.nivel) + " -> " + string(2 + torre_seleccionada.nivel) + " resbalones");
                if (_next_lvl == 3) {
                    draw_set_color(c_yellow);
                    draw_text(_info_x, _by1 + 92, "! Desbloquea: Ve Invisibles");
                } else if (_next_lvl == 5) {
                    draw_set_color(c_yellow);
                    draw_text(_info_x, _by1 + 92, "! Desbloquea: Perfora Piedra");
                } else {
                    draw_set_color(c_lime);
                    draw_text(_info_x, _by1 + 92, "+ Cadencia: +10% rapido");
                }
            } else if (torre_seleccionada.object_index == Obj_TorreCapuchino) {
                draw_text(_info_x, _by1 + 52, "+ Dano: " + string(torre_seleccionada.danio) + " -> " + string(torre_seleccionada.danio + 2));
                draw_text(_info_x, _by1 + 72, "+ Cadencia: +10% rapido");
                if (_next_lvl == 5) {
                    draw_set_color(c_yellow);
                    draw_text(_info_x, _by1 + 92, "! Desbloquea: Perfora Piedra");
                } else {
                    draw_set_color(c_lime);
                    draw_text(_info_x, _by1 + 92, "* Ve invisibles (Activo)");
                }
            } else {
                // TripleT y demas
                draw_text(_info_x, _by1 + 52, "+ Dano: " + string(torre_seleccionada.danio) + " -> " + string(torre_seleccionada.danio + 2));
                draw_text(_info_x, _by1 + 72, "+ Cadencia: +10% rapido");
                if (_next_lvl == 3) {
                    draw_set_color(c_yellow);
                    draw_text(_info_x, _by1 + 92, "! Desbloquea: Ve Invisibles");
                } else if (_next_lvl == 5) {
                    draw_set_color(c_yellow);
                    draw_text(_info_x, _by1 + 92, "! Desbloquea: Perfora Piedra");
                } else if (torre_seleccionada.nivel >= 3) {
                    draw_set_color(c_lime);
                    draw_text(_info_x, _by1 + 92, "* Ve invisibles (Activo)");
                } else {
                    draw_set_color(c_gray);
                    draw_text(_info_x, _by1 + 92, "(Nv 3 desbloquea Invisibles)");
                }
            }
        } else {
            draw_set_color(c_yellow);
            draw_text(_t_mid, _by1 + 48, "Nivel Maximo");
            draw_set_color(c_lime);
            draw_text(_t_mid, _by1 + 72, "(Poder al maximo)");
        }

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        // Boton Mejorar
        var _btn_upg_y1 = _by1 + 118;
        var _btn_upg_y2 = _by1 + 156;
        var _costo_mejora = costo_mejora(torre_seleccionada);
        draw_set_color((_es_max || global.dinero < _costo_mejora) ? c_dkgray : c_green);
        draw_rectangle(_bx1 + 12, _btn_upg_y1, _bx2 - 12, _btn_upg_y2, false);
        draw_set_color(c_black);
        draw_rectangle(_bx1 + 12, _btn_upg_y1, _bx2 - 12, _btn_upg_y2, true);
        draw_set_color(_es_max ? c_silver : c_white);
        draw_text(_t_mid, _btn_upg_y1 + 19, _es_max ? "Nivel MAX" : "Mejorar ($" + string(_costo_mejora) + ")");

        // Boton Vender
        var _btn_sell_y1 = _by1 + 164;
        var _btn_sell_y2 = _by1 + 198;
        draw_set_color(c_maroon);
        draw_rectangle(_bx1 + 12, _btn_sell_y1, _bx2 - 12, _btn_sell_y2, false);
        draw_set_color(c_black);
        draw_rectangle(_bx1 + 12, _btn_sell_y1, _bx2 - 12, _btn_sell_y2, true);
        draw_set_color(c_white);
        var venta = round(torre_seleccionada.inversion_total * porcentaje_venta);
        draw_text(_t_mid, _btn_sell_y1 + 17, "Vender (+$" + string(venta) + ")");

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
    }
}

// Pantallas de Derrota, Victoria y Pausa
if (global.estado_juego == "game_over" || global.estado_juego == "pausado" || global.estado_juego == "victoria") {
    if (global.estado_juego == "pausado" && sprite_exists(pause_sprite)) {
        draw_sprite_stretched(pause_sprite, 0, 0, 0, display_get_gui_width(), display_get_gui_height());
    }
    
    // Fondo semitransparente
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(0, 0, 1366, 768, false);
    draw_set_alpha(1.0);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    if (global.estado_juego == "game_over") {
        draw_set_color(c_red);
        draw_text_transformed(1366/2, 140, "GAME OVER", 3, 3, 0);
        draw_set_color(c_white);
        if (global.modo_infinito) {
            draw_text(1366/2, 205, "Llegaste a la Oleada: " + string(global.oleada));
            draw_set_color(c_yellow);
            draw_text(1366/2, 235, "Record: Oleada " + string(record_infinita));
        } else {
            draw_text(1366/2, 220, "Bombardilo Cocodrilo gano...");
        }
        
        draw_set_color(c_maroon);
        draw_rectangle(1366/2 - 150, 300, 1366/2 - 10, 350, false);
        draw_set_color(c_white);
        draw_rectangle(1366/2 - 150, 300, 1366/2 - 10, 350, true);
        
        draw_set_color(c_teal);
        draw_rectangle(1366/2 + 10, 300, 1366/2 + 150, 350, false);
        draw_set_color(c_white);
        draw_rectangle(1366/2 + 10, 300, 1366/2 + 150, 350, true);
        
        draw_set_color(c_white);
        draw_text(1366/2 - 80, 325, "Reiniciar");
        draw_text(1366/2 + 80, 325, "Menu Principal");
    } else if (global.estado_juego == "victoria") {
        draw_set_color(c_yellow);
        draw_text_transformed(1366/2, 160, "¡VICTORIA!", 3, 3, 0);
        draw_set_color(c_white);
        draw_text(1366/2, 230, "¡Nivel completado con exito!");
        
        // Boton Volver al Menu Principal (Izquierda)
        draw_set_color(c_maroon);
        draw_rectangle(1366/2 - 170, 320, 1366/2 - 10, 370, false);
        draw_set_color(c_white);
        draw_rectangle(1366/2 - 170, 320, 1366/2 - 10, 370, true);
        draw_text(1366/2 - 90, 345, "Menu Principal");
        
        // Boton Siguiente Nivel / Continuar (Derecha)
        draw_set_color(c_teal);
        draw_rectangle(1366/2 + 10, 320, 1366/2 + 170, 370, false);
        draw_set_color(c_white);
        draw_rectangle(1366/2 + 10, 320, 1366/2 + 170, 370, true);
        var _txt_sig = (room == Rm_Mar) ? "Ver Final" : "Siguiente Nivel";
        draw_text(1366/2 + 90, 345, _txt_sig);
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
            draw_text(1366/2 - 80, 325, "Reanudar");
            draw_text(1366/2 + 80, 325, "Salir al Menu");
            draw_text(1366/2, 405, "Ajustes");
        } else {
            // Menu de Ajustes
            draw_set_color(c_black);
            draw_set_alpha(0.8);
            draw_rectangle(1366/2 - 300, 80, 1366/2 + 300, 580, false);
            draw_set_alpha(1.0);
            
            draw_set_color(c_white);
            draw_text_transformed(1366/2, 110, "AJUSTES", 2, 2, 0);
            
            // Musica
            draw_text(1366/2, 165, "Musica: " + string(round(global.vol_musica * 100)) + "%");
            draw_set_color(c_gray);
            draw_rectangle(1366/2 - 150, 150, 1366/2 - 100, 195, false); // [-]
            draw_rectangle(1366/2 + 100, 150, 1366/2 + 150, 195, false); // [+]
            draw_set_color(c_black);
            draw_text(1366/2 - 125, 172, "-");
            draw_text(1366/2 + 125, 172, "+");
            
            // SFX
            draw_set_color(c_white);
            draw_text(1366/2, 235, "SFX: " + string(round(global.vol_sfx * 100)) + "%");
            draw_set_color(c_gray);
            draw_rectangle(1366/2 - 150, 220, 1366/2 - 100, 265, false); // [-]
            draw_rectangle(1366/2 + 100, 220, 1366/2 + 150, 265, false); // [+]
            draw_set_color(c_black);
            draw_text(1366/2 - 125, 242, "-");
            draw_text(1366/2 + 125, 242, "+");
            
            // Pantalla Completa
            var txt_fs = global.fullscreen ? "Pantalla Completa: SI" : "Pantalla Completa: NO";
            draw_set_color(c_teal);
            draw_rectangle(1366/2 - 200, 290, 1366/2 + 200, 340, false);
            draw_set_color(c_black);
            draw_text(1366/2, 315, txt_fs);
            
            // Barra de Vida en Peces
            var txt_vida = global.mostrar_vida_enemigos ? "Vida en Peces: SI" : "Vida en Peces: NO";
            draw_set_color(c_teal);
            draw_rectangle(1366/2 - 200, 360, 1366/2 + 200, 410, false);
            draw_set_color(c_black);
            draw_text(1366/2, 385, txt_vida);
            
            // Boton Volver
            draw_set_color(c_maroon);
            draw_rectangle(1366/2 - 150, 460, 1366/2 + 150, 510, false);
            draw_set_color(c_white);
            draw_text(1366/2, 485, "VOLVER");
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
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